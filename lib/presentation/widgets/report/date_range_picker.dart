import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

/// A visual-only date range picker widget resembling the provided design.
/// Usage: showModalBottomSheet(context: ..., builder: (_) => DateRangePicker(onApply: (start,end){...}));
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
  DateTime _now = DateTime.now();
  DateTime? _start;
  DateTime? _end;

  String _selectedDate = '';
  String _dateCount = '';
  String _range = '';
  String _rangeCount = '';

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
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
    return SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.78,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: SfDateRangePicker(
                onSelectionChanged: _onSelectionChanged,
                selectionMode: DateRangePickerSelectionMode.range,
                initialSelectedRange: PickerDateRange(
                  DateTime.now().subtract(const Duration(days: 4)),
                  DateTime.now().add(const Duration(days: 3)),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Text('Selecciona una fecha de inicio y fin', style: Theme.of(context).textTheme.titleMedium),
            // const SizedBox(height: 8),
            // _buildWeekdays(),
            // const SizedBox(height: 6),
            // Expanded(
            //   child: SingleChildScrollView(
            //     child: Column(
            //       children: [
            //         _buildMonth(firstMonth),
            //         _buildMonth(secondMonth),
            //         const SizedBox(height: 18),
            //       ],
            //     ),
            //   ),
            // ),
            const Divider(height: 1),
            const SizedBox(height: 8),
            Text(
              _formatRange(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFD400),
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  if (_start != null && _end != null) {
                    Navigator.of(context).pop(
                      DateTimeRange(
                        start: _start!,
                        end: _end!,
                      ),
                    );
                  } else {
                    Navigator.of(context).pop(null);
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  child: Text(
                    'Ver registros',
                    style: TextStyle(fontWeight: FontWeight.w700),
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
