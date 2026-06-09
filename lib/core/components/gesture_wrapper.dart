import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leaper/models/course_data.dart';
import 'package:leaper/pages/courses/course_detail.dart';
import 'package:leaper/pages/courses/edit_grades.dart';
import 'package:leaper/pages/forum/forum.dart';
import 'package:leaper/providers/api_provider.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:http/http.dart' as http;
import 'package:leaper/providers/course_cache_provider.dart';
import 'package:leaper/providers/user_info_provider.dart';

class GestureWrapper extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;
  final bool isLoggedIn;
  const GestureWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
    required this.isLoggedIn,
  });

  @override
  State<GestureWrapper> createState() => _GestureWrapperState();
}

class _GestureWrapperState extends State<GestureWrapper> {
  final Map<int, Offset> _pointers = {};
  bool _triggered = false;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showOverlay() {
    if (_isOpen) return;
    if (!widget.isLoggedIn) return;
    setState(() => _isOpen = true);
    showGeneralDialog(
      context: widget.navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: 'Search',
      barrierColor: Colors.transparent,
      pageBuilder: (context, _, __) => SearchOverlay(onClose: _hideOverlay),
    ).then((_) => _hideOverlay());
  }

  void _hideOverlay() {
    setState(() => _isOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        _pointers[event.pointer] = event.position;
        _triggered = false;
      },
      onPointerMove: (event) {
        _pointers[event.pointer] = event.position;
        if (_pointers.length == 2 && !_triggered) {
          final positions = _pointers.values.toList();
          final dy1 = positions[0].dy;
          final dy2 = positions[1].dy;
          if (dy1 > 100 && dy2 > 100) {
            _triggered = true;
            _showOverlay();
          }
        }
      },
      onPointerUp: (event) {
        _pointers.remove(event.pointer);
        if (_pointers.isEmpty) _triggered = false;
      },
      onPointerCancel: (event) {
        _pointers.remove(event.pointer);
        if (_pointers.isEmpty) _triggered = false;
      },
      child: widget.child,
    );
  }
}

class SearchOverlay extends ConsumerStatefulWidget {
  final VoidCallback onClose;
  const SearchOverlay({super.key, required this.onClose});

  @override
  ConsumerState<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends ConsumerState<SearchOverlay>
    with SingleTickerProviderStateMixin {
  final _searchController = TextEditingController();
  final _focusNode = FocusNode();
  late AnimationController _animController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  List<CourseData> _courses = [];
  String _query = '';

  final List<SearchResult> _pages = [
    SearchResult(title: "Courses", icon: Icons.book, route: '/course'),
    SearchResult(
      title: "Schedule",
      icon: Icons.calendar_today,
      route: '/schedule',
    ),
    SearchResult(title: "Grades", icon: Icons.view_kanban, route: '/grades'),
    SearchResult(title: "Dashboard", icon: Icons.dashboard, route: '/main'),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));
    _animController.forward();
    Future.delayed(
      Duration(milliseconds: 100),
      () => _focusNode.requestFocus(),
    );
    _fetchCourses();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    _animController.dispose();
    super.dispose();
  }

  void _navigate(BuildContext context, String route, Object? arguments) async {
    widget.onClose();
    final navigator = Navigator.of(context);
    if (route == '/main') {
      navigator.popUntil((r) => r.settings.name == '/main');
    } else {
      navigator.pushNamedAndRemoveUntil(
        route,
        (r) => r.settings.name == '/main',
        arguments: arguments,
      );
    }
  }

  Future<void> _fetchCourses() async {
    final cached = ref.read(coursesCacheProvider);
    final cacheTime = ref.read(coursesCacheTimeProvider);

    final isFresh =
        cacheTime != null &&
        DateTime.now().difference(cacheTime).inMinutes < 30;

    if (cached.isNotEmpty && isFresh) {
      setState(() => _courses = cached);
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('${ref.read(apiProvider).value}/courses'),
        headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
      );
      if (response.statusCode == 200) {
        final list = CourseData.fromJsonList(jsonDecode(response.body) as List);
        ref.read(coursesCacheProvider.notifier).setCache(list);
        ref.read(coursesCacheTimeProvider.notifier).setTime(DateTime.now());
        setState(() => _courses = list);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  List<SearchResult> get _allResults {
    final isTeacher = ref.read(userInfoProvider).value?.role == 'Teacher';
    final dynamic = _courses
        .expand(
          (course) => [
            SearchResult(
              title: course.name,
              subtitle: 'Course',
              icon: Icons.book,
              route: '/course/detail',
              arguments: CourseDetailArgs(courseId: course.id),
            ),
            SearchResult(
              title: course.name,
              subtitle: 'Forum',
              icon: Icons.chat,
              route: '/forum',
              arguments: ForumArgs(courseId: course.id),
            ),
            if (isTeacher)
              SearchResult(
                title: course.name,
                subtitle: 'Grade Edit',
                icon: Icons.edit,
                route: '/course/grades/edit',
                arguments: EditGradeArgs(courseId: course.id),
              ),
          ],
        )
        .toList();
    return [..._pages, ...dynamic];
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _allResults.where((p) {
      final words = _query.toLowerCase().split(' ');
      final combined = '${p.title} ${p.subtitle ?? ''}'.toLowerCase();
      return words.every((word) => combined.contains(word));
    }).toList();
    return Material(
      color: Colors.transparent,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: GestureDetector(
          onTap: widget.onClose,
          child: Container(
            color: Colors.black54,
            child: SlideTransition(
              position: _slideAnimation,
              child: GestureDetector(
                onTap: () {}, // prevent closing when tapping the sheet
                child: SafeArea(
                  child: Container(
                    margin: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(color: Color(0x33000000), blurRadius: 24),
                      ],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            onChanged: (value) {
                              setState(() => _query = value);
                              final results = _allResults.where((p) {
                                final words = _query.toLowerCase().split(' ');
                                final combined =
                                    '${p.title} ${p.subtitle ?? ''}'
                                        .toLowerCase();
                                return words.every(
                                  (word) => combined.contains(word),
                                );
                              }).toList();
                              if (results.length == 1) {
                                _navigate(
                                  context,
                                  results.first.route,
                                  results.first.arguments,
                                );
                              }
                            },
                            decoration: InputDecoration(
                              hintText: "Search...",
                              prefixIcon: Icon(Icons.search),
                              suffixIcon: IconButton(
                                icon: Icon(Icons.close),
                                onPressed: widget.onClose,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32),
                                borderSide: BorderSide.none,
                              ),
                              filled: true,
                              fillColor: Color(0xFFF5F5F5),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView(
                            children: filtered
                                .map(
                                  (result) => ListTile(
                                    leading: Icon(result.icon),
                                    title: Text(result.title),
                                    subtitle: result.subtitle != null
                                        ? Text(result.subtitle!)
                                        : null,
                                    onTap: () => _navigate(
                                      context,
                                      result.route,
                                      result.arguments,
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SearchResult {
  final String title;
  final String? subtitle;
  final IconData icon;
  final String route;
  final Object? arguments;
  const SearchResult({
    required this.title,
    this.subtitle,
    required this.icon,
    required this.route,
    this.arguments,
  });
}
