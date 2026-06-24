import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:zentinel/domain/entities/api_response.dart';
import 'package:zentinel/presentation/providers/providers.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class PurchaseOrderForm extends ConsumerStatefulWidget {
  final Future<ApiResponse<dynamic>> Function(Map<String, dynamic>) onSubmit;
  const PurchaseOrderForm({super.key, required this.onSubmit});

  @override
  ConsumerState<PurchaseOrderForm> createState() => _PurchaseOrderFormState();
}

class _PurchaseOrderFormState extends ConsumerState<PurchaseOrderForm> {
  final _formKey = GlobalKey<FormState>();

  // Selecciones de combos
  String _typeOrder = '0';
  String _destinyId = '0';

  // Rango de fechas
  DateTime? _startDate;
  DateTime? _endDate;
  bool _dateError = false;

  bool isLoading = false;
  bool _isInitializing = true;

  // Controllers
  final _numberOrderCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  final _providerCtrl = TextEditingController();
  final _observationsCtrl = TextEditingController();

  // Focus nodes
  final FocusNode _typeOrderFocus = FocusNode();
  final FocusNode _destinyFocus = FocusNode();
  final FocusNode _numberOrderFocus = FocusNode();
  final FocusNode _quantityFocus = FocusNode();
  final FocusNode _providerFocus = FocusNode();
  final FocusNode _observationsFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await ref.read(getGroupBusinessByIdBusiness.notifier).load();

      if (!mounted) return;

