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
  final TextEditingController observationsCtrl;

  final Function(List<Uint8List>) onImagesChanged;


  final int? vehicleSelected;
  final int? destinySelected;
  final List<VehicleType> catalogVehicles;
  final List<DestinyIntern> catalogDestiny;
  final void Function(int) onDestinyChanged;
  final void Function(int) onVehicleChanged;

  const InformacionLogisticaCard({
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
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: kGrayBorder, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 14, 16, 10),
            child: Text(
              'INFORMACIÓN LOGÍSTICA',
              style: TextStyle(
                color: kTextSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
              ),
            ),
          ),

          const Divider(height: 0.5, thickness: 0.5, color: kGrayBorder),
          _LogisticaFila(
            icono: Icons.numbers_rounded,
            label: 'N. ORDEN',
            valor: orderNumber,
            controllerTxt: orderNumberCtrl,
          ),


          const Divider(height: 0.5, thickness: 0.5, color: kGrayBorder),
          _LogisticaFila(
            icono: Icons.person_rounded,
            label: 'CONDUCTOR',
            valor: driver,
            controllerTxt: driverCtrl,
          ),

          const Divider(height: 0.5, thickness: 0.5, color: kGrayBorder),
          _LogisticaFila(
            icono: Icons.directions_car_rounded,
            label: 'PLACA',
            valor: truckLicense,
            controllerTxt: truckLicenseCtrl,
          ),

          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kGrayBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.location_on_rounded, color: kNavy, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Destino'.toUpperCase(),
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      GlowDropdownFormField2<String>(
                        value: destinySelected.toString(),
                        textColor: Colors.black,
                        items: [
                          DropdownMenuItem(
                            enabled: false,
                            value: '0',
                            child: Text(
                              'Seleccione una opción',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          ...catalogDestiny.map(
                            (c) => DropdownMenuItem(
                              value: c.idDestiny.toString(),
                              child: Text(
                                c.name,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
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
                    ]
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kGrayBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.local_shipping, color: kNavy, size: 18),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tipo transporte'.toUpperCase(),
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 3),
                      GlowDropdownFormField2<String>(
                        value: vehicleSelected.toString(),
                        textColor: Colors.black,
                        items: [
                          DropdownMenuItem(
                            enabled: false,
                            value: '0',
                            child: Text(
                              'Seleccione una opción',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                          ...catalogVehicles.map(
                            (c) => DropdownMenuItem(
                              value: c.idVehicleType.toString(),
                              child: Text(
                                c.name,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                ),
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
                    ]
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: kGrayBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.message, color: kNavy, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Observaciones'.toUpperCase(),
                        style: const TextStyle(
                          color: kTextSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          
                        ),
                      ),
                      TextFormField(
                        controller: observationsCtrl,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Color.fromARGB(189, 233, 233, 233)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color.fromARGB(189, 233, 233, 233),
                              width: 1.5,
                            ),
                          ),
                        ),
                        validator: (v) {
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          const Divider(height: 0.5, thickness: 0.5, indent: 56, color: kGrayBorder),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: CameraImagePicker(
              minImages: 5,
              maxImages: 10,
              onImagesChanged: onImagesChanged,
            ),
          ),

          const SizedBox(height: 26),

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
            const SizedBox(height: 12,),
        ],
      ),
    );
  }
}

class _LogisticaFila extends StatelessWidget {
  final IconData icono;
  final String label;
  final String valor;
  final TextEditingController controllerTxt;

  const _LogisticaFila({required this.icono, required this.label, required this.valor, required this.controllerTxt});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: kGrayBg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icono, color: kNavy, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        color: kTextSecondary, fontSize: 11, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
                const SizedBox(height: 3),
                // Text(valor,
                //     style: const TextStyle(color: kTextPrimary, fontSize: 14, fontWeight: FontWeight.w500)),

                TextFormField(
                  controller: controllerTxt,
                  validator: (v) {
                    if (v == null || v.isEmpty) return messageValidatorEmpty;
                    return null;
                  },
                )
                
              ],
            ),
          ),
        ],
      ),
    );
  }
}