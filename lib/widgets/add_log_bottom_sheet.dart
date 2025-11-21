import 'package:flutter/material.dart';

void showAddLogBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => const _AddLogSheet(),
  );
}

class _AddLogSheet extends StatefulWidget {
  const _AddLogSheet();

  @override
  State<_AddLogSheet> createState() => _AddLogSheetState();
}

class _AddLogSheetState extends State<_AddLogSheet> {
  String _type = 'sleep'; 
  TimeOfDay _start = const TimeOfDay(hour: 1, minute: 0);
  TimeOfDay _end = const TimeOfDay(hour: 7, minute: 30);
  int _caffeineMg = 100;

  Future<void> _pickTime(bool isStart) async {
    final initial = isStart ? _start : _end;
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _start = picked;
        } else {
          _end = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '데이터 기록',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'sleep', label: Text('수면')),
              ButtonSegment(value: 'caffeine', label: Text('카페인')),
            ],
            selected: {_type},
            onSelectionChanged: (set) {
              setState(() => _type = set.first);
            },
          ),
          const SizedBox(height: 16),
          if (_type == 'sleep') _sleepForm() else _caffeineForm(),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton(
              onPressed: () {
                debugPrint(
                    'add log type=$_type start=$_start end=$_end caffeine=$_caffeineMg');
                Navigator.pop(context);
              },
              child: const Text('저장'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sleepForm() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('수면 시작 / 종료 시간'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickTime(true),
                  child: Text('시작: ${_start.format(context)}'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickTime(false),
                  child: Text('종료: ${_end.format(context)}'),
                ),
              ),
            ],
          ),
        ],
      );

  Widget _caffeineForm() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('카페인 섭취량 (mg)'),
          Slider(
            min: 0,
            max: 400,
            divisions: 8,
            value: _caffeineMg.toDouble(),
            label: '$_caffeineMg mg',
            onChanged: (v) => setState(() => _caffeineMg = v.toInt()),
          ),
        ],
      );
}
