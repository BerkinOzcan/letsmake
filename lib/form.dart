import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:letsmake/Drink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class MyCustomForm extends StatefulWidget {
  final User user;
  MyCustomForm(this.user) {
    print("asdasdasdasd");
    print(this.user.displayName);
    print("asdasdasdasd");
  }

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class MyCustomFormState extends State<MyCustomForm> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  //CollectionReference users = FirebaseFirestore.instance.collection('/users');
  //DocumentReference drinkDoc = FirebaseFirestore.instance.doc('/users/');

  final _formKey = GlobalKey<FormState>();
  List drinks = new List();
  String isim;
  String hacim;
  String oran;
  String fiyat;
  double puan;
//DocumentReference myUser = FirebaseFirestore.instance.collection('/users').doc(user.uid);

void showOops(var err) {
    

    
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (_) => AlertDialog(
              title: Text("Oops"),
              content: Text("Hiçbir şey olmasa bile bir şeyler oldu! \n İnternet bağlantını falan kontrol et. \n Uygulamayı yeniden falan başlat ben ne biliyim."),
            ));
  
  }

  Future<void> addUser(String isim, String hacim, String oran, String fiyat) {
    // Call the user's CollectionReference to add a new user
    DocumentReference myUser = FirebaseFirestore.instance
        .collection('/users')
        .doc(this.widget.user.uid);
    return myUser.set(
      {
        'name': this.widget.user.displayName,
        'uid': this.widget.user.uid,
      },
      SetOptions(merge: true),
    ).then((value) {
      print("User Added");
      addDrink(isim, hacim, oran, fiyat);
    }).catchError((error) => showOops(error));
  }

  Future<void> addDrink(String isim, String hacim, String oran, String fiyat) {
    DocumentReference myUser = FirebaseFirestore.instance
        .collection('/users')
        .doc(this.widget.user.uid);

    var dr = Drink(isim, hacim, oran, fiyat);
    return myUser.collection('drinks').add({
      'isim': dr.isim,
      'hacim': dr.hacim,
      'oran': dr.oran,
      'fiyat': dr.fiyat,
      'puan': dr.puanHesapla(),
    }).then((value) {
      showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
                  title: Text("Okeyto"),
                  content: Text(
                      "İçkini ekledim babacım \n Orta sekmedeki sıralama ekranından bakabilirsin (Sıralama ekranını yenilemek için iki sağ sol yap kendine gelir kerata)."),
                ));
      print("added the drink ma boi");
    }).catchError((error) => showOops(error));
  }

  void listeyiGoster() {
    for (var i in drinks) {
      print(i.isim + i.puanHesapla().toString());
    }
  }

  void listeyeEkle(String isim, String hacim, String oran, String fiyat) {
    var d1 = Drink(isim, hacim, oran, fiyat);
    drinks.add(d1);
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return SingleChildScrollView(
      child: Form(
          key: _formKey,
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: <
              Widget>[
            // Add TextFormFields and RaisedButton here.
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                // inputFormatters: [
                //   LengthLimitingTextInputFormatter(3),
                // ],
                
                //maxLengthEnforced: false,
                decoration: InputDecoration(
                  
                  helperText: "örn. Efes Malt",
                  //hintText: "Buraya içeceğin ismini girin",

                  labelText: "Alkollü İçecek Adı",
                  labelStyle: TextStyle(fontSize: 20.0),
                  //contentPadding: EdgeInsets.all(16.0),
                  prefixIcon: Icon(Icons.local_bar),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Lütfen bir ad girin!';
                  }
                  isim = value;
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                key: Key("hacimField"),
                inputFormatters: [
                  FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ |\\,]'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: "örn. 50 ya da 14.4",
                  //hintText: "Buraya içeceğin cl cinsinden hacmini girin",
                  suffixText: "cl",
                  labelText: "Alkollü İçecek Hacmi (cl)",
                  labelStyle: TextStyle(fontSize: 20.0),
                  //contentPadding: EdgeInsets.all(16.0),
                  prefixIcon: Icon(Icons.local_drink),
                  border: OutlineInputBorder(
                    
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Lütfen bir değer girin!';
                  }

                  double checknum = 31.0;
                  double condition = double.tryParse(value) ?? checknum;
                  if (condition == checknum) {
                    return "düzgün gir lan";
                  } else if (condition != checknum) {
                    hacim = value;
                    //return null;
                  }

                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ |\\,]'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: "örn. 5 ya da 35",
                  //hintText: "Buraya içeceğin yüzde olarak alkol oranını girin",
                  prefixText: "%",
                  labelText: "Alkollü İçecek Alkol Oranı (%)",
                  labelStyle: TextStyle(fontSize: 20.0),
                  //contentPadding: EdgeInsets.all(16.0),
                  prefixIcon: Icon(Icons.local_gas_station),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Lütfen bir değer girin!';
                  }

                  double checknum = 31.0;
                  double condition = double.tryParse(value) ?? checknum;
                  if (condition == checknum) {
                    return "düzgün gir lan";
                  } else if (condition != checknum) {
                    oran = value;
                    //return null;
                    if (double.parse(value) > 99)
                      return "Alkol oranı çok büyük";
                  }

                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(new RegExp('[\\-|\\ |\\,]'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  helperText: "örn. 15 ya da 120",
                  //hintText: "Buraya içeceğin yüzde olarak alkol oranını girin",
                  suffixText: "TL",
                  labelText: "Alkollü İçecek Fiyatı (TL)",
                  labelStyle: TextStyle(fontSize: 20.0),
                  //contentPadding: EdgeInsets.all(16.0),
                  prefixIcon: Icon(Icons.local_atm),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Lütfen bir değer girin!';
                  }

                  double checknum = 31.0;
                  double condition = double.tryParse(value) ?? checknum;
                  if (condition == checknum) {
                    return "düzgün gir lan";
                  } else if (condition != checknum) {
                    fiyat = value;
                    //return null;
                  }

                  return null;
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(right: 16),
              color: Colors.transparent,
              child: ButtonTheme(
                minWidth: 150,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),

                  padding: const EdgeInsets.symmetric(vertical: 16.0),

                  color: Colors.deepPurple,
                  textColor: Colors.white,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      // print("İsim: $isim");
                      // print("Hacim: $hacim");
                      // print("Alkol oranı: $oran");
                      // print("Fiyat: $fiyat");

                      //puan = double.parse(hacim) * double.parse(oran) / double.parse(fiyat);
                      //print(puan);
                      // Drink drinky =  new Drink(this.isim, this.hacim, this.oran, this.fiyat);

                      //print(drinky.puanHesapla());
                      addUser(isim, hacim, oran, fiyat);
//addDrink(isim, hacim, oran, fiyat);
                      listeyeEkle(isim, hacim, oran, fiyat);
                      listeyiGoster();
                      FocusScope.of(context).unfocus();
                      print(drinks.length);
// TODO: submite bastıkdan sonra mal gibi kalmasın bidaha bidaha submite basarlar sonra.
//TODO: aynı içkinin aynısının tıpkısını bidaha ekleyememesi lazım.
                      // If the form is valid, display a Snackbar.
                      Scaffold.of(context).showSnackBar(
                          SnackBar(content: Text('Ekliyorum babacım bi saniye')));
                    }
                  },
                  // Validate returns true if the form is valid, or false
                  // otherwise.

                  child: Text('Submit'),
                ),
              ),
            ),
          ])),
    );
  }
}
