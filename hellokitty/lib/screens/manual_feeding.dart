import 'package:flutter/material.dart';
import 'package:hellokitty/utils/constants.dart';
import '../components/custom_appbar.dart';
import '../components/path_config.dart';
import 'package:dio/dio.dart';

class ManualFeeding extends StatelessWidget {
  // ManualFeeding({super.key});
  ManualFeeding({Key? key}) : super(key: key);

  final dioClient = Dio();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Manual Feeding",
        iconPath: IconPath.customOptions[2][1],
        backgroudColor: Colors.black,
        height: 40,
      ),
      body: Center(
          child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 320,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    //  send feeding request to backend
                    try {
                      var reqData = {
                        "topic": "esp32/aws2esp",
                        "msg": 999,
                        "id": 11,
                      };
                      Response rsp = await dioClient
                          .post(ApiConstants.manualFeeding, data: reqData);
                      if (rsp.statusCode == 200 && rsp.data != null) {
                        debugPrint('http: response $rsp');
                        showDialog(
                          context: context,
                          builder: (context) {
                            return const AlertDialog(
                              scrollable: true,
                              // backgroundColor: Colors.deepPurple,
                              title: Center(
                                child: Text(
                                  'In preparation for feeding, please do not click repeatedly!',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 16),
                                ),
                              ),
                            );
                          },
                        );
                        await Future.delayed(Duration(seconds: 3));
                        Navigator.pop(context);
                      }
                    } on DioError catch (e) {
                      debugPrint('DioError: failed to request $e');
                    } catch (e) {
                      debugPrint('Error: failed to request $e');
                    }
                  },
                  child: const Text(
                    'Click to feed your cat!',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ))),
    );
  }
}
