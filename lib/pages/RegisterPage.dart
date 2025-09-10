import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:new_my_app/config/config.dart';
import 'package:new_my_app/model/request/customer_register_post_req.dart';
import 'package:new_my_app/model/response/customer_get_res.dart';
import 'package:new_my_app/model/response/customer_register_post_res.dart';
import 'package:new_my_app/pages/login.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController fullname = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController image = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController con_password = TextEditingController();

  String url = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ลงทะเบียนสมาชิกใหม่')),
      body: SizedBox(
        child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [Text('ชื่อ-นามสกุล')],
              ),
              TextField(
                controller: fullname,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('หมายเลขโทรศัพท์')],
                ),
              ),
              TextField(
                controller: phone,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('อีเมล์')],
                ),
              ),
              TextField(
                controller: email,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('รหัสผ่าน')],
                ),
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('ยืนยันรหัสผ่าน')],
                ),
              ),
              TextField(
                controller: con_password,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('รูปภาพ')],
                ),
              ),
              TextField(
                controller: image,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: FilledButton(
                  onPressed: register,
                  child: const Text('สมัครสมาชิก'),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: const Text(
                      'หากมีบัญชีอยู่แล้ว?',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LoginPage(),
                        ),
                      );
                    },
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void register() async{
    var config = await Configuration.getConfig();
    var url = config['apiEndPoint'];

    CustomerRegisterPostRequest customerRegisterPostRequest =
        CustomerRegisterPostRequest(
          fullname: fullname.text,
          phone: phone.text,
          email: email.text,
          image: image.text,
          password: password.text,
        );

    http.get(Uri.parse("$url/customers")).then((value) {
      List<GetCustomer> getCustomer = getCustomerFromJson(value.body);
      //log(jsonEncode(getCustomer));
      int count = 0;
      for (var cus in getCustomer) {
        if (cus.phone == phone.text) {
          count++;
        }
      }

      if (count > 0) {
        log("phone is exited");
      } else {
        log(jsonEncode(customerRegisterPostRequest));
        http
            .post(
              Uri.parse("$url/customers"),
              headers: {"Content-Type": "application/json; charset=utf-8"},
              body: customerRegisterPostRequestToJson(
                customerRegisterPostRequest,
              ),
            )
            .then((value) {
              //value = jason string
              CustomerRegisterPostResponse customerRegisterPostResponse =
                  customerRegisterPostResponseFromJson(value.body);
              log(customerRegisterPostResponse.message);
              log(customerRegisterPostResponse.id.toString());

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            })
            .catchError((error) {});
      }
    });
  }
}
