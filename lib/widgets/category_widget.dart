// CATEGORY BUTTON WIDGET
import 'package:flutter/material.dart';

import '../controller/category_controller.dart';

class CategoryButton extends StatelessWidget {
  final String category;
  final CategoryController controller;

  CategoryButton({required this.category, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextButton(onPressed: () => controller.selectedSector(category),
        child: Text(category.toUpperCase())
    );
  }
}