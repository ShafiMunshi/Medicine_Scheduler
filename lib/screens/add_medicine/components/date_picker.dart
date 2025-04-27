import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart'; // Import for date formatting

/// A calendar widget that allows selection of multiple dates.
class MultiDatePicker extends StatefulWidget {
  /// Callback function when dates are chosen or changed.
  /// Returns a list of selected non-null dates.
  final ValueChanged<List<DateTime>> onDatesSelected;

  /// Optional list of initial dates to be selected.
  final List<DateTime>? initialDates;

  /// Optional first selectable date.
  final DateTime? firstDate;

  /// Optional last selectable date.
  final DateTime? lastDate;

  const MultiDatePicker({
    super.key,
    required this.onDatesSelected,
    this.initialDates,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<MultiDatePicker> createState() => _MultiDatePickerState();
}

class _MultiDatePickerState extends State<MultiDatePicker> {
  // Store potentially null DateTime objects from the picker,
  // but the callback will only return non-null ones.
  List<DateTime?> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    // Set initial selection if provided
    if (widget.initialDates != null) {
      // Normalize dates to midnight for consistency
      _selectedDates = widget.initialDates!
          .map((date) => DateUtils.dateOnly(date))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      // *** Key Change: Set calendar type to multi ***
      calendarType: CalendarDatePicker2Type.multi,

      // Pass firstDate and lastDate if provided by the parent widget
      firstDate: widget.firstDate,
      lastDate: widget.lastDate,
      currentDate: DateTime.now(), // Good practice to set the current date

      // --- Optional Styling (can be kept or adjusted) ---
      selectedDayHighlightColor: Theme.of(context).primaryColor,
      weekdayLabels: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
      weekdayLabelTextStyle: TextStyle(
        color: Colors.grey[700],
        fontWeight: FontWeight.bold,
      ),
      controlsTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
      ),
      dayTextStyle: const TextStyle(
          // Style for regular, selectable days
          ),
      selectedDayTextStyle: TextStyle(
        // Style for the selected days
        color: Theme.of(context).colorScheme.onPrimary,
        fontWeight: FontWeight.bold,
      ),
      disabledDayTextStyle: TextStyle(
        // Style for days outside firstDate/lastDate range
        color: Colors.grey[400],
      ),
      // --- End Optional Styling ---
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CalendarDatePicker2(
          config: config,
          value: _selectedDates, // Pass the current list of selected dates
          onValueChanged: (dates) {
            // Callback is triggered when any date is selected or deselected
            setState(() {
              // Update the state with the new list of selected dates from the picker
              _selectedDates = dates;
            });
            // Notify the parent widget with only the non-null dates
            // The picker returns List<DateTime?>, filter out nulls before calling back
            final nonNullDates = dates.whereType<DateTime>().toList();
            widget.onDatesSelected(nonNullDates);
          },
        ),
        const SizedBox(height: 16),
        // Display the selected dates for feedback (optional)
        _buildSelectedDatesFeedback(context),
      ],
    );
  }

  // Helper widget to display selected dates feedback
  Widget _buildSelectedDatesFeedback(BuildContext context) {
    final nonNullSelectedDates = _selectedDates.whereType<DateTime>().toList();
    nonNullSelectedDates.sort(); // Sort dates for consistent display

    String displayText;
    if (nonNullSelectedDates.isEmpty) {
      displayText = '';
    } else if (nonNullSelectedDates.length == 1) {
      displayText =
          'Repeat Every ${DateFormat.yMd().format(nonNullSelectedDates.first)}';
    } else {
      displayText = 'Repeat at every ${nonNullSelectedDates.length} dates';
      // Optionally, you could list them all if space permits:
      // displayText = 'Selected: ${nonNullSelectedDates.map((d) => DateFormat.yMd().format(d)).join(', ')}';
    }

    return Text(
      displayText,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }
}
