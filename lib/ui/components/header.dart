import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/cupertino.dart';
import 'package:moshir_test/main.dart';
import 'package:moshir_test/test/test_firebase_page.dart';
import 'package:moshir_test/ui/screens/lazy_loading.dart';
import 'package:moshir_test/ui/screens/settings.dart';
import 'package:moshir_test/ui/screens/user_profile.dart';

class Header extends StatelessWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const _HeaderMenuButton(),
        Text("صفحه اصلی", style: Theme.of(context).textTheme.headlineSmall),
        const _HeaderBackButton(),
      ],
    );
  }
}

class _HeaderMenuButton extends StatelessWidget {
  const _HeaderMenuButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  'پروفایل',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserProfileState()),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'تنظیمات',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Firebase Test BTN',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => TestFirebasePage()),
                  // );
                },
              ),
              CupertinoActionSheetAction(
                child: Text(
                  'Lazy Load API',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LazyLoadingPage()),
                  );
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'لغو',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
      },
      child: SvgPicture.asset("assets/images/More.svg"),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton();

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _showTopMessage(context);
        String currentTime = MyApp().getTime();
        String currentDate = MyApp().getDate();
        showCupertinoModalPopup(
          context: context,
          builder: (context) => CupertinoActionSheet(
            actions: [
              CupertinoActionSheetAction(
                child: Text(
                  'Current Time: $currentTime \n Current Date: $currentDate',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              child: Text(
                'برگشت',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        );
        // Navigator.pop(context);
      },
      onLongPress: () {},
      child: SvgPicture.asset("assets/images/Arrow.svg"),
      // width: 24,
      // height: 24,
    );
  }

  void _showTopMessage(BuildContext context) {
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

              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w100,
                fontSize: 20,
              ),
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
