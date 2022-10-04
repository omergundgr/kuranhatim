import 'package:get/get.dart';

class HatimlerController extends GetxController {
  var hatimlerDokuman = [].obs;
  var aldiklarimListesi = [].obs;
  var olusturduklarimListesi = [].obs;
  var isAdmin = false.obs;

  setHatimlerDokuman(List list) {
    hatimlerDokuman.value = list;
    hatimlerDokuman.refresh();
  }

  setAldiklarimListesi(List list) {
    aldiklarimListesi.value = list;
    aldiklarimListesi.refresh();
  }

  setOlusturduklarimListesi(List list) {
    olusturduklarimListesi.value = list;
    olusturduklarimListesi.refresh();
  }

  setIsAdmin(bool value) => isAdmin.value = value;
}
