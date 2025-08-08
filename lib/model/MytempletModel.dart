class MytempleteModel {
  bool? success;
  String? message;
  String? timestamp;
  List<Data>? data;
  Meta? meta;

  MytempleteModel(
      {this.success, this.message, this.timestamp, this.data, this.meta});

  MytempleteModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    timestamp = json['timestamp'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    meta = json['meta'] != null ? Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    data['timestamp'] = this.timestamp;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (this.meta != null) {
      data['meta'] = this.meta!.toJson();
    }
    return data;
  }
}

class Data {
  String? sId;
  String? userId;
  String? name;
  String? subject;
  String? body;
  String? regards;
  bool? isFavorite;
  List<String>? tags;
  int? usageCount;
  String? createdAt;
  String? updatedAt;
  int? iV;

  Data({
    this.sId,
    this.userId,
    this.name,
    this.subject,
    this.body,
    this.regards,
    this.isFavorite,
    this.tags,
    this.usageCount,
    this.createdAt,
    this.updatedAt,
    this.iV,
  });

  Data.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userId = json['userId'];
    name = json['name'];
    subject = json['subject'];
    body = json['body'];
    regards = json['regards'];
    isFavorite = json['isFavorite'];
    tags = json['tags'] != null ? List<String>.from(json['tags']) : null;
    usageCount = json['usageCount'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = sId;
    data['userId'] = userId;
    data['name'] = name;
    data['subject'] = subject;
    data['body'] = body;
    data['regards'] = regards;
    data['isFavorite'] = isFavorite;
    if (tags != null) {
      data['tags'] = tags;
    }
    data['usageCount'] = usageCount;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    return data;
  }
}

class Meta {
  Pagination? pagination;

  Meta({this.pagination});

  Meta.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.pagination != null) {
      data['pagination'] = this.pagination!.toJson();
    }
    return data;
  }
}

class Pagination {
  int? currentPage;
  int? totalPages;
  int? totalItems;
  int? itemsPerPage;
  bool? hasNextPage;
  bool? hasPrevPage;

  Pagination(
      {this.currentPage,
      this.totalPages,
      this.totalItems,
      this.itemsPerPage,
      this.hasNextPage,
      this.hasPrevPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    totalItems = json['totalItems'];
    itemsPerPage = json['itemsPerPage'];
    hasNextPage = json['hasNextPage'];
    hasPrevPage = json['hasPrevPage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['currentPage'] = this.currentPage;
    data['totalPages'] = this.totalPages;
    data['totalItems'] = this.totalItems;
    data['itemsPerPage'] = this.itemsPerPage;
    data['hasNextPage'] = this.hasNextPage;
    data['hasPrevPage'] = this.hasPrevPage;
    return data;
  }
}