      setState(() {
        _isInitializing = false;
      });
    });
  }

  @override
  void dispose() {
    _numberOrderCtrl.dispose();
    _quantityCtrl.dispose();
    _providerCtrl.dispose();
    _observationsCtrl.dispose();
    _typeOrderFocus.dispose();
    _destinyFocus.dispose();
    _numberOrderFocus.dispose();
    _quantityFocus.dispose();
    _providerFocus.dispose();
    _observationsFocus.dispose();
    super.dispose();
  }

  String _formatRange() {
    if (_startDate == null) return 'Selecciona el rango de fechas';
    final f = DateFormat('dd MMM yyyy');
    if (_endDate == null) return 'Del ${f.format(_startDate!)}, ...';
    return 'Del ${f.format(_startDate!)}, al ${f.format(_endDate!)}';
  }

  Future<void> _pickDateRange() async {
    FocusScope.of(context).unfocus();
    final range = await ModalHelper.open<DateTimeRange>(
      context,
      child: DateRangePicker(
        initialStart: _startDate,
        initialEnd: _endDate,
      ),
    );

    if (range == null) return;

    // El picker usa el año 1969 como marcador para "limpiar"
    final isClearMarker = range.start.year == 1969 && range.end.year == 1969;

    setState(() {
      if (isClearMarker) {
        _startDate = null;
        _endDate = null;
      } else {
        _startDate = range.start;
        _endDate = range.end;
        _dateError = false;
      }
    });
  }

  void _submit() async {
    if (isLoading) return;
    setState(() => isLoading = true);

    FocusScope.of(context).unfocus();

    final formValid = _formKey.currentState?.validate() ?? false;
    final datesValid = _startDate != null && _endDate != null;

    if (!datesValid) {
      setState(() => _dateError = true);
    }

    if (!formValid || !datesValid) {
      setState(() => isLoading = false);
      return;
    }

    final authState = ref.read(userSessionProvider);

    // Usuario no cargado o sesión inválida
    if (!authState.hasValue || authState.value == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Sesión no válida. Vuelva a iniciar sesión'),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    final userData = authState.value!;

    final data = {
      "start_date": _startDate!.toIso8601String(),
      "end_date": _endDate!.toIso8601String(),
      "type_order": _typeOrder.toUpperCase(),
      "destiny_id": int.tryParse(_destinyId),
      "number_order": _numberOrderCtrl.text.trim(),
      "quantity": int.tryParse(_quantityCtrl.text.trim()),
      "provider": _providerCtrl.text.trim(),
      "observations": _observationsCtrl.text.trim(),
      "user": userData.user,
    };

    GlobalLoadingBottomSheet.show(
      status: OverlayStatus.loading,
      message: "Guardando orden de compra...",
    );

    final response = await widget.onSubmit.call(data);
    if (!mounted) return;
    setState(() => isLoading = false);

    if (Navigator.canPop(context)) {
      context.pop();
    }

    if (response.success) {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.success,
        message: "Orden de compra guardada exitosamente",
        autoDismiss: const Duration(seconds: 2),
      );
    } else {
      GlobalLoadingBottomSheet.show(
        status: OverlayStatus.error,
        message:
            'Error: ${response.message ?? 'Error al guardar la orden de compra. Intente nuevamente.'}',
        autoDismiss: const Duration(seconds: 3),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final groupBusiness = ref.watch(getGroupBusinessByIdBusiness);

    const messageValidatorEmpty = 'Este campo es obligatorio';
    final fieldFill = const Color.fromARGB(255, 20, 21, 23);
    final borderRadius = BorderRadius.circular(8.0);

    InputDecoration styleDecoration() => InputDecoration(
      filled: true,
      fillColor: fieldFill,
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
      border: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Colors.white12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: borderRadius,
        borderSide: const BorderSide(color: Color.fromARGB(190, 58, 199, 199)),
      ),
    );

    if (_isInitializing) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 280,
                child: Text(
                  'Cargando formulario...',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
              ),
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        Expanded(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ─── Rango de fechas ───────────────────────────────────
                  const CustomFieldLabelRequired(txtLabel: 'Rango de fechas'),
                  InkWell(
                    borderRadius: borderRadius,
                    onTap: _pickDateRange,
                    child: InputDecorator(
                      decoration: styleDecoration().copyWith(
                        errorText: _dateError ? messageValidatorEmpty : null,
                        suffixIcon: const Icon(
                          Icons.calendar_today,
                          color: Color.fromARGB(190, 58, 199, 199),
                          size: 18,
                        ),
                      ),
                      child: Text(
                        _formatRange(),
                        style: TextStyle(
                          color: _startDate == null
                              ? Colors.white54
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),
                  // ─── Tipo de orden ─────────────────────────────────────
                  const CustomFieldLabelRequired(txtLabel: 'Tipo de orden'),
                  GlowDropdownFormField2<String>(
                    value: _typeOrder,
                    focusNode: _typeOrderFocus,
                    decoration: styleDecoration(),
                    items: const [
                      DropdownMenuItem(
                        enabled: false,
                        value: '0',
                        child: Text(
                          'Seleccione una opción',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Balanceado',
                        child: Text(
                          'Balanceado',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Combustible',
                        child: Text(
                          'Combustible',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _typeOrder = v);
                    },
                    validator: (v) {
                      if (v == '0' || v == null || v.trim().isEmpty) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  // ─── Destino ───────────────────────────────────────────
                  const CustomFieldLabelRequired(txtLabel: 'Destino'),
                  GlowDropdownFormField2<String>(
                    value: _destinyId,
                    focusNode: _destinyFocus,
                    decoration: styleDecoration(),
                    items: [
                      const DropdownMenuItem(
                        enabled: false,
                        value: '0',
                        child: Text(
                          'Seleccione una opción',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ...groupBusiness.map(
                        (g) => DropdownMenuItem(
                          value: g.idGroupBusiness.toString(),
                          child: Text(
                            g.name,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                    onChanged: (v) {
                      if (v != null) setState(() => _destinyId = v);
                    },
                    validator: (v) {
                      if (v == '0' || v == null || v.trim().isEmpty) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  // ─── Número de orden ───────────────────────────────────
                  const CustomFieldLabelRequired(txtLabel: 'Número de orden'),
                  GlowTextFormField(
                    controller: _numberOrderCtrl,
                    focusNode: _numberOrderFocus,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  // ─── Cantidad ──────────────────────────────────────────
                  const CustomFieldLabelRequired(txtLabel: 'Cantidad (Toneladas)'),
                  GlowTextFormField(
                    controller: _quantityCtrl,
                    focusNode: _quantityFocus,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  // ─── Proveedor ─────────────────────────────────────────
                  const CustomFieldLabelRequired(txtLabel: 'Proveedor'),
                  GlowTextFormField(
                    controller: _providerCtrl,
                    focusNode: _providerFocus,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return messageValidatorEmpty;
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 12),
                  // ─── Observaciones ─────────────────────────────────────
                  const CustomFieldLabelRequired(
                    txtLabel: 'Observaciones',
                    isRequired: false,
                  ),
                  GlowTextFormField(
                    controller: _observationsCtrl,
                    focusNode: _observationsFocus,
                    maxLines: 3,
                    validator: (v) {
                      return null;
                    },
                  ),

                  const SizedBox(height: 26),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => context.pop(),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white24),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          child: const Text(
                            'Cancelar',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            backgroundColor: const Color.fromARGB(
                              189,
                              7,
                              213,
                              213,
                            ),
                            disabledBackgroundColor: const Color.fromARGB(
                              120,
                              7,
                              213,
                              213,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (isLoading) ...[
                                const SizedBox(
                                  width: 14,
                                  height: 14,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 12),
                              ],
                              const Text(
                                'Guardar',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
