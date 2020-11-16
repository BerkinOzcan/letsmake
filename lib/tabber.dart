import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:letsmake/Sirala.dart';
import 'package:letsmake/form.dart';

class TabBarDemo extends StatefulWidget {
  final User user;
  TabBarDemo(this.user);
  @override
  _TabBarDemoState createState() => _TabBarDemoState();
}

class _TabBarDemoState extends State<TabBarDemo> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.deepPurple,
            //shadowColor: Colors.deepPurple,
            bottom: TabBar(
              indicatorColor: Colors.white70,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.black38,
              indicatorWeight: 1,
              tabs: [
                Tab(icon: Icon(Icons.note_add)),
                Tab(icon: Icon(Icons.sort)),
                Tab(icon: Icon(Icons.message)),
              ],
            ),
            title: Text('Tabs Democchhhaaannnnnggggeeeeeeee'),
          ),
          body: TabBarView(
            children: [
              MyCustomForm(this.widget.user),
              Sirala(this.widget.user),
              Icon(Icons.directions_bike),
            ],
          ),
        ),
      ),
    );
  }
}
