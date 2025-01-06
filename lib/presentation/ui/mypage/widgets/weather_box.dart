import 'package:flutter/material.dart';

class WeatherBox extends StatelessWidget {
  const WeatherBox(this.title, this.imagePath);

  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 114,
      height: 120,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
            image: AssetImage(
              imagePath,
            ),
            fit: BoxFit.cover),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Pretendard',
          fontWeight: FontWeight.w700,
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
