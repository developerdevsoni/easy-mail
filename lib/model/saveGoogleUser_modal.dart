class saveGoogleUser_modal {
  bool? success;
  String? message;
  Data? data;

  saveGoogleUser_modal({this.success, this.message, this.data});

  saveGoogleUser_modal.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? email;
  String? name;
  int? iV;
  String? serverAuthCode;
  String? id;

  Data(
      {this.sId, this.email, this.name, this.iV, this.serverAuthCode, this.id});

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    iV = json['__v'];
    serverAuthCode = json['serverAuthCode'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['email'] = this.email;
    data['name'] = this.name;
    data['__v'] = this.iV;
    data['serverAuthCode'] = this.serverAuthCode;
    data['id'] = this.id;
    return data;
  }
}
