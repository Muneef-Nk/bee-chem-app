class PersonnelListModel {
  final bool status;
  final List<Personnel> data;

  PersonnelListModel({required this.status, required this.data});

  factory PersonnelListModel.fromJson(Map<String, dynamic> json) {
    return PersonnelListModel(
      status: json['status'] ?? false,
      data:
          (json['data'] as List<dynamic>?)?.map((item) => Personnel.fromJson(item)).toList() ?? [],
    );
  }
}

class Personnel {
  final int id;
  final String? firstName;
  final String? lastName;
  final String? address;
  final String? latitude;
  final String? longitude;
  final String? suburb;
  final String? state;
  final String? postcode;
  final String? country;
  final String? contactNumber;
  final String? additionalNotes;
  final String? status;
  final String? createdBy;
  final String? updatedBy;
  final List<RoleDetail> roleDetails;
  final List<String> apiaryRoleArray;

  Personnel({
    required this.id,
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
    this.createdBy,
    this.updatedBy,
    required this.roleDetails,
    required this.apiaryRoleArray,
  });

  factory Personnel.fromJson(Map<String, dynamic> json) {
    return Personnel(
      id: json['id'] ?? 0,
      firstName: json['first_name'],
      lastName: json['last_name'],
      address: json['address'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      suburb: json['suburb'],
      state: json['state'],
      postcode: json['postcode'],
      country: json['country'],
      contactNumber: json['contact_number'],
      additionalNotes: json['additional_notes'],
      status: json['status'],
      createdBy: json['created_by'],
      updatedBy: json['updated_by'],
      roleDetails:
          (json['role_details'] as List<dynamic>?)?.map((e) => RoleDetail.fromJson(e)).toList() ??
          [],
      apiaryRoleArray:
          (json['apiary_role_array'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
    );
  }
}

class RoleDetail {
  final int id;
  final String role;

  RoleDetail({required this.id, required this.role});

  factory RoleDetail.fromJson(Map<String, dynamic> json) {
    return RoleDetail(id: json['id'] ?? 0, role: json['role'] ?? '');
  }
}
