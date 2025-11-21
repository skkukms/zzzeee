import 'package:flutter/material.dart';
import 'timeline_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  int _pageIndex = 0;

  // 설문 응답 (1~3) → 5문항
  final List<int?> _chronoAnswers = [null, null, null, null, null];

  // 수면/준비 시간
  Duration _minSleep = const Duration(hours: 6);
  Duration _recSleep = const Duration(hours: 8);
  Duration _prepTime = const Duration(hours: 1, minutes: 30);

  void _next() {
    // 설문 페이지(= index 1) 검증: 5문항 모두 응답 필요
    if (_pageIndex == 1) {
      if (_chronoAnswers.any((e) => e == null)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('모든 질문에 응답해 주세요.')),
        );
        return;
      }
    }
    if (_pageIndex < 5) {
      setState(() => _pageIndex++);
    }
  }

  void _prev() {
    if (_pageIndex > 0) {
      setState(() => _pageIndex--);

    }
  }

  @override
  Widget build(BuildContext context) {

    final pages = <Widget>[
      _WelcomeScreen(onStart: _next, currentIndex: _pageIndex),
      _ChronotypeSurveyScreen(
        currentIndex: _pageIndex,
        answers: _chronoAnswers,
        onChanged: (idx, val) {
          setState(() => _chronoAnswers[idx] = val);
        },
      ),
      _SleepGoalScreen(
        minSleep: _minSleep,
        recSleep: _recSleep,
        onChangedMin: (d) => setState(() => _minSleep = d),
        onChangedRec: (d) => setState(() => _recSleep = d),
      ),
      _PrepTimeScreen(
        prepTime: _prepTime,
        onChanged: (d) => setState(() => _prepTime = d),
      ),
      _CalendarScreen(onSkip: _next),
      const _CompleteScreen(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: pages[_pageIndex],
            ),
          ),
        ),
      ),
      // ✅ 환영 화면(index 0)과 마지막 화면(index 5)에서는 하단 버튼 숨김
      bottomNavigationBar: (_pageIndex == 0 || _pageIndex == 5)
          ? null
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Row(
                  children: [
                    if (_pageIndex > 0 && _pageIndex < 5)
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _prev,
                          child: const Text('이전'),
                        ),
                      )
                    else
                      const Spacer(),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: _next,
                        child: const Text('다음'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

/// ─────────────────────────────────────────
/// Screen 1: 환영 화면
/// ─────────────────────────────────────────
class _WelcomeScreen extends StatelessWidget {
  final VoidCallback onStart;
  final int currentIndex;

  const _WelcomeScreen({
    required this.onStart,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      key: const ValueKey('welcome'),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(height: 8),
          Column(
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2D2A5A), Color(0xFF9153FF)],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  image: const DecorationImage(
                    image: AssetImage('assets/images/배경화면.png'),
                    fit: BoxFit.cover,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Zzzeee',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Zzzeee에 오신 것을 환영합니다',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                '더 나은 수면을 위한 여정을 시작해보세요.\n'
                '개인 맞춤형 수면 관리를 통해 건강한 생활 리듬을 만들어드립니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, height: 1.5),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                    elevation: 3,
                  ),
                  onPressed: onStart,
                  child: const Text(
                    '시작하기',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _PageIndicator(currentIndex: currentIndex, total: 5),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  final int currentIndex;
  final int total;

  const _PageIndicator({
    required this.currentIndex,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF5B4BFF);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(total, (i) {
        final isActive = i == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: isActive ? 10 : 8,
          height: isActive ? 10 : 8,
          decoration: BoxDecoration(
            color: isActive ? activeColor : Colors.grey.shade400,
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

/// ─────────────────────────────────────────
/// Screen 2: 크로노타입 설문 (5문항)
/// ─────────────────────────────────────────
class _ChronotypeSurveyScreen extends StatelessWidget {
  final List<int?> answers;
  final void Function(int index, int value) onChanged;
  final int currentIndex;

  const _ChronotypeSurveyScreen({
    required this.answers,
    required this.onChanged,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('chrono'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SimpleAppBar(title: '크로노타입 설문'),
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '당신의 수면 패턴을 파악하기 위한 간단한 질문입니다',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 16),

                // Q1: 자기 인식형
                _QuestionCard(
                  question: 'Q1. 스스로 생각하기에 당신은…',
                  options: const [
                    '완전 아침형이라고 느낀다',
                    '아침형과 저녁형의 중간이다',
                    '완전 저녁형이라고 느낀다',
                  ],
                  groupValue: answers[0],
                  onChanged: (v) => onChanged(0, v),
                ),
                const SizedBox(height: 12),

                // Q2: 아침 기상 난이도
                _QuestionCard(
                  question: 'Q2. 아침에 알람 없이 일어나는 것이',
                  options: const [
                    '매우 쉽다',
                    '그럭저럭 가능하다',
                    '매우 어렵다',
                  ],
                  groupValue: answers[1],
                  onChanged: (v) => onChanged(1, v),
                ),
                const SizedBox(height: 12),

                // Q3: 저녁 활동성
                _QuestionCard(
                  question:
                      'Q3. 저녁(특히 21시 이후)에 가장 활동적이고\n에너지가 넘치는 편인가요?',
                  options: const [
                    '거의 항상 그렇다',
                    '가끔 그렇다',
                    '거의 그렇지 않다',
                  ],
                  groupValue: answers[2],
                  onChanged: (v) => onChanged(2, v),
                ),
                const SizedBox(height: 12),

                // Q4: 기상 직후 컨디션
                _QuestionCard(
                  question: 'Q4. 평소 기상 직후 컨디션은 어떤가요?',
                  options: const [
                    '상당히 맑고 상쾌하다',
                    '그럭저럭 움직일 만하다',
                    '항상 매우 피곤하고 멍하다',
                  ],
                  groupValue: answers[3],
                  onChanged: (v) => onChanged(3, v),
                ),
                const SizedBox(height: 12),

                // Q5: 자연스럽게 잠드는 시간대
                _QuestionCard(
                  question:
                      'Q5. 알람이나 일정이 없어도\n자연스럽게 잠드는 시간대는 언제인가요?',
                  options: const [
                    '22시 이전에 잠드는 편이다',
                    '22시~자정 사이에 잠드는 편이다',
                    '자정 이후에 잠드는 편이다',
                  ],
                  groupValue: answers[4],
                  onChanged: (v) => onChanged(4, v),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: _PageIndicator(currentIndex: currentIndex, total: 5),
        ),
      ],
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? groupValue;
  final ValueChanged<int> onChanged;

  const _QuestionCard({
    required this.question,
    required this.options,
    required this.groupValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          ...List.generate(options.length, (idx) {
            final value = idx + 1;
            return Container(
              margin: const EdgeInsets.only(top: 6),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color(0xFFF7F8FD),
              ),
              child: RadioListTile<int>(
                dense: true,
                visualDensity: VisualDensity.compact,
                value: value,
                groupValue: groupValue,
                onChanged: (v) => onChanged(v!),
                activeColor: const Color(0xFF5B4BFF),
                title: Text(
                  options[idx],
                  style: const TextStyle(fontSize: 14),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────
/// Screen 3: 수면 목표 설정 (타임 스테퍼)
/// ─────────────────────────────────────────
class _SleepGoalScreen extends StatelessWidget {
  final Duration minSleep;
  final Duration recSleep;
  final ValueChanged<Duration> onChangedMin;
  final ValueChanged<Duration> onChangedRec;

  const _SleepGoalScreen({
    required this.minSleep,
    required this.recSleep,
    required this.onChangedMin,
    required this.onChangedRec,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('sleep'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SimpleAppBar(title: '수면 목표 설정'),
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '건강한 수면을 위한 목표 시간을 설정해주세요.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 16),
                _TimeCard(
                  title: '최소 수면 시간',
                  duration: minSleep,
                  onChanged: onChangedMin,
                ),
                const SizedBox(height: 12),
                _TimeCard(
                  title: '권장 수면 시간',
                  duration: recSleep,
                  onChanged: onChangedRec,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────
/// Screen 4: 준비 시간 설정
/// ─────────────────────────────────────────
class _PrepTimeScreen extends StatelessWidget {
  final Duration prepTime;
  final ValueChanged<Duration> onChanged;

  const _PrepTimeScreen({
    required this.prepTime,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    String format(Duration d) {
      final h = d.inHours;
      final m = d.inMinutes % 60;
      if (m == 0) return '${h}시간';
      if (h == 0) return '${m}분';
      return '${h}시간 ${m}분';
    }

    return Column(
      key: const ValueKey('prep'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SimpleAppBar(title: '준비 시간 설정'),
        Expanded(
          child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '기상 후 첫 일정을 위해 필요한 준비 시간을 설정해주세요.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE9EDFF),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, size: 18),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '준비 시간에는 세수, 옷 입기, 아침 식사, 통학/통근 시간 등을 '
                          '포함한 전체 시간을 기준으로 설정해 주세요.',
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                _TimeCard(
                  title: '준비 시간',
                  duration: prepTime,
                  onChanged: onChanged,
                ),
                const SizedBox(height: 12),
                Text(
                  '총 ${format(prepTime)}의 준비 시간이 필요합니다.',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF5B4BFF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// 타임 카드 + 스테퍼 (시간/분)
class _TimeCard extends StatelessWidget {
  final String title;
  final Duration duration;
  final ValueChanged<Duration> onChanged;

  const _TimeCard({
    required this.title,
    required this.duration,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final totalMinutes = duration.inMinutes.clamp(0, 24 * 60);
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    void adjust(int minuteDelta) {
      int newMinutes = totalMinutes + minuteDelta;
      newMinutes = newMinutes.clamp(0, 24 * 60);
      onChanged(Duration(minutes: newMinutes));
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:
                const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _NumberStepper(
                label: '시간',
                value: hours,
                onUp: () => adjust(60),
                onDown: () => adjust(-60),
              ),
              const SizedBox(width: 16),
              const Text(
                ':',
                style:
                    TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
              ),
              const SizedBox(width: 16),
              _NumberStepper(
                label: '분',
                value: minutes,
                onUp: () => adjust(10), // 10분 단위
                onDown: () => adjust(-10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NumberStepper extends StatelessWidget {
  final String label;
  final int value;
  final VoidCallback onUp;
  final VoidCallback onDown;

  const _NumberStepper({
    required this.label,
    required this.value,
    required this.onUp,
    required this.onDown,
  });

  String _twoDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CircleIconButton(
          icon: Icons.keyboard_arrow_up,
          onPressed: onUp,
        ),
        const SizedBox(height: 4),
        Text(
          _twoDigits(value),
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        _CircleIconButton(
          icon: Icons.keyboard_arrow_down,
          onPressed: onDown,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _CircleIconButton({
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFF3F4FF),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(
            icon,
            size: 18,

          ),
        ),
      ),
    );
  }

}

/// ─────────────────────────────────────────
/// Screen 5: 캘린더 연동
/// ─────────────────────────────────────────
class _CalendarScreen extends StatelessWidget {
  final VoidCallback onSkip;

  const _CalendarScreen({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const ValueKey('calendar'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _SimpleAppBar(title: '캘린더 연동'),
        Expanded(
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '캘린더를 연동하여 스케줄을 분석합니다.',
                  style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                const Text(
                  '수업, 시험, 알바 등의 일정을 기반으로\n'
                  '당신에게 맞는 수면 스케줄을 계산할 수 있어요.',
                  style: TextStyle(fontSize: 13, color: Colors.black54),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Google 캘린더 연동은 추후 구현 예정입니다.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login),
                  label: const Text('Google로 로그인'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('.ics 파일 가져오기는 추후 구현 예정입니다.'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.file_open),
                  label: const Text('.ics 파일 가져오기'),
                ),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: onSkip,
                  child: const Text('건너뛰기'),
                ),
              ],
            ),
          ),

        ),
      ],
    );
  }
}

/// ─────────────────────────────────────────
/// Screen 6: 계산 중 → 완료 → 자동 이동
/// ─────────────────────────────────────────
class _CompleteScreen extends StatefulWidget {
  const _CompleteScreen({super.key});

  @override
  State<_CompleteScreen> createState() => _CompleteScreenState();
}

class _CompleteScreenState extends State<_CompleteScreen> {
  bool _done = false;

  @override
  void initState() {
    super.initState();
    // 10초 동안 "분석 중" 상태 → 그 후 완료 상태로 변경 + 자동 이동
    Future.delayed(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() => _done = true);

      // 완료 메시지를 2초 정도 보여준 뒤 타임라인으로 이동
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushReplacementNamed(
          context,
          TimelineScreen.routeName,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_done) {
      // 아직 계산 중
      return Center(
        key: const ValueKey('processing'),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(strokeWidth: 5),
            ),
            SizedBox(height: 24),
            Text(
              '당신의 크로노타입을 분석하는 중입니다…',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12),
            Text(
              '수면 패턴, 기상 습관, 저녁 활동성을\n기반으로 최적의 유형을 계산하고 있어요.',
              style: TextStyle(fontSize: 13, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    // 계산 완료 상태
    return Center(
      key: const ValueKey('done'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.check_circle, size: 80, color: Color(0xFF4CAF50)),
          SizedBox(height: 16),
          Text(
            '크로노타입 생성이 완료되었습니다!',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8),
          Text(
            '이제 당신에게 맞는 수면 타임라인을\n화면에서 바로 확인하실 수 있어요.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }
}

/// 단계 상단 타이틀용 간단 AppBar
class _SimpleAppBar extends StatelessWidget {
  final String title;

  const _SimpleAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 4, right: 4, top: 8, bottom: 4),
      child: Row(
        children: [
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

