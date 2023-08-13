List<Audio> audioFromJson(List d) =>
    List<Audio>.from(d.map((x) => Audio.fromJson(x)));

class Audio {
  final String id;
  final String folderId;
  final String originalUrl;
  final String reciterImg;
  final String reciterName;
  final String reciterRef;
  final String surah;

  Audio({
    required this.id,
    required this.folderId,
    required this.originalUrl,
    required this.reciterImg,
    required this.reciterName,
    required this.reciterRef,
    required this.surah,
  });

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        id: json["id"],
        folderId: json["folderId"],
        originalUrl: json["original_url"],
        reciterImg: json["reciter_img"],
        reciterName: json["reciter_name"],
        reciterRef: json["reciter_ref"],
        surah: json["surah"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "folderId": folderId,
        "original_url": originalUrl,
        "reciter_img": reciterImg,
        "reciter_name": reciterName,
        "reciter_ref": reciterRef,
        "surah": surah,
      };
}
