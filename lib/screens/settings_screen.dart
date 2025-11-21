// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  static const routeName = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 토글 상태 (지금은 로컬 상태만, 나중에 SharedPreferences 등으로 저장 가능)
  bool _bedtimeReminder = true;
  bool _wakeCheckReminder = true;
  bool _showTodaySleep = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        title: const Text('설정'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black87,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        children: [
          // ===== 캘린더 관리 =====
          const _SectionTitle('캘린더 관리'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsTile(
                icon: Icons.calendar_month_outlined,
                iconColor: const Color(0xFF5C6BC0),
                title: '캘린더 추가 연동',
                subtitle: 'Google / Apple 캘린더를 연결해요.',
                onTap: () {
                  // TODO: 실제 캘린더 연동 화면/로직 연결
                },
              ),
              const Divider(height: 1),
              _SettingsTile(
                icon: Icons.sync,
                iconColor: const Color(0xFF26A69A),
                title: '일정 동기화 하기',
                subtitle: '연동된 캘린더의 일정을 다시 불러와요.',
                onTap: () {
                  // TODO: 실제 동기화 로직 연결
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===== 알림 설정 =====
          const _SectionTitle('알림 설정'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: [
              _SettingsSwitchTile(
                icon: Icons.nightlight_round,
                iconColor: const Color(0xFF7E57C2),
                title: '취침 전 알림',
                subtitle: '권장 취침 시간 30분 전에 알려줘요.',
                value: _bedtimeReminder,
                onChanged: (v) {
                  setState(() => _bedtimeReminder = v);
                  // TODO: 실제 알림 스케줄링 로직 연결
                },
              ),
              const Divider(height: 1),
              _SettingsSwitchTile(
                icon: Icons.wb_sunny_outlined,
                iconColor: const Color(0xFFFFB74D),
                title: '기상 후 체크 알림',
                subtitle: '기상한 뒤 수면 기록을 잊지 않도록 알려줘요.',
                value: _wakeCheckReminder,
                onChanged: (v) {
                  setState(() => _wakeCheckReminder = v);
                },
              ),
              const Divider(height: 1),
              _SettingsSwitchTile(
                icon: Icons.insights_outlined,
                iconColor: const Color(0xFF42A5F5),
                title: '현재 수면 상태 표시',
                subtitle: '위젯/알림에 오늘의 수면 빚을 함께 보여줘요.',
                value: _showTodaySleep,
                onChanged: (v) {
                  setState(() => _showTodaySleep = v);
                },
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ===== 앱 정보 =====
          const _SectionTitle('앱 정보'),
          const SizedBox(height: 8),
          _SettingsCard(
            children: const [
              _SettingsTile(
                icon: Icons.info_outline,
                iconColor: Color(0xFF90A4AE),
                title: '앱 버전',
                subtitle: 'v1.0.0',
                showChevron: false,
              ),
              Divider(height: 1),
              _SettingsTile(
                icon: Icons.help_outline,
                iconColor: Color(0xFFFFA726),
                title: '도움말',
                subtitle: '사용 방법과 자주 묻는 질문',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// 섹션 타이틀 텍스트
class _SectionTitle extends StatelessWidget {
  final String text;
  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: Colors.grey.shade700,
      ),
    );
  }
}

/// 카드 컨테이너 (보라빛 살짝 도는 배경)
class _SettingsCard extends StatelessWidget {
  final List<Widget> children;

  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8F6FF),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}

/// 일반 설정 타일 ( > 아이콘 있는 타입)
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showChevron;

  const _SettingsTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: iconColor.withOpacity(0.12),
              child: Icon(icon, color: iconColor, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (showChevron)
              Icon(
                Icons.chevron_right,
                color: Colors.grey.shade500,
              ),
          ],
        ),
      ),
    );
  }
}

/// 스위치가 달린 설정 타일
class _SettingsSwitchTile extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String? subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SettingsSwitchTile({
    required this.icon,
    required this.iconColor,
    required this.title,
    this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: iconColor.withOpacity(0.12),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: const Color(0xFF5C5CFF),
            activeTrackColor: const Color(0xFFD1C4E9),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
