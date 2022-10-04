import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuranhatim/constants/colors.dart';
import 'package:kuranhatim/controller/hatimler_controller.dart';
import 'package:kuranhatim/screens/hatim_screen.dart';
import 'package:kuranhatim/screens/hatimolustur_screen.dart';

import '../islemler/hatimislemleri.dart';

class AnaSayfa extends StatefulWidget {
  AnaSayfa({Key? key}) : super(key: key);

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  final _hatimlerController = Get.put(HatimlerController());
  final _hatimIslemleri = HatimIslemleri();

  Future _hatimGetir() async {
    _hatimlerController.setHatimlerDokuman(await _hatimIslemleri.hatimGetir());
    _hatimIslemleri.olusturduklarimListesi();
  }

  @override
  void initState() {
    _hatimGetir();
    _isUserAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorBg,
        body: Center(
          child: Column(
            children: [
              _ustBilgi(),
              Expanded(
                child: Card(
                  elevation: 5,
                  margin: const EdgeInsets.all(20),
                  child: Obx(
                    () => _hatimlerController.hatimlerDokuman.isEmpty
                        ? const SizedBox(
                            width: double.infinity,
                            child: Icon(
                              Icons.hourglass_empty,
                              color: Colors.grey,
                              size: 100,
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount:
                                _hatimlerController.hatimlerDokuman.length,
                            itemBuilder: (context, index) {
                              return _hatimListesi(index);
                            },
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              _bottomButton(
                  text: "HATİM OLUŞTUR",
                  color: colorPink,
                  onTap: () => Get.to(() => HatimOlustur())),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bottomButton(
      {required Function() onTap, required String text, required Color color}) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        alignment: Alignment.center,
        color: color,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.all(5),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.brown[900]),
        ),
      ),
    );
  }

  Widget _hatimListesi(int index) {
    final veri = _hatimlerController.hatimlerDokuman[index];

    final DateTime bitis = veri["bitis"].toDate();
    final DateTime dateNow = DateTime.now();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        index == 0
            ? GestureDetector(
                onTap: () {},
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(8),
                  color: colorBlueGreen,
                  child: const Text(
                    "KATILABİLECEĞİNİZ HATİMLER",
                    style: TextStyle(fontFamily: "Poppins", fontSize: 16),
                  ),
                ),
              )
            : const SizedBox(),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () => Get.to(() => HatimSayfasi(veri: veri)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      text: veri["baslik"],
                      style: TextStyle(
                          fontFamily: "Poppins",
                          color: bitis.isAfter(dateNow)
                              ? Colors.black54
                              : Colors.red[200],
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                Obx(
                  () => Visibility(
                    visible: _hatimlerController.olusturduklarimListesi
                            .contains(veri.id) ||
                        _hatimlerController.isAdmin.value,
                    child: IconButton(
                      onPressed: () {
                        Get.generalDialog(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return AlertDialog(
                              title: Text(veri["baslik"]),
                              content:
                                  const Text('Oluşturduğunuz hatim silinecek'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Get.back(),
                                  child: const Text('İPTAL'),
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    Get.back();
                                    await _hatimIslemleri.hatimSil(
                                        hatimId: veri.id);
                                    Get.back();
                                    Get.to(AnaSayfa());
                                    Get.snackbar("Başarılı", "Hatim silindi.",
                                        backgroundColor: Colors.green[100],
                                        snackPosition: SnackPosition.BOTTOM,
                                        margin: const EdgeInsets.all(10));
                                  },
                                  child: const Text('ONAYLA'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(
                        Icons.delete,
                        size: 25,
                        color: Colors.red[300],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        const Divider(
          thickness: 1,
        )
      ],
    );
  }

  Widget _ustBilgi() {
    return Card(
      margin: const EdgeInsets.all(20),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            alignment: Alignment.center,
            color: colorGreen,
            child: const Text(
              "DİKKAT",
              style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
            ),
          ),
          const Text(
            "Uygulamayı kötü niyet ile kullanmaya çalışanlar vebale gireceklerini bilsinler",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 14, color: Colors.black54),
          ),
          const Divider(
            thickness: 1,
          ),
          const Text(
            "Uygulama içerisinde hatim oluşturabilir veya aktif olan hatimlere katılım sağlayabilirsiniz",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 14, color: Colors.black54),
          )
        ],
      ),
    );
  }

  Future _isUserAdmin() async {
    _hatimlerController
        .setIsAdmin(await _hatimIslemleri.giveName() == "92TrC2dk@");
  }
}
