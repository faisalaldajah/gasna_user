class Regions {
  List<Districts>? districts;

  Regions({this.districts});

  Regions.fromJson(Map<String, dynamic> json) {
    if (json['districts'] != null) {
      districts = <Districts>[];
      json['districts'].forEach((v) {
        districts!.add(new Districts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.districts != null) {
      data['districts'] = this.districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  int? districtID;
  String? districtAR;
  List<Cities>? cities;

  Districts({this.districtID,  this.districtAR, this.cities});

  Districts.fromJson(Map<String, dynamic> json) {
    districtID = json['districtID'];
    districtAR = json['districtAR'];
    if (json['cities'] != null) {
      cities = <Cities>[];
      json['cities'].forEach((v) {
        cities!.add(new Cities.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['districtID'] = this.districtID;
    data['districtAR'] = this.districtAR;
    if (this.cities != null) {
      data['cities'] = this.cities!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Cities {
  int? cityID;
  String? cityAR;

  Cities({this.cityID,  this.cityAR});

  Cities.fromJson(Map<String, dynamic> json) {
    cityID = json['cityID'];
    cityAR = json['cityAR'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cityID'] = this.cityID;
    data['cityAR'] = this.cityAR;
    return data;
  }
}
