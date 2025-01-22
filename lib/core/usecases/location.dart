class Location {
  final String country;
  final String city;

  Location({
    required this.country,
    required this.city,
  });

  // Convert Location to JSON
  Map<String, dynamic> toJson() => {
        'country': country,
        'city': city,
      };

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
      country: json['country'] ?? "no country",
      city: json['city'] ?? "no city",
    );
  }
}
