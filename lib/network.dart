import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'server_spec.dart' as server;
import 'models.dart';
import 'file_system.dart';

var dio = Dio(BaseOptions(baseUrl: server.serverAddress, headers: server.headers));

Future<List<Item>> fetchUserItems() async {
  List<Item> items = [];
  final response = await dio.get(server.apiItems);
  if (response.statusCode == 200) {
    response.data.forEach((item) => items.add(Item.fromJson(item)));
  }
  return items;
}

Future<List<Folder>> fetchRoot() async {
  List<Folder> root = [];
  final response = await dio.get(server.apiRoot);
  print(response.data);
  try {
    if (response.statusCode == 200) {
      response.data.forEach((item) => root.add(Folder.fromJson(item)));
    }
  } catch (e) {
    print(e);
  }
  return root;
}

Future<Folder?> fetchFolder(String folderId) async {
  final response = await dio.get(server.apiFolders + folderId, queryParameters: {'expand': '~all'});
  print(response.data);
  if (response.statusCode == 200) {
    return Folder.fromJson(response.data);
  }
  return null;
}

Future<void> downloadFile(BuildContext context, File file) async {
  bool hasStoragePermission = await checkStoragePermission();
  if (hasStoragePermission) {
    Directory saveDir = await prepareSaveDir();
    print('Starting Downloading');
    try {
      await dio.download(server.apiDownload + file.id, '${saveDir.path}${file.name}');
      print('Download Finished');
    } catch (e) {
      print(e);
    }
  }
}
