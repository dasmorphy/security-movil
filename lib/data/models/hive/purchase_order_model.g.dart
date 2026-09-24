part of 'purchase_order_model.dart';

class PurchaseOrderModelAdapter extends TypeAdapter<PurchaseOrderModel> {
  @override
  final int typeId = 8;

  @override
  PurchaseOrderModel read(BinaryReader reader) {
    final fields = <int, dynamic>{};
    final count = reader.readByte();
    for (var i = 0; i < count; i++) {
      fields[reader.readByte()] = reader.read();
    }
    return PurchaseOrderModel(
      createdAt: fields[0] as String,
      createdBy: fields[1] as String,
      endDate: fields[2] as String,
      idOrder: fields[3] as int,
      numberOrder: fields[4] as String,
      observations: fields[5],
      provider: fields[6] as String,
      quantity: (fields[7] as num).toDouble(),
      startDate: fields[8] as String,
      statusId: fields[9] as int,
      statusName: fields[10] as String,
      typeOrder: fields[11] as String,
      updatedAt: fields[12] as String,
      updatedBy: fields[13] as String,
    );
  }

  @override
  void write(BinaryWriter writer, PurchaseOrderModel obj) {
    writer
      ..writeByte(14)
      ..writeByte(0)..write(obj.createdAt)
      ..writeByte(1)..write(obj.createdBy)
      ..writeByte(2)..write(obj.endDate)
      ..writeByte(3)..write(obj.idOrder)
      ..writeByte(4)..write(obj.numberOrder)
      ..writeByte(5)..write(obj.observations)
      ..writeByte(6)..write(obj.provider)
      ..writeByte(7)..write(obj.quantity)
      ..writeByte(8)..write(obj.startDate)
      ..writeByte(9)..write(obj.statusId)
      ..writeByte(10)..write(obj.statusName)
      ..writeByte(11)..write(obj.typeOrder)
      ..writeByte(12)..write(obj.updatedAt)
      ..writeByte(13)..write(obj.updatedBy);
  }
}
