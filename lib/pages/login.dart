import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:new_my_app/config/config.dart';
//import 'package:new_my_app/config/internal_config.dart';
import 'package:new_my_app/model/request/customer_login_post_req.dart';
import 'package:new_my_app/model/response/customer_login_post_res.dart';
import 'package:new_my_app/pages/RegisterPage.dart';
import 'package:new_my_app/pages/showTrip.dart';

import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /* String phone = '0902577501';
  String password = '1234'; */
  String text = '';
  TextEditingController phoneInput = TextEditingController();
  TextEditingController passwordInput = TextEditingController();

  String url ='';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Configuration.getConfig().then(
  (config) {
	url = config['apiEndPoint'];
  },
);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              InkWell(
                onTap: () => login(),
                child: Image.asset('assets/images/travel.jpg')),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('หมายเลขโทรศัพท์', style: TextStyle(fontSize: 20)),
                  ],
                ),
              ),
              TextField(
                controller: phoneInput,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
                keyboardType: TextInputType.phone,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [Text('รหัสผ่าน', style: TextStyle(fontSize: 20))],
                ),
              ),
              TextField(
                controller: passwordInput,
                decoration: InputDecoration(
                  border: OutlineInputBorder(borderSide: BorderSide(width: 1)),
                ),
                obscureText: true,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: register,
                      child: const Text('ลงทะเบียนใหม่'),
                    ),
                    FilledButton(
                      onPressed: login,
                      child: const Text('เข้าสู่ระบบ'),
                    ),
                  ],
                ),
              ),
              Text(text)
            ],
          ),
        ),
      ),
    );
  }

  void register() {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>  RegisterPage(),
        ));
  }

  void login() {

  //0817399999
  //1111
   CustomerLoginPostRequest customerLoginPostRequest = CustomerLoginPostRequest(phone: phoneInput.text, password: passwordInput.text);
  log(jsonEncode(customerLoginPostRequest));
  log(url);
    http
        .post(Uri.parse("$url/customers/login"),
            headers: {"Content-Type": "application/json; charset=utf-8"},
            body: customerLoginPostRequestToJson(customerLoginPostRequest))
        .then((value) {
          //value = jason string
        CustomerLoginPostResponse customerLoginPostResponse = customerLoginPostResponseFromJson(value.body);
        
        log(customerLoginPostResponse.customer.fullname);
        log(customerLoginPostResponse.customer.email);
        Navigator.push(
        context, 
        MaterialPageRoute(builder: (context)=>Showtrip(
          cid: customerLoginPostResponse.customer.idx
        )),);
      },
    ).catchError((error) {
      log('Error $error');
    });
    
  }

}
