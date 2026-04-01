
# Formulario de Confirmación de Recepción

Este módulo contiene widgets reutilizables para crear un formulario de confirmación de recepción de despachos.

## Archivos Creados

### 1. **dispatch_info_card.dart**
Widget reutilizable que muestra la información del despacho:
- ID del despacho
- Punto de origen
- Chofer asignado
- Estado del despacho con color indicador

**Uso:**
```dart
DispatchInfoCard(
  dispatchId: '#8892-X',
  origin: 'Central Hub',
  driver: 'Marcus V.',
  status: 'IN TRANSIT',
  statusColor: Color.fromARGB(255, 34, 197, 94),
)
```

### 2. **received_product_item.dart**
Widget extensible para mostrar cada producto a recibir con:
- Nombre del producto
- Estado (CORRECTO/DISCREPANCIA)
- Cantidad esperada
- Toggle para indicar discrepancia
- Campo slider para cantidad recibida (solo si hay discrepancia)
- Campo de comentario (solo si hay discrepancia)
- Botón para adjuntar evidencia fotográfica (solo si hay discrepancia)

**Uso:**
```dart
ReceivedProductItem(
  productName: 'Panel Solar XL-400',
  status: 'CORRECTO',
  expectedQty: 12,
  receivedQty: 12,
  hasDiscrepancy: false,
  onToggleChanged: (hasDiscrepancy) { },
  onReceivedQtyChanged: (qty) { },
  onCommentaryChanged: (comment) { },
  onPhotoPressed: () { },
)
```

### 3. **confirmation_header.dart**
Header reutilizable con:
- Botón de atrás
- Título personalizable

**Uso:**
```dart
ConfirmationHeader(
  title: 'Confirmar Recepción',
  onBackPressed: () => Navigator.pop(context),
)
```

### 4. **reception_confirmation_form.dart**
Formulario principal que integra todos los componentes:
- Manejo de estado de productos
- Validaciones
- Integración con API

**Modelos utilizados:**
- `ReceivedProduct`: Modelo de datos para cada producto
- `DispatchData`: Modelo para información del despacho

**Uso:**
```dart
ReceptionConfirmationForm(
  dispatchData: DispatchData(
    dispatchId: '#8892-X',
    origin: 'Central Hub',
    driver: 'Marcus V.',
    status: 'IN TRANSIT',
  ),
  products: [
    ReceivedProduct(
      id: '1',
      productName: 'Panel Solar XL-400',
      status: 'CORRECTO',
      expectedQty: 12,
      receivedQty: 12,
    ),
  ],
  onSubmit: (data) async {
    // Enviar datos al servidor
    return true;
  },
)
```

### 5. **reception_confirmation_screen.dart**
Pantalla de demostración que muestra cómo usar el formulario con datos de ejemplo.

## Características Principales

✅ **Widgets Reutilizables**: Cada componente está diseñado para ser independiente y reutilizable

✅ **Diseño Consistente**: Mantiene la paleta de colores y estilos del proyecto (tema oscuro)

✅ **Campos Condicionales**: Los campos de cantidad, comentario y fotos solo aparecen cuando hay discrepancias

✅ **Validaciones**: Validación de campos requeridos antes de enviar

✅ **Manejo de Estado**: Usa ConsumerStatefulWidget para gestionar el estado con Riverpod

✅ **Feedback Visual**: Animaciones suaves y retroalimentación visual (sliders, toggles, shadows with glow)

✅ **Responsive**: Diseño adaptativo para diferentes tamaños de pantalla

## Integración con el Proyecto

Los widgets están exportados en `lib/presentation/widgets/widgets.dart` para fácil importación:

```dart
import 'package:zentinel/presentation/widgets/widgets.dart';
```

## Próximas Mejoras

- Integración real con cámara para captura de fotos
- Almacenamiento de fotos en el servidor
- Historial de cambios y auditoría
- Soporte para múltiples idiomas
- Temas adaptables (claro/oscuro)
