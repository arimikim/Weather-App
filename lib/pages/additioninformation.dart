import 'package:flutter/material.dart';


class AddtionalInformation extends StatelessWidget {
  final IconData icon;
  final String label;
  final String Value;


  const AddtionalInformation({
    required this.icon,
    required this.label,
    required this.Value,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
        ),
        SizedBox(height: 8,),
        Text (label ),
        SizedBox(height: 8,),
Text(
  Value,
  style: TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold
  ),
)
      ],
    );
  }
}
