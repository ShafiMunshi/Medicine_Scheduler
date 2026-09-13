import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:medicine_app/constant/app_color.dart';
import 'package:medicine_app/models/adherence_summary.dart';
import 'package:medicine_app/viewmodels/schedule_viewmodel.dart';
import 'package:nb_utils/nb_utils.dart';

class MonthlyAdherenceChart extends ConsumerStatefulWidget {
  const MonthlyAdherenceChart({super.key});

  @override
  ConsumerState<MonthlyAdherenceChart> createState() =>
      _MonthlyAdherenceChartState();
}

class _MonthlyAdherenceChartState extends ConsumerState<MonthlyAdherenceChart> {
  int? _selectedDayIndex;

  @override
  Widget build(BuildContext context) {
    final selectedMonth = ref.watch(homeSelectedMonthProvider);
    final stats = ref.watch(monthlyAdherenceStatsProvider);
    final monthLabel = DateFormat('MMMM yyyy').format(selectedMonth);

    final selectedDaySummary = _selectedDayIndex != null &&
            _selectedDayIndex! >= 0 &&
            _selectedDayIndex! < stats.dailySummaries.length
        ? stats.dailySummaries[_selectedDayIndex!]
        : null;

    final now = DateTime.now();
    final year = selectedMonth.year;
    final month = selectedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstDayWeekday = DateTime(year, month, 1).weekday; // 1 = Mon, 7 = Sun
    final leadingEmptyDays = firstDayWeekday - 1;
    final totalSlots = leadingEmptyDays + daysInMonth;
    final numRows = ((totalSlots + 6) / 7).floor();

    return Column(
      children: [
        // Sleek Dark Calendar Card matching requested design
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          decoration: BoxDecoration(
            color: const Color(0xFF131722),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.18),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with < Month Year >
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildCircleNavButton(
                    icon: Icons.chevron_left,
                    onTap: () {
                      setState(() => _selectedDayIndex = null);
                      ref.read(homeSelectedMonthProvider.notifier).state =
                          DateTime(selectedMonth.year, selectedMonth.month - 1, 1);
                    },
                  ),
                  Text(
                    monthLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.3,
                    ),
                  ),
                  _buildCircleNavButton(
                    icon: Icons.chevron_right,
                    onTap: () {
                      setState(() => _selectedDayIndex = null);
                      ref.read(homeSelectedMonthProvider.notifier).state =
                          DateTime(selectedMonth.year, selectedMonth.month + 1, 1);
                    },
                  ),
                ],
              ),
              20.verticalSpace,

