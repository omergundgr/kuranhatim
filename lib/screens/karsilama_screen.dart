import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuranhatim/constants/colors.dart';
import 'package:kuranhatim/controller/karsilama_controller.dart';
import 'package:kuranhatim/screens/anasayfa_screen.dart';
import 'package:hive/hive.dart';

class KarsilamaEkrani extends StatelessWidget {
  KarsilamaEkrani({Key? key}) : super(key: key);

  final _karsilamaEkraniCtrl = Get.put(KarsilamaController());
  final _isimCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: colorBg,
        body: Center(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Hatim Zinciri",
                  style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87),
                ),
                const SizedBox(height: 30),
                Image.asset(
                  "assets/images/kuran.png",
                  scale: 5,
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.all(30),
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  color: colorDark,
                  child: TextField(
                    onChanged: (_) {
                      _karsilamaEkraniCtrl.setDevamBtnVisible(true);
                    },
                    controller: _isimCtrl,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: "Poppins"),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: "İSMİNİZİ GİRİNİZ",
                        hintStyle: TextStyle(fontFamily: "Poppins")),
                  ),
                ),
                const SizedBox(height: 35),
                Obx(() => Visibility(
                      visible: _karsilamaEkraniCtrl.devamBtnVisible.value,
                      child: GestureDetector(
                        onTap: () => _isimKaydet(),
                        child: const Text(
                          "Devam et",
                          style: TextStyle(
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.bold,
                              color: Colors.blueGrey,
                              fontSize: 20),
                        ),
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future _isimKaydet() async {
    var box = await Hive.openBox('hatimflutter');
    await box.put("isim", _isimCtrl.text);
    Get.off(() => AnaSayfa());
  }
}
