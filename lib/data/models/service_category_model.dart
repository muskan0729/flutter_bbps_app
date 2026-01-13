class ServiceCategoryResponse {
  final bool status;
  final List<String> categories;

  ServiceCategoryResponse({required this.status, required this.categories});

  factory ServiceCategoryResponse.fromJson(Map<String, dynamic> json) {
    return ServiceCategoryResponse(
      status: json['status'] ?? false,
      categories: List<String>.from(json['categories'] ?? []),
    );
  }
}