              // Weekday labels: Mon, Tue, Wed, Thu, Fri, Sat, Sun
              Row(
                children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                    .map(
                      (day) => Expanded(
                        child: Center(
                          child: Text(
                            day,
                            style: const TextStyle(
                              color: Color(0xFF8E95A5),
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
              14.verticalSpace,

              // Calendar Days Grid
              ...List.generate(numRows, (row) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: Row(
                    children: List.generate(7, (col) {
                      final slotIndex = row * 7 + col;
                      if (slotIndex < leadingEmptyDays || slotIndex >= totalSlots) {
                        return const Expanded(child: SizedBox());
                      }

                      final dayNum = slotIndex - leadingEmptyDays + 1;
                      final dayDate = DateTime(year, month, dayNum);
                      final isToday = dayDate.year == now.year &&
                          dayDate.month == now.month &&
                          dayDate.day == now.day;
                      final isSelected = _selectedDayIndex == (dayNum - 1);
                      final summary = (dayNum <= stats.dailySummaries.length)
                          ? stats.dailySummaries[dayNum - 1]
                          : null;

                      final isAllTaken = summary?.isAllTaken ?? false;
                      final missedCount = summary?.missedCount ?? 0;
                      final hasMissed = missedCount > 0;

                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = _selectedDayIndex == (dayNum - 1)
                                  ? null
                                  : (dayNum - 1);
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // 1. Above date text: Done icon if user took all medicine of that day
                                SizedBox(
                                  height: 12,
                                  child: isAllTaken
                                      ? const Icon(
                                          Iconsax.tick_circle,
                                          size: 12,
                                          color: Color(0xFF10B981),
                                        )
                                      : null,
                                ),
                                const SizedBox(height: 2),

                                // 2. Center: Date text (circle background if today / selected)
                                Container(
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF7C71F5)
                                        : isToday
                                            ? const Color(0xFF7C71F5).withValues(alpha: 0.35)
                                            : Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: isToday && !isSelected
                                        ? Border.all(
                                            color: const Color(0xFF7C71F5),
                                            width: 1.5,
                                          )
                                        : null,
                                  ),
                                  child: Text(
                                    '$dayNum',
                                    style: TextStyle(
                                      color: isSelected || isToday
                                          ? Colors.white
                                          : const Color(0xFFCBD5E1),
                                      fontSize: 12,
                                      fontWeight: isSelected || isToday
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),

                                // 3. Below date text: Shows how much medicine has been missed with meaningful icon
                                SizedBox(
                                  height: 11,
                                  child: hasMissed
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Iconsax.close_circle,
                                              size: 9,
                                              color: Color(0xFFEF4444),
                                            ),
                                            const SizedBox(width: 1.5),
                                            Text(
                                              '$missedCount',
                                              style: const TextStyle(
                                                fontSize: 9,
                                                color: Color(0xFFEF4444),
                                                fontWeight: FontWeight.bold,
                                                height: 1.0,
                                              ),
                                            ),
                                          ],
                                        )
                                      : null,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              }),

              14.verticalSpace,
              const Divider(color: Color(0xFF1E2333), height: 1),
              12.verticalSpace,

              // Legend indicators
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegend(
                    icon: Iconsax.tick_circle,
                    color: const Color(0xFF10B981),
                    label: 'All Taken',
                  ),
                  _buildLegend(
                    icon: Iconsax.close_circle,
                    color: const Color(0xFFEF4444),
                    label: 'Missed Doses',
                  ),
                  _buildLegendCircle(
                    color: const Color(0xFF7C71F5),
                    label: 'Today',
                  ),
                ],
              ),
            ],
          ),
        ),

        // Monthly KPI Summary Cards
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _buildKpiCard(
                label: 'All Taken',
                value: '${stats.perfectDaysCount} Days',
                icon: Iconsax.tick_circle,
                color: const Color(0xFF10B981),
              ),
              10.horizontalSpace,
              _buildKpiCard(
                label: 'Missed',
                value: '${stats.totalMissedDoses} Doses',
                icon: Iconsax.close_circle,
                color: const Color(0xFFEF4444),
              ),
              10.horizontalSpace,
              _buildKpiCard(
                label: 'Adherence',
                value: '${stats.adherencePercentage.toStringAsFixed(0)}%',
                icon: Iconsax.percentage_circle,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),

        // Interactive Selected Day Details
        if (selectedDaySummary != null) ...[
          12.verticalSpace,
          _buildDayDetailCard(selectedDaySummary),
        ],
      ],
    );
  }

  Widget _buildCircleNavButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        color: Color(0xFF1E2333),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        padding: EdgeInsets.zero,
        onPressed: onTap,
      ),
    );
  }

  Widget _buildLegend({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        6.horizontalSpace,
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8E95A5),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendCircle({
    required Color color,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        6.horizontalSpace,
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF8E95A5),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: color),
            6.verticalSpace,
            Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            2.verticalSpace,
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayDetailCard(DayAdherenceSummary summary) {
    final dateStr = DateFormat('EEEE, MMMM d, yyyy').format(summary.date);

    Color badgeColor;
    String badgeText;
    if (summary.hasNoSchedule) {
      badgeColor = Colors.grey;
      badgeText = 'No Schedule';
    } else if (summary.isAllTaken) {
      badgeColor = const Color(0xFF10B981);
      badgeText = 'All Taken (${summary.takenCount}/${summary.totalScheduled}) 🎉';
    } else if (summary.isMissed) {
      badgeColor = const Color(0xFFEF4444);
      badgeText = '${summary.missedCount} Missed (${summary.takenCount}/${summary.totalScheduled} Taken)';
    } else {
      badgeColor = Colors.orange;
      badgeText = '${summary.takenCount}/${summary.totalScheduled} Taken';
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  dateStr,
                  style: boldTextStyle(size: 13),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              8.horizontalSpace,
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          if (summary.scheduledMedicines.isNotEmpty) ...[
            12.verticalSpace,
            ...summary.scheduledMedicines.map((med) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 6.0),
                child: Row(
                  children: [
                    const Icon(Icons.medication, size: 16, color: AppColors.primaryColor),
                    8.horizontalSpace,
                    Expanded(
                      child: Text(
                        med.medicine.medicineName,
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Text(
                      '${med.schedules.length} dose(s)',
                      style: secondaryTextStyle(size: 11),
                    ),
                  ],
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}
