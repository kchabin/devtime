import 'package:flutter/material.dart';
import 'dart:async';

class StopWatchScreen extends StatefulWidget {
  const StopWatchScreen({super.key});

  @override
  State<StopWatchScreen> createState() => _StopWatchScreenState();
}

class _StopWatchScreenState extends State<StopWatchScreen> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _timer;
  bool _isRunning = false;

  void _resetTimer() {
    //리셋 버튼
    _timer?.cancel();
    _stopwatch.stop();
    setState(() {
      _isRunning = false;
    });
    _stopwatch.reset();
  }

  void startTimer() {
    //시작 버튼
    if (!_stopwatch.isRunning) {
      //매 1초마다 _updateTimer를 호출하여 시간 업데이트를 UI에 반영함.
      _timer = Timer.periodic(const Duration(seconds: 1), _updateTimer);

      _stopwatch.start();
      setState(() {
        _isRunning = true;
      });
    }
  }

  void _pauseTimer() {
    //일시정지 버튼
    if (_stopwatch.isRunning) {
      _timer?.cancel();
      _stopwatch.stop();
      setState(() {
        _isRunning = false;
      });
    }
  }

  void _updateTimer(Timer timer) {
    //타이머가 동작하는 동안 일정한 간격으로 호출되어 UI 업데이트
    if (_stopwatch.isRunning) {
      setState(() {});
    }
  }

  String _formattedTime() {
    int totalSeconds = _stopwatch.elapsed.inSeconds;
    int hours = totalSeconds ~/ 3600;
    int minutes = (totalSeconds % 3600) ~/ 60;
    int seconds = totalSeconds % 60;
    return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'DevTIME',
          style: TextStyle(
              color: Color.fromRGBO(2, 73, 255, 1),
              fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
          child: Column(
            children: [
              const SizedBox(
                height: 150,
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: const Color.fromRGBO(2, 73, 255, 1),
                ),
                alignment: Alignment.center,
                child: Text(
                  _formattedTime(),
                  style: const TextStyle(
                      fontSize: 58,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 90,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _isRunning ? _pauseTimer : startTimer,
                    icon: Icon(_isRunning
                        ? Icons.pause_circle_filled_rounded
                        : Icons.play_circle_fill_rounded),
                    iconSize: 50,
                    color: const Color.fromRGBO(2, 73, 255, 1),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  IconButton(
                    onPressed: _resetTimer,
                    icon: const Icon(Icons.restart_alt_rounded),
                    iconSize: 50,
                    color: const Color.fromRGBO(2, 73, 255, 1),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
