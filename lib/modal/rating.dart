import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  String? feedback;
  String? ratedBy;
  String? ratingId;
  double? overAllRating;
  double? behaviour;
  Timestamp? ratedAt;
  double? checkup;
  double? facility;

  Rating(
      {this.feedback,
      this.ratedBy,
      this.ratingId,
      this.overAllRating,
      this.behaviour,
      this.ratedAt,
      this.checkup,
      this.facility});

  Rating.fromJson(dynamic json) {
    feedback = json["feedback"];
    ratedBy = json["rated_by"];
    ratingId = json["rating_id"];
    overAllRating = json["over_all_rating"];
    behaviour = json["behaviour"];
    ratedAt = json["rated_at"];
    checkup = json["checkup"];
    facility = json["facility"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["feedback"] = feedback;
    map["rated_by"] = ratedBy;
    map["rating_id"] = ratingId;
    map["over_all_rating"] = overAllRating;
    map["behaviour"] = behaviour;
    map["rated_at"] = ratedAt;
    map["checkup"] = checkup;
    map["facility"] = facility;
    return map;
  }
}
