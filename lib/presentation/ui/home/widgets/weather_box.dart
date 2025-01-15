import 'package:drawee/presentation/ui/weather_post/weather_post_page.dart';
import 'package:flutter/material.dart';

class WeatherBox extends StatelessWidget {
  const WeatherBox(this.title, this.imagePath, {super.key});

  final String title;
  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => WeatherPostPage(fromHome: title)));
        },
        child: Container(
          height: 130,
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
        ),
      ),
    );
  }
}
