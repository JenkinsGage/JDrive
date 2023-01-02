class Item {
  final String id;
  final int ownerId;
  final String name;
  final List<dynamic> accessibleUsersId;
  final bool isSharable;
  final String type;

  Item(this.id, this.ownerId, this.name, this.accessibleUsersId, this.isSharable, this.type);

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(json['Id'], json['Owner'], json['Name'], json['Access'], json['IsSharable'], json['Type']);
  }
}

class Folder {
  final String id;
  final int ownerId;
  final String name;
  final List<dynamic> accessibleUsersId;
  final bool isSharable;
  final String type;

  final String createdTime;
  final List<dynamic> files;
  final dynamic parentFolder;
  final List<dynamic> subFolders;

  Folder(this.id, this.ownerId, this.name, this.accessibleUsersId, this.isSharable, this.type, this.createdTime,
      this.files, this.parentFolder, this.subFolders);

  factory Folder.fromJson(Map<String, dynamic> json) {
    return Folder(json['Id'], json['Owner'], json['Name'], json['Access'], json['IsSharable'], json['Type'],
        json['CreatedTime'], json['Files'], json['ParentFolder'], json['SubFolders']);
  }
}

class File {
  final String id;
  final int ownerId;
  final String name;
  final List<dynamic> accessibleUsersId;
  final bool isSharable;
  final String type;

  final String uploadedTime;
  final String hash;
  final int size;
  final dynamic folder;

  File(this.id, this.ownerId, this.name, this.accessibleUsersId, this.isSharable, this.type, this.uploadedTime,
      this.hash, this.size, this.folder);

  factory File.fromJson(Map<String, dynamic> json) {
    return File(json['Id'], json['Owner'], json['Name'], json['Access'], json['IsSharable'], json['Type'],
        json['UploadedTime'], json['Hash'], json['Size'], json['Folder']);
  }
}
