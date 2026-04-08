import 'package:flutter/material.dart';

class MaterialEntry {
  final int id;
  final String name;
  final int quantity;

  MaterialEntry({
    required this.id,
    required this.name,
    required this.quantity,
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