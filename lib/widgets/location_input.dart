import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';

import '../models/place.dart';

class LoactionInput extends StatefulWidget {
  const LoactionInput({super.key, required this.onPickLocation});

  final void Function(PlaceLoaction location) onPickLocation;

  @override
  State<LoactionInput> createState() => _LoactionInputState();
}

class _LoactionInputState extends State<LoactionInput> {
  PlaceLoaction? _selecetedLocation;
  var _isGettingLocation = false;

  String get locationImage {
    if (_selecetedLocation == null) return '';

    final lat = _selecetedLocation!.latitude;
    final lng = _selecetedLocation!.longitude;

    return 'https://maps.googleapis.com/maps/api/staticmap?center=$lat,$lng,NY&zoom=16&size=600x300&maptype=roadmap&markers=color:red%7Clabel:A%7C$lat,$lng&key=YOUR_API_KEY';
  }

  void _getCurrentLocation() async {
    setState(() {
      _isGettingLocation = true;
    });

    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    setState(() {
      _isGettingLocation = true;
    });

    locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) return;

    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${locationData.latitude},${locationData.longitude}&key=YOUR_API_KEY');

    final response = await http.get(url);
    final resData = json.decode(response.body);
    final address =
        resData['results'][0]['formatted_address'] ?? 'Fake address Data';

    setState(() {
      _isGettingLocation = false;
      _selecetedLocation = PlaceLoaction(
        latitude: locationData.latitude!,
        longitude: locationData.longitude!,
        address: address,
      );
    });

    widget.onPickLocation(_selecetedLocation!);
  }

  @override
  Widget build(BuildContext context) {
    Widget previewContent = Text(
      'No Location Provided',
      textAlign: TextAlign.center,
      style: Theme.of(context)
          .textTheme
          .bodyLarge!
          .copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (_selecetedLocation != null) {
      previewContent = Image.network(
        locationImage,
        fit: BoxFit.cover,
        height: double.infinity,
        width: double.infinity,
      );
    }

    if (_isGettingLocation) {
      previewContent = const CircularProgressIndicator();
    }

    return Column(
      children: [
        Container(
          height: 170,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(
              width: 1,
              color: Theme.of(context).colorScheme.primary.withOpacity(.2),
            ),
          ),
          child: previewContent,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextButton.icon(
              onPressed: _getCurrentLocation,
              icon: const Icon(Icons.location_on),
              label: const Text('Get Current Location'),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.map),
              label: const Text('Select on map'),
            ),
          ],
        ),
      ],
    );
  }
}
