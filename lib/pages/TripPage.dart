import 'dart:developer';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_my_app/model/response/trip_idx_get_res.dart';
import 'package:new_my_app/pages/profile.dart';
import '../config/config.dart';

class TripPage extends StatefulWidget {
  int idx = 0;
  TripPage({super.key, required this.idx});

  @override
  State<TripPage> createState() => _TripPageState();
}

class _TripPageState extends State<TripPage> {
  String url = '';

  late Future<void> loadData;
  late TripIdxRes tripIdxRes;

  @override
  void initState() {
    super.initState();
    // Call async function
    loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการทริป"),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              log(value);
             
            },
            itemBuilder: (context) => [
              const PopupMenuItem<String>(
                value: 'profile',
                child: Text('ข้อมูลส่วนตัว'),
              ),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Text('ออกจากระบบ'),
              ),
            ],
          ),
        ],
      ),
      // Loding data with FutureBuilder
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: loadData,
          builder: (context, snapshot) {
            // Loading...
            if (snapshot.connectionState != ConnectionState.done) {
              return CircularProgressIndicator();
            }
            // Load Done
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tripIdxRes.name,
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: Text(tripIdxRes.country),
                  ),
                  Image.network(tripIdxRes.coverimage),

                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("ราคา " + tripIdxRes.price.toString() + " บาท"),
                        Text(tripIdxRes.destinationZone),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(tripIdxRes.detail),
                  ),
                  Center(
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text("จองเลย!!"),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> loadDataAsync() async {
    var config = await Configuration.getConfig();
    url = config['apiEndPoint'];
    var res = await http.get(Uri.parse('$url/trips/${widget.idx}'));
    log(res.body);
    tripIdxRes = tripIdxResFromJson(res.body);
  }
}
