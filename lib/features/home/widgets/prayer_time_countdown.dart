import 'dart:async';

import 'package:flutter/material.dart';

import '../../../shared/utils/utils.dart';

class PrayerTimeCountdown extends StatefulWidget {
  final String time;
  final VoidCallback? onTimerFinshed;
  final bool fromPrayerPage;

  const PrayerTimeCountdown({
    super.key,
    required this.time,
    required this.onTimerFinshed,
    this.fromPrayerPage = false,
  });

  @override
  State<PrayerTimeCountdown> createState() => _PrayerTimeCountdownState();
}

class _PrayerTimeCountdownState extends State<PrayerTimeCountdown> {
  late Duration _myDuration;
  Timer? countdownTimer;

  @override
  void initState() {
    prepareTimer();
    super.initState();
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);
    print('=== didUpdateWidget [oldWidget.time]  ===> ${oldWidget.time}');
    print('=== didUpdateWidget [widget.time]  ===> ${widget.time}');
    if (widget.time != oldWidget.time) {
      print('=== didUpdateWidget [new.time]  ===> ${widget.time}');
      prepareTimer();
    }
  }

  @override
  void dispose() {
    countdownTimer!.cancel();
    super.dispose();
  }

  void prepareTimer() {
    stopTimer();
    final [hours, minutes] = getHoursAndMinutes(widget.time).split(':');
    final tm = DateTime.now()
        .copyWith(hour: int.parse(hours), minute: int.parse(minutes), second: 0)
        .difference(DateTime.now().copyWith(second: 0));

    // print('tm ===> ${tm.inHours}');
    // print('tmm ===> ${tm.inMinutes}');
    // print('tms ===> ${tm.inSeconds}');

    _myDuration = Duration(minutes: tm.inMinutes.abs());
    startTimer();
  }

  void startTimer() {
    // if (_myDuration == null) return;
    countdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => setCountDown(),
    );
  }

  void stopTimer() {
    if (countdownTimer != null) {
      countdownTimer!.cancel();
      setState(() {});
    }
  }

  void setCountDown() {
    const reduceSecondsBy = 1;
    final seconds = _myDuration.inSeconds - reduceSecondsBy;
    if (seconds < 0) {
      stopTimer();
      if (widget.onTimerFinshed != null) widget.onTimerFinshed!();
    } else {
      _myDuration = Duration(seconds: seconds);
    }
    setState(() {});
  }

  String strDigits(int n) => n.toString().padLeft(2, '0');

  @override
  Widget build(BuildContext context) {
    final hours = strDigits(_myDuration.inHours.remainder(24));
    final minutes = strDigits(_myDuration.inMinutes.remainder(60));
    final seconds = strDigits(_myDuration.inSeconds.remainder(60));

    return widget.fromPrayerPage
        ? Row(
            textDirection: TextDirection.ltr,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // hours
              _RemainingTime(
                time: hours,
                label: translate(context).hour,
              ),
              const SizedBox(width: 20),
              // minutes
              _RemainingTime(
                time: minutes,
                label: translate(context).minute,
              ),
              const SizedBox(width: 20),
              // seconds
              _RemainingTime(
                time: seconds,
                label: translate(context).second,
              ),
            ],
          )
        : Text(
            '$hours:$minutes:$seconds',
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 16,
            ),
          );
  }
}

class _RemainingTime extends StatelessWidget {
  final String time;
  final String label;

  const _RemainingTime({
    required this.time,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(3),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            time,
            style: const TextStyle(
              color: AppColors.primaryColor,
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(label),
        ],
      ),
    );
  }
}
