import 'package:flutter/material.dart';

import 'package:meals/data/dummy_data.dart';
import 'package:meals/models/category.dart';
import 'package:meals/models/meals.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/widgets/category_grid_item.dart';

class CategoriesScreen extends StatelessWidget {
  final List<Meal> availableMeals;
  final void Function(Meal meal) onToggleFavorite;

  const CategoriesScreen(
      {super.key,
      required this.onToggleFavorite,
      required this.availableMeals});

  void _selectCategory(BuildContext context, Category category) {
    final filteredMeals = availableMeals
        .where((element) => element.categories.contains(category.id))
        .toList();

    Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => MealsScreen(
        meals: filteredMeals,
        title: category.title,
        onToggleFavorite: onToggleFavorite,
      ),
    ));
    // Navigator.push(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return GridView(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      children: [
        // ...availableCategories
        //     .map((category) => CategoryGridItem(category: category)),
        for (final category in availableCategories)
          CategoryGridItem(
              category: category,
              onClickCategory: () {
                _selectCategory(context, category);
              }),
      ],
    );
  }
}
