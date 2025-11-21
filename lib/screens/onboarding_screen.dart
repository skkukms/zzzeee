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
      debugPrint('chronoType=$_chronoType '
          'minSleep=$_minSleep targetSleep=$_targetSleep prep=$_prepHours');
      Navigator.pushReplacementNamed(context, TimelineScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;
    switch (_step) {
      case 0:
        body = _welcomeStep();
        break;
      case 1:
        body = _chronoStep();
        break;
      case 2:
        body = _sleepStep();
        break;
      default:
        body = _prepStep();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Zzzeee 최초 설정'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: body,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _next,
        label: Text(_step == 3 ? '완료' : '다음'),
        icon: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _welcomeStep() => const Center(
        child: Text(
          'Zzzeee에 오신 것을 환영합니다!\n\n몇 가지 기본 정보를 설정할게요.',
          textAlign: TextAlign.center,
        ),
      );

  Widget _chronoStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '크로노타입을 선택해주세요',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          RadioListTile(
            title: const Text('아침형'),
            value: 'morning',
            groupValue: _chronoType,
            onChanged: (v) => setState(() => _chronoType = v!),
          ),
          RadioListTile(
            title: const Text('저녁형'),
            value: 'evening',
            groupValue: _chronoType,
            onChanged: (v) => setState(() => _chronoType = v!),
          ),
        ],
      );

  Widget _sleepStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('최소 수면 시간: ${_minSleep.toStringAsFixed(1)}시간'),
          Slider(
            min: 4,
            max: 9,
            divisions: 10,
            value: _minSleep,
            label: _minSleep.toStringAsFixed(1),
            onChanged: (v) => setState(() => _minSleep = v),
          ),
          const SizedBox(height: 24),
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
      );

  Widget _prepStep() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('기상 후 준비 시간: ${_prepHours.toStringAsFixed(1)}시간'),
          Slider(
            min: 0.5,
            max: 3,
            divisions: 5,
            value: _prepHours,
            label: _prepHours.toStringAsFixed(1),
            onChanged: (v) => setState(() => _prepHours = v),
          ),
          const SizedBox(height: 16),
          const Text('완료를 누르면 오늘 타임라인 화면으로 이동합니다.'),
        ],
      );
}
