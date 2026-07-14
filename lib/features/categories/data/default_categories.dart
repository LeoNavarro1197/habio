import 'package:flutter/material.dart';

import 'models/category_model.dart';

List<CategoryModel> buildDefaultCategories() {
  return [
    CategoryModel(
      id: 'study',
      name: 'Estudio',
      iconCodePoint: Icons.auto_stories_rounded.codePoint,
    ),
    CategoryModel(
      id: 'work',
      name: 'Trabajo',
      iconCodePoint: Icons.work_outline_rounded.codePoint,
    ),
    CategoryModel(
      id: 'health',
      name: 'Salud',
      iconCodePoint: Icons.favorite_outline_rounded.codePoint,
    ),
    CategoryModel(
      id: 'personal',
      name: 'Personal',
      iconCodePoint: Icons.self_improvement_rounded.codePoint,
    ),
  ];
}
