library time_info;

import 'dart:async' show Timer;
import 'dart:developer' show log;

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// A Calculator.






class TimeInfo extends StatefulWidget {
  const TimeInfo({super.key , required this.time, this.style, this.languageCode});

  final DateTime time;

  final TextStyle? style;

  final String? languageCode;


  @override
  State<TimeInfo> createState() => _TimeInfoState();
}

class _TimeInfoState extends State<TimeInfo> {


  late ({String? time, bool previusYear}) info;

  late final Timer timer;


  bool needTimer = false;

  @override
  void initState() {
    super.initState();

    info = _Time.getTimeAgo(givenTime: widget.time);

    if (info.previusYear == false &&
        info.time != null &&
        (info.time!.contains('m') || info.time!.contains('now'))) {
      log('time ago: ${info.time}');
      needTimer = true;
      timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (mounted) {
          setState(() {});
        }
      });
    }
  }

  @override
  void dispose() {
    if (needTimer) {
      timer.cancel();
    }
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final text = info.previusYear
        ? DateFormat.yMMMd(widget.languageCode).format(widget.time)
        : (info.time == null
            ? DateFormat('d MMMM', widget.languageCode).format(widget.time)
            // ? DateFormat('d MMM').format(widget.time!)
            : info.time!);

    return Text(
      text,
      style: widget.style,
    );
  }
}






abstract class _Time {
  static ({String? time, bool previusYear}) getTimeAgo(
      {required DateTime givenTime}) {
    final now = DateTime.now();

    log('${givenTime.year} == ${now.year}');
    if (givenTime.year == now.year) {
      late String? timeAgo;

      final difference = now.difference(givenTime).inMinutes;

      if (givenTime.day == now.day) {
        if (difference < 1) {
          timeAgo = 'now';
        } else if (difference < 60) {
          timeAgo = '${difference}m';
        } else if (difference < 1440) {
          final hours = (difference / 60).floor();
          timeAgo = '${hours}h';
        }
      } else {
        timeAgo = null;

        // final months = (difference / 43200).floor();
        // timeAgo = '$months months ago';
      }

      return (time: timeAgo, previusYear: false);
    } else {
      return (previusYear: true, time: '');
    }
  }
}
