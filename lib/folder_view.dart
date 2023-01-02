import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:another_flushbar/flushbar.dart';

import 'models.dart';
import 'network.dart';
import 'utils.dart';

class FolderView extends StatefulWidget {
  final Folder viewOfFolder;

  const FolderView({Key? key, required this.viewOfFolder}) : super(key: key);

  @override
  State<FolderView> createState() => _FolderViewState();
}

class _FolderViewState extends State<FolderView> {
  late Future<Folder?> folderDetailed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.viewOfFolder.name)),
      body: FutureBuilder<Folder?>(
        future: folderDetailed,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          } else if (snapshot.hasData) {
            if (snapshot.data!.subFolders.isNotEmpty || snapshot.data!.files.isNotEmpty) {
              ListView folderList = ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.subFolders.length,
                  itemBuilder: (context, index) {
                    Folder subFolder = Folder.fromJson(snapshot.data?.subFolders[index]);
                    return buildFolderWidget(context, subFolder);
                  });

              ListView fileList = ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.files.length,
                  itemBuilder: (context, index) {
                    File file = File.fromJson(snapshot.data!.files[index]);
                    return buildFileWidget(context, file);
                  });

              return Column(
                children: [
                  Flexible(
                    flex: 1,
                    child: folderList,
                  ),
                  Flexible(
                    flex: 2,
                    child: fileList,
                  )
                ],
              );
            }
            return Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.emoji_emotions_rounded,
                    color: Colors.blue,
                  ),
                  Text('Nothing Seems To Be There'),
                ],
              ),
            );
          }
          return const LinearProgressIndicator();
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'upload',
            onPressed: () {
              setState(() {});
            },
            child: const Icon(Icons.file_upload_rounded),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              setState(() {
                folderDetailed = fetchFolder(widget.viewOfFolder.id);
              });
            },
            child: const Icon(Icons.refresh_rounded),
          ),
          const SizedBox(
            height: 8,
          ),
          FloatingActionButton(
            heroTag: 'newFolder',
            onPressed: () {
              setState(() {});
            },
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    folderDetailed = fetchFolder(widget.viewOfFolder.id);
    super.initState();
  }
}

Widget buildFolderWidget(BuildContext context, Folder folder) {
  return Card(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0))),
      child: InkWell(
        onLongPress: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.download_rounded),
                      title: Text("Download All"),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.share_rounded),
                      title: Text("Share"),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.drive_file_rename_outline_rounded),
                      title: Text("Rename"),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.drive_file_move_rounded),
                      title: Text("Move"),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.delete_rounded),
                      title: Text("Delete"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
            return FolderView(viewOfFolder: folder);
          }));
        },
        child: Column(
          children: [
            ListTile(
              leading: folder.isSharable
                  ? const Icon(
                      Icons.folder_shared,
                      color: Colors.blue,
                    )
                  : const Icon(Icons.folder_rounded),
              title: Text(folder.name),
              subtitle: Text(folder.createdTime.replaceFirst('T', ' ').split('.')[0]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: folder.files.isNotEmpty
                    ? [const Icon(Icons.file_present_rounded), Text(folder.files.length.toString())]
                    : [],
              ),
            )
          ],
        ),
      ));
}

Widget buildFileWidget(BuildContext context, File file) {
  return Card(
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
              bottomLeft: Radius.circular(16.0),
              bottomRight: Radius.circular(16.0))),
      child: InkWell(
        onTap: () {
          showMaterialModalBottomSheet(
            context: context,
            builder: (context) => SingleChildScrollView(
              controller: ModalScrollController.of(context),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      downloadFile(context, file);
                      Navigator.of(context).pop();
                      Flushbar(
                        margin: const EdgeInsets.all(8),
                        borderRadius: BorderRadius.circular(8),
                        title: '${file.name} [${formatBytes(file.size, 2)}]',
                        message: 'Downloading Started...',
                        icon: Icon(
                          Icons.download_rounded,
                          size: 28,
                          color: Colors.blue[300],
                        ),
                        duration: const Duration(seconds: 3),
                        flushbarPosition: FlushbarPosition.TOP,
                      ).show(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.download_rounded),
                      title: Text("Download"),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.share_rounded),
                      title: Text("Share"),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.drive_file_rename_outline_rounded),
                      title: Text("Rename"),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const ListTile(
                      leading: Icon(Icons.drive_file_move_rounded),
                      title: Text("Move"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: Colors.deepOrange[800],
                                ),
                                content: const Text("Do you really want to delete it?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Delete")),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: const Text("Cancel"))
                                ],
                              ));
                    },
                    child: const ListTile(
                      leading: Icon(Icons.delete_rounded),
                      title: Text("Delete"),
                    ),
                  )
                ],
              ),
            ),
          );
        },
        child: Column(
          children: [
            ListTile(
              leading: file.isSharable
                  ? const Icon(
                      Icons.file_present_rounded,
                      color: Colors.blue,
                    )
                  : const Icon(Icons.file_present_rounded),
              title: Text(file.name),
              subtitle: Text(file.uploadedTime.replaceFirst('T', ' ').split('.')[0]),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [Text(formatBytes(file.size, 2)), const Icon(Icons.file_download)],
              ),
            )
          ],
        ),
      ));
}
