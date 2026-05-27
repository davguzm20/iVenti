import 'package:flutter/material.dart';

class DateRangePickerWidget extends StatelessWidget {
  final DateTime startDate;
  final DateTime endDate;
  final Function(DateTime) onStartDateChanged;
  final Function(DateTime) onEndDateChanged;

  const DateRangePickerWidget({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
  });

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: isStart ? startDate : endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      if (isStart) {
        onStartDateChanged(picked);
      } else {
        onEndDateChanged(picked);
      }
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                "Inicio: ${_formatDate(startDate)}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () => _pickDate(context, true),
              child: const Text("Seleccionar"),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Text(
                "Final: ${_formatDate(endDate)}",
                style: const TextStyle(fontSize: 14),
              ),
            ),
            TextButton(
              onPressed: () => _pickDate(context, false),
              child: const Text("Seleccionar"),
            ),
          ],
        ),
      ],
    );
  }
}