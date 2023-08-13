import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../services/location.dart';
import '../../../shared/constants/constants.dart';
import '../../../shared/language/providers/language_provider.dart';
import '../../../shared/utils/utils.dart';
import '../../../shared/widgets/widgets.dart';

class QiblaScreen extends ConsumerStatefulWidget {
  const QiblaScreen({super.key});

  @override
  ConsumerState<QiblaScreen> createState() => _QiblaScreenState();
}

class _QiblaScreenState extends ConsumerState<QiblaScreen> {
  double? _latitude;
  double? _longitude;
  String? _address;

  double? _direction;
  double? _userHeading = 0;
  StreamSubscription<CompassEvent>? subscription;

  bool _isLoading = false;

  @override
  void initState() {
    _getCompassHeading();
    _getLocation(true);

    super.initState();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  _getCompassHeading() {
    subscription = FlutterCompass.events?.listen((CompassEvent event) {
      final heading = event.heading ?? 0;
      if (heading != _userHeading) {
        setState(() {
          _userHeading = heading;
        });
        // print('userHeading ====> $_userHeading');
      }
    });
  }

  _getLocation(bool refetch) async {
    try {
      setState(() {
        _isLoading = true;
      });
      var lang = ref.read(languageProvider);
      var locationData = await LocationService.getCurrentLocation(
        lang,
        refetch: refetch,
      );

      _latitude = locationData['latitude'];
      _longitude = locationData['longitude'];
      _address = locationData['address'];

      if (_latitude == null && _longitude == null) return;
      getQibla(_latitude!, _longitude!);
      setState(() {
        _isLoading = false;
      });
      print('qible direction =====> $_direction');
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  _toRadians(degrees) {
    return (degrees * pi) / 180;
  }

  // Converts from radians to degrees.
  _toDegrees(radians) {
    return (radians * 180) / pi;
  }

  void getQibla(double lat, double long) {
    // kaba direction
    final [makkahLatitude, makkahLongitude] = [21.4225241, 39.8261818];

    final latitude = _toRadians(lat);
    final longitude = _toRadians(long);

    final makkahLat = _toRadians(makkahLatitude);
    final makkahLong = _toRadians(makkahLongitude);

    var y = sin(makkahLong - longitude) * cos(makkahLat);
    var x = cos(latitude) * sin(makkahLat) -
        sin(latitude) * cos(makkahLat) * cos(makkahLong - longitude);

    var brng = atan2(y, x);
    // brng = _toDegrees(brng);

    setState(() {
      _direction = (brng + 360) % 360;
      // _direction = brng;
    });
  }

  _goBack() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: CustomAppBar(
          leadingIcon: ImgAssets.cancel,
          title: translate(context).qiblaDirection,
          onLeadingIconPressed: _goBack,
        ),
      ),
      body: LoaderOverlay(
        showLoader: _isLoading,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // address
              if (_address != null)
                Text(
                  _address!,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
              // qibla direction message
              const SizedBox(height: 10),
              if (_direction != null)
                Text(
                  '${translate(context).qiblaDirection}: ${_direction!.toStringAsFixed(3)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
              // direction
              const SizedBox(height: 20),
              Transform.rotate(
                angle: (_userHeading! * (pi / 180) * -1),
                // turns: turns,
                // duration: const Duration(milliseconds: 250),
                child: Stack(
                  textDirection: TextDirection.ltr,
                  children: [
                    SizedBox(
                      height: 320,
                      width: 320,
                      // color: AppColors.cyanColor,
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: 250,
                          height: 250,
                          decoration: const BoxDecoration(
                            color: AppColors.yellowColor,
                            shape: BoxShape.circle,
                          ),
                          child: _direction != null
                              ? Transform.rotate(
                                  angle: _direction!,
                                  child: const Center(
                                    child: DynamicIcon(
                                      ImgAssets.qibla,
                                      size: 100,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    // north
                    _Direction(
                      alignment: Alignment.topCenter,
                      title: translate(context).north,
                      flip: Flip.normal,
                    ),
                    // south
                    _Direction(
                      alignment: Alignment.bottomCenter,
                      title: translate(context).south,
                      flip: Flip.flipDown,
                    ),
                    // east
                    _Direction(
                      alignment: Alignment.centerRight,
                      title: translate(context).east,
                      flip: Flip.flipRight,
                    ),
                    // west
                    _Direction(
                      alignment: Alignment.centerLeft,
                      title: translate(context).west,
                      flip: Flip.flipLeft,
                    ),
                  ],
                ),
              ),
              // const Spacer(flex: 1),
              // compass heading
              const SizedBox(height: 20),
              if (_userHeading != null)
                Text(
                  '${translate(context).directionNow}: ${_userHeading!.toStringAsFixed(3)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.whiteColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

enum Flip { flipDown, flipRight, flipLeft, normal }

class _Direction extends StatelessWidget {
  final String title;
  final Alignment alignment;
  final Flip flip;

  final double _boxHeight = 35;

  const _Direction({
    required this.title,
    required this.alignment,
    required this.flip,
  });

  @override
  Widget build(BuildContext context) {
    var titleWid = Text(
      title,
      style: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 12,
      ),
    );

    var expWig = Expanded(
      flex: 1,
      child: Container(
        width: 5,
        color: AppColors.orangeColor,
      ),
    );
    return Positioned.fill(
      child: Align(
        alignment: alignment,
        child: SizedBox(
          // color: AppColors.purpleColor,
          width: flip == Flip.flipRight || flip == Flip.flipLeft
              ? _boxHeight
              : null,
          height: _boxHeight,
          child: flip == Flip.normal
              ? Column(
                  children: [titleWid, expWig],
                )
              : flip == Flip.flipRight
                  ? RotatedBox(
                      quarterTurns: 1,
                      child: Column(
                        children: [titleWid, expWig],
                      ),
                    )
                  : flip == Flip.flipLeft
                      ? RotatedBox(
                          quarterTurns: -1,
                          child: Column(
                            children: [titleWid, expWig],
                          ),
                        )
                      : Column(
                          children: [expWig, titleWid],
                        ),
        ),
      ),
    );
  }
}
