import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SchedulePage extends ConsumerStatefulWidget {
  const SchedulePage({super.key});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends ConsumerState<SchedulePage> {
  final Map<DateTime, List<Map<String, dynamic>>> _events = {};
  List<Map<String, dynamic>> _selectedEvents = [];
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FAFC),
      body: Column(
        children: [
          _buildTopBar(),
          const SizedBox(height: 16.0),
          _buildCalendarBox(),
          const SizedBox(height: 16.0),
          _buildAppointmentsTitle(),
          const SizedBox(height: 8.0),
          _buildAppointmentList(),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Schedule',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.filter_list, color: Color(0xFF718096)),
                onPressed: () {
                  // Handle filter button press
                },
              ),
              IconButton(
                icon: Icon(Icons.search, color: Color(0xFF718096)),
                onPressed: () {
                  // Handle search button press
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8.0,
              spreadRadius: 2.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: _buildCalendarGrid(),
      ),
    );
  }

  Widget _buildCalendarGrid() {
    return TableCalendar(
      firstDay: DateTime.utc(2000, 1, 1),
      lastDay: DateTime.utc(2100, 12, 31),
      focusedDay: _selectedDay,
      calendarFormat: _calendarFormat,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        setState(() {
          _selectedDay = selectedDay;
          _selectedEvents = _events[selectedDay] ?? [];
        });
      },
      onFormatChanged: (format) {
        setState(() {
          _calendarFormat = format;
        });
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
      headerVisible: false,
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle:
            TextStyle(color: Color(0xFF718096), fontWeight: FontWeight.w600),
        weekendStyle:
            TextStyle(color: Color(0xFF718096), fontWeight: FontWeight.w600),
      ),
      calendarStyle: CalendarStyle(
        todayDecoration: BoxDecoration(
          color: Color(0xFF4299E1),
          shape: BoxShape.circle,
        ),
        selectedDecoration: BoxDecoration(
          color: Color(0xFF4299E1),
          shape: BoxShape.circle,
        ),
        defaultDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        weekendDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        outsideDecoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        defaultTextStyle: TextStyle(color: Color(0xFF4A5568)),
        weekendTextStyle: TextStyle(color: Color(0xFF4A5568)),
        outsideTextStyle: TextStyle(color: Color(0xFFCBD5E0)),
      ),
    );
  }

  Widget _buildAppointmentsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Appointments',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2D3748),
            ),
          ),
          ElevatedButton(
            onPressed: () => _showAddEventDialog(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4299E1), // Blue color
            ),
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentList() {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(16.0),
        scrollDirection: Axis.horizontal,
        children: _selectedEvents.map((event) {
          return Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: _buildAppointmentCard(
              title: event['title'],
              timeSlot: event['timeSlot'],
              progress: event['progress'],
              daysLeft: event['daysLeft'],
              color: event['color'],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String title,
    required String timeSlot,
    required double progress,
    required String daysLeft,
    required Color color,
  }) {
    return Container(
      width: 280,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 4.0,
                    color: color,
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Row(
                          children: [
                            Icon(Icons.access_time,
                                size: 16, color: Color(0xFF718096)),
                            const SizedBox(width: 4.0),
                            Text(
                              timeSlot,
                              style: TextStyle(
                                fontSize: 14,
                                color: Color(0xFF718096),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: Text(
                      daysLeft,
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Expanded(
                    child: LinearPercentIndicator(
                      lineHeight: 4.0,
                      percent: progress,
                      backgroundColor: Color(0xFFE2E8F0),
                      progressColor: color,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddEventDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController timeController = TextEditingController();
    TextEditingController periodController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(hintText: 'Enter name'),
            ),
            TextField(
              controller: timeController,
              decoration: InputDecoration(
                  hintText: 'Enter time (e.g., 08:00 - 11:50 AM)'),
            ),
            TextField(
              controller: periodController,
              decoration:
                  InputDecoration(hintText: 'Enter period (e.g., 2 days left)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  timeController.text.isNotEmpty &&
                  periodController.text.isNotEmpty) {
                // Add the new appointment to the list
                setState(() {
                  _events[_selectedDay] = [
                    ...?_events[_selectedDay],
                    {
                      'title': nameController.text,
                      'timeSlot': timeController.text,
                      'progress': 0.0, // Default progress
                      'daysLeft': periodController.text,
                      'color': Color(0xFF4299E1), // Default color
                    }
                  ];
                  _selectedEvents = _events[_selectedDay]!;
                });
              }
              Navigator.pop(context);
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }
}
