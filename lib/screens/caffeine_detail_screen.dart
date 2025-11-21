import 'package:flutter/material.dart';

class CaffeineDetailScreen extends StatelessWidget {
  const CaffeineDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 데모용 고정 값 (나중에 실제 로직으로 교체 가능)
    const int recommendedMaxMg = 300; // 하루 권장 상한
    const int currentIntakeMg = 120;  // 오늘 섭취량 예시
    const int remainingMg = recommendedMaxMg - currentIntakeMg;
    const String lastDrinkTime = '13:20'; // 마지막 카페인 섭취 시각 예시

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        title: const Text('카페인 가이드'),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          // 오늘의 카페인 요약
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘의 카페인 요약',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '지금까지 섭취량',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$currentIntakeMg mg',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF42A5F5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '권장 최대 섭취량',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$recommendedMaxMg mg',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF5C6BC0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                LinearProgressIndicator(
                  value: (currentIntakeMg / recommendedMaxMg).clamp(0.0, 1.0),
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade200,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF42A5F5)),
                ),
                const SizedBox(height: 8),
                Text(
                  remainingMg > 0
                      ? '권장 섭취량까지 약 ${remainingMg}mg 여유가 있어요.'
                      : '오늘 카페인은 이미 충분히 먹었어요. 더 줄이는 게 좋아요.',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 추천 섭취·중단 시간대 안내
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘의 카페인 권장 시간대',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _timeChip(
                      icon: Icons.local_cafe,
                      label: '섭취 추천 시간',
                      timeRange: '09:00 ~ 15:00',
                    ),
                    const SizedBox(width: 12),
                    _timeChip(
                      icon: Icons.nightlight_round,
                      label: '섭취 자제 시간',
                      timeRange: '15:00 이후',
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  '취침 6시간 전 이후에는 카페인을 피하는 것이 좋아요.\n'
                  '너무 늦게 마시면 깊은 잠에 방해가 될 수 있어요.',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // 간단한 팁
          Container(
            padding: const EdgeInsets.all(16),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '오늘의 팁',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      size: 18,
                      color: Color(0xFF5C6BC0),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '마지막 카페인 섭취 시각: $lastDrinkTime',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  '졸릴 때마다 카페인을 추가로 마시는 것보다는\n'
                  '낮에 한두 번, 일정한 시간대에만 섭취해보는 건 어떨까요?',
                  style: TextStyle(fontSize: 12, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
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

  Widget _timeChip({
    required IconData icon,
    required String label,
    required String timeRange,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFE3F2FD),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 16, color: const Color(0xFF1E88E5)),
                const SizedBox(width: 4),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E88E5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              timeRange,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
