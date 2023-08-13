import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';
import '../models/city.dart';

class CitiesDetails extends StatelessWidget {
  final bool isSearchingForCities;
  final List<City> cities;

  final Function(City city) onCityClick;

  const CitiesDetails({
    super.key,
    required this.isSearchingForCities,
    required this.cities,
    required this.onCityClick,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = const SizedBox.shrink();

    if (isSearchingForCities) {
      child = const Center(
        child: SizedBox(
          height: 25,
          width: 25,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    } else if (cities.isEmpty) {
      child = _Tile(
        text: translate(context).noCitites,
      );
    } else {
      child = Column(
        children: cities
            .map(
              (city) => InkWell(
                onTap: () => onCityClick(city),
                child: _Tile(text: city.name),
              ),
            )
            .toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: child,
    );
  }
}

class _Tile extends StatelessWidget {
  final String text;

  const _Tile({
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 5,
      ),
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 1,
            color: AppColors.grayColor3,
          ),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: AppColors.grayColor3,
        ),
      ),
    );
  }
}
