import 'dart:convert';

import 'package:flutter/cupertino.dart';

import 'package:sos_docteur/widgets/user_session_widget.dart';

import '../../index.dart';
import 'medecin_profil_page.dart';

class MedecinProfilViewPage extends StatefulWidget {
  const MedecinProfilViewPage({Key key}) : super(key: key);

  @override
  _MedecinProfilViewPageState createState() => _MedecinProfilViewPageState();
}

class _MedecinProfilViewPageState extends State<MedecinProfilViewPage> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("medecin_id").toString(),
      scaffold: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/shapes/bg3p.png"),
                  fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  primaryColor.withOpacity(.9),
                  Colors.white.withOpacity(.8),
                  Colors.white.withOpacity(.8)
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Obx(() {
              return SafeArea(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 16.0, right: 16.0, top: 20.0),
                      child: _header(),
                    ),
                    const SizedBox(height: 30.0),
                    Expanded(
                      // ignore: avoid_unnecessary_containers
                      child: Container(
                        child: Scrollbar(
                          thickness: 5,
                          radius: const Radius.circular(10.0),
                          child: SingleChildScrollView(
                            physics: const BouncingScrollPhysics(),
                            child: Column(
                              children: [
                                Padding(
                                  child: profilAvatar(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                ),
                                if (medecinController.medecinProfil.value.datas
                                        .profilSpecialites !=
                                    null)
                                  const TitleLine(
                                    title: "Spécialités",
                                  ),
                                if (medecinController.medecinProfil.value.datas
                                        .profilSpecialites !=
                                    null)
                                  ListView.builder(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: medecinController.medecinProfil
                                        .value.datas.profilSpecialites.length,
                                    itemBuilder: (context, i) {
                                      var data = medecinController.medecinProfil
                                          .value.datas.profilSpecialites[i];
                                      return SpecCard(
                                        value: data.specialite,
                                      );
                                    },
                                  ),
                                if (medecinController.medecinProfil.value.datas
                                        .profilEtudesFaites !=
                                    null)
                                  const TitleLine(
                                    title: "Etudes faites",
                                  ),
                                if (medecinController.medecinProfil.value.datas
                                        .profilEtudesFaites !=
                                    null)
                                  Container(
                                    height: 170.0,
                                    child: ListView.builder(
                                      padding: const EdgeInsets.only(
                                          top: 5.0, left: 10.0),
                                      physics: const BouncingScrollPhysics(),
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount: medecinController
                                          .medecinProfil
                                          .value
                                          .datas
                                          .profilEtudesFaites
                                          .length,
                                      itemBuilder: (context, i) {
                                        var data = medecinController
                                            .medecinProfil
                                            .value
                                            .datas
                                            .profilEtudesFaites[i];
                                        return StudyCard(
                                          certificatImage: data.certificat,
                                          university:
                                              data.institut.toUpperCase(),
                                          etude: data.etude,
                                          endAt: data.periodeFin.split("/")[2],
                                          startAt:
                                              data.periodeDebut.split("/")[2],
                                        );
                                      },
                                    ),
                                  ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 10.0, vertical: 20.0),
                                  height: 70.0,
                                  width: MediaQuery.of(context).size.width,
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0)),
                                    color: Colors.blue[800],
                                    onPressed: () async {
                                      Navigator.push(
                                        context,
                                        PageTransition(
                                          type: PageTransitionType
                                              .rightToLeftWithFade,
                                          alignment: Alignment.topCenter,
                                          curve: Curves.easeIn,
                                          child: MedecinProfilPage(),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      "Mettre à jour votre profil",
                                      style:
                                          GoogleFonts.lato(color: Colors.white),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  profilAvatar() {
    return Center(
      child: Column(
        children: [
          if (medecinController.medecinProfil.value.datas.photo.length > 200)
            Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: MemoryImage(
                      base64Decode(
                          medecinController.medecinProfil.value.datas.photo),
                    ),
                    fit: BoxFit.cover),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black38,
                    blurRadius: 12.0,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
            )
          else
            Container(
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Colors.cyan, primaryColor],
                ),
                boxShadow: [
                  BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      blurRadius: 12.0,
                      offset: const Offset(0, 2))
                ],
              ),
              child: const Center(
                child: Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.white,
                  size: 40.0,
                ),
              ),
            ),
          const SizedBox(height: 10.0),
          Text(
            "Dr. ${medecinController.medecinProfil.value.datas.nom}",
            style: style1(
                color: Colors.black,
                fontWeight: FontWeight.w800,
                fontSize: 18.0),
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
          mainAxisSize: MainAxisSize.min,
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
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Text(
                "Mon profil",
                style: style1(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18.0,
                ),
              ),
            ),
          ],
        ),
        if (storage.read("isMedecin") == true) UserSession()
      ],
    );
  }
}

class StudyCard extends StatelessWidget {
  final String university;
  final String certificatImage;
  final String etude;
  final String startAt;
  final String endAt;
  const StudyCard(
      {Key key,
      this.university,
      this.certificatImage,
      this.startAt,
      this.endAt,
      this.etude})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8.0),
      height: 180.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            color: Colors.grey.withOpacity(.3),
            offset: const Offset(0, 3),
          )
        ],
      ),
      width: MediaQuery.of(context).size.width - 30,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 60,
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  university,
                  style: GoogleFonts.lato(fontWeight: FontWeight.w800),
                ),
                const SizedBox(
                  height: 3.0,
                ),
                Flexible(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.lato(
                          fontWeight: FontWeight.w600, color: Colors.black),
                      children: [
                        TextSpan(
                          text: "$etude ",
                          style: GoogleFonts.lato(fontWeight: FontWeight.w800),
                        ),
                        TextSpan(
                          text: " de ",
                          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: "$startAt ",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w800,
                            color: Colors.blue[800],
                          ),
                        ),
                        TextSpan(
                          text: " à ",
                          style: GoogleFonts.lato(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(
                          text: " $endAt",
                          style: GoogleFonts.lato(
                            fontWeight: FontWeight.w800,
                            color: Colors.blue[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(5.0),
                  bottomRight: Radius.circular(5.0),
                ),
                image: DecorationImage(
                  image: MemoryImage(base64Decode(certificatImage)),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 12.0,
                    color: Colors.grey.withOpacity(.3),
                    offset: const Offset(0, 3),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class SpecCard extends StatelessWidget {
  final String value;
  const SpecCard({
    Key key,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        Container(
          margin: const EdgeInsets.only(bottom: 8.0),
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.3),
                blurRadius: 12.0,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: 16.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        Positioned(
          top: -4,
          left: -4,
          child: Container(
            height: 25.0,
            width: 25.0,
            decoration: BoxDecoration(
              color: Colors.green[700],
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3),
                )
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.check,
                color: Colors.white,
                size: 12.0,
              ),
            ),
          ),
        )
      ],
    );
  }
}

class TitleLine extends StatelessWidget {
  final String title;
  const TitleLine({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        bottom: 10.0,
        left: 10.0,
        right: 10.0,
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5.0),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue,
                  Colors.blue[900],
                ],
              ),
            ),
            child: Center(
              child: Text(title, style: GoogleFonts.lato(color: Colors.white)),
            ),
          ),
          Flexible(
            child: Container(
                height: 2.0,
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: Colors.blue[900],
                ),
                width: MediaQuery.of(context).size.width),
          ),
        ],
      ),
    );
  }
}
