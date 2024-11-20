import 'package:citypressgo/common/extension/tklmn.dart';
import 'package:citypressgo/screens/other_screens/dashboard/dashboard.dart';
import 'package:citypressgo/screens/other_screens/internet.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'config.dart';
import 'controllers/other_controller/ad_controller.dart';
import 'controllers/other_controller/notification_controller.dart';

void main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  RequestConfiguration configuration =
  RequestConfiguration(testDeviceIds: ['BA8E705C106E7DCFBC1D0087AC2D6231','33BE2250B43518CCDA7DE426D04EE231']);

  MobileAds.instance.updateRequestConfiguration(configuration);

  await Firebase.initializeApp();
  Get.put(AdController());
  Get.put(CustomNotificationController());
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    lockScreenPortrait();

    return GetMaterialApp(
        themeMode: ThemeService().theme,
        theme: AppTheme.fromType(ThemeType.light).themeData,
        darkTheme: AppTheme.fromType(ThemeType.dark).themeData,
        locale: const Locale('en', 'US'),
        translations: Language(),
        fallbackLocale: const Locale('en', 'US'),
        home:  const CallFunc(),
        title: appFonts.CityPressGo,
        getPages: appRoute.getPages,
        debugShowCheckedModeBanner: false);
  }

  lockScreenPortrait() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }
}

