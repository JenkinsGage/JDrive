import 'dart:io';

import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

Future<bool> checkStoragePermission() async {
  if (!Platform.isAndroid) {
    print('Not android platform, storage permission granted!');
    return true;
  } else {
    final status = await Permission.manageExternalStorage.status;
    if (status != PermissionStatus.granted) {
      final result = await Permission.manageExternalStorage.request();
      if (result == PermissionStatus.granted) {
        print('Storage permission granted!');
        return true;
      }
    } else {
      print('Already has storage permission.');
      return true;
    }
  }
  print('No storage permission?!');
  return false;
}

Future<Directory> prepareSaveDir() async {
  String localPath = (await findDownloadPath())!;
  print('Downloads will be saved to $localPath');
  final savedDir = Directory(localPath);
  bool hasExisted = await savedDir.exists();
  if (!hasExisted) {
    savedDir.create();
  }
  return savedDir;
}

Future<String?> findDownloadPath() async {
  if (Platform.isAndroid) {
    return "/storage/emulated/0/JDriveDownload/";
  } else {
    var directory = await getDownloadsDirectory();
    return '${directory!.path}${Platform.pathSeparator}JDriveDownload${Platform.pathSeparator}';
  }
}
