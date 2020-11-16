import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsmake/MyHomePage.dart';
import 'package:letsmake/Sirala.dart';

class MainMenu extends StatefulWidget {
  final User user;
  MainMenu(this.user);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("Worthilator"),
      ),
      body: Center(
        child: Wrap(
          spacing: 50,
          direction: Axis.vertical,
          //runAlignment: WrapAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: 280,
                height: 80,
                colorScheme: ColorScheme.fromSwatch(),
                buttonColor: Colors.deepPurple,
                child: RaisedButton(
                  textColor: Colors.white,
                  child: Text(
                    "Ekle",
                    style: TextStyle(
                      fontSize: 40,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(
                              user: this.widget.user,
                                  title: "Ekleme Ekranı",
                                )));
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: 280,
                height: 80,
                colorScheme: ColorScheme.fromSwatch(),
                buttonColor: Colors.deepPurple,
                child: RaisedButton(
                  textColor: Colors.white,
                  child: Text(
                    "Sırala",
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => Sirala(this.widget.user)));
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                minWidth: 280,
                height: 80,
                colorScheme: ColorScheme.fromSwatch(),
                buttonColor: Colors.deepPurple,
                child: RaisedButton(
                  textColor: Colors.white,
                  child: Text(
                    "lol",
                    style: TextStyle(fontSize: 40),
                  ),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
