import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:letsmake/MainMenu.dart';
import 'package:letsmake/tabber.dart';

import 'auth.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Worthilator')), body: Body());
  }
}

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  User myUser;
  final  FirebaseMessaging _messaging = FirebaseMessaging();

  @override
  void initState() {
    super.initState();
    _messaging.getToken().then((token) => print("token is $token")).catchError((err) => showOops(err));

    //signOutGoogle();
  }

  Widget textbelirle() {
    // if (isSigned) {
    //   return Text(
    //     'Sign in with google',
    //     style: TextStyle(color: Colors.deepPurple, fontSize: 25),
    //   );
    // } else {
    return Text(
      'Enter',
      style: TextStyle(color: Colors.deepPurple, fontSize: 25),
    );
    //}
  }

  void showOops(var err) {
    

    
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              title: Text("Oops"),
              content: Text("Hiçbir şey olmasa bile bir şeyler oldu! \n İnternet bağlantını falan kontrol et. \n Uygulamayı yeniden falan başlat ben ne biliyim."),
            ));
  
  }

  void click() {
    setState(() {
      signInWithGoogle()
          .then((myUser) => {
                print("yarrararaar ${myUser.user.displayName}"),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TabBarDemo(myUser.user)))
              })
          .catchError((erro) {showOops(erro);});
    });
  }

  void clickBack() {
    setState(() {
      signInWithGoogle()
          .then((myUser) => {
                Navigator.pop(context),
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TabBarDemo(myUser.user)))
              })
          .catchError((erro) {showOops(erro);});
    });
  }

// Scaffold.of(context).showSnackBar(
//                           SnackBar(content: Text('SIGNED OUT')))
  void clickOut() {
    // if (isSigned) {
    setState(() {
      handleSignOut().whenComplete(() => {
            showDialog(
                context: context,
                barrierDismissible: true,
                builder: (_) => AlertDialog(
                      title: Text("we signed out"),
                      content: Text("sign out successful"),
                      actions: [
                        FlatButton(
                            onPressed: clickBack, child: Text("Sign back in!")),
                        FlatButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("ok whatever"))
                      ],
                    )),
          });
    });
    //}
    // else
    // {Scaffold.of(context).showSnackBar(
    //                        SnackBar(content: Text('Already signed OUT')));}
  }

  Widget googleLoginButton() {
    return OutlineButton(
        onPressed: this.click,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        splashColor: Colors.deepPurpleAccent,
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.group_add),
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: textbelirle(),
                ),
              ],
            )));
  }

  Widget googleSignOutButton() {
    return OutlineButton(
        onPressed: this.clickOut,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
        splashColor: Colors.grey,
        borderSide: BorderSide(color: Colors.deepPurple, width: 2),
        child: Padding(
            padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.exit_to_app),
                Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Text('Sign Out',
                        style:
                            TextStyle(color: Colors.deepPurple, fontSize: 25)))
              ],
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Wrap(
        direction: Axis.vertical,
        spacing: 16,
        children: [
          googleLoginButton(),
          googleSignOutButton(),
        ],
      ),
    );
  }
}
