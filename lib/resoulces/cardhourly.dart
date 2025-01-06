import 'dart:math';

import 'package:flutter/material.dart';

class HourlyForeCast extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyForeCast({super.key, required this.time, required this.icon, required this.temp});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                time,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,

                ),
              ),
              SizedBox(height: 8),
              Icon(
                icon,
                size: 32,
              ),
              SizedBox(height: 8),
              Text(
                temp, // Replaced the repeated '03:00' with temperature for relevance
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
