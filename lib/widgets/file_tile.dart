import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:adaptive_dialog/adaptive_dialog.dart';

import 'package:jdrive/models.dart';
import 'package:jdrive/network.dart';
import 'package:jdrive/utils.dart';

class FileTile extends StatefulWidget {
  File file;

  FileTile({Key? key, required this.file}) : super(key: key);

  @override
  State<FileTile> createState() => _FileTileState();
}

class _FileTileState extends State<FileTile> {
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
          onTap: () {
            showMaterialModalBottomSheet(
              context: context,
              builder: (context) => SingleChildScrollView(
                controller: ModalScrollController.of(context),
                child: Column(
                  children: [
                    InkWell(
                      onTap: () {
                        downloadFile(context, widget.file);
                        Navigator.of(context).pop();
                        Flushbar(
                          margin: const EdgeInsets.all(8),
                          borderRadius: BorderRadius.circular(8),
                          title: '${widget.file.name} [${formatBytes(widget.file.size, 2)}]',
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
                      onTap: () {
                        showTextInputDialog(
                                context: context,
                                textFields: [DialogTextField(initialText: widget.file.name)],
                                title: 'New Name')
                            .then((value) async {
                          if (value != null) {
                            var newName = value[0].replaceAll(' ', '');
                            if (newName != '') {
                              print(newName);
                              File newFile = File.clone(widget.file);
                              newFile.name = newName;
                              var response = await updateFile(widget.file, newFile);
                              print(response?.data);
                              setState(() {
                                widget.file = newFile;
                              });

                              if (!mounted) return;
                              Navigator.of(context).pop();
                            }
                          }
                        });
                      },
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
                leading: widget.file.isSharable
                    ? const Icon(
                        Icons.file_present_rounded,
                        color: Colors.blue,
                      )
                    : const Icon(Icons.file_present_rounded),
                title: Text(widget.file.name),
                subtitle: Text(widget.file.uploadedTime.replaceFirst('T', ' ').split('.')[0]),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text(formatBytes(widget.file.size, 2)), const Icon(Icons.file_download)],
                ),
              )
            ],
          ),
        ));
  }
}
