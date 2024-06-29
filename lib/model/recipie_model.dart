class RecipeModel {
  final String label;
  final String image;
  final String url;
  final String source;

  RecipeModel({
    required this.label,
    required this.image,
    required this.url,
    required this.source,
  });

  factory RecipeModel.fromMap(Map<String, dynamic> map) {
    return RecipeModel(
      label: map['label'],
      image: map['image'],
      url: map['url'],
      source: map['source'],
    );
  }
}
