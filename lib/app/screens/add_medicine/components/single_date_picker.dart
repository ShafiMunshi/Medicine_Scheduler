import 'package:flutter/material.dart';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:intl/intl.dart'; // Import for date formatting

/// A calendar widget that allows selection of a single date.
class SingleDatePicker extends StatefulWidget {
  /// Callback function when a date is chosen or changed.
  /// Returns the selected non-null date, or null if deselected.
  final ValueChanged<DateTime?> onDateSelected;

  /// Optional initial date to be selected.
  final DateTime? initialDate;

  /// Optional first selectable date.
  final DateTime? firstDate;

  /// Optional last selectable date.
  final DateTime? lastDate;

  const SingleDatePicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    this.firstDate,
    this.lastDate,
  });

  @override
  State<SingleDatePicker> createState() => _SingleDatePickerState();
}

class _SingleDatePickerState extends State<SingleDatePicker> {
  // Store the selected date. The picker uses a list, so we'll manage it as a list of 0 or 1 item.
  List<DateTime?> _selectedDates = [];

  @override
  void initState() {
    super.initState();
    // Set initial selection if provided
    if (widget.initialDate != null) {
      // Normalize date to midnight for consistency
      _selectedDates = [DateUtils.dateOnly(widget.initialDate!)];
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = CalendarDatePicker2Config(
      // *** Key Change: Set calendar type to single ***
      calendarType: CalendarDatePicker2Type.single,

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
        // Style for the selected day
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
          value: _selectedDates, // Pass the current list (max 1 item)
          onValueChanged: (dates) {
            // Callback is triggered when a date is selected or deselected
            setState(() {
              // Update the state with the new list (will contain 0 or 1 item)
              _selectedDates = dates;
            });
            // Notify the parent widget with the single selected date (or null)
            // The picker returns List<DateTime?>, get the first element or null
            widget.onDateSelected(dates.isNotEmpty ? dates[0] : null);
          },
        ),
        const SizedBox(height: 16),
        // Display the selected date for feedback (optional)
        _buildSelectedDateFeedback(context),
      ],
    );
  }

  // Helper widget to display selected date feedback
  Widget _buildSelectedDateFeedback(BuildContext context) {
    // Get the first date from the list, or null if empty
    final selectedDate = _selectedDates.isNotEmpty ? _selectedDates[0] : null;

    String displayText;
    if (selectedDate == null) {
      displayText = 'Selected: None';
    } else {
      // Use DateFormat for better formatting
      displayText = 'Selected: ${DateFormat.yMd().format(selectedDate)}';
    }

    return Text(
      displayText,
      style: Theme.of(context).textTheme.titleMedium,
      textAlign: TextAlign.center,
    );
  }
}
