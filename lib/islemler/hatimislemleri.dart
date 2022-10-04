import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:kuranhatim/controller/hatimler_controller.dart';
import 'package:hive/hive.dart';

class HatimIslemleri {
  final _firestore = FirebaseFirestore.instance.collection("hatimler");
  final _hatimController = Get.put(HatimlerController());

  // kullanici ismini getir
  Future<String> giveName() async {
    var box = await Hive.openBox("hatimflutter");
    return box.get("isim");
  }

  // hatim oluştur ve veriyi telefona kaydet
  Future hatimOlustur(
      {required String baslik,
      required String aciklama,
      required String gun}) async {
    if (baslik.isEmpty || aciklama.isEmpty || gun.isEmpty) {
      return false;
    }

    DateTime now = DateTime.now();
    DateTime bitis = DateTime(now.year, now.month, now.day + int.parse(gun));

    var box = await Hive.openBox("hatimflutter");
    final String docId = _firestore.doc().id;

    await _firestore.doc(docId).set({
      'kullanici': await giveName(),
      'baslik': baslik,
      'aciklama': aciklama,
      'bitis': bitis,
      'alinanlar': []
    });
    if (!box.keys.contains('hatimler')) {
      await box.put('hatimler', []);
    }

    List olusturulanHatimler = box.get('hatimler');
    olusturulanHatimler.add(docId);
    await box.put('hatimler', olusturulanHatimler);
    return docId;
  }

  // oluşturulan hatim sayfasına git
  Future<DocumentSnapshot<Map>> olusturulanHatmeGit(
      {required String docId}) async {
    var veriler = await _firestore.doc(docId).get();
    return veriler;
  }

  // tüm hatimleri getir
  Future<List<QueryDocumentSnapshot<Map>>> hatimGetir() async {
    var hatimlerDoc = await _firestore.get();
    return hatimlerDoc.docs;
  }

  // hatim cüzü al ve telefona kaydet
  Future cuzAl({required int cuzNumara, required String hatimId}) async {
    var box = await Hive.openBox("hatimflutter");
    await _firestore.doc(hatimId).update({
      'alinanlar': FieldValue.arrayUnion([
        {cuzNumara.toString(): await giveName()}
      ])
    });
    if (!box.keys.contains('alinanlar')) {
      await box.put('alinanlar', {});
    }

    final Map alinanlar = box.get('alinanlar');

    if (!alinanlar.keys.contains(hatimId)) {
      alinanlar[hatimId] = [];
      await box.put('alinanlar', alinanlar);
    }

    final List cuzList = alinanlar[hatimId];
    cuzList.add(cuzNumara);
    alinanlar[hatimId] = cuzList;

    await box.put('alinanlar', alinanlar);
    _hatimController.setAldiklarimListesi(cuzList);
  }

  // telefon kayıtlarından alınanları getir
  Future aldiklarimListesi({required String hatimId}) async {
    var box = await Hive.openBox("hatimflutter");
    if (!box.keys.contains('alinanlar')) {
      _hatimController.setAldiklarimListesi([]);
      return;
    } else {
      if (!box.get('alinanlar').keys.contains(hatimId)) {
        _hatimController.setAldiklarimListesi([]);
        return;
      }
    }
    final List list = box.get('alinanlar')[hatimId];
    _hatimController.setAldiklarimListesi(list);
  }

  // oluşturulan hatimleri telefon kayıtlarından getir
  Future olusturduklarimListesi() async {
    var box = await Hive.openBox("hatimflutter");
    if (!box.keys.contains('hatimler')) {
      _hatimController.setOlusturduklarimListesi([]);
      return;
    }
    List hatimler = box.get('hatimler');
    _hatimController.setOlusturduklarimListesi(hatimler);
  }

  // hatim sil
  Future hatimSil({required String hatimId}) async {
    await _firestore.doc(hatimId).delete();
  }
}
