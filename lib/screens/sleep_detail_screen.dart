import 'package:flutter/material.dart';


class SleepDetailScreen extends StatefulWidget {
  const SleepDetailScreen({super.key});

  @override
  State<SleepDetailScreen> createState() => _SleepDetailScreenState();
}

class _SleepDetailScreenState extends State<SleepDetailScreen> {
  // TODO: 나중에 실제 데이터로 교체
  final int totalSleepDebtMinutes = 150;      // 2시간 30분 부족 예시
  final int recommendedSleepMinutes = 480;    // 8시간 추천 예시
  final List<_SleepRecordDemo> records = [
    _SleepRecordDemo(
      date: DateTime.now().subtract(const Duration(days: 1)),
      sleepMinutes: 360,
      targetMinutes: 420,
    ),
    _SleepRecordDemo(
      date: DateTime.now().subtract(const Duration(days: 2)),
      sleepMinutes: 420,
      targetMinutes: 420,
    ),
    _SleepRecordDemo(
      date: DateTime.now().subtract(const Duration(days: 3)),
      sleepMinutes: 300,
      targetMinutes: 420,
    ),
  ];

  // 알람 토글 상태 & 추천 기상 시간 (UI용)
  bool _alarmEnabled = false;
  final String _recommendedWakeTime = '07:30'; // 예시: 나중에 로직으로 계산 가능

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        title: const Text('수면 기록 & 수면빚'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          _buildSummaryCard(),
          const SizedBox(height: 16),
          _buildRecommendedCard(),
          const SizedBox(height: 16),
          // 🔔 여기 새로 들어간 "추천 기상 시간 알람" 카드
          _buildWakeAlarmCard(),
          const SizedBox(height: 24),
          const Text(
            '지난 수면 기록',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _buildRecordsCard(),
        ],
      ),
    );
  }

  // 상단 누적 수면빚 카드
  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _detailCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '누적 수면빚',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _formatMinutes(totalSleepDebtMinutes),
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: totalSleepDebtMinutes > 0
                  ? const Color(0xFFE57373)
                  : const Color(0xFF4CAF50),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            totalSleepDebtMinutes > 0
                ? '최근 며칠간 부족했던 수면 시간이에요.'
                : '수면빚이 거의 없어요. 잘 관리하고 있어요 👏',
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // 오늘 추천 수면시간 카드
  Widget _buildRecommendedCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _detailCardDecoration(),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF5C5CFF).withOpacity(0.12),
            ),
            child: const Icon(
              Icons.bedtime,
              color: Color(0xFF5C5CFF),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘 추천 수면 시간',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatMinutes(recommendedSleepMinutes),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '수면빚을 조금씩 줄일 수 있도록 권장하는 시간이에요.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 🔔 추천 기상시간 알람 카드 (새로 추가된 부분)
  Widget _buildWakeAlarmCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          colors: [
            const Color(0xFF5C6BC0).withOpacity(0.95), // 남색 계열
            const Color(0xFF42A5F5).withOpacity(0.9),  // 파랑 계열
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // 왼쪽: 아이콘 + 텍스트
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.alarm,
                      color: Colors.white,
                      size: 22,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '추천 기상 시간 알람',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.5),
                          width: 0.8,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.wb_sunny,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _recommendedWakeTime, // 예: 07:30
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        _alarmEnabled
                            ? '내일 아침 이 시간에 알람이 울려요.'
                            : '필요하면 이 시간에 맞춰 알람을 켤 수 있어요.',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // 오른쪽: 토글 스위치
          Switch(
            value: _alarmEnabled,
            activeColor: const Color(0xFFFFF59D),
            activeTrackColor: Colors.white.withOpacity(0.5),
            inactiveThumbColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            onChanged: (v) {
              setState(() {
                _alarmEnabled = v;
              });
              // TODO: 실제 알람 스케줄링 로직은 나중에 연결
            },
          ),
        ],
      ),
    );
  }

  // 지난 수면 기록 카드
  Widget _buildRecordsCard() {
    if (records.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: _detailCardDecoration(),
        child: const Text(
          '아직 기록된 수면 데이터가 없어요.',
          style: TextStyle(fontSize: 13, color: Colors.grey),
        ),
      );
    }

    return Container(
      decoration: _detailCardDecoration(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: records.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, index) {
          final r = records[index];
          final diff = r.sleepMinutes - r.targetMinutes;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _formatDate(r.date),
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '잠: ${_formatMinutes(r.sleepMinutes)} / 목표: ${_formatMinutes(r.targetMinutes)}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  diff == 0
                      ? '딱 맞게 잤어요'
                      : (diff > 0
                          ? '+${_formatMinutes(diff)}'
                          : _formatMinutes(diff)),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: diff < 0
                        ? const Color(0xFFE57373)
                        : const Color(0xFF4CAF50),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  BoxDecoration _detailCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  String _formatMinutes(int minutes) {
    final sign = minutes < 0 ? '-' : '';
    final absMin = minutes.abs();
    final h = absMin ~/ 60;
    final m = absMin % 60;
    if (h == 0) return '$sign${m}분';
    if (m == 0) return '$sign${h}시간';
    return '$sign${h}시간 ${m}분';
  }

  String _formatDate(DateTime date) {
    const week = ['일', '월', '화', '수', '목', '금', '토'];
    final w = week[date.weekday % 7];
    return '${date.month}/${date.day} ($w)';
  }
}

// 데모용 레코드 모델 (나중에 실제 모델로 교체 가능)
class _SleepRecordDemo {
  final DateTime date;
  final int sleepMinutes;
  final int targetMinutes;

  _SleepRecordDemo({
    required this.date,
    required this.sleepMinutes,
    required this.targetMinutes,
  });
}
