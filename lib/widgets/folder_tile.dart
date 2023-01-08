import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:jdrive/models.dart';
import 'package:jdrive/folder_view.dart';

class FolderTile extends StatefulWidget {
  final Folder folder;

  const FolderTile({Key? key, required this.folder}) : super(key: key);

  @override
  State<FolderTile> createState() => _FolderTileState();
}

class _FolderTileState extends State<FolderTile> {
  @override
  Widget build(BuildContext context) {
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
              return FolderView(viewOfFolder: widget.folder);
            }));
          },
          child: Column(
            children: [
              ListTile(
                leading: widget.folder.isSharable
                    ? const Icon(
                        Icons.folder_shared,
                        color: Colors.blue,
                      )
                    : const Icon(Icons.folder_rounded),
                title: Text(widget.folder.name),
                subtitle: Text(widget.folder.createdTime.replaceFirst('T', ' ').split('.')[0]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: widget.folder.files.isNotEmpty
                      ? [const Icon(Icons.file_present_rounded), Text(widget.folder.files.length.toString())]
                      : [],
                ),
              )
            ],
          ),
        ));
  }
}
