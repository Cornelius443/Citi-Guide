

import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
    hintText: "Email",
    hintStyle: const TextStyle(
        color: Colors.white
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.amber),
    ),
    focusedBorder: const UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.grey),
    ),
    fillColor:  Colors.transparent,
    filled: false,
    prefixIcon: const Icon(Icons.email, color: Colors.white,)
);

var addInputDecoration = InputDecoration(

    hintStyle: const TextStyle(
        color: Colors.black
    ),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.black), // Set the default border color
    ),
    focusedBorder:  OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.black),
    ),
    prefixIcon: const Icon(Icons.nature, color: Colors.black,)
);