import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/widgets/forms/reception_confirmation_form.dart';

// ============ EJEMPLO DE USO AVANZADO ============
// 
// Este archivo demuestra cómo integrar el formulario de recepción
// con providers de Riverpod y servicios de la aplicación

// Provider para gestionar el estado del despacho
class DispatchNotifier extends StateNotifier<DispatchData?> {
  DispatchNotifier() : super(null);

  void loadDispatchData(String dispatchId) {
    // Simulación: En producción, traerías datos de un repositorio
    state = DispatchData(
      dispatchId: dispatchId,
      origin: 'Central Hub',
      driver: 'Marcus V.',
      status: 'IN TRANSIT',
      statusColor: const Color.fromARGB(255, 34, 197, 94),
    );
  }
}

final dispatchProvider =
    StateNotifierProvider<DispatchNotifier, DispatchData?>((ref) {
  return DispatchNotifier();
});

// Provider para gestionar los productos
class ProductsNotifier extends StateNotifier<List<ReceivedProduct>> {
  ProductsNotifier() : super([]);

  void loadProducts(String dispatchId) {
    // Simulación: En producción, traerías datos de un repositorio
    state = [
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
        productName: 'Inversor Trifásico ssscc',
        status: 'DISCREPANCIA',
        expectedQty: 4,
        receivedQty: 3,
        commentary:
            'Se recibe 1 unidad menos debido a daño visible en el embalaje',
        hasDiscrepancy: true,
        photoUrls: [],
      ),
    ];
  }

  void updateProduct(int index, ReceivedProduct product) {
    final newState = [...state];
    newState[index] = product;
    state = newState;
  }
}

final productsProvider =
    StateNotifierProvider<ProductsNotifier, List<ReceivedProduct>>((ref) {
  return ProductsNotifier();
});

// Provider para servicio de recepción (simulado)
final receptionServiceProvider = Provider<ReceptionService>((ref) {
  return ReceptionService();
});

class ReceptionService {
  Future<bool> confirmReception(Map<String, dynamic> data) async {
    try {
      // Simulación de publicación a servidor
      // await dio.post('/api/reception/confirm', data: data);
      
      // Por ahora, simulamos un delay
      await Future.delayed(const Duration(seconds: 2));
      
      print('✓ Recepción confirmada: $data');
      return true;
    } catch (e) {
      print('✗ Error confirmando recepción: $e');
      return false;
    }
  }
}

// Pantalla de ejemplo integrada con providers
class ReceptionConfirmationScreenAdvanced extends ConsumerWidget {
  final String dispatchId;

  const ReceptionConfirmationScreenAdvanced({
    super.key,
    required this.dispatchId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dispatchData = ref.watch(dispatchProvider);
    final products = ref.watch(productsProvider);
    final receptionService = ref.watch(receptionServiceProvider);

    // Cargar datos al iniciar
    ref.listen(dispatchProvider, (previous, next) {
      if (next == null) {
        Future.microtask(() {
          ref.read(dispatchProvider.notifier).loadDispatchData(dispatchId);
          ref.read(productsProvider.notifier).loadProducts(dispatchId);
        });
      }
    });

    if (dispatchData == null || products.isEmpty) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 20, 21, 23),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return ReceptionConfirmationForm(
      dispatchData: dispatchData,
      products: products,
      onSubmit: (data) async {
        return await receptionService.confirmReception(data);
      },
      onBackPressed: () {
        Navigator.pop(context);
      },
    );
  }
}

// ============ EJEMPLO DE PRUEBA ============

void main() {
  runApp(
    const ProviderScope(
      child: TestApp(),
    ),
  );
}

class TestApp extends StatelessWidget {
  const TestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reception Confirmation Test',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: const Color.fromARGB(255, 40, 98, 245),
      ),
      home: const ReceptionConfirmationScreenAdvanced(
        dispatchId: '#8892-X',
      ),
    );
  }
}
