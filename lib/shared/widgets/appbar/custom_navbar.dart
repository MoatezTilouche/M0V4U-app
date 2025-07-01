import 'package:app_m0v4u/constants/assets.dart';
import 'package:app_m0v4u/constants/styles.dart';
import 'package:app_m0v4u/shared/widgets/animations/animation_navigator.dart';
import 'package:app_m0v4u/ui/auth/views/profil_screen.dart';
import 'package:app_m0v4u/ui/chat_bot_screen/views/chat_bot_screen.dart';
import 'package:app_m0v4u/ui/home_screen/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../ui/mainScreen/main_screen.dart';
import 'navbar_provider.dart';

class CustomNavBar extends StatefulWidget implements PreferredSizeWidget {
  final bool isBackButtonShown;

  const CustomNavBar({super.key, this.isBackButtonShown = true});

  @override
  State<CustomNavBar> createState() => _CustomNavBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomNavBarState extends State<CustomNavBar> {
  late final NavBarState navState;

  @override
  void initState() {
    super.initState();
    navState = context.read<NavBarState>();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NavBarState>(
      builder: (context, navState, _) {
        return AppBar(
          leadingWidth: !widget.isBackButtonShown ? 120 : 56,
          backgroundColor: AppStyles.secondaryColor,
          leading: widget.isBackButtonShown
              ? IconButton(
                  icon: Image.asset(
                    Assets.prevIcon,
                    height: 35.0,
                    width: 35.0,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                   Image.asset(
                      Assets.appLogoIcon,
                      height: 35.0,
                      width: 35.0,
                    ),

                  const SizedBox(width: 8),
                  const Text(
                    'M0V4U',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
          title: !widget.isBackButtonShown
              ? SizedBox.shrink()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: (){
                        AnimatedNavigator.pushZoomIn(context,MainScreen());

                      },
                      icon: Image.asset(
                        Assets.appLogoIcon,
                        height: 35.0,
                        width: 35.0,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'M0V4U',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
          actions: [
            IconButton(
              icon: Image.asset(
                Assets.chatBotAppbar,
                height: 35.0,
                width: 35.0,
              ),
              onPressed: () {
                AnimatedNavigator.pushZoomIn(context, ChatBotScreen());
              },
            ),
            IconButton(
              icon: Image.asset(
                Assets.userIcon,
                height: 35.0,
                width: 35.0,
                fit: BoxFit.cover,
              ),
              onPressed: () {
                AnimatedNavigator.pushZoomIn(context, ProfileScreen());

              },
            ),
          ],
        );
      },
    );
  }
}
