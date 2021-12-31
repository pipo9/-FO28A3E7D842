class NotificationModel {
  String id;
  String body;
  String title;
  String to;
  bool seen;
  String timeStamp;

  NotificationModel(data) {
    try {
          this.id = data.id;

    } catch (e) {
      print(e);
    }
    this.body = data['body'];
    this.timeStamp = data['timeStamp'].toString();
    this.title = data['title'];
    this.to = data['to'] ?? "";
    // // data.containsKey("seen")
    try {
      this.seen = data['seen'];
    } catch (e) {
      this.seen = false;
    }
  }

  Map<String, dynamic> toMap() {
    return {"seen": this.seen};
  }
}
