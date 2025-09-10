import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_my_app/config/config.dart';

import 'package:http/http.dart' as http;
import 'package:new_my_app/model/response/trip_get_res.dart';
import 'package:new_my_app/pages/TripPage.dart';
import 'package:new_my_app/pages/profile.dart';

class Showtrip extends StatefulWidget {
  int cid = 0;
  Showtrip({super.key, required this.cid});

  @override
  State<Showtrip> createState() => _ShowtripState();
}

class _ShowtripState extends State<Showtrip> {
  String url = '';
  
  List<GetTripResponse> getTripResponse = [];
  late Future<void> loadData;

  List<GetTripResponse> AllMain = [];

  @override
  void initState() {
    super.initState();
    loadData = getTrip();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('รายการทริป'),
        actions: [
          PopupMenuButton(
            onSelected: (value) {
              if (value == 'profile') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => profilePage(
                    idx: widget.cid,
                  )),
                );
              } else if (value == 'logout') {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
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
      body:
          //load Data From API
          FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                //waiting
                return Center(child: CircularProgressIndicator());
              }
              //done
              return SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ปลายทาง'),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: FilledButton(
                                onPressed: () {
                                  setState(() {
                                    getTripResponse = AllMain;
                                    getTrip();
                                  });
                                },
                                child: const Text('ทั้งหมด'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: FilledButton(
                                onPressed: () {
                                  getT('เอเชีย');
                                  /* getTripResponse = AllMain;
                                  List<GetTripResponse> asiaTrip = [];
                                  for (var trip in getTripResponse) {
                                    if (trip.destinationZone == 'เอเชีย') {
                                      asiaTrip.add(trip);
                                    }
                                  }
                                  setState(() {
                                    getTripResponse = asiaTrip;
                                  }); */
                                },
                                child: const Text('เอเชีย'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: FilledButton(
                                onPressed: () {
                                  getT('ยุโรป');
                                },
                                child: const Text('ยุโรป'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: FilledButton(
                                onPressed: () {
                                  getT('เอเชียตะวันออกเฉียงใต้');
                                },
                                child: const Text('อาเซียน'),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5),
                              child: FilledButton(
                                onPressed: () {
                                  getT('ประเทศไทย');
                                },
                                child: const Text('ประเทศไทย'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: getTripResponse
                                .map(
                                  (trip) => Card(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 10,
                                            top: 10,
                                          ),
                                          child: Text(
                                            trip.name,
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: trip.coverimage.isNotEmpty
                                                  ? Image.network(
                                                      trip.coverimage,
                                                      width: 180,
                                                      height: 200,
                                                      errorBuilder:
                                                          (
                                                            context,
                                                            error,
                                                            stackTrace,
                                                          ) {
                                                            return Container(
                                                              width: 180,
                                                              height: 200,
                                                              color:
                                                                  Colors.grey,
                                                              child: Icon(
                                                                Icons
                                                                    .broken_image,
                                                                size: 50,
                                                              ),
                                                            );
                                                          },
                                                    )
                                                  : Container(
                                                      width: 180,
                                                      height: 200,
                                                      color: Colors.white,
                                                    ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                left: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text('ประเทศ${trip.country}'),
                                                  Text(
                                                    'ระยะเวลา${trip.duration}',
                                                  ),
                                                  Text('ราคา${trip.price}'),
                                                  FilledButton(
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) =>
                                                              TripPage(
                                                                idx: trip.idx,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                    child: const Text(
                                                      'รายละเอียดเพิ่มเติม',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
    );
  }

  Future<void> getTrip() async {
    /* http.get(Uri.parse("$url/trips")).then((value) {
      getTripRespond = getTripRespondFromJson(value.body);
      log(getTripRespond.length.toString());
      setState(() {});
    }); */
    var config = await Configuration.getConfig();
    url = config['apiEndPoint'];
    var res = await http.get(Uri.parse('$url/trips'));
    //log(res.body);
    getTripResponse = getTripResponseFromJson(res.body);
    log(getTripResponse.length.toString());
    AllMain = getTripResponse;
  }

  getT(String zone) {
    List<GetTripResponse> Trip = [];
    getTripResponse = AllMain;
    for (var trip in getTripResponse) {
      if (trip.destinationZone == zone) {
        Trip.add(trip);
      }
    }
    setState(() {
      getTripResponse = Trip;
    });
  }
}
