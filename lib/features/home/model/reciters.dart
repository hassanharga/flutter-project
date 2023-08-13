List<Reciter> reciterFromJson(List d) =>
    List<Reciter>.from(d.map((x) => Reciter.fromJson(x)));

class Reciter {
  final String id;
  final String name;
  final String imgUrl;

  Reciter({
    required this.id,
    required this.name,
    required this.imgUrl,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) => Reciter(
        id: json["id"],
        name: json["name"],
        imgUrl: json["imgUrl"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "imgUrl": imgUrl,
      };
}
