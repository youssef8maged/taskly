import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Today extends StatefulWidget {
  const Today({
    super.key,
  });

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  late final Stream<DateTime> _timeStream;

  @override
  void initState() {
    super.initState();
    _timeStream =
        Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(DateFormat('MMMM d, y').format(DateTime.now()),
            style: theme.textTheme.titleLarge),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "Today",
              style: theme.textTheme.headlineSmall,
            ),
            const SizedBox(width: 10),
            StreamBuilder<DateTime>(
              stream: _timeStream,
              builder: (BuildContext contextStream, AsyncSnapshot<DateTime> snapshot) {
                if (snapshot.hasData) {
                  final DateTime time = snapshot.data!;
                  final String formattedTime =
                        DateFormat('HH:mm:ss').format(time);
                  return Text(
                    formattedTime,
                    style: Theme.of(contextStream).textTheme.bodyLarge,
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            )
          ],
        )
      ],
    );
  }
}
