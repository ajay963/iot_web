import 'dart:async';
import 'package:get/get.dart';
import 'package:web_socket_channel/io.dart';

import '../models/master_model.dart' as m;
import '../models/temp.dart';
import '../utilities/logger.dart';

final log = getLogger("Mater_Controller");

class MasterDataController extends GetxController {
  RxInt idx = 0.obs;
  late IOWebSocketChannel channel;
  Rx<bool> isConnected = false.obs;

  RxList<GraphData> tempList = [GraphData(time: 0, value: 0)].obs;
  m.HL tempHL = m.HL(highest: 0, lowest: 85);
  Rx<m.MasterDataModel> sensorsData = m.MasterDataModel(
          atmos: m.AtmosDataModel(temp: 0, humidity: 0, pressure: 0),
          gps: m.GPSDataModel(lat: 23.79565310, lon: 23.79565310),
          gas: m.GasDataModel(mq4: 0, mq7: 0, mq135: 0),
          reflex: m.ReflexDataModel(
              yaw: 0, pitch: 0, roll: 0, fClr: 100, lClr: 100, rClr: 100))
      .obs;

  @override
  void onInit() {
    isConnected.value = false;
    Timer.periodic(const Duration(seconds: 1), _updateGraphAndValues);

    Future.delayed(Duration.zero, () async {
      channelconnect(); //connect to WebSocket wth NodeMCU
    });
    super.onInit();
  }

  channelconnect() {
    try {
      channel =
          IOWebSocketChannel.connect("ws://192.168.4.1:81"); //channel IP : Port
      channel.stream.listen(
        (message) {
          log.i(message);
          isConnected.value = true;
          sensorsData.value = m.MasterDataModel.fromJson(message);
        },
        onDone: () {
          //if WebSocket is disconnected
          log.w("Websocket is closed");
          isConnected.value = false;
          update();
        },
        onError: (error) {
          log.e("socket error : $error");
        },
      ).onError((e) {
        log.e("socket error : $e");
      });
    } catch (_) {
      log.e("error on connecting to websocket.");
    }
  }

  Future<void> sendcmd(String cmd) async {
    if (isConnected.value == true) {
      log.i(cmd);
      channel.sink.add(cmd); //sending Command to NodeMCU
    } else {
      channelconnect();
      log.i(cmd);
      log.w("Websocket is not connected.");
    }
  }

  void _updateGraphAndValues(Timer time) {
    idx = idx + 1;

    // range check
    if (sensorsData.value.atmos.temp < 80 && sensorsData.value.atmos.temp > 4) {
      tempHL = tempHL.getHL(sensorsData.value.atmos.temp);
    }

    tempList.add(GraphData(
        time: idx.toDouble(), value: sensorsData.value.atmos.temp.toDouble()));

    if (tempList.length > 10) tempList.removeAt(0);
    if (isConnected.value == false && idx % 10 == 0) {
      channelconnect();
    }
    log.i("seconds : $idx");
    update();
  }
}
