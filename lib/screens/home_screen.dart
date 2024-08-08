import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedMinutes = 25;
  int initialMinutes = 25;
  int totalSeconds = 25 * 60; // 기본 설정 시간
  bool isRunning = false;
  bool isBreak = false;
  int totalRounds = 0;
  int totalGoals = 0;
  late Timer timer;

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      timer.cancel();
      if (!isBreak) {
        setState(() {
          totalRounds++;
          if (totalRounds % 4 == 0) {
            totalGoals++;
            totalRounds = 0; // 라운드를 초기화
            _startBreakTimer();
          } else {
            _startWorkTimer();
          }
        });
      } else {
        setState(() {
          _startWorkTimer();
        });
      }
    } else {
      setState(() {
        totalSeconds--;
      });
    }
  }

  void _startBreakTimer() {
    setState(() {
      isBreak = true;
      totalSeconds = 5 * 60; // 5분 휴식
    });
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  void _startWorkTimer() {
    setState(() {
      isBreak = false;
      totalSeconds = initialMinutes * 60; // 초기 설정 시간
    });
    timer = Timer.periodic(const Duration(seconds: 1), onTick);
  }

  void onStartPressed() {
    if (!isRunning) {
      timer = Timer.periodic(const Duration(seconds: 1), onTick);
    }
    setState(() {
      isRunning = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isRunning = false;
    });
  }

  void onResetPressed() {
    timer.cancel();
    setState(() {
      totalSeconds = initialMinutes * 60; // 초기 설정 시간
      isRunning = false;
      isBreak = false;
    });
  }

  void onMinuteSelected(int index) {
    setState(() {
      selectedMinutes = [15, 20, 25, 30, 35][index];
      totalSeconds = selectedMinutes * 60;
      initialMinutes = selectedMinutes;
    });
  }

  String formatMinutes(int seconds) {
    return (seconds ~/ 60).toString().padLeft(2, '0');
  }

  String formatSeconds(int seconds) {
    return (seconds % 60).toString().padLeft(2, '0');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'POMOTIMER',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).cardColor,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      formatMinutes(totalSeconds),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  ':',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  width: 100,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Text(
                      formatSeconds(totalSeconds),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).scaffoldBackgroundColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 100,
              child: ListWheelScrollView.useDelegate(
                itemExtent: 50,
                onSelectedItemChanged: onMinuteSelected,
                physics: const FixedExtentScrollPhysics(),
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final minutes = [15, 20, 25, 30, 35][index];
                    return Center(
                      child: Text(
                        '$minutes',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    );
                  },
                  childCount: 5,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 80,
                  color: Colors.white,
                  onPressed: isRunning ? onPausePressed : onStartPressed,
                  icon: Icon(isRunning
                      ? Icons.pause_circle_outline
                      : Icons.play_circle_outline),
                ),
                const SizedBox(width: 20),
                IconButton(
                  iconSize: 80,
                  color: Colors.white,
                  onPressed: onResetPressed,
                  icon: const Icon(Icons.stop_circle_outlined),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '$totalRounds/4',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'ROUND',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 50),
                Column(
                  children: [
                    Text(
                      '$totalGoals/12',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      'GOAL',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
