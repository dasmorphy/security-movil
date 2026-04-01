import 'package:flutter/material.dart';
import 'package:zentinel/presentation/widgets/dispatch/dispatch_info_card.dart';
import 'package:zentinel/presentation/widgets/dispatch/received_product_item.dart';
import 'package:zentinel/presentation/widgets/headers/confirmation_header.dart';

// ============ GALERÍA DE COMPONENTES ============
//
// Este archivo demuestra cada componente de forma individual
// para facilitar el testing y visualización de estilos

class ComponentGalleryScreen extends StatefulWidget {
  const ComponentGalleryScreen({super.key});

  @override
  State<ComponentGalleryScreen> createState() => _ComponentGalleryScreenState();
}

class _ComponentGalleryScreenState extends State<ComponentGalleryScreen> {
  bool _discrepancyToggle = false;
  int _receivedQty = 3;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 20, 21, 23),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: ConfirmationHeader(
          title: 'Component Gallery',
          onBackPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============ DISPATCH INFO CARD ============
              _buildSectionTitle('1. Dispatch Info Card'),
              const SizedBox(height: 12),
              DispatchInfoCard(
                dispatchId: '#8892-X',
                origin: 'Central Hub',
                driver: 'Marcus V.',
                status: 'IN TRANSIT',
                statusColor: const Color.fromARGB(255, 34, 197, 94),
              ),
              const SizedBox(height: 32),

              // ============ DISPATCH INFO CARD - DELAYED ============
              _buildSectionTitle('2. Dispatch Info Card - Different Status'),
              const SizedBox(height: 12),
              DispatchInfoCard(
                dispatchId: '#7721-Y',
                origin: 'South Distribution Center',
                driver: 'Juan P.',
                status: 'DELAYED',
                statusColor: const Color.fromARGB(255, 245, 158, 11),
              ),
              const SizedBox(height: 32),

              // ============ RECEIVED PRODUCT - CORRECTO ============
              _buildSectionTitle('3. Received Product - CORRECTO (No Discrepancy)'),
              const SizedBox(height: 12),
              ReceivedProductItem(
                productName: 'Panel Solar XL-400',
                status: _discrepancyToggle ? 'CORRECTO' : 'DISCREPANCIA',
                expectedQty: 12,
                receivedQty: 12,
                hasDiscrepancy: _discrepancyToggle,
                onToggleChanged: (value) {
                  setState(() => _discrepancyToggle = value);
                },
              ),
              const SizedBox(height: 32),

              // ============ RECEIVED PRODUCT - DISCREPANCIA ============
              _buildSectionTitle('4. Received Product - DISCREPANCIA'),
              const SizedBox(height: 12),
              ReceivedProductItem(
                productName: 'Inversor Trifásicosssss',
                status: _discrepancyToggle ? 'CORRECTO' : 'DISCREPANCIA',
                expectedQty: 4,
                receivedQty: _receivedQty,
                commentary:
                    'Se recibe 1 unidad menos debido a daño visible en el embalaje exterior durante la descarga.',
                hasDiscrepancy: _discrepancyToggle,
                onToggleChanged: (value) {
                  setState(() => _discrepancyToggle = value);
                },
                onReceivedQtyChanged: (qty) {
                  setState(() => _receivedQty = qty);
                },
                onCommentaryChanged: (comment) {
                  print('Commentary: $comment');
                },
                // onPhotoPressed: () {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Camera functionality would be triggered'),
                //       duration: Duration(seconds: 2),
                //     ),
                //   );
                // },
              ),
              const SizedBox(height: 32),

              // ============ RECEIVED PRODUCT - INTERACTIVE ============
              _buildSectionTitle('5. Received Product - Interactive Toggle'),
              const SizedBox(height: 12),
              ReceivedProductItem(
                productName: 'Batería de Almacenamiento',
                status: 'CORRECTO',
                expectedQty: 8,
                receivedQty: 8,
                hasDiscrepancy: _discrepancyToggle,
                commentary: 'Click the toggle to see the form expand/collapse',
                onToggleChanged: (value) {
                  setState(() => _discrepancyToggle = value);
                },
                onReceivedQtyChanged: (qty) {
                  print('Cantidad recibida: $qty');
                },
                onCommentaryChanged: (comment) {
                  print('Comentario: $comment');
                },
                // onPhotoPressed: () {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Photo attachment triggered'),
                //       duration: Duration(seconds: 2),
                //     ),
                //   );
                // },
              ),
              const SizedBox(height: 32),

              // ============ CONFIRMATION BUTTONS ============
              _buildSectionTitle('6. Action Buttons'),
              const SizedBox(height: 12),
              _buildConfirmButton(),
              const SizedBox(height: 12),
              _buildCancelButton(),
              const SizedBox(height: 32),

              // ============ STATUS INDICATORS ============
              _buildSectionTitle('7. Status Color Indicators'),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatusIndicator('CORRECTO',
                      const Color.fromARGB(255, 34, 197, 94)),
                  _buildStatusIndicator('DISCREPANCIA',
                      const Color.fromARGB(255, 245, 158, 11)),
                  _buildStatusIndicator('ERROR',
                      const Color.fromARGB(255, 220, 53, 69)),
                ],
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildConfirmButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reception confirmed!'),
            backgroundColor: Color.fromARGB(255, 34, 197, 94),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color.fromARGB(255, 100, 200, 255),
              Color.fromARGB(255, 76, 195, 233),
            ],
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color.fromARGB(255, 76, 195, 233).withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Confirmar Recepción',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8),
            Icon(Icons.check, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton() {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Operation cancelled'),
            backgroundColor: Color.fromARGB(255, 150, 150, 150),
            duration: Duration(seconds: 1),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 40, 40, 45),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: const Color.fromARGB(255, 75, 83, 83),
            width: 1.5,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.close, color: Color.fromARGB(255, 150, 150, 150)),
            SizedBox(width: 8),
            Text(
              'Cancelar',
              style: TextStyle(
                color: Color.fromARGB(255, 150, 150, 150),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIndicator(String label, Color color) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(0.2),
            border: Border.all(color: color, width: 2),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
