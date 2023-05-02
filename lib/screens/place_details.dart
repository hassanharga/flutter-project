import 'package:flutter/material.dart';

import '../models/place.dart';

class PlaceDetailsScreen extends StatelessWidget {
  final Place place;

  const PlaceDetailsScreen({super.key, required this.place});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Center(
          child: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            height: double.infinity,
            width: double.infinity,
          )
        ],
      )
          // Text(
          //   place.title,
          //   style: Theme.of(context)
          //       .textTheme
          //       .titleMedium!
          //       .copyWith(color: Theme.of(context).colorScheme.onBackground),
          // ),
          ),
    );
  }
}
