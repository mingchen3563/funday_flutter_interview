import 'package:flutter/material.dart';
import 'package:funday_flutter_interview/presentation/guide_spots_page/guide_spots_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: GuideSpotsPage());
  }
}
