import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:leaper/core/components/heading_card.dart';
import 'package:leaper/core/components/scaffold_background.dart';
import 'package:leaper/core/styles/text_styles/font_sizes.dart';
import 'package:table_calendar/table_calendar.dart';

enum EventType { classEvent, exam }

class Schedule extends StatefulWidget {
  const Schedule({super.key});
  @override
  State<Schedule> createState() => _ScheduleState();
}

class _ScheduleState extends State<Schedule> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  // TODO: Change to API
  final Map<DateTime, EventType> _events = {
    DateTime.utc(2026, 5, 7): EventType.exam,
    DateTime.utc(2026, 5, 10): EventType.classEvent,
  };
  @override
  Widget build(BuildContext context) {
    return ScaffoldBackground(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              HeadingCard(
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
                    return isSameDay(_selectedDay, day);
                  },
                  onPageChanged: (focusedDay) {
                    setState(() => _focusedDay = focusedDay);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    if (!isSameDay(_selectedDay, selectedDay)) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    }
                  },
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final EventType? events = _events[day];
                      return dayContainer(day, false, events);
                    },
                    selectedBuilder: (context, day, focusedDay) {
                      final EventType? events = _events[day];
                      return dayContainer(day, true, events);
                    },
                    todayBuilder: (context, day, focusedDay) {
                      final EventType? events = _events[day];
                      return dayContainer(day, false, events);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget dayContainer(DateTime day, bool isSelected, EventType? event) {
    final EventType? events = _events[day];

    Color highlight = switch (events) {
      EventType.exam => Color(0xFF9E6666),
      EventType.classEvent => Color(0xFF4A5580),
      null => Color(0xFFADB5D5),
    };

    Color textColor = switch (events) {
      EventType.exam => Colors.black,
      EventType.classEvent => Colors.white,
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
