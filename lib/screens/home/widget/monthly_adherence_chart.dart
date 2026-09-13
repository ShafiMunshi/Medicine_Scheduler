import 'package:fl_chart/fl_chart.dart';
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
  ConsumerState<MonthlyAdherenceChart> createState() => _MonthlyAdherenceChartState();
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

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with Month Selector
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Iconsax.chart_2, size: 18, color: AppColors.primaryColor),
                    ),
                    8.horizontalSpace,
                    Flexible(
                      child: Text(
                        'Monthly Adherence',
                        style: boldTextStyle(size: 16),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left, size: 20, color: AppColors.primaryColor),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() => _selectedDayIndex = null);
                      ref.read(homeSelectedMonthProvider.notifier).state =
                          DateTime(selectedMonth.year, selectedMonth.month - 1, 1);
                    },
                  ),
                  8.horizontalSpace,
                  Text(
                    monthLabel,
                    style: boldTextStyle(size: 13, color: AppColors.primaryColor),
                  ),
                  8.horizontalSpace,
                  IconButton(
                    icon: const Icon(Icons.chevron_right, size: 20, color: AppColors.primaryColor),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    onPressed: () {
                      setState(() => _selectedDayIndex = null);
                      ref.read(homeSelectedMonthProvider.notifier).state =
                          DateTime(selectedMonth.year, selectedMonth.month + 1, 1);
                    },
                  ),
                ],
              ),
            ],
          ),
          14.verticalSpace,

          // KPI Summary Chips
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildKpiChip(
                icon: Iconsax.tick_circle,
                label: '${stats.perfectDaysCount} Days All Taken',
                color: const Color(0xFF10B981),
              ),
              _buildKpiChip(
                icon: Iconsax.close_circle,
                label: '${stats.totalMissedDoses} Missed (${stats.missedDaysCount} Days)',
                color: const Color(0xFFEF4444),
              ),
              _buildKpiChip(
                icon: Iconsax.percentage_circle,
                label: '${stats.adherencePercentage.toStringAsFixed(0)}% Adherence',
                color: AppColors.primaryColor,
              ),
            ],
          ),
          16.verticalSpace,

          // Bar Chart Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildLegendIndicator(color: const Color(0xFF10B981), label: 'Taken'),
              14.horizontalSpace,
              _buildLegendIndicator(color: const Color(0xFFEF4444), label: 'Missed'),
            ],
          ),
          10.verticalSpace,

          // Bar Chart
          SizedBox(
            height: 180,
            child: stats.dailySummaries.isEmpty
                ? const Center(child: Text('No data for this month', style: TextStyle(color: Colors.grey)))
                : BarChart(
                    BarChartData(
                      alignment: BarChartAlignment.spaceAround,
                      maxY: _calculateMaxY(stats.dailySummaries),
                      barTouchData: BarTouchData(
                        enabled: true,
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => const Color(0xFF1E293B),
                          getTooltipItem: (group, groupIndex, rod, rodIndex) {
                            if (groupIndex >= stats.dailySummaries.length) return null;
                            final day = stats.dailySummaries[groupIndex];
                            final dateStr = DateFormat('d MMM').format(day.date);
                            final status = day.hasNoSchedule
                                ? 'No Schedule'
                                : day.isAllTaken
                                    ? 'All Taken ✓'
                                    : '${day.takenCount} Taken, ${day.missedCount} Missed';
                            return BarTooltipItem(
                              '$dateStr\n$status',
                              const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            );
                          },
                        ),
                        touchCallback: (event, response) {
                          if (event is FlTapUpEvent && response?.spot != null) {
                            setState(() {
                              _selectedDayIndex = response!.spot!.touchedBarGroupIndex;
                            });
                          }
                        },
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              if (value % 2 != 0 && value != 0) return const SizedBox();
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(color: Colors.grey, fontSize: 10),
                              );
                            },
                          ),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 22,
                            getTitlesWidget: (value, meta) {
                              final dayNum = value.toInt() + 1;
                              // Show every 5 days to avoid clutter
                              if (dayNum == 1 || dayNum % 5 == 0 || dayNum == stats.totalDaysInMonth) {
                                return Text(
                                  dayNum.toString(),
                                  style: const TextStyle(color: Colors.grey, fontSize: 10),
                                );
                              }
                              return const SizedBox();
                            },
                          ),
                        ),
                      ),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(
                          color: const Color(0xFFF1F5F9),
                          strokeWidth: 1,
                        ),
                      ),
                      borderData: FlBorderData(show: false),
                      barGroups: List.generate(stats.dailySummaries.length, (index) {
                        final summary = stats.dailySummaries[index];
                        final isSelected = _selectedDayIndex == index;

                        return BarChartGroupData(
                          x: index,
                          barRods: [
                            // Taken Bar (Green)
                            BarChartRodData(
                              toY: summary.takenCount.toDouble(),
                              color: isSelected
                                  ? const Color(0xFF059669)
                                  : const Color(0xFF10B981),
                              width: 4,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                            ),
                            // Missed Bar (Red)
                            BarChartRodData(
                              toY: summary.missedCount.toDouble(),
                              color: isSelected
                                  ? const Color(0xFFDC2626)
                                  : const Color(0xFFEF4444),
                              width: 4,
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(3)),
                            ),
                          ],
                        );
                      }),
                    ),
                  ),
          ),
          12.verticalSpace,

          // Day Breakdown Card (when a bar is tapped)
          if (selectedDaySummary != null)
            _buildSelectedDayCard(selectedDaySummary)
          else
            Center(
              child: Text(
                'Tap any bar in the chart to inspect that day\'s intake',
                style: secondaryTextStyle(size: 11),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildKpiChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          6.horizontalSpace,
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendIndicator({required Color color, required String label}) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)),
        ),
        5.horizontalSpace,
        Text(label, style: secondaryTextStyle(size: 11)),
      ],
    );
  }

  Widget _buildSelectedDayCard(DayAdherenceSummary summary) {
    final dateFormatted = DateFormat('EEEE, d MMMM yyyy').format(summary.date);

    Color statusColor;
    String statusText;
    IconData statusIcon;

    if (summary.hasNoSchedule) {
      statusColor = Colors.grey;
      statusText = 'No medications scheduled';
      statusIcon = Iconsax.info_circle;
    } else if (summary.isAllTaken) {
      statusColor = const Color(0xFF10B981);
      statusText = 'All scheduled medicines taken ✓';
      statusIcon = Iconsax.tick_circle;
    } else if (summary.isMissed) {
      statusColor = const Color(0xFFEF4444);
      statusText = '${summary.missedCount} dose${summary.missedCount > 1 ? 's' : ''} missed!';
      statusIcon = Iconsax.close_circle;
    } else {
      statusColor = AppColors.primaryColor;
      statusText = '${summary.takenCount}/${summary.totalScheduled} doses taken';
      statusIcon = Iconsax.clock;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(dateFormatted, style: boldTextStyle(size: 12, color: const Color(0xFF334155))),
              Row(
                children: [
                  Icon(statusIcon, size: 14, color: statusColor),
                  4.horizontalSpace,
                  Text(statusText, style: boldTextStyle(size: 11, color: statusColor)),
                ],
              ),
            ],
          ),
          if (summary.scheduledMedicines.isNotEmpty) ...[
            8.verticalSpace,
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: summary.scheduledMedicines.map((med) {
                final isMedTaken = summary.logs.any((l) => l.medicineId == med.medicine.id && l.status == 'taken');
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isMedTaken ? const Color(0xFFDCFCE7) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${med.medicine.medicineName} (${isMedTaken ? "Taken" : "Missed"})',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: isMedTaken ? const Color(0xFF166534) : const Color(0xFF991B1B),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  double _calculateMaxY(List<DayAdherenceSummary> summaries) {
    int maxDose = 2;
    for (final s in summaries) {
      if (s.totalScheduled > maxDose) maxDose = s.totalScheduled;
      if (s.takenCount > maxDose) maxDose = s.takenCount;
      if (s.missedCount > maxDose) maxDose = s.missedCount;
    }
    return (maxDose + 1).toDouble();
  }
}
