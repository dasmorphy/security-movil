import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:zentinel/domain/entities/destiny_intern.dart';
import 'package:zentinel/domain/entities/vehicle_type.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class InformacionLogisticaCard extends StatelessWidget {
  final String driver;
  final String orderNumber;
  final String truckLicense;
  final bool imagesMinError;
  final bool imagesMaxError;
  final TextEditingController driverCtrl;
  final TextEditingController orderNumberCtrl;
  final TextEditingController truckLicenseCtrl;
  final TextEditingController clientCtrl;
  final TextEditingController observationsCtrl;

  final Function(List<Uint8List>) onImagesChanged;

  final int? vehicleSelected;
  final int? destinySelected;
  final String? destinyProduct;
  final bool? isProductTerm;
  final List<VehicleType> catalogVehicles;
  final List<DestinyIntern> catalogDestiny;
  final void Function(int) onDestinyChanged;
  final void Function(String) onDestinyProductChange;
  final void Function(int) onVehicleChanged;

  const InformacionLogisticaCard({
    super.key,
    required this.truckLicense,
    required this.driver,
    required this.orderNumber,
    required this.vehicleSelected,
    required this.onDestinyChanged,
    required this.catalogVehicles,
    required this.onVehicleChanged,
    required this.catalogDestiny,
    required this.destinySelected,
    required this.orderNumberCtrl,
    required this.driverCtrl,
    required this.truckLicenseCtrl,
    required this.observationsCtrl,
    required this.imagesMinError,
    required this.imagesMaxError,
    required this.onImagesChanged,
    required this.clientCtrl,
    required this.onDestinyProductChange,
    this.destinyProduct = '0',
    this.isProductTerm = false,
  });

  @override
  Widget build(BuildContext context) {
    final FocusNode orderNumberFocus = FocusNode();
    final FocusNode driverFocus = FocusNode();
    final FocusNode truckLicenseFocus = FocusNode();
    final FocusNode clientFocus = FocusNode();
    final FocusNode observationsFocus = FocusNode();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'INFORMACIÓN LOGÍSTICA',
          style: TextStyle(
            color: kTextSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
        
        const SizedBox(height: 16),

        CustomFieldLabelRequired(txtLabel: 'N. ORDEN'),
        GlowTextFormField(
          controller: orderNumberCtrl,
          focusNode: orderNumberFocus,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return messageValidatorEmpty;
            }
            return null;
          },
        ),

        const SizedBox(height: 12),

        CustomFieldLabelRequired(txtLabel: 'CONDUCTOR'),
        GlowTextFormField(
          controller: driverCtrl,
          focusNode: driverFocus,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return messageValidatorEmpty;
            }
            return null;
          },
        ),

        const SizedBox(height: 12),

        CustomFieldLabelRequired(txtLabel: 'PLACA'),
        GlowTextFormField(
          controller: truckLicenseCtrl,
          focusNode: truckLicenseFocus,
          validator: (v) {
            if (v == null || v.trim().isEmpty) {
              return messageValidatorEmpty;
            }
            return null;
          },
        ),

        const SizedBox(height: 16),
        CustomFieldLabelRequired(txtLabel: 'DESTINO'),
        if (isProductTerm == true) ...[
          GlowDropdownFormField2<String>(
            value: destinyProduct.toString(),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            items: [
              DropdownMenuItem(
                enabled: false,
                value: '0',
                child: Text(
                  'Seleccione una opción',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              DropdownMenuItem(
                value: 'Bodega',
                child: Text(
                  'Bodega',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              
              DropdownMenuItem(
                value: 'Cliente',
                child: Text(
                  'Cliente',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ],
            onChanged: (option) {
              if (option != null) {
                onDestinyProductChange(option);
              }
            },
            validator: (v) {
              if (v == '0' || v == null || v.trim().isEmpty) {
                return messageValidatorEmpty;
              }
              return null;
            },
          ),
        ],

        // Mostrar dropdown de catalogDestiny si es Bodega o si isProductTerm es false
        if (isProductTerm != true || (isProductTerm == true && destinyProduct == 'Bodega')) ...[
          const SizedBox(height: 12),
          GlowDropdownFormField2<String>(
            value: destinySelected.toString(),
            textColor: const Color.fromARGB(255, 255, 255, 255),
            items: [
              DropdownMenuItem(
                enabled: false,
                value: '0',
                child: Text(
                  'Seleccione una opción',
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
              ...catalogDestiny.map(
                (c) => DropdownMenuItem(
                  value: c.idDestiny.toString(),
                  child: Text(
                    c.name,
                    style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  ),
                ),
              ),
            ],
            onChanged: (id) {
              if (id != null) {
                onDestinyChanged(int.parse(id));
              }
            },
            validator: (v) {
              if (v == '0' || v == null || v.trim().isEmpty) {
                return messageValidatorEmpty;
              }
              return null;
            },
          ),
        ],

        // Mostrar campo de texto si destinyProduct es Cliente
        if (destinyProduct == 'Cliente') ...[
          const SizedBox(height: 12),

          CustomFieldLabelRequired(txtLabel: 'Cliente'),
          GlowTextFormField(
            controller: clientCtrl,
            focusNode: clientFocus,
            validator: (v) {
              if (v == null || v.trim().isEmpty) {
                return messageValidatorEmpty;
              }
              return null;
            },
          ),
        ],


        const SizedBox(height: 20),
        CustomFieldLabelRequired(txtLabel: 'TIPO TRANSPORTE'),
        GlowDropdownFormField2<String>(
          value: vehicleSelected.toString(),
          textColor: const Color.fromARGB(255, 255, 255, 255),
          items: [
            DropdownMenuItem(
              enabled: false,
              value: '0',
              child: Text(
                'Seleccione una opción',
                style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
              ),
            ),
            ...catalogVehicles.map(
              (c) => DropdownMenuItem(
                value: c.idVehicleType.toString(),
                child: Text(
                  c.name,
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
          onChanged: (id) {
            if (id != null) {
              onVehicleChanged(int.parse(id));
            }
          },
          validator: (v) {
            if (v == '0' || v == null || v.trim().isEmpty) {
              return messageValidatorEmpty;
            }
            return null;
          },
        ),

        const SizedBox(height: 20),

        CommentaryReception(
          controller: observationsCtrl,
          focusNode: observationsFocus,
          hint: 'Observaciones generales sobre la recepción (opcional)',
          // ,
          // onChanged: (value) {
          //   setState(() {
          //     _observationsCtrl.text = value;
          //   });
          // },
        ),
        const SizedBox(height: 20),

        CameraImagePicker(
          minImages: 5,
          maxImages: 10,
          onImagesChanged: onImagesChanged,
        ),

        const SizedBox(height: 10),

        if (imagesMinError || imagesMaxError)
          SizedBox(
            width: double.infinity,
            child: Text(
              imagesMinError
                  ? 'Debe subir mínimo 5 imagenes'
                  : 'Debe subir máximo 10 imagenes',
              style: TextStyle(color: Color.fromARGB(255, 239, 28, 13)),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}
