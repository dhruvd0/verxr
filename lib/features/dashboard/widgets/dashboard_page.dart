import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:provider/provider.dart';
import 'package:verxr/config/common/icons.dart';
import 'package:verxr/config/theme.dart';
import 'package:verxr/features/dashboard/navigation/provider/dashboard_nav_provider.dart';
import 'package:verxr/features/dashboard/pages/home/widgets/home_page.dart';
import 'package:verxr/features/dashboard/pages/profile/profile_page.dart';
import 'package:verxr/features/dashboard/pages/settings/settings_page.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);
  static const String routeName = 'dashboardPage';
  final List<Widget> pages = const [HomePage(), ProfilePage(), SettingsPage()];
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => DashboardNavigationProvider(),
      child: Consumer<DashboardNavigationProvider>(
        builder: (context, navigator, child) {
          return Scaffold(
            body: pages[navigator.currentPageIndex],
            bottomNavigationBar: CurvedNavigationBar(
              index: navigator.currentPageIndex,
              animationCurve: Curves.ease,
              height: 50,
              onTap: navigator.changePageIndex,
              animationDuration: const Duration(milliseconds: 200),
              backgroundColor: Colors.white,
              items: [
                Column(
                  children: [
                    const Iconify(
                      homePageIcon,
                      size: 30,
                    ),
                    Text(
                      'Home',
                      style: getTextTheme(context).bodyText2,
                    )
                  ],
                ),
                Column(
                  children: [
                    const Icon(
                      Icons.person,
                      size: 30,
                    ),
                    Text(
                      'Profile',
                      style: getTextTheme(context).bodyText2,
                    )
                  ],
                ),
                Column(
                  children: [
                    const Icon(Icons.settings),
                    Text(
                      'Settings',
                      style: getTextTheme(context).bodyText2,
                    )
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
