import 'package:flutter/material.dart';
import 'package:jdrive/widgets/folder_tile.dart';

import 'models.dart';
import 'network.dart';
import 'widgets/file_tile.dart';

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
                    return FolderTile(folder: subFolder);
                  });

              ListView fileList = ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshot.data!.files.length,
                  itemBuilder: (context, index) {
                    File file = File.fromJson(snapshot.data!.files[index]);
                    return FileTile(file: file);
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
