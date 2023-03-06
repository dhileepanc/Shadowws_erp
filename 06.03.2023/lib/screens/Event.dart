import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Event extends StatefulWidget {

  const Event({Key? key}) : super(key: key);

  @override
  _EventState createState() => _EventState();
}

class _EventState extends State<Event> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  String _eventName = '';
  String _eventType = 'Select';
  List _events = [];

  final List<String> _eventTypes = ['Select', 'Holiday', 'Event', 'Birthday'];

  void _submitForm() async {
    // Get the user ID and location from the project table using a backend service
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final url = Uri.parse('http://192.168.0.14/d_shadowws_client_6/add_cli_event.php?user_id=$userId');
    final response = await http.post(url, body: {
      'title': _eventName,
      'type': _eventType,
      'date': _selectedDay.toString(),
      'user_id': userId,
      'category': 'client',
      'location': 'Location', // Replace with actual location from the project table
    });

    final responseData = jsonDecode(response.body);
    print(responseData);
  }
  void _fetchEventsData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    String apiUrl =
        "http://localhost/add_cli_event.php?user_id=$userId}";
    var response = await http.get(Uri.parse(apiUrl));
    setState(() {
      _events = jsonDecode(response.body);
    });
  }
  @override
  void initState() {
    super.initState();
    _fetchEventsData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Event'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TableCalendar(
                  calendarFormat: _calendarFormat,
                  focusedDay: _focusedDay,
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  selectedDayPredicate: (day) {
                    return isSameDay(_selectedDay, day);
                  },
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Add Event"),
                        content: Container(
                          height: 150,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Event Name',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _eventName = value;
                                  });
                                },
                              ),
                              DropdownButtonFormField(
                                value: _eventType,
                                items: _eventTypes
                                    .map((type) =>
                                    DropdownMenuItem(value: type, child: Text(type)))
                                    .toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _eventType = value.toString();
                                  });
                                },
                                decoration: InputDecoration(
                                  labelText: 'Type',
                                ),
                              ),
                            ],
                          ),
                        ),
                        actions: <Widget>[
                          ElevatedButton(
                            onPressed: () {
                              _submitForm();
                              Navigator.of(context).pop();
                            },
                            child: Text("Submit"),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text("Cancel"),
                          ),
                        ],
                      ),
                    );
                  },
                  calendarStyle: CalendarStyle(
                    todayDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Events',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                Expanded(
                  child: ListView.builder(
                    itemCount: _events.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          title: Text(_events[index]['title']),
                          subtitle: Text(_events[index]['type']),
                          trailing: Text(_events[index]['date']),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}