class MyActivityRatingSendModel {
  String id;
  String rate;
  String comment;

  MyActivityRatingSendModel(this.id, this.rate, this.comment);

  toMap() {
    return {"activity_ID": id, "rating": rate, "comment": comment};
  }
}
