import 'package:flutter/material.dart';

class MaterialEntry {
  final int id;
  final String productName;
  final String status;
  final int expectedQty;
  int receivedQty;
  String commentary;
  bool hasDiscrepancy;
  List<String>? photoUrls;

  MaterialEntry({
    required this.id,
    required this.productName,
    required this.status,
    required this.expectedQty,
    this.receivedQty = 0,
    this.commentary = '',
    this.hasDiscrepancy = false,
    this.photoUrls,
  });
}

class EntryHeader {
  final int entryAccessId;
  final String dni;
  final String nameVisit;
  final String areaVisit;
  final String status;
  final Color statusColor;

  const EntryHeader({
    required this.entryAccessId,
    required this.dni,
    required this.nameVisit,
    required this.areaVisit,
    required this.status,
    this.statusColor = const Color.fromARGB(255, 34, 197, 94),
  });
}