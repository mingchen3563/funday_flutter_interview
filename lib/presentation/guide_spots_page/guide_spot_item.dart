import 'package:flutter/material.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';

class GuideSpotItem extends StatelessWidget {
  const GuideSpotItem({super.key, required this.guideSpot});
  final GuideSpot guideSpot;

  @override
  Widget build(BuildContext context) {
    return ListTile(title: Text(guideSpot.title));
  }
}
