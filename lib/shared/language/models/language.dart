class Language {
  final String id;
  final String name;
  final String code;

  Language(this.id, this.name, this.code);

  static List<Language> languageList() {
    return [
      Language('1', 'عربى', 'ar'),
      Language('2', 'English', 'en'),
    ];
  }
}
