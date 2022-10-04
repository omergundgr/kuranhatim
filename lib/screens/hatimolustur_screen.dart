import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuranhatim/constants/colors.dart';
import 'package:kuranhatim/islemler/hatimislemleri.dart';
import 'package:kuranhatim/screens/anasayfa_screen.dart';
import 'package:kuranhatim/screens/hatim_screen.dart';

class HatimOlustur extends StatelessWidget {
  HatimOlustur({Key? key}) : super(key: key);

  final _isimCtrl = TextEditingController();
  final _aciklamaCtrl = TextEditingController();
  final _gunCtrl = TextEditingController();
  final _hatimIslemleri = HatimIslemleri();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: colorBg,
          elevation: 0,
          title: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.black,
              )),
        ),
        backgroundColor: colorBg,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(40),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Hatim Oluştur",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87),
                  ),
                  const SizedBox(height: 50),
                  TextField(
                      controller: _isimCtrl,
                      decoration:
                          const InputDecoration(hintText: "Hatim İsmi")),
                  const SizedBox(height: 20),
                  TextField(
                      controller: _aciklamaCtrl,
                      keyboardType: TextInputType.multiline,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: "Hatim Açıklaması",
                      )),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Text(
                        "Kaç gün devam edecek? :",
                        style: TextStyle(fontSize: 15, fontFamily: "Poppins"),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          onChanged: (value) {
                            if (int.parse(value) > 30) {
                              _gunCtrl.clear();
                              Get.snackbar("Uyarı",
                                  "En fazla 30 günlük hatim oluşturabilirsiniz",
                                  margin: const EdgeInsets.all(15),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: colorDark);
                            } else if (int.parse(value) < 1) {
                              _gunCtrl.clear();
                              Get.snackbar("Uyarı",
                                  "En az 1 günlük hatim oluşturabilirsiniz",
                                  margin: const EdgeInsets.all(15),
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: colorDark);
                            }
                          },
                          style: const TextStyle(
                              fontSize: 15,
                              color: Colors.blue,
                              fontFamily: "Poppins"),
                          controller: _gunCtrl,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          decoration: const InputDecoration(
                            hintText: "gün",
                          ),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () async {
                      dynamic hatim = await HatimIslemleri().hatimOlustur(
                          baslik: _isimCtrl.text,
                          aciklama: _aciklamaCtrl.text,
                          gun: _gunCtrl.text);
                      if (hatim is bool) {
                        Get.snackbar("Hata", "Lütfen tüm alanları doldurun",
                            margin: const EdgeInsets.all(15),
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: colorDark);
                      } else {
                        Get.back();
                        Get.back();
                        Get.to(AnaSayfa());
                        Get.snackbar(
                          "Başarılı",
                          "Hatim zinciri oluşturuldu.",
                          margin: const EdgeInsets.all(15),
                          snackPosition: SnackPosition.BOTTOM,
                        );
                        var veri = await _hatimIslemleri.olusturulanHatmeGit(
                            docId: hatim);
                        Get.to(() => HatimSayfasi(veri: veri));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 40),
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 15),
                      decoration: BoxDecoration(
                          color: Colors.black45,
                          borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "Oluştur",
                        style: TextStyle(
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 20),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
