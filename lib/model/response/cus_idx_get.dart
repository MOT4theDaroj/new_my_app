// To parse this JSON data, do
//
//     final cusIdxRes = cusIdxResFromJson(jsonString);

import 'dart:convert';

CusIdxRes cusIdxResFromJson(String str) => CusIdxRes.fromJson(json.decode(str));

String cusIdxResToJson(CusIdxRes data) => json.encode(data.toJson());

class CusIdxRes {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    CusIdxRes({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory CusIdxRes.fromJson(Map<String, dynamic> json) => CusIdxRes(
        idx: json["idx"],
        fullname: json["fullname"],
        phone: json["phone"],
        email: json["email"],
        image: json["image"],
    );

    Map<String, dynamic> toJson() => {
        "idx": idx,
        "fullname": fullname,
        "phone": phone,
        "email": email,
        "image": image,
    };
}
