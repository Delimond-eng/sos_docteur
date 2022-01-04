import 'dart:convert';
import 'dart:ui';

import 'package:badges/badges.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shimmer/shimmer.dart';
import 'package:sos_docteur/constants/controllers.dart';
import 'package:sos_docteur/constants/style.dart';
import 'package:sos_docteur/models/configs_model.dart';
import 'package:sos_docteur/models/inernal_data_model.dart';
import 'package:sos_docteur/models/patients/home_model.dart';
import 'package:sos_docteur/pages/patient/doctor_detail_page.dart';
import 'package:sos_docteur/pages/patient/patient_examens_page.dart';
import 'package:sos_docteur/pages/patient/patient_schedule_page.dart';
import 'package:sos_docteur/screens/auth_screen.dart';
import 'package:sos_docteur/screens/widgets/custom_header_widget7.dart';
import 'package:sos_docteur/screens/widgets/doctor_card.dart';
import 'package:sos_docteur/screens/widgets/speciality_card_widget.dart';
import 'package:sos_docteur/services/db_service.dart';
import 'package:sos_docteur/utilities/utilities.dart';

import 'package:sos_docteur/widgets/bottom_menu_btn.dart';
import 'package:sos_docteur/widgets/menu_item_widget.dart';

import '../index.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey();

  bool isConnected = storage.read("isPatient") ?? false;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  String uid = storage.read('patient_id').toString();

  String searchType = "Domaine médical";
  String selectedSpeech = "Français";

  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return PickupLayout(
      uid: uid,
      scaffold: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _globalKey,
          resizeToAvoidBottomInset: false,
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/shapes/bg4p.png"),
                  fit: BoxFit.cover),
            ),
            child: Container(
              decoration: const BoxDecoration(color: Colors.white30),
              child: Obx(
                () {
                  return SafeArea(
                    child: Column(
                      children: [
                        Header1(
                          onOpenMenu: () {
                            if (isConnected) {
                              _globalKey.currentState.openDrawer();
                            } else {
                              XDialog.show(
                                context: context,
                                icon: Icons.info_rounded,
                                content:
                                    "vous devez vous connectez à votre compte pour avoir le droit de parcourir le menu !",
                                title: "Connectez-vous",
                                onValidate: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                      type: PageTransitionType
                                          .leftToRightWithFade,
                                      alignment: Alignment.topCenter,
                                      child: AuthScreen(),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          onLoggedIn: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                type: PageTransitionType.rightToLeftWithFade,
                                child: AuthScreen(),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15.0, bottom: 10.0),
                          child: _searchBar(), //SearchInput(),
                        ),
                        Expanded(
                          child: Scrollbar(
                            hoverThickness: 5.0,
                            radius: const Radius.circular(5.0),
                            child: ListView(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(bottom: 20.0),
                              physics: const ScrollPhysics(),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 15.0,
                                    right: 15.0,
                                  ),
                                  child: _banner(),
                                ),
                                if (patientController
                                    .currentMedecins.isNotEmpty)
                                  Container(
                                    height: 250.0,
                                    child: ListView.builder(
                                      itemCount: patientController
                                          .currentMedecins.length,
                                      padding: const EdgeInsets.only(
                                          left: 15, bottom: 10.0),
                                      scrollDirection: Axis.horizontal,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        var medecin = patientController
                                            .currentMedecins[index];
                                        return CurrentMedCard(
                                          medecin: medecin,
                                          onPressed: () async {
                                            /*Xloading.showLottieLoading(context);
                                            var mDatas = await PatientApi
                                                .viewMedecinProfil(
                                                    medecin.medecinId);
                                            Xloading.dismiss();
                                            HomeMedecins m = HomeMedecins(
                                              cote: int.parse(medecin.cote),
                                              nom: medecin.nom,
                                              photo: medecin.photo,
                                              medecinId: medecin.medecinId,
                                              specialites: [],
                                            );
                                            Navigator.push(
                                              context,
                                              PageTransition(
                                                type: PageTransitionType
                                                    .leftToRightWithFade,
                                                alignment: Alignment.topCenter,
                                                child: DoctorDetailPage(
                                                  profil:
                                                      mDatas.content.profile,
                                                  supDatas: m,
                                                ),
                                              ),
                                            );*/
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, top: 10.0, right: 15.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            "assets/icons/medicine-sign.svg",
                                            height: 20.0,
                                            width: 20.0,
                                            fit: BoxFit.scaleDown,
                                          ),
                                          const SizedBox(
                                            width: 5.0,
                                          ),
                                          Text(
                                            "Spécialités",
                                            style: GoogleFonts.lato(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 17.0,
                                              letterSpacing: 1.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Btn(
                                        onPressed: () async {
                                          Xloading.showLottieLoading(context);
                                          var datas = await PatientApi
                                              .viewHomeContents();
                                          if (datas != null) {
                                            Xloading.dismiss();

                                            patientController.platformMedecins
                                                .value = datas.content.medecins;
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  height:
                                      MediaQuery.of(context).size.height * .12,
                                  child: ListView.builder(
                                    itemCount:
                                        patientController.specialities.length,
                                    physics: const BouncingScrollPhysics(),
                                    scrollDirection: Axis.horizontal,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 15.0,
                                      vertical: 10.0,
                                    ),
                                    shrinkWrap: true,
                                    // ignore: missing_return
                                    itemBuilder: (context, index) {
                                      var data =
                                          patientController.specialities[index];
                                      return SpecialityCard(
                                        title: data.specialite,
                                        icon:
                                            "assets/icons/doctor-trichologist.svg",
                                        isActive: data.isActive,
                                        onPressed: () async {},
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  height: 10.0,
                                ),
                                Container(
                                  width: _size.width,
                                  padding: const EdgeInsets.only(bottom: 50.0),
                                  child: medecinsListView(),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          bottomSheet: (isConnected)
              ? Container(
                  height: 60,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BottomMenuBtn(
                        icon: Icon(
                          CupertinoIcons.house_fill,
                          size: 15.0,
                          color: primaryColor,
                        ),
                        label: "Acceuil      ",
                        onPressed: () {
                          FlutterRingtonePlayer.stop();
                        },
                        isActive: true,
                      ),
                      BottomMenuBtn(
                        icon: Badge(
                          badgeContent: Obx(() {
                            return Text('${patientController.meetings.length}',
                                style: style1(color: Colors.white));
                          }),
                          position: const BadgePosition(top: -12, end: -10),
                          child: const Icon(CupertinoIcons.calendar,
                              size: 15.0, color: Colors.grey),
                        ),
                        label: "Rendez-vous    ",
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.rightToLeftWithFade,
                              child: PatientSchedulePage(),
                            ),
                          );
                        },
                      ),
                      BottomMenuBtn(
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              type: PageTransitionType.bottomToTop,
                              child: PatientExamenPage(),
                            ),
                          );
                        },
                        icon: const Icon(
                          CupertinoIcons.doc_plaintext,
                          size: 18.0,
                          color: Colors.grey,
                        ),
                        label: "Mes examens",
                      ),
                    ],
                  ),
                )
              : null,
          drawer: Drawer(
            elevation: 0,
            child: SideMenu(),
          ),
        ),
      ),
    );
  }

  Widget medecinsListView() {
    return FutureBuilder(
      future: patientController.medecinsList,
      builder: (context, AsyncSnapshot<List<HomeMedecins>> snapshot) {
        if (snapshot.data == null) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Shimmer.fromColors(
              direction: ShimmerDirection.ltr,
              baseColor: Colors.grey[500],
              highlightColor: Colors.grey[100],
              enabled: true,
              child: Column(
                children: [
                  for (int i = 0; i < 8; i++) ...[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: Row(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          const SizedBox(
                            width: 20.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 30,
                                width: 200,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: 10,
                                width: 200,
                                color: Colors.white,
                              ),
                              const SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                height: 6,
                                width: 100.0,
                                color: Colors.white,
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]
                ],
              ),
            ),
          );
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              var medecin = snapshot.data[index];
              return MedCard(
                medecin: medecin,
                onPressed: () async {
                  Xloading.showLottieLoading(context);
                  var mDatas =
                      await PatientApi.viewMedecinProfil(medecin.medecinId);
                  String o = medecin.photo.length > 100 ? medecin.photo : "";
                  String s = medecin.specialites.isNotEmpty
                      ? medecin.specialites[0].specialite
                      : "aucune spécialité";
                  IMedecins current = IMedecins(
                    medecinId: medecin.medecinId,
                    nom: medecin.nom,
                    photo: o,
                    specialite: s,
                    cote: medecin.cote.toString(),
                  );
                  await DBService.insertNewMedecin(
                    medecin: current,
                    where: medecin.medecinId,
                  );
                  Xloading.dismiss();
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.leftToRightWithFade,
                      alignment: Alignment.topCenter,
                      child: DoctorDetailPage(
                        profil: mDatas.content.profile,
                        supDatas: medecin,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }

  Widget _banner() {
    return Container(
      height: MediaQuery.of(context).size.height * .2,
      margin: const EdgeInsets.only(bottom: 20.0, top: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/vector/undraw_medicine_b1ol.png"),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(10.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.4),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(.4),
              blurRadius: 12.0,
              offset: const Offset(0, 3),
            )
          ],
          gradient: LinearGradient(
            colors: [
              Colors.blue[900].withOpacity(.8),
              Colors.cyan.withOpacity(.8)
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Shimmer.fromColors(
                enabled: true,
                baseColor: Colors.white,
                highlightColor: Colors.cyan,
                child: RichText(
                  text: TextSpan(
                    text:
                        "Bienvenu ${(storage.read('patient_name') != null) ? storage.read('patient_name') : ''} sur ",
                    style: GoogleFonts.lato(
                      fontSize: 17.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      shadows: [
                        const Shadow(
                          color: Colors.black26,
                          blurRadius: 10.0,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: 'SOS',
                        style: GoogleFonts.lato(
                          letterSpacing: 1.20,
                          fontWeight: FontWeight.w900,
                          color: Colors.cyan[100],
                        ),
                      ),
                      const TextSpan(text: "  "),
                      TextSpan(
                        text: 'Docteur',
                        style: GoogleFonts.lato(
                          fontWeight: FontWeight.w900,
                          color: Colors.cyan[100],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              Text(
                "Bienvenue sur SOS Docteur la plateforme de télé consultation qui vous permet d'être en contact permanent et en toute confidentialité avec les spécialistes de santé !",
                style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return Container(
      padding: const EdgeInsets.only(left: 10.0),
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 12.0,
            offset: const Offset(0, 10),
          )
        ],
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Row(
        children: [
          Flexible(
            child: TypeAheadField<dynamic>(
              debounceDuration: const Duration(milliseconds: 500),
              textFieldConfiguration: TextFieldConfiguration(
                autofocus: false,
                controller: _searchController,
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.only(top: 14, bottom: 10, left: 10),
                  hintText: "Recherche...",
                  hintStyle:
                      GoogleFonts.lato(color: Colors.grey[400], fontSize: 16),
                  suffixIcon: Container(
                    height: 50,
                    width: 120.0,
                    padding: const EdgeInsets.only(right: 5),
                    child: DropdownButton<String>(
                      menuMaxHeight: 300,
                      dropdownColor: Colors.white,
                      alignment: Alignment.centerRight,
                      borderRadius: BorderRadius.circular(4.0),
                      style: GoogleFonts.lato(color: Colors.black),
                      value: selectedSpeech,
                      underline: SizedBox(),
                      hint: Text(
                        "Langue",
                        style: GoogleFonts.mulish(
                            color: Colors.grey[600],
                            fontSize: 15.0,
                            fontStyle: FontStyle.italic),
                      ),
                      isExpanded: true,
                      items: [
                        "Français",
                        "Anglais",
                      ].map((e) {
                        return DropdownMenuItem<String>(
                            value: e,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(5),
                                    height: 20.0,
                                    width: 20.0,
                                    color: primaryColor,
                                    child: Icon(
                                      CupertinoIcons.location,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 5.0,
                                  ),
                                  Text(
                                    truncateString(e, 8),
                                    style: GoogleFonts.lato(
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSpeech = value;
                        });
                      },
                    ),
                  ),
                  border: InputBorder.none,
                  counterText: '',
                ),
              ),
              suggestionsCallback: (pattern) async {
                return getSpecialities(pattern);
              },
              suggestionsBoxDecoration:
                  const SuggestionsBoxDecoration(elevation: 0.0),
              getImmediateSuggestions: false,
              hideOnEmpty: true,
              itemBuilder: (context, suggestion) {
                return ListTile(
                  focusColor: Colors.blue[200],
                  leading: Container(
                    height: 40.0,
                    width: 40.0,
                    padding: const EdgeInsets.all(10.0),
                    child: SvgPicture.asset(
                      "assets/icons/filter1.svg",
                      color: primaryColor,
                    ),
                  ),
                  title: Text(
                    suggestion.specialite,
                    style: GoogleFonts.lato(fontWeight: FontWeight.w400),
                  ),
                );
              },
              onSuggestionSelected: (suggestion) async {
                _searchController.text = suggestion.specialite;
              },
              noItemsFoundBuilder: (context) => Container(
                height: 120.0,
                child: Center(
                  child: Text(
                    "Pas trouvé !",
                    style: style1(
                        color: Colors.red,
                        fontWeight: FontWeight.w800,
                        fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: 50.0,
            width: 60.0,
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(5.0),
              ),
            ),
            child: Material(
              borderRadius: const BorderRadius.horizontal(
                right: Radius.circular(5.0),
              ),
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.horizontal(
                  right: Radius.circular(5.0),
                ),
                onTap: () async {
                  Xloading.showLottieLoading(context);
                  var found = await PatientApi.searchContents(
                    langue: selectedSpeech,
                    specialite: _searchController.text,
                  );
                  Xloading.dismiss();
                  if (found != null) {
                    print(found.content.medecins[0].nom);
                    patientController.platformMedecins.value =
                        found.content.medecins;
                  }
                },
                child: const Center(
                  child: Icon(CupertinoIcons.search, color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  List<Specialites> getSpecialities(String query) {
    List<Specialites> matches = List();
    matches.addAll(patientController.specialities);
    matches.retainWhere(
        (s) => s.specialite.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> getSpeechs(String query) {
    List<String> matches = List();
    List<String> speechs = [
      "Français",
      "Anglais",
      "Lingala",
      "Swahili",
      "Tshiluba",
      "Kikongo",
    ];
    matches.addAll(speechs);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
}

class FilterBtn extends StatelessWidget {
  final String icon;
  final String title;
  final Function onPressed;
  const FilterBtn({
    Key key,
    this.icon,
    this.title,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.1),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: onPressed,
          child: Center(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SvgPicture.asset(
                    "assets/icons/$icon",
                    height: 20.0,
                    width: 20.0,
                  ),
                ),
                Text(title),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Btn extends StatelessWidget {
  final Function onPressed;
  const Btn({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.2),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(5.0),
          splashColor: Colors.cyan[200],
          onTap: onPressed,
          child: Container(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: const Text("Voir tout"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CurrentMedCard extends StatelessWidget {
  const CurrentMedCard({
    Key key,
    @required this.medecin,
    this.onPressed,
  }) : super(key: key);

  final IMedecins medecin;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 150.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                    blurRadius: 12.0,
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(0, 3))
              ],
            ),
            width: 200.0,
            margin: const EdgeInsets.only(right: 15.0),
            child: Padding(
              padding:
                  const EdgeInsets.only(top: 60.0, left: 15.0, right: 15.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      'Dr. ${medecin.nom}',
                      style:
                          style1(fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                  ),
                  Flexible(
                    child: Text(medecin.specialite,
                        style: style1(
                            color: Colors.grey, fontWeight: FontWeight.w400)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RatingBar.builder(
                        initialRating: int.parse(medecin.cote).toDouble(),
                        minRating: 1,
                        direction: Axis.horizontal,
                        itemSize: 13.0,
                        allowHalfRating: false,
                        ignoreGestures: true,
                        unratedColor: Colors.transparent,
                        itemCount: 5,
                        itemPadding:
                            const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.orange.withOpacity(.7),
                        ),
                        updateOnDrag: false,
                        onRatingUpdate: (double value) {},
                      ),
                      Flexible(
                        // ignore: deprecated_member_use
                        child: FlatButton(
                          color: Colors.grey[100],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          onPressed: onPressed,
                          child: Icon(Icons.arrow_right_alt_rounded,
                              color: primaryColor),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          left: 5.0,
          right: 5.0,
          child: Container(
            height: 120.0,
            width: 150.0,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12.0,
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(20.0),
                gradient: LinearGradient(colors: [primaryColor, Colors.cyan])),
            margin: const EdgeInsets.only(right: 15.0),
            child: medecin.photo.length > 200
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 12.0,
                          color: Colors.grey.withOpacity(.3),
                          offset: const Offset(0, 3),
                        )
                      ],
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: MemoryImage(
                          base64Decode(medecin.photo),
                        ),
                      ),
                    ),
                  )
                : const Center(
                    child: Icon(
                      CupertinoIcons.person_fill,
                      color: Colors.white,
                      size: 40.0,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

class SideMenu extends StatelessWidget {
  final String userName =
      (storage.read("isPatient") == true && storage.read("isPatient") != null)
          ? storage.read("patient_name")
          : "Non connecté";
  final String userEmail =
      storage.read("patient_email") ?? "veuillez vous connecter";
  final bool isConnected = storage.read("isPatient") ?? false;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/shapes/bg10.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(color: Colors.black.withOpacity(.8)),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 30.0),
          physics: const ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100.0,
                width: 100.0,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                    gradient:
                        LinearGradient(colors: [Colors.cyan, primaryColor]),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(.4),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3),
                      )
                    ],
                    shape: BoxShape.circle),
                child: Center(
                  child: (userName != null)
                      ? Text(
                          userName.substring(0, 1).toUpperCase(),
                          style: GoogleFonts.lato(
                            fontSize: 35.0,
                            fontWeight: FontWeight.w900,
                          ),
                        )
                      : Icon(
                          CupertinoIcons.person,
                          size: 30,
                          color: Colors.white,
                        ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                userName.capitalizeFirst,
                style: style1(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 5.0),
              Text(userEmail,
                  style: style1(
                      color: Colors.cyan[100],
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400)),
              const SizedBox(height: 20.0),
              Divider(
                color: Colors.cyan.withOpacity(.4),
                thickness: 0.5,
                indent: 50.0,
                endIndent: 50.0,
              ),
              const SizedBox(height: 30.0),
              MenuItem(
                icon:
                    const Icon(CupertinoIcons.person_fill, color: Colors.cyan),
                label: 'Mon profil',
                onPressed: () {
                  Get.back();
                },
              ),
              MenuItem(
                icon: Badge(
                  badgeContent: Obx(() {
                    return Text(
                      '${patientController.meetings.length}',
                      style: style1(color: Colors.white),
                    );
                  }),
                  child:
                      const Icon(CupertinoIcons.calendar, color: Colors.cyan),
                ),
                label: 'Mes rendez-vous',
                onPressed: () {
                  Get.back();
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: PatientSchedulePage(),
                    ),
                  );
                },
              ),
              MenuItem(
                icon: const Icon(CupertinoIcons.doc_plaintext,
                    color: Colors.cyan),
                label: 'Mes examens',
                onPressed: () {
                  Get.back();
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeftWithFade,
                      child: PatientExamenPage(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20.0),
              Divider(
                color: Colors.cyan.withOpacity(.4),
                thickness: 0.5,
                indent: 50.0,
                endIndent: 50.0,
              ),
              MenuItem(
                icon: const Icon(CupertinoIcons.info, color: Colors.cyan),
                label: 'Aide',
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Banner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow: Overflow.visible,
      children: [
        Container(
          height: 170.0, //MediaQuery.of(context).size.height / 3-50,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage(
                      "assets/images/vector/undraw_medicine_b1ol.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(30.0)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                primaryColor.withOpacity(.8),
                Colors.deepOrangeAccent.withOpacity(.8)
              ]),
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
        ),
        Positioned(
          left: 115.0,
          right: 5.0,
          top: 20.0,
          child: Container(
            alignment: Alignment.centerRight,
            child: Text(
              "Trouvez les meilleurs spécialistes de santé sur SOs Docteur",
              style: style1(
                  color: Colors.white,
                  fontWeight: FontWeight.w400,
                  fontSize: 20.0,
                  letterSpacing: 2.0),
            ),
          ),
        ),
        Positioned(
          top: -50.0,
          left: 10.0,
          child: Image.asset(
            "assets/images/vector/chat.png",
            fit: BoxFit.cover,
          ),
        )
      ],
    );
  }
}

class Medecin {
  final String nom, specialite, photo;
  Medecin({this.nom, this.specialite, this.photo});
}
