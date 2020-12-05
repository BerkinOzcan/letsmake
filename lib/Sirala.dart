import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:letsmake/Drink.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Sirala extends StatefulWidget {
  final User user;
  
  Sirala(this.user) {
    print("siralasirala");
    print(this.user.displayName);
  }

  @override
  _SiralaState createState() => _SiralaState();
}

class _SiralaState extends State<Sirala> {
  List<Drink> myDrinks;
  bool sort = false;

  void getMyDrinks() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(this.widget.user.uid)
        .collection("drinks")
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        var keylist = result.data().keys.toList();

        int isimIndex = keylist.indexOf('isim');
        int hacimIndex = keylist.indexOf('hacim');
        int oranIndex = keylist.indexOf('oran');
        int fiyatIndex = keylist.indexOf('fiyat');
        int puanIndex = keylist.indexOf('puan');
        var valueList = result.data().values.toList();
        String docid = result.id;
        print(docid);
        var dk = Drink(valueList[isimIndex], valueList[hacimIndex],
            valueList[oranIndex], valueList[fiyatIndex],
            puan: valueList[puanIndex], docId: docid);
        if (mounted) {
          //print("mauntıdaa");
          setState(() {
            myDrinks.add(dk);
          });
        }
        print(dk.isim);
        // print(myDrinks.length);
        // print(valueList);
        // print(keylist);

        //myDrinks.forEach((element) {print(element.isim);});
//print(myDrinks);
        //print("siralayanpphard ${result.data().map((key, value) => null)}");
      });
    });
  }

  void initState() {
    //getMyDrinks();
    myDrinks = List<Drink>();

    getMyDrinks();
    //myDrinks = getMyDrinks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Padding(
        padding: EdgeInsets.only(
          top: 30,
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
              dividerThickness: 2,
              sortAscending: sort,
              sortColumnIndex: 4,
              columns: [
                DataColumn(
                  label: Text("İsim"),
                ),
                DataColumn(
                  label: Text("Hacim"),
                ),
                DataColumn(
                  label: Text("Oran"),
                ),
                DataColumn(
                  label: Text("Fiyat"),
                ),
                DataColumn(
                  label: Text("Puan"),
                  onSort: (columnIndex, ascending) {
                    var sortedItems = myDrinks;
                    sortedItems.sort((a, b) => a.puan.compareTo(b.puan));
                    myDrinks =
                        ascending ? sortedItems : sortedItems.reversed.toList();
                    if (mounted) {
                      //print("MAUNTID");
                      setState(() {
                        sort = ascending;
                      });
                    }
                  },
                ),
              ],
              rows: myDrinks
                  .map(
                    (drs) => DataRow(
                      cells: [
                        DataCell(
                          Text(
                            drs.isim,
                          ),
                          showEditIcon: true,
                          
                          onTap: () {
                            print("TIKLANAN ID: ${drs.docId}");
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (_) =>
                                    EditField(this.widget.user, drs));
                          },
                        ),
                        DataCell(
                          Text(
                            drs.hacim,
                          ),
                        ),
                        DataCell(
                          Text(
                            drs.oran,
                          ),
                          //showEditIcon: true,
                          // onTap: () => print("yaarrraaa: ${drs.isim}"),
                        ),
                        DataCell(
                          Text(
                            drs.fiyat,
                          ),
                        ),
                        DataCell(
                          Text(
                            (drs.puan.toString().isEmpty)
                                ? "NO DATA"
                                : drs.puan.toString(),
                          ),
                        ),
                      ],
                    ),
                  )
                  .toList()
              // [
              //   DataRow(cells: [
              //     DataCell(
              //       SingleChildScrollView(
              //           child: SizedBox(
              //               width: 70,
              //               child: Text(
              //                 "acabahepsinigorecekmiyimkineki",
              //                 //overflow: TextOverflow.clip,
              //               ))),
              //     ),
              //     DataCell(
              //       Text("50"),
              //     ),
              //     DataCell(
              //       Text("5"),
              //     ),
              //     DataCell(
              //         //Text("15"),
              //         FlatButton(
              //             onPressed: getMyDrinks, child: Text("press me"))),
              //   ])
              // ]),
              ),
        ),
      ),
    );
  }
}

class EditField extends StatefulWidget {
  final User usa;
  final Drink drdr;
  EditField(this.usa, this.drdr);
  @override
  _EditFieldState createState() => _EditFieldState();
}

class _EditFieldState extends State<EditField> {
  String _text;
  TextEditingController _c;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  Future<void> deleteDrink() {
    return users
        .doc(this.widget.usa.uid)
        .collection('drinks')
        .doc(this.widget.drdr.docId)
        .delete().then((value) {
      setState(() {
        print("drink deleted!");

        Navigator.of(context, rootNavigator: true).pop('dialog');
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
                  title: Text("Silme Başarılı!"),
                  content: Text(
                      "Emin misin diye sormadım çünkü bizde R olmaz \n Sekmeler arası bi sağ sol yap yenilenir."),
                ));
      });
    }).catchError((error) => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
                  title: Text("Oops"),
                  content: Text(
                      "Hiçbir şey olmasa bile bir şeyler oldu! \n İnternet bağlantını falan kontrol et. \n Uygulamayı yeniden falan başlat ben ne biliyim."),
                )));
  }

  Future<void> editDrinkName() {
    return users
        .doc(this.widget.usa.uid)
        .collection('drinks')
        .doc(this.widget.drdr.docId)
        .update({'isim': _text}).then((value) {
      setState(() {
        print("drink name updated!");

        Navigator.of(context, rootNavigator: true).pop('dialog');
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
                  title: Text("Düzenleme Başarılı!"),
                  content: Text(
                      "Düzenleme başarılı kardeşim hayırlı olsun \n Sekmeler arası bi sağ sol yap yenilenir."),
                ));
      });
    }).catchError((error) => showDialog(
            context: context,
            barrierDismissible: true,
            builder: (_) => AlertDialog(
                  title: Text("Oops"),
                  content: Text(
                      "Hiçbir şey olmasa bile bir şeyler oldu! \n İnternet bağlantını falan kontrol et. \n Uygulamayı yeniden falan başlat ben ne biliyim."),
                )));
  }

  @override
  void initState() {
    _c = new TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Düzenle veya Sil"),
      content: TextField(
        controller: _c,
      ),
      actions: [
        FlatButton(
            onPressed: () {
              deleteDrink();
            //print("SİLDİM LAAAAAN");
            },
            child: Text("SİL")),
        FlatButton(
            onPressed: () {
              this._text = _c.text;
              editDrinkName();
            
            },
            child: Text("Tamam hocam!")),
        FlatButton(
            onPressed: () {
              
                Navigator.of(context, rootNavigator: true).pop('dialog');
                },
            child: Text("cancel"))
      ],
    );
  }
}
