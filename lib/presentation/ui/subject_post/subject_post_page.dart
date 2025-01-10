import 'package:drawee/presentation/ui/subject_search/subject_search_page.dart';
import 'package:flutter/material.dart';

class SubjectPostPage extends StatelessWidget {
  const SubjectPostPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SubjectSearchPage(),
                  ));
            },
            child: Text('검색')),
        //child: Text('Subject Post Page'),
      ),
    );
  }
}
