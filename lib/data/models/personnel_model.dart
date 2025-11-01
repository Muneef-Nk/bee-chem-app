class PersonnelListModel {
  bool? status;
  List<Personnel>? data;

  PersonnelListModel({this.status, this.data});

  PersonnelListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Personnel>[];
      json['data'].forEach((v) {
        data!.add(new Personnel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Personnel {
  int? id;
  String? firstName;
  String? lastName;
  String? address;
  String? latitude;
  String? longitude;
  String? suburb;
  String? state;
  String? postcode;
  String? country;
  String? contactNumber;
  String? additionalNotes;
  String? status;
  String? roleIds;
  String? createdBy;
  String? updatedBy;
  List<RoleDetail>? roleDetails;
  List<String>? apiaryRoleArray;

  Personnel({
    this.id,
    this.firstName,
    this.lastName,
    this.address,
    this.latitude,
    this.longitude,
    this.suburb,
    this.state,
    this.postcode,
    this.country,
    this.contactNumber,
    this.additionalNotes,
    this.status,
    this.roleIds,
    this.createdBy,
    this.updatedBy,
    this.roleDetails,
    this.apiaryRoleArray,
  });

  Personnel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    address = json['address'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    suburb = json['suburb'];
    state = json['state'];
    postcode = json['postcode'];
    country = json['country'];
    contactNumber = json['contact_number'];
    additionalNotes = json['additional_notes'];
    status = json['status'];
    roleIds = json['role_ids'];
    createdBy = json['created_by'];
    updatedBy = json['updated_by'];
    if (json['role_details'] != null) {
      roleDetails = <RoleDetail>[];
      json['role_details'].forEach((v) {
        roleDetails!.add(new RoleDetail.fromJson(v));
      });
    }
    apiaryRoleArray = json['apiary_role_array'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['address'] = this.address;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['suburb'] = this.suburb;
    data['state'] = this.state;
    data['postcode'] = this.postcode;
    data['country'] = this.country;
    data['contact_number'] = this.contactNumber;
    data['additional_notes'] = this.additionalNotes;
    data['status'] = this.status;
    data['role_ids'] = this.roleIds;
    data['created_by'] = this.createdBy;
    data['updated_by'] = this.updatedBy;
    if (this.roleDetails != null) {
      data['role_details'] = this.roleDetails!.map((v) => v.toJson()).toList();
    }
    data['apiary_role_array'] = this.apiaryRoleArray;
    return data;
  }
}

class RoleDetail {
  int? id;
  String? role;

  RoleDetail({this.id, this.role});

  RoleDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['role'] = this.role;
    return data;
  }
}
