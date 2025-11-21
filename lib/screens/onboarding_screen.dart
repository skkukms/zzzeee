import 'package:flutter/material.dart';
import 'timeline_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  String _chronoType = 'evening';
  double _minSleep = 6;
  double _targetSleep = 8;
  double _prepHours = 1.5;

  int _step = 0; 

  void _next() {
    if (_step < 3) {
      setState(() => _step++);
    } else {
      // TODO: 여기서 SharedPreferences 등에 값 저장하면 됨
      debugPrint('chronoType=$_chronoType '
          'minSleep=$_minSleep targetSleep=$_targetSleep prep=$_prepHours');
      Navigator.pushReplacementNamed(context, TimelineScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stepBodies = <Widget>[
      _welcomeStep(),
      _chronoStep(),
      _sleepStep(),
      _prepStep(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          '처음 설정',
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Zzzeee를 내 생활 패턴에 맞게\n한 번만 설정해 둘게요.',
              style: TextStyle(
                fontSize: 15,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                Text(
                  '${_step + 1} / 4',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF5C5CFF),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      value: (_step + 1) / 4,
                      minHeight: 6,
                      backgroundColor: Colors.grey.shade200,
                      valueColor: const AlwaysStoppedAnimation(
                        Color(0xFF5C5CFF),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOut,
                switchOutCurve: Curves.easeIn,
                child: stepBodies[_step],
              ),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF5C5CFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              elevation: 4,
              shadowColor: const Color(0xFF5C5CFF).withOpacity(0.4),
            ),
            onPressed: _next,
            icon: Icon(_step == 3 ? Icons.check_rounded : Icons.arrow_forward),
            label: Text(
              _step == 3 ? '완료' : '다음',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _welcomeStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB39DFF),
              Color(0xFF8C9EFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,   
          children: const [
            Text(
              "Zzzeee에 오신 걸\n환영해요 😊",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 12),
            Text(
              "몇 가지 질문만 답해주면\n"
              "내 생활 패턴에 맞는 수면/카페인 타임라인을 만들어 줄게요.",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget _chronoStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '어떤 시간대에 더 또렷한가요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              '크로노타입에 따라 추천 기상 시간과 카페인 섭취 시간대를 조정해줄게요.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 20),

            RadioListTile(
              value: 'morning',
              groupValue: _chronoType,
              title: const Text('아침형이에요'),
              subtitle: const Text('아침에 집중이 잘 되고 밤에는 빨리 피곤해져요.'),
              onChanged: (v) => setState(() => _chronoType = v!),
            ),
            RadioListTile(
              value: 'evening',
              groupValue: _chronoType,
              title: const Text('저녁형이에요'),
              subtitle: const Text('밤에 집중이 잘 되고 아침엔 늦게 깨어나요.'),
              onChanged: (v) => setState(() => _chronoType = v!),
            ),
          ],
        ),
      ),
    ],
  );
}



  Widget _sleepStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '보통 얼마나 자나요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '최소~목표 수면 시간을 기준으로\n수면 빚과 추천 수면 시간을 계산해줄게요.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Text('최소 수면 시간: ${_minSleep.toStringAsFixed(1)}시간'),
            Slider(
              min: 4,
              max: 9,
              divisions: 10,
              value: _minSleep,
              label: _minSleep.toStringAsFixed(1),
              onChanged: (v) => setState(() => _minSleep = v),
            ),

            const SizedBox(height: 20),

            Text('목표 수면 시간: ${_targetSleep.toStringAsFixed(1)}시간'),
            Slider(
              min: 6,
              max: 10,
              divisions: 8,
              value: _targetSleep,
              label: _targetSleep.toStringAsFixed(1),
              onChanged: (v) => setState(() => _targetSleep = v),
            ),
          ],
        ),
      )
    ],
  );
}


Widget _prepStep() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 16),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '아침에 준비하는 데 얼마나 걸리나요?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '기상 후 씻기 · 아침 식사 · 이동 시간 등을 포함해서\n평균 준비 시간을 알려주세요.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
            const SizedBox(height: 20),

            Text('${_prepHours.toStringAsFixed(1)}시간 정도 걸려요'),
            Slider(
              min: 0.5,
              max: 3,
              divisions: 5,
              value: _prepHours,
              label: _prepHours.toStringAsFixed(1),
              onChanged: (v) => setState(() => _prepHours = v),
            ),

            const SizedBox(height: 12),
            const Text(
              '완료를 누르면 오늘 타임라인 화면에서\n추천 기상/수면/카페인 시간대를 볼 수 있어요.',
              style: TextStyle(color: Colors.black54, fontSize: 13),
            ),
          ],
        ),
      ),
    ],
  );
}



BoxDecoration _cardDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18), 
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 9,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

  Widget _prettyRadio({
  required String title,
  required String subtitle,
  required String value,
}) {
  final selected = _chronoType == value;
  return InkWell(
    borderRadius: BorderRadius.circular(14),
    onTap: () => setState(() => _chronoType = value),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8), // 더 작게
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: selected ? const Color(0xFF5C5CFF).withOpacity(0.05) : null,
        border: Border.all(
          color: selected ? const Color(0xFF5C5CFF) : Colors.grey.shade300,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            selected ? Icons.radio_button_checked : Icons.radio_button_off,
            size: 18, 
            color: selected ? const Color(0xFF5C5CFF) : Colors.grey.shade500,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13, // 14 → 13
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                    color: Colors.grey.shade900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,  // 12 → 11
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}
