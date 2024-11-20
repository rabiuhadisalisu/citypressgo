
import 'package:goapp/screens/other_screens/dashboard/bottom_nav.dart';
import 'package:goapp/screens/other_screens/dashboard/dash_app_bar.dart';
import 'package:goapp/widgets/directionality_rtl.dart';
import '../../../config.dart';

class Dashboard extends StatelessWidget {
  final dashboardCtrl = Get.put(DashboardController());

  Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(builder: (dashboardCtrl) {
      return PopScope(
          canPop: false,
          onPopInvoked: (didPop) async {
            if (didPop) {
              // If back navigation was allowed, do nothing.
              return;
            }

            // If it was not allowed, do this
            final NavigatorState navigator = Navigator.of(context);
            final bool? shouldPop = await dashboardCtrl.onBackPressed(context);
            if (shouldPop ?? false) {
              navigator.pop();
            }
          },
          child: DirectionalityRtl(
              child: Scaffold(
                  backgroundColor: appCtrl.appTheme.backgroudColor,
                  appBar: appCtrl.isAppBar
                      ? const DashboardAppBar()
                      : null,
                  body: dashboardCtrl
                      .bottomBarPages[dashboardCtrl.maxCount],
                  bottomNavigationBar: const BottomNav())));
    });
  }
}
