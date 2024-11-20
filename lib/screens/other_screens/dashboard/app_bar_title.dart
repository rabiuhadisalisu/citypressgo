
import '../../../config.dart';

class AppBarTitle extends StatelessWidget {
  final String? appName,appLogo;
  final int? index;
  const AppBarTitle({super.key, this.appName, this.appLogo, this.index});

  @override
  Widget build(BuildContext context) {
    return  Text(index == 0
        ? appFonts.search.tr
        : index == 1
        ? appFonts.home.tr
        : appFonts.settings.tr)
        .textColor(appCtrl.appTheme.black)
        .fontSize(FontSizes.f20)
        .fontWeight(FontWeight.w600).fontFamily(GoogleFonts.readexPro().fontFamily!).marginSymmetric(horizontal: Insets.i10);
  }
}
