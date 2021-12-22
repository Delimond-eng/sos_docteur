import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:shimmer/shimmer.dart';

import 'data_connection_screen.dart';
import 'index.dart';
import 'screens/home_screen.dart';
import 'screens/home_screen_for_medecin.dart';
import 'services/db_service.dart';
import 'utilities/config.dart';
import 'video_calls/permissions.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isMedecin = storage.read("isMedecin") ?? false;

  StreamSubscription<DataConnectionStatus> listener;

  @override
  void initState() {
    super.initState();
    initLoading();
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  Future<void> initLoading() async {
    await handleCameraAndMic(Permission.camera);
    await handleCameraAndMic(Permission.microphone);
    await DBService.initDb();
    if (isMedecin) {
      await medecinController.refreshDatas();
      await Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            alignment: Alignment.topCenter,
            child: MedecinHomeScreen(),
          ),
          (Route<dynamic> route) => false);
      return;
    } else {
      await patientController.refreshDatas();
      await Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.leftToRightWithFade,
            alignment: Alignment.topCenter,
            child: HomeScreen(),
          ),
          (Route<dynamic> route) => false);
      return;
    }
    /*listener = DataConnectionChecker().onStatusChange.listen((status) async {
      if (status == DataConnectionStatus.connected) {
        
      } else {
        await Navigator.pushAndRemoveUntil(
          context,
          PageTransition(
            type: PageTransitionType.bottomToTop,
            child: DataConnectionScreen(),
          ),
          (Route<dynamic> route) => false,
        );
      }
    });*/
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/shapes/cap7.png"),
                fit: BoxFit.fill)),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black87.withOpacity(.8), primaryColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    height: 100,
                    width: 100.0,
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        const BoxShadow(
                          color: Colors.black38,
                          blurRadius: 12.0,
                          offset: Offset(0, 3),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(8.0),
                    child: const Center(
                      child: SpinKitWave(
                        color: Colors.white,
                        duration: Duration(seconds: 1),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.lato(
                            fontSize: 20.0,
                            color: Colors.white,
                            shadows: [
                              const Shadow(
                                  color: Colors.black26,
                                  blurRadius: 10.0,
                                  offset: Offset(0, 2))
                            ],
                          ),
                          children: <TextSpan>[
                            TextSpan(
                              text: 'SOS',
                              style: GoogleFonts.lato(
                                letterSpacing: 1.20,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const TextSpan(text: "  "),
                            TextSpan(
                              text: 'docteur',
                              style: GoogleFonts.lato(
                                fontWeight: FontWeight.w900,
                                color: Colors.blue[800],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Shimmer(
                    direction: ShimmerDirection.ltr,
                    enabled: true,
                    gradient: LinearGradient(
                      colors: [
                        Colors.blue[700],
                        Colors.white,
                      ],
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: 5.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        gradient: LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.blue[700],
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
