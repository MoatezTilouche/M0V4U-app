import 'dart:convert';

Actor actorFromJson(String str) => Actor.fromJson(json.decode(str));

String actorToJson(Actor data) => json.encode(data.toJson());

class Actor { bool? adult; List? alsoKnownAs; String? biography; DateTime? birthday; dynamic deathday; int? gender; String? homepage; int? id; String? imdbId; String? knownForDepartment; String? name; String? placeOfBirth; double? popularity; String? profilePath;
Actor({
    this.adult,
    this.alsoKnownAs,
    this.biography,
    this.birthday,
    this.deathday,
    this.gender,
    this.homepage,
    this.id,
    this.imdbId,
    this.knownForDepartment,
    this.name,
    this.placeOfBirth,
    this.popularity,
    this.profilePath,
});

factory Actor.fromJson(Map<String, dynamic> json) => Actor(
    adult: json["adult"] as bool?,
    alsoKnownAs: json["also_known_as"] == null
        ? []
        : List<String>.from(json["also_known_as"]!.map((x) => x as String)),
    biography: json["biography"] as String?,
    birthday: json["birthday"] != null ? DateTime.tryParse(json["birthday"] as String) : null,
    deathday: json["deathday"],
    gender: json["gender"] as int?,
    homepage: json["homepage"] as String?,
    id: json["id"] as int?,
    imdbId: json["imdb_id"] as String?,
    knownForDepartment: json["known_for_department"] as String?,
    name: json["name"] as String?,
    placeOfBirth: json["place_of_birth"] as String?,
    popularity: (json["popularity"] as num?)?.toDouble(),
    profilePath: json["profile_path"] as String?,
);

Map<String, dynamic> toJson() => {
    "adult": adult,
    "also_known_as": alsoKnownAs ?? [],
    "biography": biography,
    "birthday": birthday != null
        ? "${birthday!.year.toString().padLeft(4, '0')}-${birthday!.month.toString().padLeft(2, '0')}-${birthday!.day.toString().padLeft(2, '0')}"
        : null,
    "deathday": deathday,
    "gender": gender,
    "homepage": homepage,
    "id": id,
    "imdb_id": imdbId,
    "known_for_department": knownForDepartment,
    "name": name,
    "place_of_birth": placeOfBirth,
    "popularity": popularity,
    "profile_path": profilePath,
};

@override
String toString() => 'Actor(id: $id, name: $name, profilePath: $profilePath)';}