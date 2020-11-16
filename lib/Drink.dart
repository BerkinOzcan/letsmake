


class Drink {
  //var drinkList = List.empty(growable: true);
  final String isim;
  final String hacim;
  final String oran;
  final String fiyat;
  final String docId;
  double puan;
  Drink(this.isim, this.hacim, this.oran, this.fiyat, {this.puan, this.docId});

  double puanHesapla() {
    this.puan = double.parse(this.hacim) *
        double.parse(this.oran) /
        double.parse(this.fiyat);
        double n = num.parse(this.puan.toStringAsFixed(2));
        this.puan = n;
    return this.puan;
  }
  

  // void listeyeEkle(Drink drink) {
  //   drinks.add(drink);
  //   for (int i = 0; i < drinkList.length; i++) {
  //     print(drinkList[i].isim);

  //     print(drinkList[i].puanHesapla());
  //   }
  // }
}
