

class pkt {
  String this1;
  String by;
  String the;
  List<With> withList;

  pkt({this.this1, this.by, this.the, this.withList});

  pkt.fromJson(Map<String, dynamic> json) {
    this1 = json['this'];
    by = json['by'];
    the = json['the'];
    if (json['with'] != null) {
      withList = new List<With>();
    json['with'].forEach((v) { withList.add(new With.fromJson(v)); });
  }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['this'] = this.this1;
    data['by'] = this.by;
    data['the'] = this.the;
    if (this.withList != null) {
    data['with'] = this.withList.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class With {
  String thing;
  String created;
  Content content;

  With({this.thing, this.created, this.content});

  With.fromJson(Map<String, dynamic> json) {
    thing = json['thing'];
    created = json['created'];
    content = json['content'] != null ? new Content.fromJson(json['content']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['thing'] = this.thing;
    data['created'] = this.created;
    if (this.content != null) {
      data['content'] = this.content.toJson();
    }
    return data;
  }
}

class Content {
  int lat;
  int long;

  Content({this.lat, this.long});

  Content.fromJson(Map<String, dynamic> json) {
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lat'] = this.lat;
    data['long'] = this.long;
    return data;
  }
}