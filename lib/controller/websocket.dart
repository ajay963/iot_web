import 'dart:developer';
import 'package:get/get.dart';
import 'package:iot/models/temp.dart';
import 'package:web_socket_channel/io.dart';

class IncomingDataController extends GetxController {
  late IOWebSocketChannel channel;
  Rx<AtmosDataModel> atmosData = AtmosDataModel(temp: 0, humidity: 0).obs;
  Rx<bool> isConnected = false.obs;
  @override
  void onInit() {
    channelconnect();
    super.onInit();
  }

  channelconnect() async {
    try {
      channel = IOWebSocketChannel.connect("ws://192.168.4.1:81");
      channel.stream.listen((incomingData) {
        if (incomingData == "connected") {
          isConnected.value = true;
        } else if (incomingData.substring(0, 6) == "{'temp") {
          atmosData.value = AtmosDataModel.fromJson(incomingData);
        }
      }, onDone: () {
        isConnected.value = false;
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (isConnected.value == true) {
      channel.sink.add(cmd); //sending Command to NodeMCU
    } else {
      channelconnect();
      log("Websocket is not connected.");
    }
  }
}
