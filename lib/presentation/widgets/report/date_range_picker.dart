import 'package:flutter/material.dart';
import 'package:zentinel/config/theme/app_colors.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateRangePicker extends StatefulWidget {
  final DateTime? initialStart;
  final DateTime? initialEnd;
  final void Function(DateTime? start, DateTime? end)? onApply;

  const DateRangePicker({
    super.key,
    this.initialStart,
    this.initialEnd,
    this.onApply,
  });

  @override
  State<DateRangePicker> createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  DateTime? _start;
  DateTime? _end;

  @override
  void initState() {
    super.initState();
    _start = widget.initialStart;
    _end = widget.initialEnd;
  }

  String _formatRange() {
    if (_start == null) return 'Selecciona una fecha de inicio y fin';

    final f = DateFormat('dd MMM yyyy');

    if (_end == null) {
      return 'Del ${f.format(_start!)}, ...';
    }

    return 'Del ${f.format(_start!)}, al ${f.format(_end!)}';
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (args.value is PickerDateRange) {
      setState(() {
        _start = args.value.startDate;
        _end = args.value.endDate ?? args.value.startDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final double dayFontSize = theme.textTheme.bodyMedium?.fontSize ?? 14;

    final double headerFontSize = theme.textTheme.titleMedium?.fontSize ?? 16;

    final double rangeFontSize = theme.textTheme.bodySmall?.fontSize ?? 12;
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SfDateRangePicker(
                backgroundColor: Colors.transparent,
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                allowViewNavigation: false,
                monthViewSettings: const DateRangePickerMonthViewSettings(
                  firstDayOfWeek: 1,
                  viewHeaderStyle: DateRangePickerViewHeaderStyle(
                    textStyle: TextStyle(
                      color: Color.fromARGB(255, 48, 51, 51),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                startRangeSelectionColor: context.colors.focus,
                endRangeSelectionColor: context.colors.focus,
                rangeSelectionColor: const Color.fromARGB(255, 58, 199, 199),
                todayHighlightColor: context.colors.focus,

                monthCellStyle: DateRangePickerMonthCellStyle(
                  textStyle: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: dayFontSize,
                    fontFamily: theme.textTheme.bodyMedium?.fontFamily,
                  ),
                  todayTextStyle: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: dayFontSize,
                    fontWeight: FontWeight.bold,
                  ),
                  weekendTextStyle: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: dayFontSize,
                  ),
                ),

                headerStyle: DateRangePickerHeaderStyle(
                  textAlign: TextAlign.center,
                  backgroundColor: Colors.transparent,
                  textStyle: TextStyle(
                    color: context.colors.textPrimary,
                    fontSize: headerFontSize,
                    fontWeight: FontWeight.w600,
                    fontFamily: theme.textTheme.titleMedium?.fontFamily,
                  ),
                ),

                rangeTextStyle: TextStyle(
                  color: context.colors.textPrimary,
                  fontSize: rangeFontSize, // 👈 theme
                  fontFamily: theme.textTheme.bodySmall?.fontFamily,
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Text(
              _formatRange(),
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: context.colors.textPrimary,
              ),
            ),
            const SizedBox(height: 25),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: context.colors.focus,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  if (_start != null && _end != null) {
                    Navigator.of(
                      context,
                    ).pop(DateTimeRange(start: _start!, end: _end!));
                  } else {
                    Navigator.of(context).pop(null);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Aceptar',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: context.colors.textPrimary,
                  side: BorderSide(
                    color: context.colors.focus,
                    width: 1.5,
                  ),
                ),
                onPressed: () {
                  // Retorna un DateTimeRange especial para indicar "limpiar"
                  // Usamos una fecha especial (año 1969) como marcador
                  final clearMarker = DateTimeRange(
                    start: DateTime(1969, 1, 1),
                    end: DateTime(1969, 1, 1),
                  );
                  Navigator.of(context).pop(clearMarker);
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Limpiar',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
