abstract class BaseModel {
  String get tableName;
  int? id;
  DateTime? createdAt;
  DateTime? updatedAt;
  int isDeleted = 0;

  BaseModel({this.id, this.createdAt, this.updatedAt, this.isDeleted = 0});

  Map<String, dynamic> toJson();

}
