import 'dart:convert';

List<Batch> batchFromJson(String str) => List<Batch>.from(json.decode(str).map((x) => Batch.fromJson(x)));

String batchToJson(List<Batch> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Batch {
  Batch({
    this.idbatchNumbers,
    this.idItem,
    this.batchNum,
    this.dateExpiry,
    this.qtyReceived,
    this.balance,
    this.status,
    this.deleted,
    this.dateCreated,
  });

  final String idbatchNumbers;
  final String idItem;
  final String batchNum;
  final DateTime dateExpiry;
  final String qtyReceived;
  final String balance;
  final String status;
  final String deleted;
  final DateTime dateCreated;

  factory Batch.fromJson(Map<String, dynamic> json) => Batch(
    idbatchNumbers: json["idbatch_numbers"],
    idItem: json["id_item"],
    batchNum: json["batch_num"],
    dateExpiry: DateTime.parse(json["date_expiry"]),
    qtyReceived: json["qty_received"],
    balance: json["balance"],
    status: json["status"],
    deleted: json["deleted"],
    dateCreated: DateTime.parse(json["date_created"]),
  );

  Map<String, dynamic> toJson() => {
    "idbatch_numbers": idbatchNumbers,
    "id_item": idItem,
    "batch_num": batchNum,
    "date_expiry": dateExpiry.toIso8601String(),
    "qty_received": qtyReceived,
    "balance": balance,
    "status": status,
    "deleted": deleted,
    "date_created": dateCreated.toIso8601String(),
  };
}
