import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos_docteur/constants/style.dart';
import 'package:sos_docteur/index.dart';
import 'package:sos_docteur/screens/auth_screen.dart';
import 'package:sos_docteur/widgets/client_schedule_card.dart';
import 'package:sos_docteur/widgets/user_session_widget.dart';

import 'page_schedule_detail_view.dart';

class PatientSchedulePage extends StatefulWidget {
  @override
  _PatientSchedulePageState createState() => _PatientSchedulePageState();
}

class _PatientSchedulePageState extends State<PatientSchedulePage>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  double position = 0;
  TabController controller;

  @override
  void initState() {
    super.initState();
    controller = TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("patient_id").toString(),
      scaffold: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/shapes/bg3p.png"),
                  fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(.8), Colors.white54],
                stops: const [0.1, 0.9],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
                child: NotificationListener(
              onNotification: (n) {
                if (n is ScrollEndNotification) {
                  setState(() {
                    position = _scrollController.position.pixels;
                  });
                }
                return true;
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 15.0),
                    child: _header(),
                  ),
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          tabHeader(),
                          tabBody(),
                        ],
                      ),
                    ),
                  ),
                  /*Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 15.0),
                      child: _header(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 20.0, top: 5.0, right: 16.0, left: 16.0),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width,
                              child: RaisedButton(
                                elevation: 10.0,
                                color: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: Text(
                                  "Tout",
                                  style: GoogleFonts.lato(color: Colors.white),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Flexible(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40.0,
                              child: RaisedButton(
                                elevation: 10.0,
                                color: Colors.white.withOpacity(.7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  "Récents",
                                  style: GoogleFonts.lato(
                                    color: Colors.blue[900],
                                  ),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: patientController.meetings.isEmpty
                            ? Center(
                                child: Lottie.asset(
                                    "assets/lotties/10002-empty-notification.json"),
                              )
                            : _listSchedule(context),
                      ),
                    )
                  
                  */
                ],
              ),
            )),
          ),
        ),
        floatingActionButton: position > 40
            ? FloatingActionButton(
                onPressed: () {
                  _scrollController.animateTo(
                    0.0,
                    curve: Curves.easeOut,
                    duration: const Duration(milliseconds: 300),
                  );
                },
                tooltip: 'Back to top',
                child: const Icon(
                  CupertinoIcons.arrow_up,
                  color: Colors.white,
                ))
            : null,
      ),
    );
  }

  Widget tabBody() {
    return Expanded(
      child: Container(
        child: TabBarView(
          physics: const BouncingScrollPhysics(),
          controller: controller,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: patientController.meetings.isEmpty
                  ? Center(
                      child: Lottie.asset(
                          "assets/lotties/10002-empty-notification.json"),
                    )
                  : _listSchedule(context),
            ),
            Center(
              child: Text("Pas prêt !"),
            ),
          ],
        ),
      ),
    );
  }

  Widget tabHeader() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
          color: primaryColor.withOpacity(.4),
          borderRadius: BorderRadius.circular(30.0)),
      margin: const EdgeInsets.symmetric(horizontal: 15.0),
      child: TabBar(
        controller: controller,
        indicatorSize: TabBarIndicatorSize.tab,
        indicator: BubbleTabIndicator(
          indicatorHeight: 47.0,
          indicatorColor: primaryColor,
          tabBarIndicatorSize: TabBarIndicatorSize.label,
          indicatorRadius: 30,
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white,
        labelStyle: GoogleFonts.mulish(
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
        unselectedLabelStyle: GoogleFonts.mulish(
          fontSize: 15,
          fontWeight: FontWeight.w400,
        ),
        tabs: [
          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    const Text("En cours"),
                  ],
                ),
              ],
            ),
          ),
          Tab(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.calendar,
                      size: 16.0,
                    ),
                    SizedBox(
                      width: 8.0,
                    ),
                    const Text("Antérieures"),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Container(
                height: 35.0,
                width: 35.0,
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(.3),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: const Center(
                  child: Icon(
                    CupertinoIcons.back,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Mes Rendez-vous",
              style: style1(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 18.0),
            )
          ],
        ),
        if (storage.read("isPatient") == true)
          UserSession()
        else
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                  type: PageTransitionType.leftToRightWithFade,
                  alignment: Alignment.topCenter,
                  child: AuthScreen(),
                ),
              );
            },
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(
                      CupertinoIcons.person_circle_fill,
                      color: primaryColor,
                      size: 18.0,
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                    Text(
                      "Se connecter",
                      style: style1(
                        fontWeight: FontWeight.w700,
                        color: primaryColor,
                      ),
                    )
                  ],
                )),
          ),
      ],
    );
  }

  Widget _listSchedule(context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10.0),
      controller: _scrollController,
      physics: const BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: patientController.meetings.length,
      itemBuilder: (context, index) {
        var data = patientController.meetings[index];
        return ClientScheduleCard(
          data: data,
          onPressed: () {
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.leftToRightWithFade,
                alignment: Alignment.topCenter,
                child: PageScheduleDetailView(
                  data: data,
                ),
              ),
            );
          },
          onCancelled: () async {
            XDialog.show(
                context: context,
                icon: Icons.help,
                title: "Annulation rdv!",
                content:
                    "Etes-vous sûr de vouloir annuler votre rendez-vous avec le Dr. ${data.medecin.nom} ?",
                onValidate: () async {
                  Xloading.showLottieLoading(context);
                  var res = await PatientApi.annulerRdvEnLigne(
                      consultId: data.consultationRdvId);
                  if (res != null) {
                    Xloading.dismiss();
                    XDialog.showSuccessAnimation(context);
                    patientController.refreshDatas();
                  } else {
                    Xloading.dismiss();
                    XDialog.showErrorMessage(context,
                        title: "Echec!",
                        color: Colors.amber[900],
                        message:
                            "Echec de traitement de votre annulation,\nveuillez reéssayer svp!");
                  }
                });
          },
        );
      },
    );
  }
}
