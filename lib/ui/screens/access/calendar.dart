import 'dart:collection';

import 'package:lumen_app_registro/src/models/acceses_model.dart';
import 'package:lumen_app_registro/src/models/user_model.dart';
import 'package:lumen_app_registro/src/provider/user_provider.dart';
import 'package:lumen_app_registro/src/data/AccessService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key key}) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  AccessService accesService = AccessService();
  Registration r;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  var events;
  ValueNotifier<List<Access>> _selectedEvents = ValueNotifier([]);
  //bool _loading = true;
  bool _loading = false;
  UserProvider userProvider;

  @override
  void initState() {
    events = LinkedHashMap(
      equals: isSameDay,
      hashCode: getHashCode,
    );
    _selectedDay = _focusedDay;

    super.initState();
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getUserData();
    super.didChangeDependencies();
  }

  setLoading(value) {
    setState(() {
      _loading = value;
    });
  }

  getUserData() async {
    userProvider = Provider.of<UserProvider>(context, listen: true);
    r = userProvider.getRegistration;
    _getAccess(r.idbio.toString());
  }

  _getAccess(String idBio) async {
    try {
      var result = await accesService.getAllById(idBio);
      fillMap(result);
      setLoading(false);
      _selectedEvents.value = _getAccessForDay(_focusedDay);
    } catch (error) {
      print(error);
    }
    return;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  fillMap(List<Event> _events) {
    setState(() {
      _events.forEach((e) {
        if (e.checkInTime != null)
          events[e.date] = [Access(time: e.checkInTime, type: "Entrada")];
        if (e.departureTime != null)
          events[e.date].add(Access(time: e.departureTime, type: "Salida"));
      });
    });
  }

  List<Access> _getAccessForDay(DateTime day) {
    return events[day] ?? [];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getAccessForDay(selectedDay);
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () {
          setLoading(true);
          r = userProvider.getRegistration;
          _getAccess(r.idbio.toString());
          return;
        },
        child: ModalProgressHUD(
            inAsyncCall: _loading,
            child: Column(children: [
              TableCalendar<Access>(
                locale: 'es-ES',
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2025, 3, 14),
                focusedDay: _focusedDay,
                calendarFormat: CalendarFormat.month,
                calendarStyle: CalendarStyle(
                    defaultTextStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.04)),
                headerStyle: HeaderStyle(
                    titleCentered: true,
                    titleTextFormatter: (date, locale) =>
                        DateFormat.yMMM(locale)
                            .format(date)
                            .toString()
                            .toUpperCase(),
                    formatButtonVisible: false,
                    titleTextStyle: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.07)),
                selectedDayPredicate: (day) {
                  // Use `selectedDayPredicate` to determine which day is currently selected.
                  // If this returns true, then `day` will be marked as selected.

                  // Using `isSameDay` is recommended to disregard
                  // the time-part of compared DateTime objects.
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                eventLoader: _getAccessForDay,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },
              ),
              const SizedBox(height: 8.0),
              Expanded(child: _accessDetails()),
            ])));
  }

  _accessDetails() {
    return ValueListenableBuilder<List<Access>>(
      valueListenable: _selectedEvents,
      builder: (context, value, _) {
        return Row(mainAxisSize: MainAxisSize.max, children: [
          Expanded(
              child: ListView.builder(
            itemCount: value.length,
            itemBuilder: (context, index) {
              var time = DateFormat("HH:mm").format(value[index].time);
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 4.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ListTile(
                  onTap: () => print('${value[index]}'),
                  title: Text(time),
                  leading: Text(value[index].type),
                ),
              );
            },
          )),
          value.length == 2
              ? Container(
                  width: 100,
                  padding: EdgeInsets.only(top: 40),
                  child: Align(
                      alignment: Alignment.topCenter,
                      child: Icon(
                        Icons.check_circle,
                        size: 50,
                        color: Colors.green,
                      )))
              : value.length == 1
                  ? Container(
                      width: 100,
                      padding: EdgeInsets.only(top: 40),
                      child: Align(
                          alignment: Alignment.topCenter,
                          child: Icon(
                            Icons.error,
                            size: 50,
                            color: Colors.orange,
                          )))
                  : Container(),
        ]);
      },
    );
  }
}
