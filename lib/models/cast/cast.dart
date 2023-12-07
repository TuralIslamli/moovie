class Cast {
  int? id, genderId, castId;
  String? department, name, characterName, profilePath;

  Cast(cast) {
    id = cast["id"];
    genderId = cast["gender"];
    castId = cast["cast_id"];
    name = cast["name"];
    characterName = cast["character"];
    department = cast["known_for_department"];
    profilePath = "https://image.tmdb.org/t/p/w500/${cast["profile_path"]}";
  }
}
