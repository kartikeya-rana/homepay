import 'package:flutter_inset_box_shadow/flutter_inset_box_shadow.dart';
import 'package:flutter/material.dart' hide BoxDecoration, BoxShadow;

// const primaryColor = Color.fromARGB(255, 22, 27, 39);
const primaryColor = Color.fromARGB(255, 20, 20, 20);
const secondaryColor = Colors.teal;
const dividerColor = Colors.teal;

// Login Form
const loginFormlabelColor = Colors.white;
const loginFormInputColor = secondaryColor;
const loginFormBorderColor = Colors.white;

// Sign Out Popup Menu Button
const popUpMenuColor = secondaryColor;

// New House
const houseFormBorderColor = Colors.white;
const houseFormLabelColor = Colors.white;
const houseFormTextColor = Colors.white;

//Rental Card
const rentalCardBackground = primaryColor;

// Inside Shadow Effect
const insideShadow = [
  BoxShadow(
    blurRadius: 4,
    offset: Offset(5, 5),
    color: Colors.black54,
    inset: true,
  ),
  BoxShadow(
    blurRadius: 4,
    offset: Offset(-3, -3),
    color: Color(0xFF35393F),
    inset: true,
  ),
];
