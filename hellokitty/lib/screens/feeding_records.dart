import 'package:flutter/material.dart';
import 'package:hellokitty/model/feeding_data.dart';
import 'package:hellokitty/utils/api_service.dart';
import '../components/custom_appbar.dart';
import '../components/path_config.dart';

class FeedingRecords extends StatefulWidget {
  // const FeedingRecords({super.key});
  const FeedingRecords({Key? key}) : super(key: key);

  @override
  State<FeedingRecords> createState() => _FeedingRecordsState();
}

class _FeedingRecordsState extends State<FeedingRecords> {
  List<FeedingRecordsData> records = [];
  var recordCnt = 0;
  @override
  void initState() {
    super.initState();
    getFeedingRecords();
  }

  void getFeedingRecords() async {
    ApiService apiService = ApiService();
    await apiService.getRecords().then((value) => setState(() {
          if (value != null) {
            records = value;
            recordCnt = records.length;
          }
        }));
    debugPrint('feeding records:  $records');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        backgroudColor: Colors.black,
        title: "Feeding Records",
        height: 40,
        iconPath: IconPath.customOptions[3][1],
      ),
      // body: ListView.builder(
      //     itemCount: records.length,
      //     itemBuilder: (context, index) {
      //       return Card(
      //           child: ListTile(
      //         title: Text(records[index].feedDate),
      //         subtitle: Text("Type: " +
      //             records[index].type.toString() +
      //             ", Food Weights: " +
      //             records[index].foodWeight.toString()),
      //         leading: Icon(
      //           Icons.done,
      //           color: Colors.green,
      //         ),
      //         // trailing: Icon(Icons.access_time)
      //       ));
      //     }),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 0.0, left: 30.0, right: 20.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: 20,
                ),
                Text(
                  '$recordCnt records',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    return Card(
                        child: ListTile(
                      title: Text(records[index].feedDate),
                      subtitle: Text("Type: " +
                          records[index].type.toString() +
                          ", Food Weights: " +
                          records[index].foodWeight.toString()),
                      leading: Icon(
                        Icons.done,
                        color: Colors.green,
                      ),
                      // trailing: Icon(Icons.access_time)
                    ));
                  }),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
