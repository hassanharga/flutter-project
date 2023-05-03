import 'dart:io';

import 'package:uuid/uuid.dart';

var uuid = const Uuid();

class PlaceLoaction {
  final double latitude;
  final double longitude;
  final String address;

  PlaceLoaction({
    required this.latitude,
    required this.longitude,
    required this.address,
  });
}

class Place {
  final String id;
  final String title;
  final File image;
  final PlaceLoaction location;

  Place({
    required this.title,
    required this.image,
    required this.location,
    String? id,
  }) : id = id ?? uuid.v4();
}
