import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuranhatim/constants/colors.dart';
import 'package:kuranhatim/islemler/hatimislemleri.dart';

import '../controller/hatimler_controller.dart';

class HatimSayfasi extends StatefulWidget {
  final veri;
  HatimSayfasi({required this.veri});

  @override
  State<HatimSayfasi> createState() => _HatimSayfasiState();
}

class _HatimSayfasiState extends State<HatimSayfasi> {
  final _hatimIslemleri = HatimIslemleri();
  final _hatimController = Get.put(HatimlerController());

  @override
  void initState() {
    _hatimIslemleri.aldiklarimListesi(hatimId: widget.veri.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final DateTime bitis = widget.veri["bitis"].toDate();
    final DateTime dateNow = DateTime.now();

    return SafeArea(
      child: Scaffold(
        backgroundColor: colorBg,
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                _titleWidget(),
                const SizedBox(height: 10),
                _gridView(bitis: bitis, dateNow: dateNow),
                const Divider(
                  thickness: 1,
                  height: 20,
                ),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _aciklamaWidget(dateNow, bitis),
                        _cuzAlanlarBtn()
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  GestureDetector _cuzAlanlarBtn() {
    return GestureDetector(
      onTap: () {
        String alinanlarText = "";
        List alinanList = widget.veri["alinanlar"];
        for (Map kullanici in alinanList) {
          alinanlarText += kullanici.keys.toList()[0].toString();
          alinanlarText += ". Cüz ";
          alinanlarText += kullanici.values.toList()[0].toString();
          alinanlarText += "\n";
        }
        Get.generalDialog(
          pageBuilder: (context, animation, secondaryAnimation) {
            return AlertDialog(
              scrollable: true,
              title: const Text('Cüz Alanlar'),
              content: Text(alinanlarText),
              actions: [
                ElevatedButton(
                  child: const Text('Kapat'),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        child: const Text(
          "Cüz Alanları Gör",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: "Poppins", fontSize: 16),
        ),
      ),
    );
  }

  Widget _aciklamaWidget(DateTime dateNow, DateTime bitis) {
    String kalanTarih =
        dateNow.difference(bitis).inDays.toString().replaceAll('-', '') +
            " Gün kaldı";

    if (bitis.isBefore(dateNow)) {
      kalanTarih = "Süre Doldu";
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.veri['baslik'],
          textAlign: TextAlign.center,
          style: const TextStyle(
              color: Color(0xFF26A69A),
              fontFamily: "Poppins",
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          widget.veri['aciklama'],
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text(
              widget.veri['kullanici'],
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.blueGrey),
            ),
            const Expanded(child: SizedBox()),
            Text(
              kalanTarih,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.blueGrey),
            )
          ],
        ),
        const Divider(
          thickness: 1,
          height: 40,
        )
      ],
    );
  }

  Widget _gridView({required DateTime bitis, required DateTime dateNow}) {
    final List alinanlar = widget.veri['alinanlar'];
    List alinanCuzler = [];
    for (Map cuz in alinanlar) {
      alinanCuzler.add(cuz.keys.toList()[0]);
    }

    return Obx(() => GridView.count(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          crossAxisCount: 6,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
          children: [
            for (var i = 1; i <= 30; i++)
              GestureDetector(
                  onTap: alinanCuzler.contains(i.toString()) ||
                          bitis.isBefore(dateNow)
                      ? null
                      : () {
                          Get.generalDialog(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return AlertDialog(
                                title: Text('$i. Cüz Alınacak'),
                                content: const Text(
                                    'Bu cüzü almak istediğinize emin misiniz?'),
                                actions: [
                                  ElevatedButton(
                                    onPressed: () => Get.back(),
                                    child: const Text('İPTAL'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Get.back();
                                      _hatimIslemleri.cuzAl(
                                          cuzNumara: i,
                                          hatimId: widget.veri.id);
                                      alinanCuzler.add(i);
                                      setState(() {});
                                      Get.snackbar("Başarılı",
                                          "$i. Cüzü aldınız. Lütfen zamanında okumaya özen gösterin.",
                                          backgroundColor: Colors.green[100],
                                          snackPosition: SnackPosition.BOTTOM,
                                          margin: const EdgeInsets.all(10));
                                    },
                                    child: const Text('KABUL'),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                  child: Center(
                    child: Container(
                      decoration: BoxDecoration(
                          color: _hatimController.aldiklarimListesi.contains(i)
                              ? Colors.amber[200]
                              : alinanCuzler.contains(i.toString())
                                  ? Colors.grey[300]
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(8)),
                      alignment: Alignment.center,
                      width: double.infinity,
                      child: Text(
                        i.toString(),
                        style: const TextStyle(fontFamily: "Poppins"),
                      ),
                    ),
                  ))
          ],
        ));
  }

  Widget _titleWidget() {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          "Hangi Cüzü Okumak İstersiniz?",
          style: TextStyle(
              color: Colors.purple[500],
              fontFamily: "Poppins",
              fontSize: 17,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
