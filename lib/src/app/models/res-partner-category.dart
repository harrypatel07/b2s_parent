class ResPartnerCategory {
  dynamic sLastUpdate;
  dynamic active;
  dynamic childIds;
  dynamic color;
  dynamic createDate;
  dynamic createUid;
  dynamic displayName;
  dynamic id;
  dynamic name;
  dynamic parentId;
  dynamic parentPath;
  dynamic partnerIds;
  dynamic writeDate;
  dynamic writeUid;

  ResPartnerCategory(
      {this.sLastUpdate,
      this.active,
      this.childIds,
      this.color,
      this.createDate,
      this.createUid,
      this.displayName,
      this.id,
      this.name,
      this.parentId,
      this.parentPath,
      this.partnerIds,
      this.writeDate,
      this.writeUid});

  ResPartnerCategory.fromJson(Map<String, dynamic> json) {
    sLastUpdate = json['__last_update'];
    active = json['active'];
    childIds = json['child_ids'];
    color = json['color'];
    createDate = json['create_date'];
    createUid = json['create_uid'];
    displayName = json['display_name'];
    id = json['id'];
    name = json['name'];
    parentId = json['parent_id'];
    parentPath = json['parent_path'];
    partnerIds = json['partner_ids'];
    writeDate = json['write_date'];
    writeUid = json['write_uid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.sLastUpdate != null) data['__last_update'] = this.sLastUpdate;
    if (this.active != null) data['active'] = this.active;
    if (this.childIds != null) data['child_ids'] = this.childIds;
    if (this.color != null) data['color'] = this.color;
    if (this.createDate != null) data['create_date'] = this.createDate;
    if (this.createUid != null) data['create_uid'] = this.createUid;
    if (this.displayName != null) data['display_name'] = this.displayName;
    if (this.id != null) data['id'] = this.id;
    if (this.name != null) data['name'] = this.name;
    if (this.parentId != null) data['parent_id'] = this.parentId;
    if (this.parentPath != null) data['parent_path'] = this.parentPath;
    if (this.partnerIds != null) data['partner_ids'] = this.partnerIds;
    if (this.writeDate != null) data['write_date'] = this.writeDate;
    if (this.writeUid != null) data['write_uid'] = this.writeUid;
    return data;
  }
}
