import 'package:flutter/material.dart';
import 'package:notes_goonline/utils/ui/custom_drawer.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(), drawer: CustomDrawer(), body: Text("STATS"));
  }
}
