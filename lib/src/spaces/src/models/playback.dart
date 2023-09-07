class LivePeerPlaybackResponse {
  String? type;
  Meta? meta;

  LivePeerPlaybackResponse({this.type, this.meta});

  LivePeerPlaybackResponse.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (meta != null) {
      data['meta'] = meta!.toJson();
    }
    return data;
  }
}

class Meta {
  int? live;
  List<Source>? source;

  Meta({this.live, this.source});

  Meta.fromJson(Map<String, dynamic> json) {
    live = json['live'];
    if (json['source'] != null) {
      source = <Source>[];
      json['source'].forEach((v) {
        source!.add(Source.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['live'] = live;
    if (source != null) {
      data['source'] = source!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Source {
  String? hrn;
  String? type;
  String? url;

  Source({this.hrn, this.type, this.url});

  Source.fromJson(Map<String, dynamic> json) {
    hrn = json['hrn'];
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hrn'] = hrn;
    data['type'] = type;
    data['url'] = url;
    return data;
  }
}
