List<City> citiesFromJson(List d) =>
    List<City>.from(d.map((x) => City.fromJson(x)));

class City {
  final String name;
  final String country;
  final double latitude;
  final double longitude;

  City({
    required this.name,
    required this.country,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) => City(
        name: json["name"],
        country: json["country"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "country": country,
        "latitude": latitude,
        "longitude": longitude,
      };
}
