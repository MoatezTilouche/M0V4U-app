import 'dart:convert';

Actor actorFromJson(String str) => Actor.fromJson(json.decode(str));

String actorToJson(Actor data) => json.encode(data.toJson());

class Actor {
    bool? adult;
    List<String>? alsoKnownAs;
    String? biography;
    DateTime? birthday;
    dynamic deathday;
    int? gender;
    dynamic homepage;
    int? id;
    String? imdbId;
    String? knownForDepartment;
    String? name;
    String? placeOfBirth;
    double? popularity;
    String? profilePath;

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
        adult: json["adult"],
        alsoKnownAs: json["also_known_as"] == null ? [] : List<String>.from(json["also_known_as"]!.map((x) => x)),
        biography: json["biography"],
        birthday: DateTime.parse(json["birthday"]),
        deathday: json["deathday"],
        gender: json["gender"],
        homepage: json["homepage"],
        id: json["id"],
        imdbId: json["imdb_id"],
        knownForDepartment: json["known_for_department"],
        name: json["name"],
        placeOfBirth: json["place_of_birth"],
        popularity: json["popularity"].toDouble(),
        profilePath: json["profile_path"],
    );

    Map<String, dynamic> toJson() => {
        "adult": adult,
        "also_known_as": alsoKnownAs == null ? [] : List<dynamic>.from(alsoKnownAs!.map((x) => x)),
        "biography": biography,
        "birthday": "${birthday!.year.toString().padLeft(4,'0')}-${birthday!.month.toString().padLeft(2,'0')}-${birthday!.day.toString().padLeft(2,'0')}",
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
}
