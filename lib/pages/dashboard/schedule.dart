import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:leaper/core/components/back_nav_heading.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:leaper/models/schedule_data.dart';
import 'package:leaper/pages/courses/course_detail.dart';
import 'package:leaper/providers/auth_provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Schedule extends ConsumerStatefulWidget {
  const Schedule({super.key});
  @override
  ConsumerState<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends ConsumerState<Schedule> {
  // Using Maps for O(1) lookup
  final Map<DateTime, EventType> _events = {};
  final Map<DateTime, List<DayComponent>> _scheduleByDay = {};
  final Set<String> _loadedMonths = {};
  bool _loading = false;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  void initState() {
    super.initState();
    loadSchedule(_focusedDay);
  }

  Future<void> loadSchedule(DateTime focusedDay) async {
    setState(() => _loading = true);
    final key = '${focusedDay.year}-${focusedDay.month}';

    if (_loadedMonths.contains(key)) return;

    try {
      final data = await fetchSchedule(focusedDay);
      final Map<DateTime, EventType> mappedEvents = {};
      final Map<DateTime, List<DayComponent>> group = {};

      for (final item in data) {
        if (item.startTime == null) continue;

        final date = DateTime(
          item.startTime!.year,
          item.startTime!.month,
          item.startTime!.day,
        );

        mappedEvents[date] = item.type;
        group.putIfAbsent(date, () => []);
        group[date]!.add(item);
      }

      setState(() {
        _scheduleByDay.addAll(group);
        _events.addAll(mappedEvents);
      });
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      setState(() => _loading = false);
      _loadedMonths.add(key);
    }
  }

  Future<List<DayComponent>> fetchSchedule(DateTime focusedDay) async {
    final start = DateTime(focusedDay.year, focusedDay.month, 1);
    final end = DateTime(focusedDay.year, focusedDay.month + 1, 0, 23, 59, 59);
    final response = await http.get(
      Uri.parse(
        '${dotenv.env['API_URL']}/schedule/${start.toIso8601String()}/${end.toIso8601String()}',
      ),
      headers: {'Authorization': 'Bearer ${ref.read(authProvider).value}'},
    );

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list.map((e) => DayComponent.fromJson(e)).toList();
    } else {
      throw Exception('Failed to fetch schedule');
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime activeDate = _selectedDay ?? _focusedDay;
    final selectedEvents =
        _scheduleByDay[DateTime(
          activeDate.year,
          activeDate.month,
          activeDate.day,
        )] ??
        [];
    return ScaffoldBackground(
      child: Center(
        child: Column(
          children: [
            BackNavHeading(heading: "Schedule"),
            Padding(
              padding: EdgeInsets.all(16),
              child: HeadingCard(
                heading: Padding(
                  padding: EdgeInsetsGeometry.only(left: 16),
                  child: Text(
                    DateFormat('MMMM yyyy').format(_focusedDay),
                    style: GoogleFonts.montserrat(
                      fontSize: FontSizes.medium,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                content: TableCalendar(
                  headerVisible: false,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 1, 1),
                  rowHeight: 40, // default is 52
                  daysOfWeekHeight: 20, // default is 16
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) {
                    return isSameDay(activeDate, day);
                  },
                  onPageChanged: (focusedDay) async {
                    setState(() => _focusedDay = focusedDay);
                    await loadSchedule(focusedDay);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(activeDate, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(
                        day.year,
                        day.month,
                        day.day,
                      );
                      final EventType? events = _events[normalizedDay];
                      return dayContainer(day, false, events);
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(
                        day.year,
                        day.month,
                        day.day,
                      );
                      final EventType? events = _events[normalizedDay];

                      return dayContainer(day, true, events);
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final normalizedDay = DateTime(
                        day.year,
                        day.month,
                        day.day,
                      );
                      final EventType? events = _events[normalizedDay];

                      return dayContainer(day, false, events);
                    },
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Color(0x335A5E75),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(32),
                        topRight: Radius.circular(32),
                      ),
                      border: Border(
                        top: BorderSide(color: Colors.white, width: 1),
                        left: BorderSide(color: Colors.white, width: 1),
                        right: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: CustomScrollView(
                      slivers: [
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: EdgeInsets.only(
                              top: 8,
                              left: 20,
                              right: 20,
                            ),
                            child: Text(
                              DateFormat(
                                'dd MMMM yyyy',
                              ).format(_selectedDay ?? _focusedDay),
                              style: GoogleFonts.montserrat(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: FontSizes.medium,
                              ),
                            ),
                          ),
                        ),
                        if (selectedEvents.isEmpty)
                          SliverFillRemaining(
                            child: Center(
                              child: Text(
                                "No Events on this day",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.montserrat(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        SliverPadding(
                          padding: EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: EventContainer(
                                  item: selectedEvents[index],
                                ),
                              ),
                              childCount: selectedEvents.length,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dayContainer(DateTime day, bool isSelected, EventType? event) {
    Color highlight = switch (event) {
      EventType.exam => Color(0xFF9E6666),
      EventType.course => Color(0xFF4A5580),
      null => Color(0xFFADB5D5),
    };

    Color textColor = switch (event) {
      EventType.exam => Colors.black,
      EventType.course => Colors.white,
      null => Colors.white,
    };
    // Special Case for Selected Day
    highlight = isSelected ? Color(0xFF000000) : highlight;
    textColor = isSelected ? Colors.white : textColor;

    return Container(
      margin: EdgeInsets.all(4),
      decoration: BoxDecoration(color: highlight, shape: BoxShape.circle),
      child: Center(
        child: Text(
          '${day.day}',
          style: GoogleFonts.montserrat(
            color: textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class EventContainer extends StatelessWidget {
  final DayComponent item;
  const EventContainer({super.key, required this.item});

  String renderEventType(EventType event) {
    return switch (event) {
      EventType.exam => "Examination",
      EventType.course => "Class Sesssion",
    };
  }

  String renderEventTime(DateTime start, DateTime end) {
    return "${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/course/detail',
          arguments: CourseDetailArgs(courseId: item.courseId),
        );
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Color(0x20373750),
          borderRadius: BorderRadius.all(Radius.circular(24)),
          border: Border.all(color: Colors.white),
        ),
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                renderEventType(item.type),
                style: GoogleFonts.montserrat(
                  color: Colors.white,
                  fontSize: FontSizes.medium,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(
                      item.courseName,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                  ),
                  Text(
                    renderEventTime(item.startTime!, item.endTime!),
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                ],
              ),

              SizedBox(height: 8),
              Text(
                "Session: ${item.sessionName}",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
              Text(
                "Location: ${item.location!}",
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
