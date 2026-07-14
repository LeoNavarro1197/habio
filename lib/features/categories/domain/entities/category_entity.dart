class CategoryEntity {
  const CategoryEntity({
    required this.id,
    required this.name,
    required this.iconCodePoint,
  });

  final String id;
  final String name;
  final int iconCodePoint;

  CategoryEntity copyWith({
    String? id,
    String? name,
    int? iconCodePoint,
  }) {
    return CategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodePoint: iconCodePoint ?? this.iconCodePoint,
    );
  }
}
