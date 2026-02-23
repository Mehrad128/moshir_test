import 'package:flutter/material.dart';
import 'package:moshir_test/main.dart';

class PageTitle extends StatelessWidget {
  const PageTitle({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Text("صفحه اصلی", style: Theme.of(context).textTheme.headlineSmall);
  }
}

class ShowTopMessage {
  void showTopMessage(BuildContext context) {
    final overlay = Overlay.of(context);
    String currentTime = MyApp().getTime();

    final entry = OverlayEntry(
      builder: (_) => Positioned(
        top: 50,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "You are in Home page \n $currentTime",
              style: const TextStyle(color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );

    overlay.insert(entry);

    Future.delayed(const Duration(seconds: 1), () {
      entry.remove();
    });
  }
}
