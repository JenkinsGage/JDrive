import 'package:flutter/material.dart';

import 'server_spec.dart' as server;
import 'network.dart' as network;
import 'models.dart';
import 'widgets/folder_tile.dart';

class DriveRoot extends StatefulWidget {
  const DriveRoot({Key? key}) : super(key: key);

  @override
  State<DriveRoot> createState() => _DriveRootState();
}

class _DriveRootState extends State<DriveRoot> {
  late Future<List<Folder>> root;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "JDrive:/",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.download_rounded)),
          IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz_rounded))
        ],
      ),
      body: FutureBuilder<List<Folder>>(
        future: root,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  Folder folder = snapshot.data![index];
                  return FolderTile(folder: folder);
                });
          } else if (snapshot.hasError) {
            return Center(child: Text("${snapshot.error}"));
          }
          return const LinearProgressIndicator();
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'refresh',
            onPressed: () {
              setState(() {
                root = network.fetchRoot();
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
    server.authToken = server.getAuthTokenFromUsernameAndPwd('admin', 'admin');
    root = network.fetchRoot();
    super.initState();
  }
}
