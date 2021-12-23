import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sos_docteur/constants/controllers.dart';
import 'package:sos_docteur/constants/style.dart';
import 'package:sos_docteur/index.dart';
import 'package:sos_docteur/models/patients/home_model.dart';
import 'package:sos_docteur/models/patients/medecin_data_profil_view_model.dart';
import 'package:sos_docteur/pages/patient/widgets/custom_expandable.dart';
import 'package:sos_docteur/screens/auth_screen.dart';
import 'package:sos_docteur/utilities/utilities.dart';
import 'package:sos_docteur/widgets/user_session_widget.dart';

import 'avis_details_page.dart';

class DoctorDetailPage extends StatefulWidget {
  final Profile profil;
  final HomeMedecins supDatas;
  const DoctorDetailPage({Key key, this.profil, this.supDatas})
      : super(key: key);
  @override
  _DoctorDetailPageState createState() => _DoctorDetailPageState();
}

class _DoctorDetailPageState extends State<DoctorDetailPage> {
  String selectedDispoId = "";
  String selectedHoure = "";

  List<Heures> heures = [];
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("patient_id").toString(),
      scaffold: Scaffold(
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildStackHeader(context),
              const SizedBox(
                height: 33.0,
              ),
              buildExpandedDetails(),
            ],
          ),
        ),
      ),
    );
  }

  Expanded buildExpandedDetails() {
    return Expanded(
      child: Container(
        child: Scrollbar(
          thickness: 5.0,
          hoverThickness: 5.0,
          radius: const Radius.circular(5.0),
          isAlwaysShown: true,
          child: ListView(
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            children: [
              CustomAccordion(
                isExpanded: true,
                title: "Expériences professionelles",
                child: buildContainerExperiences(),
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomAccordion(
                title: "Etudes faites",
                isExpanded: false,
                child: buildContainerEtudes(),
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomAccordion(
                title: "Autres diplômes",
                isExpanded: true,
                child: buildContainerSpeciality(),
              ),
              const SizedBox(
                height: 15.0,
              ),
              CustomAccordion(
                title: "Langues parlées",
                isExpanded: true,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 120.0,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 15.0,
                    ),
                    decoration: const BoxDecoration(
                      border: Border(
                          bottom: BorderSide(color: Colors.blue, width: 1)),
                    ),
                    child: GridView.builder(
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 3.5,
                        crossAxisCount: 2,
                        crossAxisSpacing: 2,
                        mainAxisSpacing: 2,
                      ),
                      itemCount: widget.profil.langues.length,
                      itemBuilder: (context, index) {
                        var data = widget.profil.langues[index];
                        // ignore: avoid_unnecessary_containers
                        return Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 10.0,
                                color: Colors.grey.withOpacity(.3),
                                offset: const Offset(0, 3),
                              )
                            ],
                          ),
                          child: Center(
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  "assets/icons/speech-svgrepo-com.svg",
                                  height: 15.0,
                                  width: 15.0,
                                  color: primaryColor,
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  data.langue,
                                  style: GoogleFonts.lato(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    )),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Center(
                child: Text(
                  "Veuillez renseigner les champs ci-dessous pour prendre un rendez-vous avec le Médecin !",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lato(
                      fontWeight: FontWeight.w800,
                      color: Colors.amber[900],
                      letterSpacing: 0.50,
                      fontSize: 15.0),
                ),
              ),
              const SizedBox(
                height: 25.0,
              ),
              Row(
                children: [
                  Icon(
                    CupertinoIcons.calendar,
                    color: primaryColor,
                    size: 15.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    "Sélectionnez le mois",
                    style: style1(
                        color: primaryColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0),
                  ),
                ],
              ),
              const SizedBox(height: 8.0),
              /*Container(
                margin: const EdgeInsets.only(top: 12),
                child: DatePicker(
                  DateTime.now(),
                  height: 100.0,
                  width: 80.0,
                  initialSelectedDate: DateTime.now(),
                  selectionColor: primaryColor,
                  selectedTextColor: Colors.white,
                  locale: "FR",
                  dateTextStyle: GoogleFonts.lato(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                  dayTextStyle: GoogleFonts.lato(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                  monthTextStyle: GoogleFonts.lato(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey),
                  onDateChange: (date) {
                    setState(() {});
                  },
                ),
              )*/
              if (widget.profil.agenda != null &&
                  widget.profil.agenda.isNotEmpty)
                // ignore: sized_box_for_whitespace
                Container(
                  height: 130,
                  child: StatefulBuilder(
                    builder: (context, setter) {
                      return Scrollbar(
                        radius: const Radius.circular(5.0),
                        thickness: 4.0,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          padding:
                              const EdgeInsets.only(top: 10.0, bottom: 10.0),
                          itemCount: widget.profil.agenda.length,
                          itemBuilder: (context, index) {
                            var data = widget.profil.agenda[index];
                            var list = strSpliter(strDateLong(data.date));
                            return DateCard(
                              isActive: data.isActive,
                              months: list[0],
                              day: list[1],
                              year: list[3],
                              onPressed: () {
                                heures.clear();
                                for (var e in widget.profil.agenda) {
                                  if (e.isActive == true) {
                                    setter(() {
                                      e.isActive = false;
                                    });
                                  }
                                }
                                setter(() {
                                  data.isActive = true;
                                });
                                setState(() {
                                  heures.addAll(data.heures);
                                  selectedDispoId =
                                      data.medecinDatesDisponibleId;
                                });
                              },
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              const SizedBox(height: 10.0),
              if (heures.isNotEmpty)
                Row(
                  children: [
                    Icon(
                      CupertinoIcons.time,
                      color: primaryColor,
                      size: 20.0,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Les heures de disponibilité",
                      style: style1(
                          color: primaryColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0),
                    ),
                  ],
                ),
              if (heures.isNotEmpty) const SizedBox(height: 20.0),
              if (heures.isNotEmpty)
                Container(
                  height: 50.0,
                  child: Scrollbar(
                    radius: const Radius.circular(5.0),
                    thickness: 4.0,
                    scrollbarOrientation: ScrollbarOrientation.bottom,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: heures.length,
                      itemBuilder: (context, index) {
                        var data = heures[index];
                        return TimeCard(
                          isActive: data.isSelected,
                          time: "${data.heureDebut} - ${data.heureFin}",
                          onPressed: () {
                            for (var e in heures) {
                              if (e.isSelected == true) {
                                setState(() {
                                  e.isSelected = false;
                                });
                              }
                            }
                            setState(() {
                              data.isSelected = true;
                              selectedHoure = data.heureDebut;
                            });
                          },
                        );
                      },
                    ),
                  ),
                ),
              if (heures.isNotEmpty) const SizedBox(height: 20.0),
              Container(
                height: 50.0,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                width: MediaQuery.of(context).size.width,
                // ignore: deprecated_member_use
                child: RaisedButton(
                  onPressed: () async {
                    bool isConnected = storage.read("isPatient") ?? false;
                    if (isConnected == false) {
                      XDialog.showConfirmation(
                        context: context,
                        icon: Icons.help_rounded,
                        title: "Connectez-vous !",
                        content:
                            "vous devez vous connecter à votre compte pour prendre un rendez-vous avec le Médecin !",
                      );
                      return;
                    }
                    if (selectedDispoId.isEmpty) {
                      Get.snackbar(
                        "Action obligatoire !",
                        "vous devez sélectionner une date de disponibilité du médecin!",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.amber[900],
                        maxWidth: MediaQuery.of(context).size.width - 4,
                        borderRadius: 2,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }

                    if (selectedHoure.isEmpty) {
                      Get.snackbar(
                        "Action obligatoire !",
                        "vous devez sélectionner une heure de disponibilité du médecin!",
                        snackPosition: SnackPosition.TOP,
                        colorText: Colors.white,
                        backgroundColor: Colors.amber[900],
                        maxWidth: MediaQuery.of(context).size.width - 4,
                        borderRadius: 2,
                        duration: const Duration(seconds: 3),
                      );
                      return;
                    }

                    try {
                      Xloading.showLottieLoading(context);
                      var result = await PatientApi.prendreRdvEnLigne(
                          dateId: selectedDispoId, heure: selectedHoure);
                      if (result != null) {
                        Xloading.dismiss();
                        if (result['reponse']['status'] == "success") {
                          XDialog.showSuccessAnimation(context);
                          setState(() {
                            selectedDispoId = "";
                            selectedHoure = "";
                            heures.clear();
                          });
                          patientController.refreshDatas();
                        }
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  color: primaryColor,
                  child: Text(
                    "Prendre un rendez-vous".toUpperCase(),
                    style: style1(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1.5,
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(.1),
                      blurRadius: 12.0,
                      offset: const Offset(0, 3),
                    )
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Avis",
                            style: GoogleFonts.lato(
                              color: Colors.black54,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      // ignore: deprecated_member_use
                      RaisedButton(
                        color: Colors.cyan,
                        child: Text(
                          "voir plus",
                          style: GoogleFonts.lato(
                            color: Colors.white,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () {
                          Navigator.push(
                            context,
                            PageTransition(
                              child: AvisDetailsPage(
                                doctorName: widget.supDatas.nom,
                                avis: widget.profil.avis,
                              ),
                              type: PageTransitionType.leftToRightWithFade,
                            ),
                          );
                        },
                        elevation: 5,
                      )
                    ],
                  ),
                ),
              ),
              buildContainerCommentaires(),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainerEtudes() {
    return Container(
      height: 250,
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.blue, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: widget.profil.etudesFaites != null
          ? ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.profil.etudesFaites.length,
              itemBuilder: (context, index) {
                var data = widget.profil.etudesFaites[index];
                return StudyCard(
                  certificat: data.certificat,
                  etude: data.etude,
                  institut: data.institut,
                  periodeDebut: data.periodeDebut.split('/')[2],
                  periodeFin: data.periodeFin.split('/')[2],
                  pays: data.adresse.pays,
                );
              },
            )
          : const Center(
              child: Text("Dossier vide pour l'instant"),
            ),
    );
  }

  Container buildContainerCommentaires() {
    return Container(
      height: 200.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15.0),
        itemCount: widget.profil.avis.length,
        itemBuilder: (context, index) {
          var data = widget.profil.avis[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10.0),
            child: CommentaireCard(
              avis: data,
            ),
          );
        },
      ),
    );
  }

  Container buildContainerExperiences() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.blue, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: (widget.profil.experiences != null &&
              widget.profil.experiences.isNotEmpty)
          ? Container(
              height: 150.0,
              width: MediaQuery.of(context).size.width,
              child: Scrollbar(
                radius: const Radius.circular(5.0),
                thickness: 2,
                child: ListView.builder(
                  itemCount: widget.profil.experiences.length,
                  itemBuilder: (context, index) {
                    var data = widget.profil.experiences[index];
                    return HeadingTitle(
                      icon: Icons.check_circle_outline_rounded,
                      color: Colors.black54,
                      title: data.adresse.pays != null
                          ? "A travailler à ${data.entite},  ${data.adresse.pays}"
                          : "A travailler à ${data.entite}",
                      subTitle:
                          "De ${data.periodeDebut.split('/')[2]} à ${data.periodeFin.split('/')[2]}",
                    );
                  },
                ),
              ),
            )
          : const Center(
              child: Text("Aucune expérience !"),
            ),
    );
  }

  Container buildContainerSpeciality() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white,
        border: const Border(bottom: BorderSide(color: Colors.blue, width: 1)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            blurRadius: 12.0,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: (widget.supDatas.specialites.isNotEmpty)
          ? Container(
              height: 150.0,
              width: MediaQuery.of(context).size.width,
              child: (widget.supDatas.specialites.length > 1)
                  ? Scrollbar(
                      radius: const Radius.circular(5.0),
                      thickness: 2,
                      child: ListView.builder(
                        itemCount: widget.supDatas.specialites.length,
                        itemBuilder: (context, index) {
                          var data = widget.supDatas.specialites[index];
                          return HeadingTitle(
                            color: Colors.green[700],
                            icon: CupertinoIcons.check_mark_circled_solid,
                            title: data.specialite,
                          );
                        },
                      ),
                    )
                  : const Center(
                      child: Text("Aucune information !"),
                    ),
            )
          : const Center(
              child: Text("Aucune information !"),
            ),
    );
  }

  Stack buildStackHeader(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 240.0,
          decoration: BoxDecoration(
            image: const DecorationImage(
                image: AssetImage("assets/images/shapes/bg10.jpg"),
                fit: BoxFit.cover),
            boxShadow: [
              BoxShadow(
                blurRadius: 12.0,
                color: Colors.grey.withOpacity(.3),
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [primaryColor.withOpacity(.5), Colors.deepOrange],
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 12.0,
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(0, 3))
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.supDatas.photo.isNotEmpty ||
                      widget.supDatas.photo.length > 200)
                    Container(
                      height: 110.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: MemoryImage(
                            base64Decode(
                              widget.supDatas.photo,
                            ),
                          ),
                        ),
                      ),
                      // ignore: prefer_const_constructors
                    )
                  else
                    Container(
                      height: 110.0,
                      width: 110.0,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.cyan,
                            Colors.blue[800],
                          ],
                        ),
                        boxShadow: [
                          const BoxShadow(
                            blurRadius: 12.0,
                            color: Colors.black26,
                            offset: Offset(0, 3),
                          )
                        ],
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          CupertinoIcons.person,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Text(
                    "Dr. ${widget.supDatas.nom}",
                    style: style1(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.supDatas.specialites != null &&
                            widget.supDatas.specialites.isNotEmpty
                        ? widget.supDatas.specialites.length > 1
                            ? widget.supDatas.specialites[0].specialite + ",..."
                            : widget.supDatas.specialites[0].specialite
                        : "aucune spécialité",
                    style: style1(color: Colors.grey[300]),
                  ),
                  const SizedBox(height: 5.0),
                  Center(
                    child: RatingBar.builder(
                      wrapAlignment: WrapAlignment.center,
                      initialRating: widget.supDatas.cote.toDouble(),
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemSize: 13.0,
                      allowHalfRating: false,
                      ignoreGestures: true,
                      unratedColor: Colors.transparent,
                      itemCount: 3,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.orange.withOpacity(.7),
                      ),
                      updateOnDrag: false,
                      onRatingUpdate: (double value) {},
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          top: 10.0,
          right: 10.0,
          left: 10.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 40.0,
                  width: 40.0,
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
                    ),
                  ),
                ),
            ],
          ),
        ),
        Positioned(
          bottom: -30.0,
          left: 10.0,
          right: 10.0,
          child: Container(
            height: 50.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(2.0),
                boxShadow: [
                  BoxShadow(
                      blurRadius: 12.0,
                      color: Colors.black12,
                      offset: const Offset(0, 3))
                ]),
            child: Center(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.medication,
                    color: primaryColor,
                    size: 17.0,
                  ),
                  const SizedBox(width: 15.0),
                  Text(
                      "N° d'ordre : ${(widget.profil.numeroOrdre.isNotEmpty) ? widget.profil.numeroOrdre : 'non répertorié'}",
                      style: style1(
                          fontWeight: FontWeight.w700, color: primaryColor))
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class DateCard extends StatelessWidget {
  final String months;
  final String day;
  final String year;
  final bool isActive;
  final Function onPressed;
  const DateCard({
    Key key,
    this.months,
    this.day,
    this.year,
    this.isActive = false,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 100.0,
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        width: 70.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: primaryColor),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(.1),
                    blurRadius: 12.0,
                    offset: const Offset(0, 5),
                  )
                ]
              : [
                  BoxShadow(
                    color: Colors.grey.withOpacity(.4),
                    blurRadius: 12.0,
                    offset: const Offset(0, 3),
                  )
                ],
          gradient: (isActive)
              ? LinearGradient(
                  colors: [
                    Colors.blue[900],
                    Colors.blue,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                )
              : LinearGradient(
                  colors: [
                    Colors.grey[100],
                    Colors.white,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
        ),
        child: Center(
          child: Column(
            children: [
              Text(
                "$months.",
                style: GoogleFonts.lato(
                    color: isActive ? Colors.white : Colors.blue[800],
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 10.0),
              Text(
                day,
                style: GoogleFonts.lato(
                    color: isActive ? Colors.white : Colors.black54,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 10.0),
              Text(
                year,
                style: GoogleFonts.lato(
                  color: isActive ? Colors.white : Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudyCard extends StatelessWidget {
  final String institut;
  final String certificat;
  final String etude;
  final String periodeDebut;
  final String periodeFin;
  final String pays;
  const StudyCard({
    Key key,
    this.institut,
    this.certificat,
    this.etude,
    this.pays,
    this.periodeDebut,
    this.periodeFin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeadingTitle(
          color: Colors.blue[800],
          icon: Icons.cast_for_education_rounded,
          title: "${etude.toUpperCase()}, pays:",
          subTitle: "à $institut de $periodeDebut à $periodeFin",
        ),
        const SizedBox(height: 8.0),
        if (certificat.length > 200 && certificat != null)
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: MemoryImage(
                  base64Decode(certificat),
                ),
                fit: BoxFit.cover,
              ),
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          )
        else
          Container(
            width: MediaQuery.of(context).size.width,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.2),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
          )
      ],
    );
  }
}

class CommentaireCard extends StatelessWidget {
  final Avis avis;
  const CommentaireCard({
    Key key,
    this.avis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 50.0,
          width: 50.0,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.cyan),
          child: Center(
            child: Text(
              avis.patient.substring(0, 1),
              style: GoogleFonts.lato(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20.0),
            ),
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Flexible(
          child: Container(
            height: 80.0,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image: AssetImage("assets/images/shapes/bg1.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: [
                BoxShadow(
                  blurRadius: 12.0,
                  color: Colors.grey.withOpacity(.2),
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(.9),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                children: [
                  Flexible(
                    child: Text(
                      avis.avis,
                      style: GoogleFonts.lato(
                        color: Colors.grey[700],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(strDateLongFr(avis.dateEnregistrement),
                        style: GoogleFonts.lato(color: Colors.blue)),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}

class HeadingTitle extends StatelessWidget {
  final IconData icon;
  final String title, subTitle;
  final Color color;
  const HeadingTitle({this.icon, this.title, this.subTitle, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20.0),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Text(
                  title,
                  style: GoogleFonts.lato(
                    color: Colors.black87,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              )
            ],
          ),
          const SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              subTitle ?? "",
              style: GoogleFonts.lato(
                color: Colors.blue[800],
                fontSize: 15.0,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeCard extends StatelessWidget {
  final bool isActive;
  final String time;
  final Function onPressed;

  const TimeCard({Key key, this.isActive, this.time, this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.only(left: 10.0, right: 10.0),
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        decoration: BoxDecoration(
            border: Border.all(
              color: primaryColor,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 12.0,
                offset: const Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.circular(10.0),
            color: (isActive) ? primaryColor : Colors.white),
        height: 40.0,
        width: 120.0,
        child: Center(
          child: Text(
            time,
            style: style1(
                color: (isActive) ? Colors.white : primaryColor,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
