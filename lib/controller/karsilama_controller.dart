import 'package:get/get.dart';

class KarsilamaController extends GetxController {
  var devamBtnVisible = false.obs;

  setDevamBtnVisible(bool visible) => devamBtnVisible.value = visible;
}
