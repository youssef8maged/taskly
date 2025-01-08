import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo/Logic/my_db.dart';
import 'package:todo/Logic/my_notification.dart';
import 'package:todo/Logic/my_work_manager.dart';
import 'package:todo/Home%20Screen/home_screen.dart';

class Splashing extends StatefulWidget {
  const Splashing({super.key});

  @override
  State<Splashing> createState() => _SplashingState();
}

class _SplashingState extends State<Splashing>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  final Duration animationDuration = const Duration(seconds: 2);
  
  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: animationDuration, 
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _controller.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) async {
      await Future.delayed(animationDuration);
      await inizializeApp();
    });
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset("pics/todo_icon.png"),
          ),
        ),
      ),
    );
  }

  Future<void> inizializeApp() async {
    await MyDb().initDB();
    await MyNotification().initNotification();

    final NotificationAppLaunchDetails? notificationAppLaunchDetails =
        await MyNotification().getNotificationDetails();

    await MyWorkManager().initWorkManager();

    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return HomeScreen(
              notificationAppLaunchDetails: notificationAppLaunchDetails,
            );
          },
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            Animatable<Offset> tween = Tween(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: Curves.easeInOut));
            Animation<Offset> offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
          transitionDuration: const Duration(seconds: 1),
        ),
      );
    }
  }


}
