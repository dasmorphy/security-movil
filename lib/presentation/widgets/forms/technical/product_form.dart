import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

typedef ProductSubmitCallback =
    FutureOr<void> Function(Map<String, dynamic> payload);

/// Construye el contrato que consumirá el endpoint de productos.
///
/// Los campos opcionales vacíos se conservan con los valores neutros del
/// contrato recibido: cadena vacía para texto y cero para números.
Map<String, dynamic> buildProductPayload({
  required String createdBy,
  required Map<String, String> values,
  String? externalTransactionId,
}) {
  num numberValue(String key) {
    final normalized = (values[key] ?? '').trim().replaceAll(',', '.');
    final parsed = double.tryParse(normalized) ?? 0;
    return parsed == parsed.truncateToDouble() ? parsed.toInt() : parsed;
  }

  return {
    'base_price': numberValue('base_price'),
    'code': (values['code'] ?? '').trim(),
    'created_by': createdBy,
    'description': (values['description'] ?? '').trim(),
    'model': (values['model'] ?? '').trim(),
    'price': numberValue('price'),
    'product': (values['product'] ?? '').trim(),
    'profit_margin': numberValue('profit_margin'),
    'profit_margin_dollar': numberValue('profit_margin_dollar'),
    'provider': (values['provider'] ?? '').trim(),
    'stock': int.tryParse((values['stock'] ?? '').trim()) ?? 0,
    'unit': (values['unit'] ?? '').trim(),
  };
}

class ProductForm extends ConsumerStatefulWidget {
  final Future<ApiResponse> Function(Map<String, dynamic> data) onSubmit;

  const ProductForm({super.key, required this.onSubmit});

  @override
  ConsumerState<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends ConsumerState<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  final _productController = TextEditingController();
  final _codeController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _modelController = TextEditingController();
  final _providerController = TextEditingController();
  final _unitController = TextEditingController();
  final _stockController = TextEditingController();
  final _basePriceController = TextEditingController();
  final _priceController = TextEditingController();
  final _profitMarginController = TextEditingController();
  final _profitMarginDollarController = TextEditingController();

  final _productFocus = FocusNode();
  final _codeFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _modelFocus = FocusNode();
  final _providerFocus = FocusNode();
  final _unitFocus = FocusNode();
  final _stockFocus = FocusNode();
  final _basePriceFocus = FocusNode();
  final _priceFocus = FocusNode();
  final _profitMarginFocus = FocusNode();
  final _profitMarginDollarFocus = FocusNode();

  bool _isSubmitting = false;

  @override
  void dispose() {
    for (final controller in [
      _productController,
      _codeController,
      _descriptionController,
      _modelController,
      _providerController,
      _unitController,
      _stockController,
      _basePriceController,
      _priceController,
      _profitMarginController,
      _profitMarginDollarController,
    ]) {
      controller.dispose();
    }

    for (final focusNode in [
      _productFocus,
      _codeFocus,
      _descriptionFocus,
      _modelFocus,
      _providerFocus,
      _unitFocus,
      _stockFocus,
      _basePriceFocus,
      _priceFocus,
      _profitMarginFocus,
      _profitMarginDollarFocus,
    ]) {
      focusNode.dispose();
    }

    super.dispose();
  }

