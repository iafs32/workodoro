import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Duration countdownDuration = const Duration(minutes: 10);
  Duration duration = const Duration();
  Timer? timer;
  AudioCache audioCache = AudioCache();

  bool isStarted = false;
  bool isCountdown = false;

  void stop() {
    timer?.cancel();
    setState(() {
      duration = const Duration();
    });
    isCountdown = false;
    isStarted = false;
  }

  void changeTimer() {
    isCountdown = !isCountdown;
    if (isCountdown) {
      duration = Duration(seconds: (3 * duration.inSeconds) ~/ 10);
    } else {
      duration = const Duration();
    }
  }

  void addTime() {
    final addSeconds = isCountdown ? -1 : 1;

    setState(() {
      final seconds = duration.inSeconds + addSeconds;

      if (seconds < 0) {
        timer?.cancel();
        playMusic();
        isCountdown = false;
        startTimer();
      } else {
        duration = Duration(seconds: seconds);
      }
    });
  }

  void playMusic() async {
    await audioCache.play('bell.mp3');
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff1F1023),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Center(
                child: Text(
                  'Workodoro',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              buildTime(),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: (() {
                        startTimer();
                        if (isStarted) {
                          changeTimer();
                        }
                        isStarted = true;
                      }),
                      fillColor: const Color(0xffFEA82F),
                      shape: const RoundedRectangleBorder(),
                      child: Text(
                        (isCountdown || !isStarted) ? 'WORK' : 'REST',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: RawMaterialButton(
                      onPressed: (() {
                        stop();
                      }),
                      fillColor: const Color(0xffFEA82F),
                      shape: const RoundedRectangleBorder(),
                      child: const Text(
                        'STOP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$hours:$minutes:$seconds',
      style: const TextStyle(
        color: Colors.white,
        fontSize: 76,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
