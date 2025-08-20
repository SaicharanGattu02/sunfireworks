class WaypointWiseBoxesModel {
  bool? success;
  String? message;
  List<Data>? data;

  WaypointWiseBoxesModel({this.success, this.message, this.data});

  WaypointWiseBoxesModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  int? totalIndividuals;
  int? totalCombos;
  int? totalBags;
  Null? extraIndividuals;
  Null? extraBags;
  Null? extraCombos;

  Data(
      {this.id,
        this.totalIndividuals,
        this.totalCombos,
        this.totalBags,
        this.extraIndividuals,
        this.extraBags,
        this.extraCombos});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    totalIndividuals = json['total_individuals'];
    totalCombos = json['total_combos'];
    totalBags = json['total_bags'];
    extraIndividuals = json['extra_individuals'];
    extraBags = json['extra_bags'];
    extraCombos = json['extra_combos'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total_individuals'] = this.totalIndividuals;
    data['total_combos'] = this.totalCombos;
    data['total_bags'] = this.totalBags;
    data['extra_individuals'] = this.extraIndividuals;
    data['extra_bags'] = this.extraBags;
    data['extra_combos'] = this.extraCombos;
    return data;
  }
}
