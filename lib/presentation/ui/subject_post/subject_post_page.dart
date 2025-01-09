import 'package:drawee/presentation/ui/subject_search/subject_search_page.dart';
import 'package:flutter/material.dart';

class SubjectPostPage extends StatelessWidget {
  const SubjectPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SubjectSearchPage(),
              )),
          child: Container(
            width: 100,
            height: 100,
            color: Colors.black,
          ),
        ),
        //child: Text('Subject Post Page'),
      ),
    );
  }
}