  String? _requiredProduct(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'El nombre del producto es obligatorio';
    }
    return null;
  }

  String? _optionalNumber(String? value, {double? maximum}) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final parsed = double.tryParse(text.replaceAll(',', '.'));
    if (parsed == null) return 'Ingrese un número válido';
    if (parsed < 0) return 'El valor no puede ser negativo';
    if (maximum != null && parsed > maximum) {
      return 'El valor no puede ser mayor a ${maximum.toInt()}';
    }
    return null;
  }

  String? _optionalStock(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;

    final parsed = int.tryParse(text);
    if (parsed == null) return 'Ingrese una cantidad entera válida';
    if (parsed < 0) return 'El stock no puede ser negativo';
    return null;
  }

  Map<String, dynamic> _payload(String createdBy) {
    return buildProductPayload(
      createdBy: createdBy,
      values: {
        'product': _productController.text,
        'code': _codeController.text,
        'description': _descriptionController.text,
        'model': _modelController.text,
        'provider': _providerController.text,
        'unit': _unitController.text,
        'stock': _stockController.text,
        'base_price': _basePriceController.text,
        'price': _priceController.text,
        'profit_margin': _profitMarginController.text,
        'profit_margin_dollar': _profitMarginDollarController.text,
      },
    );
  }

  Future<void> _submit() async {
    if (_isSubmitting) return;

    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final user = ref.read(userSessionProvider).value;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión no válida. Vuelva a iniciar sesión'),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final response = await widget.onSubmit(_payload(user.user));
      if (mounted) setState(() => _isSubmitting = false);
      if (response.success) {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.success, 
          message: "Despacho guardado exitosamente", 
          autoDismiss: const Duration(seconds: 2)
        );
        ref.read(getHistoryDispatch.notifier).load();
      } else {
        GlobalLoadingBottomSheet.show(
          status: OverlayStatus.error,
          message: 'Error: ${response.message ?? 'Error al guardar el producto.'}',
          autoDismiss: const Duration(seconds: 3),
        );
      }
    } catch (error) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message: 'Error al guardar el producto.',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }

  void _clear() {
    _formKey.currentState?.reset();
    for (final controller in [
      _productController,
      _codeController,
      _descriptionController,
      _modelController,
      _providerController,
      _unitController,
      _stockController,
      _basePriceController,
      _priceController,
      _profitMarginController,
      _profitMarginDollarController,
    ]) {
      controller.clear();
    }
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final session = ref.watch(userSessionProvider);
    final userName = session.value?.user;

    return Form(
      key: _formKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 700 ? 32.0 : 16.0;
          final contentWidth = constraints.maxWidth - (horizontalPadding * 2);
          final fieldWidth = contentWidth >= 680
              ? (contentWidth - 16) / 2
              : contentWidth;

          return SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: EdgeInsets.fromLTRB(
              horizontalPadding,
              20,
              horizontalPadding,
              32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _FormIntroduction(),
                const SizedBox(height: 20),
                _ProductSection(
                  title: 'Información general',
                  subtitle: 'Identificación y descripción del producto',
                  icon: Icons.inventory_2_outlined,
                  children: [
                    _FormField(
                      width: fieldWidth,
                      label: 'Producto',
                      isRequired: true,
                      controller: _productController,
                      focusNode: _productFocus,
                      hint: 'Ej. Cable UTP categoria 6',
                      textInputAction: TextInputAction.next,
                      validator: _requiredProduct,
                    ),
                    _FormField(
                      width: fieldWidth,
                      label: 'Código',
                      controller: _codeController,
                      focusNode: _codeFocus,
                      hint: 'Ej. UTP-CAT6-305',
                      textInputAction: TextInputAction.next,
                    ),
                    _FormField(
                      width: fieldWidth,
                      label: 'Modelo',
                      controller: _modelController,
                      focusNode: _modelFocus,
                      hint: 'Modelo o referencia',
                      textInputAction: TextInputAction.next,
                    ),
                    _FormField(
                      width: fieldWidth,
                      label: 'Proveedor',
                      controller: _providerController,
                      focusNode: _providerFocus,
                      hint: 'Nombre del proveedor',
                      textInputAction: TextInputAction.next,
                    ),
                    _FormField(
                      width: contentWidth,
                      label: 'Descripción',
                      controller: _descriptionController,
                      focusNode: _descriptionFocus,
                      hint: 'Detalles, especificaciones o notas del producto',
                      maxLines: 3,
                      maxLength: 500,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ProductSection(
                  title: 'Inventario',
                  subtitle: 'Unidad de medida y existencia inicial',
                  icon: Icons.warehouse_outlined,
                  children: [
                    _FormField(
                      width: fieldWidth,
                      label: 'Unidad',
                      controller: _unitController,
                      focusNode: _unitFocus,
                      hint: 'Ej. unidad, metro, caja',
                      textInputAction: TextInputAction.next,
                    ),
                    _FormField(
                      width: fieldWidth,
                      label: 'Stock',
                      controller: _stockController,
                      focusNode: _stockFocus,
                      hint: '0',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      textInputAction: TextInputAction.next,
                      validator: _optionalStock,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _ProductSection(
                  title: 'Precios y rentabilidad',
                  subtitle: 'Valores monetarios y márgenes del producto',
                  icon: Icons.payments_outlined,
                  children: [
                    _FormField(
                      width: fieldWidth,
                      label: 'Precio base',
                      controller: _basePriceController,
                      focusNode: _basePriceFocus,
                      hint: '0.00',
                      prefixText: r'$ ',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: _optionalNumber,
                    ),
                    _FormField(
                      width: fieldWidth,
                      label: 'Precio de venta',
                      controller: _priceController,
                      focusNode: _priceFocus,
                      hint: '0.00',
                      prefixText: r'$ ',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: _optionalNumber,
                    ),
                    _FormField(
                      width: fieldWidth,
                      label: 'Margen de ganancia',
                      controller: _profitMarginController,
                      focusNode: _profitMarginFocus,
                      hint: '0.00',
                      suffixText: ' %',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) =>
                          _optionalNumber(value, maximum: 100),
                    ),
                    _FormField(
                      width: fieldWidth,
                      label: 'Ganancia en dólares',
                      controller: _profitMarginDollarController,
                      focusNode: _profitMarginDollarFocus,
                      hint: '0.00',
                      prefixText: r'$ ',
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      textInputAction: TextInputAction.done,
                      validator: _optionalNumber,
                      onFieldSubmitted: (_) => _submit(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _FormActions(
                  enabled: userName != null,
                  loading: _isSubmitting,
                  onClear: _clear,
                  onSubmit: _submit,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _FormIntroduction extends StatelessWidget {
  const _FormIntroduction();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Completa la información disponible. Solo el producto es obligatorio.',
          style: TextStyle(color: Colors.white60, height: 1.4),
        ),
      ],
    );
  }
}

class _ProductSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final List<Widget> children;

  const _ProductSection({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 29, 30, 35),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(
                    255,
                    58,
                    199,
                    199,
                  ).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  color: const Color.fromARGB(255, 58, 199, 199),
                  size: 21,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Colors.white54,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(spacing: 16, runSpacing: 16, children: children),
        ],
      ),
    );
  }
}

class _FormField extends StatelessWidget {
  final double width;
  final String label;
  final bool isRequired;
  final TextEditingController controller;
  final FocusNode focusNode;
  final String hint;
  final int maxLines;
  final int? maxLength;
  final String? prefixText;
  final String? suffixText;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const _FormField({
    required this.width,
    required this.label,
    this.isRequired = false,
    required this.controller,
    required this.focusNode,
    required this.hint,
    this.maxLines = 1,
    this.maxLength,
    this.prefixText,
    this.suffixText,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.inputFormatters,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomFieldLabelRequired(txtLabel: label, isRequired: isRequired),
          TextFormField(
            controller: controller,
            focusNode: focusNode,
            maxLines: maxLines,
            maxLength: maxLength,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            inputFormatters: inputFormatters,
            validator: validator,
            onFieldSubmitted: onFieldSubmitted,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.white30),
              prefixText: prefixText,
              suffixText: suffixText,
              prefixStyle: const TextStyle(color: Colors.white70),
              suffixStyle: const TextStyle(color: Colors.white70),
              counterStyle: const TextStyle(color: Colors.white38),
              filled: true,
              fillColor: const Color.fromARGB(255, 20, 21, 23),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white12),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.white12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                  color: Color.fromARGB(255, 58, 199, 199),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Colors.redAccent),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormActions extends StatelessWidget {
  final bool enabled;
  final bool loading;
  final VoidCallback onClear;
  final VoidCallback onSubmit;

  const _FormActions({
    required this.enabled,
    required this.loading,
    required this.onClear,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: enabled && !loading ? onSubmit : null,
            icon: loading
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const SizedBox(),
            label: Text(loading ? 'Guardando...' : 'Guardar'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: const Color.fromARGB(255, 14, 170, 170),
              disabledBackgroundColor: const Color.fromARGB(90, 14, 170, 170),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
