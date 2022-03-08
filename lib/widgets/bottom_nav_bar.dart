import 'package:flutter/material.dart';
import 'package:verdant_solar/utils/constants.dart';


var bars = [
  BottomNavigationBarItem(
    backgroundColor: Colors.black,
    icon: Icon(
      Icons.home_outlined,
      color: Color(0xff787878),
    ),
    activeIcon: Icon(
      Icons.home,
      color: Color(kPrimaryColor),
    ),
    label: 'Home',
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.compare_arrows_outlined,
      color: Color(0xff787878),
    ),
    activeIcon: Icon(
      Icons.compare_arrows,
      color: Color(kPrimaryColor),
    ),
    label: 'Comparison',
  ),
  BottomNavigationBarItem(
    icon: Icon(
      Icons.person_outlined,
      color: Color(0xff787878),
    ),
    activeIcon: Icon(
      Icons.person,
      color: Color(kPrimaryColor),
    ),
    label: 'User Management',
  ),
];
