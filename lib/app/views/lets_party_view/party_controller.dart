import 'package:get/get.dart';
import 'package:zego_express_engine/zego_express_engine.dart';

class PartyController extends GetxController {
  @override
  void onInit() {
    initEnginer();
    super.onInit();
  }

  RxBool isEnginerInited = false.obs;

  initEnginer() async {
    await ZegoExpressEngine.createEngineWithProfile(
      ZegoEngineProfile(
        1181603960,
        ZegoScenario.HighQualityChatroom,
        appSign:
            '5de12f92b097e4d0b3fee8ea25315832053226c5b89182a5bbdd23b271f5ff51',
      ),
    );
    isEnginerInited.value = true;
  }

  @override
  void onClose() {
    ZegoExpressEngine.destroyEngine();
    super.onClose();
  }
}
