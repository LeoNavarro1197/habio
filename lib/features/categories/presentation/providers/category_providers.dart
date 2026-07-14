import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/storage/hive_boxes.dart';
import '../../data/models/category_model.dart';
import '../../data/repositories/hive_category_repository.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return HiveCategoryRepository(Hive.box<CategoryModel>(HiveBoxes.categories));
});

final categoriesProvider = StreamProvider<List<CategoryEntity>>((ref) {
  return ref.watch(categoryRepositoryProvider).watchAll();
});
