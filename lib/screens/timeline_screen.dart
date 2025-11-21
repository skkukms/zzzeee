import 'package:flutter/material.dart';
import 'settings_screen.dart';
import 'sleep_detail_screen.dart';
import 'caffeine_detail_screen.dart';

class TimelineScreen extends StatefulWidget {
  const TimelineScreen({super.key});

  static const routeName = '/timeline';

  @override
  State<TimelineScreen> createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen> {
  bool _fabExpanded = false;

  static const double _hourHeight = 64; // 한 시간 블록 높이
  static const int _startHour = 8;
  static const int _endHour = 24;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final dateText =
        '${today.month}월 ${today.day}일 ${_weekdayKo(today.weekday)}';

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      body: SafeArea(
        child: Column(
          children: [
            // 상단 날짜 + 설정 아이콘
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text(
                    dateText,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.settings_outlined),
                    onPressed: () {
                      Navigator.pushNamed(context, SettingsScreen.routeName);
                    },
                  )
                ],
              ),
            ),

            // 수면 빚 카드 (탭하면 상세 화면으로 이동)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _SleepDebtCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SleepDetailScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // 카페인 가이드 카드
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: _CaffeineSummaryCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CaffeineDetailScreen(),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // 타임라인 영역
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _TimelineView(),
              ),
            ),
          ],
        ),
      ),

      // 플로팅 액션 버튼 (수면/카페인 기록하기)
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewPadding.bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset + 8, right: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (_fabExpanded)
            Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: SizedBox(
                width: 280,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _FabMenuItem(
                        icon: Icons.bedtime,
                        text: '수면 기록하기',
                        onTap: () {
                          _closeFab();
                          _openLogSheet(context, 'sleep');
                        },
                      ),
                      const Divider(height: 1),
                      _FabMenuItem(
                        icon: Icons.local_cafe,
                        text: '카페인 기록하기',
                        onTap: () {
                          _closeFab();
                          _openLogSheet(context, 'caffeine');
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 오른쪽 아래 둥근 보라색 버튼 (X / + 토글)
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF5C5CFF).withOpacity(0.35),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: FloatingActionButton(
              elevation: 0,
              backgroundColor: const Color(0xFF5C5CFF),
              foregroundColor: Colors.white,
              onPressed: () {
                setState(() {
                  _fabExpanded = !_fabExpanded;
                });
              },
              child: Icon(
                _fabExpanded ? Icons.close : Icons.add,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _closeFab() {
    setState(() {
      _fabExpanded = false;
    });
  }

  // 수면/카페인 기록용 바텀시트
  void _openLogSheet(BuildContext context, String type) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.55,
          maxChildSize: 0.9,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                padding: EdgeInsets.only(
                  left: 20,
                  right: 20,
                  top: 20,
                  bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
                ),
                child: type == 'sleep'
                    ? const _SleepLogSheet()
                    : const _CaffeineLogSheet(),
              ),
            );
          },
        );
      },
    );
  }

  Widget _TimelineView() {
    const int hours = _endHour - _startHour;

    return SingleChildScrollView(
      child: SizedBox(
        height: hours * _hourHeight + 64,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 왼쪽 시간 레이블
            SizedBox(
              width: 56,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(hours + 1, (index) {
                  final hour = _startHour + index;
                  return SizedBox(
                    height: _hourHeight,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: Text(
                        '${hour.toString().padLeft(2, '0')}:00',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 12),

            // 오른쪽 타임라인 영역 (그리드 + 블록)
            Expanded(
              child: Stack(
                children: [
                  // 시간 그리드 배경
                  Column(
                    children: List.generate(hours, (index) {
                      return Container(
                        height: _hourHeight,
                        decoration: BoxDecoration(
                          border: Border(
                            top: BorderSide(
                              color: Colors.grey.shade300,
                              width: 0.7,
                            ),
                          ),
                        ),
                      );
                    }),
                  ),

                  // 일정 블록들
                  _TimelineEventBlock(
                    startHour: 9,
                    endHour: 12,
                    title: '오전 수업',
                    type: '일정',
                    color: const Color(0xFFB0B5C3),
                  ),
                  _TimelineEventBlock(
                    startHour: 13,
                    endHour: 14,
                    title: '점심 시간',
                    type: '일정',
                    color: const Color(0xFFB0B5C3),
                  ),
                  _TimelineEventBlock(
                    startHour: 14,
                    endHour: 15,
                    title: '휴식 수면',
                    type: '일정',
                    color: const Color(0xFF7ED3A5),
                    showIcon: true,
                    icon: Icons.refresh,
                  ),
                  _TimelineEventBlock(
                    startHour: 15,
                    endHour: 17,
                    title: '집중 시간대',
                    type: '일정',
                    color: const Color(0xFFF6D26D),
                    showIcon: true,
                    icon: Icons.check_circle_outline,
                  ),
                  _TimelineEventBlock(
                    startHour: 19,
                    endHour: 21,
                    title: '저녁 수업',
                    type: '일정',
                    color: const Color(0xFFB0B5C3),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _weekdayKo(int weekday) {
    const names = ['월요일', '화요일', '수요일', '목요일', '금요일', '토요일', '일요일'];
    return names[(weekday - 1) % 7];
  }
}

// ===== 카드 위젯들 =====

class _SleepDebtCard extends StatelessWidget {
  final VoidCallback? onTap;

  const _SleepDebtCard({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 140,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xFFB39DFF),
                Color(0xFF8C9EFF),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // 왼쪽: 텍스트/그래프
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 12, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '수면 빚',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '-2.5h',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '오늘의 컨디션 예상',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: List.generate(10, (i) {
                              final heights = [6, 10, 14, 18, 20, 18, 14, 10, 8, 5];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: Container(
                                  width: 6,
                                  height: heights[i].toDouble(),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              // 오른쪽: 원형 아이콘
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.bedtime,
                      size: 32,
                      color: Color(0xFF5C5CFF),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CaffeineSummaryCard extends StatelessWidget {
  final VoidCallback? onTap;

  const _CaffeineSummaryCard({Key? key, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onTap,
        child: Container(
          height: 96,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              colors: [
                Color(0xFF42A5F5),
                Color(0xFF5C6BC0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.10),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.18),
                ),
                child: const Icon(
                  Icons.local_cafe,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '오늘의 카페인 가이드',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '언제까지 마셔도 되는지\n간단한 권장량과 시간대를 알려줄게요.',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16),
                child: Icon(
                  Icons.chevron_right,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== 타임라인 블록 & FAB 메뉴 =====

class _TimelineEventBlock extends StatelessWidget {
  final int startHour;
  final int endHour;
  final String title;
  final String type;
  final Color color;
  final bool showIcon;
  final IconData? icon;

  const _TimelineEventBlock({
    required this.startHour,
    required this.endHour,
    required this.title,
    required this.type,
    required this.color,
    this.showIcon = false,
    this.icon,
  });

  static const double _hourHeight = _TimelineScreenState._hourHeight;
  static const int _startHourBase = _TimelineScreenState._startHour;

  @override
  Widget build(BuildContext context) {
    final double top = (startHour - _startHourBase) * _hourHeight;
    double height = (endHour - startHour) * _hourHeight;

    if (height < 72) height = 72;

    return Positioned(
      top: top + 4,
      left: 0,
      right: 0,
      child: Container(
        height: height,
        margin: const EdgeInsets.only(right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.9),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '일정',
              style: TextStyle(
                fontSize: 11,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (showIcon && icon != null)
                  Icon(
                    icon,
                    size: 18,
                    color: Colors.white,
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FabMenuItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const _FabMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFF5C5CFF).withOpacity(0.12),
              child: Icon(
                icon,
                size: 18,
                color: const Color(0xFF5C5CFF),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              text,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 바텀시트: 수면 기록 =====

class _SleepLogSheet extends StatefulWidget {
  const _SleepLogSheet({super.key});

  @override
  State<_SleepLogSheet> createState() => _SleepLogSheetState();
}

class _SleepLogSheetState extends State<_SleepLogSheet> {
  TimeOfDay _bedTime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

  Future<void> _pickTime(bool isBedTime) async {
    final initial = isBedTime ? _bedTime : _wakeTime;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
      builder: (ctx, child) {
        return MediaQuery(
          data: MediaQuery.of(ctx).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isBedTime) {
          _bedTime = picked;
        } else {
          _wakeTime = picked;
        }
      });
    }
  }

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _calcDurationText() {
    final bedMinutes = _bedTime.hour * 60 + _bedTime.minute;
    final wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    int diff = wakeMinutes - bedMinutes;
    if (diff <= 0) diff += 24 * 60;
    final h = diff ~/ 60;
    final m = diff % 60;
    if (m == 0) return '${h}시간 0분';
    return '${h}시간 ${m}분';
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const Text(
          '수면 기록하기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        _SleepTimeRow(
          label: '취침 시간',
          timeText: _formatTime(_bedTime),
          onTap: () => _pickTime(true),
        ),
        const SizedBox(height: 8),
        _SleepTimeRow(
          label: '기상 시간',
          timeText: _formatTime(_wakeTime),
          onTap: () => _pickTime(false),
        ),

        const SizedBox(height: 12),
        Row(
          children: [
            const Icon(
              Icons.bedtime,
              size: 18,
              color: Color(0xFF5C5CFF),
            ),
            const SizedBox(width: 6),
            Text(
              '수면 시간',
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade700,
              ),
            ),
            const Spacer(),
            Text(
              _calcDurationText(),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C5CFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // TODO: 실제 저장 로직 연결
              Navigator.pop(context);
            },
            child: const Text(
              '저장하기',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SleepTimeRow extends StatelessWidget {
  final String label;
  final String timeText;
  final VoidCallback onTap;

  const _SleepTimeRow({
    required this.label,
    required this.timeText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              timeText,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.access_time,
              size: 18,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// ===== 바텀시트: 카페인 기록 =====

class _CaffeineLogSheet extends StatefulWidget {
  const _CaffeineLogSheet({super.key});

  @override
  State<_CaffeineLogSheet> createState() => _CaffeineLogSheetState();
}

class _CaffeineLogSheetState extends State<_CaffeineLogSheet> {
  String _selectedType = 'coffee';
  String _selectedAmount = '75';

  final List<_CaffeineTypeItem> _types = const [
    _CaffeineTypeItem(key: 'coffee', label: '커피', color: Color(0xFFFFB74D)),
    _CaffeineTypeItem(key: 'tea', label: '차', color: Color(0xFF81C784)),
    _CaffeineTypeItem(key: 'energy', label: '에너지드링크', color: Color(0xFFE57373)),
    _CaffeineTypeItem(key: 'etc', label: '기타', color: Color(0xFF90A4AE)),
  ];

  final List<_AmountItem> _amounts = const [
    _AmountItem(label: '1샷 (75mg)', value: '75'),
    _AmountItem(label: '2샷 (150mg)', value: '150'),
    _AmountItem(label: '텀블러 1잔 (200mg)', value: '200'),
    _AmountItem(label: '캔커피 1개 (80mg)', value: '80'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
        const Text(
          '카페인 섭취 기록하기',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 16),

        const Text(
          '종류',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _types.map((t) {
            final selected = _selectedType == t.key;
            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedType = t.key;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      selected ? t.color.withOpacity(0.12) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: selected ? t.color : Colors.grey.shade300,
                    width: 1.3,
                  ),
                ),
                child: Text(
                  t.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    color: selected ? t.color : Colors.grey.shade700,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 16),

        const Text(
          '섭취량',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedAmount,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              items: _amounts.map((a) {
                return DropdownMenuItem(
                  value: a.value,
                  child: Text(a.label),
                );
              }).toList(),
              onChanged: (v) {
                if (v == null) return;
                setState(() {
                  _selectedAmount = v;
                });
              },
            ),
          ),
        ),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA726),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              // TODO: 실제 저장 로직 연결
              Navigator.pop(context);
            },
            child: const Text(
              '저장하기',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CaffeineTypeItem {
  final String key;
  final String label;
  final Color color;

  const _CaffeineTypeItem({
    required this.key,
    required this.label,
    required this.color,
  });
}

class _AmountItem {
  final String label;
  final String value;

  const _AmountItem({
    required this.label,
    required this.value,
  });
}
