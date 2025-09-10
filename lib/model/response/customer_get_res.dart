// To parse this JSON data, do
//
//     final getCustomer = getCustomerFromJson(jsonString);

import 'dart:convert';

List<GetCustomer> getCustomerFromJson(String str) => List<GetCustomer>.from(json.decode(str).map((x) => GetCustomer.fromJson(x)));

String getCustomerToJson(List<GetCustomer> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetCustomer {
    int idx;
    String fullname;
    String phone;
    String email;
    String image;

    GetCustomer({
        required this.idx,
        required this.fullname,
        required this.phone,
        required this.email,
        required this.image,
    });

    factory GetCustomer.fromJson(Map<String, dynamic> json) => GetCustomer(
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
