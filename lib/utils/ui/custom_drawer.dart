import 'package:flutter/material.dart';
import 'package:notes_goonline/const/routes.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[400],
      child: Column(
        children: [
          const DrawerHeader(
            child: Icon(Icons.task),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: ListTile(
              leading: const Icon(Icons.list),
              title: const Text("Tasks"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(tasksListRoute);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 24),
            child: ListTile(
              leading: const Icon(Icons.query_stats),
              title: const Text("Stats"),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).pushNamed(tasksStatsRoute);
              },
            ),
          )
        ],
      ),
    );
  }
}
