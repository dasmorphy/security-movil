import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/all_dispatch.dart';
import 'package:zentinel/presentation/widgets/forms/reception_confirmation_form.dart';

class ReceptionConfirmationScreen extends StatelessWidget {
  static const name = 'reception-confirmation-screen';

  final AllDispatch dispatchData; // <-- este es el que debes usar

  const ReceptionConfirmationScreen({super.key, required this.dispatchData});

  @override
  Widget build(BuildContext context) {
    // Datos de ejemplo del despacho
    print('Datos recibidos para confirmación: $dispatchData');
    final dispatchDatas = DispatchData(
      dispatchId: '#8892-X',
      origin: 'Central Hub',
      driver: 'Marcus V.',
      status: 'IN TRANSIT',
      statusColor: const Color.fromARGB(255, 34, 197, 94),
    );

  // Productos de ejemplo
    final products = [
      ReceivedProduct(
        id: '1',
        productName: 'Panel Solar XL-400',
        status: 'CORRECTO',
        expectedQty: 12,
        receivedQty: 12,
        commentary: '',
        hasDiscrepancy: false,
      ),
      ReceivedProduct(
        id: '2',
        productName: 'Inversor Trifásico sccsas',
        status: 'DISCREPANCIA',
        expectedQty: 4,
        receivedQty: 3,
        commentary:
            'Se recibe 1 unidad menos debido a daño visible en el embalaje exterior durante la descarga.',
        hasDiscrepancy: true,
        photoUrls: [],
      ),
    ];

    return ReceptionConfirmationForm(
      dispatchData: dispatchDatas,
      products: products,
      onSubmit: (data) async {
        // Aquí implementarías la lógica para enviar los datos al servidor
        print('Datos de recepción: $data');
        
        // Simular una llamada a API
        await Future.delayed(const Duration(seconds: 2));
        
        return true; // Retornar true si fue exitoso, false si hubo error
      },
      onBackPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
