import 'package:flutter/material.dart';

import '../models/score_record.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

const List<String> _namaBulan = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'Mei',
  'Jun',
  'Jul',
  'Agu',
  'Sep',
  'Okt',
  'Nov',
  'Des',
];

/// Satu baris riwayat skor untuk halaman Skor.
class ScoreTile extends StatelessWidget {
  const ScoreTile({super.key, required this.record});

  final ScoreRecord record;

  String _formatDateTime(DateTime value) {
    final hari = value.day.toString().padLeft(2, '0');
    final bulan = _namaBulan[value.month - 1];
    final jam = value.hour.toString().padLeft(2, '0');
    final menit = value.minute.toString().padLeft(2, '0');
    return '$hari $bulan ${value.year} • $jam:$menit';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    final badgeSize = responsive.bodySize * 3.4;

    return Container(
      padding: EdgeInsets.all(responsive.pagePadding * 0.45),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(responsive.radius),
        border: Border.all(
          color: AppColors.border,
          width: responsive.shortestSide * 0.005,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: badgeSize,
            height: badgeSize,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.accent.withValues(alpha: 0.45),
                  width: responsive.shortestSide * 0.004,
                ),
              ),
              child: Center(
                child: Text(
                  '${record.percentage.round()}%',
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.9,
                    fontWeight: FontWeight.w400,
                    color: AppColors.accent,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: responsive.pagePadding * 0.45),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  record.categoryTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.bodySize,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: responsive.smallGap * 0.35),
                Text(
                  '${record.score}/${record.total} benar • ${record.playerName}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.78,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary,
                  ),
                ),
                SizedBox(height: responsive.smallGap * 0.25),
                Text(
                  _formatDateTime(record.dateTime),
                  style: TextStyle(
                    fontSize: responsive.bodySize * 0.7,
                    fontWeight: FontWeight.w300,
                    color: AppColors.textSecondary.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
