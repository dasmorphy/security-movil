import 'package:flutter_test/flutter_test.dart';
import 'package:zentinel/presentation/widgets/forms/technical/product_form.dart';

void main() {
  group('buildProductPayload', () {
    test('construye el contrato completo y normaliza sus valores', () {
      final payload = buildProductPayload(
        createdBy: 'daniel',
        externalTransactionId: 'transaction-id',
        values: {
          'base_price': ' 12,50 ',
          'code': ' UTP-01 ',
          'description': ' Cable de red ',
          'model': ' CAT6 ',
          'price': '20',
          'product': ' Cable UTP ',
          'profit_margin': '37.5',
          'profit_margin_dollar': '7,50',
          'provider': ' Proveedor ACME ',
          'stock': '15',
          'unit': ' caja ',
        },
      );

      expect(payload, {
        'channel': 'Tech control',
        'data': {
          'base_price': 12.5,
          'code': 'UTP-01',
          'created_by': 'daniel',
          'description': 'Cable de red',
          'model': 'CAT6',
          'price': 20,
          'product': 'Cable UTP',
          'profit_margin': 37.5,
          'profit_margin_dollar': 7.5,
          'provider': 'Proveedor ACME',
          'stock': 15,
          'unit': 'caja',
        },
        'externalTransactionId': 'transaction-id',
      });
    });

    test('usa valores neutros para los campos opcionales vacíos', () {
      final payload = buildProductPayload(
        createdBy: 'usuario-sesion',
        externalTransactionId: 'transaction-id',
        values: {'product': 'Cable UTP'},
      );

      expect(payload['data'], {
        'base_price': 0,
        'code': '',
        'created_by': 'usuario-sesion',
        'description': '',
        'model': '',
        'price': 0,
        'product': 'Cable UTP',
        'profit_margin': 0,
        'profit_margin_dollar': 0,
        'provider': '',
        'stock': 0,
        'unit': '',
      });
    });
  });
}
