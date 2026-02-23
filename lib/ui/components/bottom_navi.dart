import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moshir_test/ui/home/home.dart';
import 'package:moshir_test/ui/screens/calendar.dart';
import 'package:moshir_test/ui/screens/history.dart';
import 'package:moshir_test/ui/screens/notifications.dart';
import 'package:moshir_test/ui/screens/user_profile.dart';

class BottomNaviState extends StatelessWidget {
  const BottomNaviState({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    // final iconColor = isDarkMode ? Colors.white : Colors.black;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    return BottomAppBar(
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Tooltip(
            message: 'Profile',
            waitDuration: Duration(milliseconds: 1),
            child: IconButton(
              icon: SvgPicture.asset("assets/images/Personal.svg"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileState()),
                );
              },
            ),
          ),
          Tooltip(
            message: 'History',
            waitDuration: Duration(milliseconds: 1),
            child: IconButton(
              icon: SvgPicture.asset("assets/images/History.svg"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HistoryPage()),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Calendar',
            waitDuration: Duration(milliseconds: 1),
            child: IconButton(
              icon: SvgPicture.asset("assets/images/Calendar.svg"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CalendarPage()),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Notification',
            waitDuration: Duration(milliseconds: 1),
            child: IconButton(
              icon: SvgPicture.asset("assets/images/Notification.svg"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
                );
              },
            ),
          ),
          Tooltip(
            message: 'Home',
            waitDuration: Duration(milliseconds: 1),
            child: IconButton(
              icon: SvgPicture.asset("assets/images/Home.svg"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
