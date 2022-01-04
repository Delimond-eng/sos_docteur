// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sos_docteur/constants/globals.dart';
import 'package:sos_docteur/models/configs_model.dart';
import 'package:sos_docteur/screens/widgets/menu_card.dart';

import '../../index.dart';

class MedecinProfilPage extends StatefulWidget {
  @override
  _MedecinProfilPageState createState() => _MedecinProfilPageState();
}

class _MedecinProfilPageState extends State<MedecinProfilPage> {
  String medName = storage.read("medecin_nom").toString() ?? "";
  String medEmail = storage.read("medecin_email").toString() ?? "";
  String medPhoto = storage.read("photo").toString() ?? "";
  String avatar = "";

  String dateStart = "";
  DateTime selectedDateStart = DateTime.now();
  String dateEnd = "";
  DateTime selectedDateEnd = DateTime.now();
  String certificatPic = "";

  //text editing
  final textSpecialite = TextEditingController();
  final textEntite = TextEditingController();
  final textExperience = TextEditingController();
  final textPays = TextEditingController();
  final textVille = TextEditingController();
  final textAdresse = TextEditingController();
  final textEtude = TextEditingController();
  Specialites selectedSpeciality;
  String selectedLangue;

  //numero d'ordre
  final textNumOrdre = TextEditingController();

  void clean() {
    setState(() {
      textSpecialite.text = "";
      textEntite.text = "";
      textExperience.text = "";
      textPays.text = "";
      textVille.text = "";
      textAdresse.text = "";
      textEtude.text = "";
      certificatPic = "";
      dateStart = "";
      dateEnd = "";
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      Get.back();
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      avatar = medPhoto ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("medecin_id").toString(),
      scaffold: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage("assets/images/shapes/bg9.png"),
                  fit: BoxFit.cover)),
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              colors: [primaryColor.withOpacity(.8), Colors.white10],
              stops: const [0.1, 0.9],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            )),
            child: SafeArea(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16.0, right: 16.0, top: 20.0, bottom: 10),
                    child: _header(),
                  ),
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                        ),
                        physics: const BouncingScrollPhysics(),
                        child: _profils(context),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<PickedFile> takePhoto({ImageSource source}) async {
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
        source: source, imageQuality: 70, maxHeight: 350, maxWidth: 350);

    if (pickedFile != null) {
      return pickedFile;
    } else {
      return null;
    }
  }

  void _showPhotoEditingSheet() {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0), topRight: Radius.circular(20.0))),
      elevation: 2,
      barrierColor: Colors.black26,
      backgroundColor: Colors.white,
      context: context,
      builder: (BuildContext bc) {
        return Container(
          height: 150.0,
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: TileBtn(
                  icon: CupertinoIcons.photo_on_rectangle,
                  label: "Gallerie",
                  onPressed: () async {
                    var pickedFile =
                        await takePhoto(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      var bytes = File(pickedFile.path).readAsBytesSync();
                      setState(() {
                        avatar = base64Encode(bytes);
                      });
                      Medecins medecin = Medecins(photo: avatar);
                      Xloading.showLottieLoading(context);
                      var res = await MedecinApi.configProfil(
                          key: "avatar", medecin: medecin);
                      if (res != null) {
                        Xloading.dismiss();
                        if (res['reponse']['status'] == "success") {
                          storage.write("photo", avatar);
                          Get.back();

                          XDialog.showSuccessAnimation(context);
                          await medecinController.refreshDatas();
                        } else {
                          Get.snackbar(
                            "Echec!",
                            "mise à jour de la photo de profil à echouée!",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.amber[900],
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 2,
                            duration: const Duration(seconds: 3),
                          );
                        }
                      }
                    }
                    //print(avatar);
                  },
                ),
              ),
              const SizedBox(width: 20.0),
              Flexible(
                child: TileBtn(
                  onPressed: () async {
                    var pickedFile =
                        await takePhoto(source: ImageSource.camera);
                    if (pickedFile != null) {
                      var bytes = File(pickedFile.path).readAsBytesSync();
                      setState(() {
                        avatar = base64Encode(bytes);
                      });

                      Medecins medecin = Medecins(photo: avatar);
                      Xloading.showLottieLoading(context);

                      var res = await MedecinApi.configProfil(
                          key: "avatar", medecin: medecin);

                      if (res != null) {
                        Xloading.dismiss();
                        if (res['reponse']['status'] == "success") {
                          storage.write("photo", avatar);
                          Get.back();

                          XDialog.showSuccessAnimation(context);
                          await medecinController.refreshDatas();
                        } else {
                          Get.snackbar(
                            "Echec!",
                            "mise à jour de la photo de profil à echouée!",
                            snackPosition: SnackPosition.TOP,
                            colorText: Colors.white,
                            backgroundColor: Colors.amber[900],
                            maxWidth: MediaQuery.of(context).size.width - 4,
                            borderRadius: 2,
                            duration: const Duration(seconds: 3),
                          );
                          Get.back();
                        }
                      }
                    }
                  },
                  icon: CupertinoIcons.photo_camera,
                  label: "Prendre une photo",
                ),
              ),
            ],
          ),
        );
      },
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
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
                child: Text(
              "Configuration & Personnalisation Profil",
              style: style1(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.0),
            ))
          ],
        ),
      ],
    );
  }

  Widget _profils(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Column(
            children: [
              Stack(
                // ignore: deprecated_member_use
                overflow: Overflow.visible,
                children: [
                  if (avatar.length > 200)
                    Container(
                      height: 120.0,
                      width: 120.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: MemoryImage(
                              base64Decode(avatar),
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
                  Positioned(
                    bottom: -10,
                    right: 5.0,
                    child: GestureDetector(
                      onTap: () {
                        _showPhotoEditingSheet();
                      },
                      child: Container(
                        height: 50.0,
                        width: 50.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.amber[800],
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              blurRadius: 12.0,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            CupertinoIcons.pencil,
                            color: Colors.white,
                            size: 25.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Text(
                "Dr. $medName",
                style: style1(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Container(height: 2.0, width: 50.0, color: Colors.grey[600])
            ],
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          "Veuillez renseigner plus d'informations sur vous!",
          textAlign: TextAlign.center,
          style: GoogleFonts.lato(
            color: Colors.white,
            shadows: [
              const Shadow(
                color: Colors.black12,
                blurRadius: 10,
                offset: Offset(0, 1),
              )
            ],
            fontSize: 15.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        LargeBtn(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Dialog(
                      child: Container(
                        height: 180.0,
                        color: Colors.white,
                        padding: const EdgeInsets.all(10.0),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Saisir votre numéro d'ordre",
                              style: GoogleFonts.lato(
                                  fontSize: 18.0, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            StandardInput(
                              hintText: "Entrez votre n° d'ordre",
                              icon: CupertinoIcons.pencil,
                              radius: 5.0,
                              controller: textNumOrdre,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Container(
                              height: 50.0,
                              width: double.infinity,
                              child: RaisedButton(
                                elevation: 5.0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.cyan,
                                child: const Icon(
                                  CupertinoIcons.check_mark,
                                  color: Colors.white,
                                ),
                                onPressed: () async {
                                  if (textNumOrdre.text.isEmpty) {
                                    Get.snackbar(
                                      "Action obligatoire!",
                                      "vous devez saisir votre n° d'ordre médical !",
                                      snackPosition: SnackPosition.TOP,
                                      colorText: Colors.red[400],
                                      backgroundColor: Colors.black87,
                                      maxWidth:
                                          MediaQuery.of(context).size.width - 4,
                                      borderRadius: 10,
                                      duration: const Duration(seconds: 5),
                                    );
                                    return;
                                  }

                                  Xloading.showLottieLoading(context);
                                  var res =
                                      await MedecinApi.enregistrerNumOrdre(
                                          numero: textNumOrdre.text);
                                  if (res != null) {
                                    Xloading.dismiss();
                                    if (res["reponse"]["status"] == "success") {
                                      XDialog.showSuccessAnimation(context);
                                      await medecinController.refreshDatas();
                                      Get.back();
                                    }
                                  } else {
                                    Xloading.dismiss();
                                    Get.snackbar(
                                      "Echec!",
                                      "echec survenu lors de l'envoi de données au serveur!,veuillez réessayer svp!",
                                      snackPosition: SnackPosition.TOP,
                                      colorText: Colors.white,
                                      backgroundColor: Colors.pinkAccent,
                                      maxWidth:
                                          MediaQuery.of(context).size.width - 4,
                                      borderRadius: 2,
                                      duration: const Duration(seconds: 3),
                                    );
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
                ;
              },
            );
          },
        ),
        const SizedBox(height: 10.0),
        Row(
          children: [
            MenuCard(
              color: Colors.blue[900],
              icon: "medical-specialist-svgrepo-com.svg",
              title: "Spécialités",
              subColor: Colors.indigo[100],
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) {
                    return StatefulBuilder(
                      builder: (context, setter) {
                        return Container(
                          height: 150,
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Ajoutez vos spécialités ",
                                style: GoogleFonts.lato(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                height: 50.0,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5.0),
                                  color: Colors.grey[200],
                                  border:
                                      Border.all(color: primaryColor, width: 1),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(.3),
                                      blurRadius: 12.0,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Flexible(
                                      child: Container(
                                        height: 50,
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        padding:
                                            const EdgeInsets.only(right: 5),
                                        child: DropdownButton(
                                          menuMaxHeight: 300,
                                          alignment: Alignment.centerRight,
                                          dropdownColor: Colors.grey[100],
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          style: GoogleFonts.lato(
                                              color: Colors.black54),
                                          value: selectedSpeciality,
                                          underline: const SizedBox(),
                                          hint: Text(
                                            "  Sélectionnez une spécialité",
                                            style: GoogleFonts.mulish(
                                                color: Colors.grey[600],
                                                fontSize: 15.0,
                                                fontStyle: FontStyle.italic),
                                          ),
                                          isExpanded: true,
                                          items: patientController.specialities
                                              .map((e) {
                                            return DropdownMenuItem(
                                                value: e,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0),
                                                  child: Text(
                                                    e.specialite,
                                                    style: GoogleFonts.lato(
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  ),
                                                ));
                                          }).toList(),
                                          onChanged: (value) {
                                            setter(() {
                                              selectedSpeciality = value;
                                            });
                                            print(value.specialiteId);
                                          },
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (selectedSpeciality == null) {
                                          Get.snackbar(
                                            "champs obligatoire!",
                                            "vous devez sélectionner une spécialité dans la liste !",
                                            snackPosition: SnackPosition.TOP,
                                            colorText: Colors.white,
                                            backgroundColor: Colors.black87,
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                4,
                                            borderRadius: 10,
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                          return;
                                        }
                                        Medecins medecin = Medecins(
                                          specialite:
                                              selectedSpeciality.specialiteId,
                                        );
                                        Xloading.showLottieLoading(context);
                                        var res = await MedecinApi.configProfil(
                                            key: "specialite",
                                            medecin: medecin);
                                        if (res != null) {
                                          Xloading.dismiss();
                                          if (res["reponse"]["status"] ==
                                              "success") {
                                            XDialog.showSuccessAnimation(
                                                context);

                                            await medecinController
                                                .refreshDatas();
                                            clean();
                                          }
                                        } else {
                                          Xloading.dismiss();
                                          Get.snackbar(
                                            "Echec!",
                                            "echec survenu lors de l'envoi de données au serveur!,\nveuillez réessayer svp!",
                                            snackPosition: SnackPosition.TOP,
                                            colorText: Colors.red[200],
                                            backgroundColor: Colors.black87,
                                            maxWidth: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                4,
                                            borderRadius: 10,
                                            duration:
                                                const Duration(seconds: 3),
                                          );
                                        }
                                      },
                                      child: Container(
                                        height: 50.0,
                                        width: 70.0,
                                        decoration: BoxDecoration(
                                          color: primaryColor,
                                        ),
                                        child: const Center(
                                          child: Icon(CupertinoIcons.add,
                                              color: Colors.white, size: 18.0),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    );
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.zero,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              width: 10.0,
            ),
            MenuCard(
              color: Colors.blue[900],
              subColor: Colors.indigo[100],
              icon: "professional-profile-with-image-svgrepo-com.svg",
              title: "Expériences",
              onPressed: () {
                showScrollableSheet(
                  context,
                  childrens: <Widget>[
                    Text(
                      "Personnaliser votre/vos expériences professionnelles",
                      style: GoogleFonts.lato(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20.0),
                    StandardInput(
                      hintText: "Entité...",
                      icon: Icons.medical_services_rounded,
                      radius: 5.0,
                      controller: textEntite,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "Expérience...",
                      icon: Icons.medication,
                      controller: textExperience,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: StatefulBuilder(builder: (context, setter) {
                            return DatePicker(
                              hintText: "De",
                              selectedDate: dateStart,
                              radius: 5.0,
                              showDate: () async {
                                DateTime date = await showDateBox(context);

                                if (date != null) {
                                  setter(() {
                                    dateStart = dateFromString(date);
                                  });
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                            child: StatefulBuilder(builder: (context, setter) {
                          return DatePicker(
                            hintText: "à",
                            selectedDate: dateEnd,
                            radius: 5.0,
                            showDate: () async {
                              DateTime date = await showDateBox(context);
                              print(date);
                              if (date != null) {
                                setter(() {
                                  dateEnd = dateFromString(date);
                                });
                              }
                            },
                          );
                        }))
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "Pays ex.RD congo...",
                      icon: CupertinoIcons.flag_circle_fill,
                      controller: textPays,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "ville...",
                      icon: Icons.location_city,
                      controller: textVille,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "Adresse...",
                      radius: 5.0,
                      icon: Icons.location_on,
                      controller: textAdresse,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                        color: primaryColor,
                        onPressed: () async {
                          List<String> fields = [
                            textEntite.text,
                            textExperience.text,
                            dateStart,
                            dateEnd,
                            textPays.text,
                            textVille.text,
                            textAdresse.text
                          ];
                          for (var i = 0; i < fields.length; i++) {
                            if (fields[i].isEmpty || fields[i] == null) {
                              Get.snackbar(
                                "Saisie obligatoire!",
                                "vous devez renseigner tous les champs requis !",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.amber[900],
                                maxWidth: MediaQuery.of(context).size.width - 4,
                                borderRadius: 2,
                                duration: const Duration(seconds: 3),
                              );
                              return;
                            }
                          }

                          final medecin = Medecins(
                            entite: textEntite.text,
                            experience: textExperience.text,
                            periodeDebut: dateStart,
                            periodeFin: dateEnd,
                            pays: textPays.text,
                            ville: textVille.text,
                            adresse: textAdresse.text,
                          );

                          Xloading.showLottieLoading(context);

                          var res = await MedecinApi.configProfil(
                              key: "experience", medecin: medecin);

                          if (res != null) {
                            Xloading.dismiss();
                            if (res["reponse"]["status"] == "success") {
                              XDialog.showSuccessAnimation(context);
                              await medecinController.refreshDatas();
                              clean();
                            }
                          } else {
                            Xloading.dismiss();
                            Get.snackbar(
                              "Echec!",
                              "echec survenu lors de l'envoi de données au serveur!,\nveuillez réessayer svp!",
                              snackPosition: SnackPosition.TOP,
                              colorText: Colors.white,
                              backgroundColor: Colors.amber[900],
                              maxWidth: MediaQuery.of(context).size.width - 4,
                              borderRadius: 20,
                              duration: const Duration(seconds: 3),
                            );
                          }
                        },
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                    )
                  ],
                );
              },
            ),
          ],
        ),
        const SizedBox(
          height: 10.0,
        ),
        Row(
          children: [
            MenuCard(
              color: Colors.blue[900],
              icon: "university-svgrepo-com.svg",
              title: "Etudes faites",
              subColor: Colors.blue[100],
              onPressed: () {
                showScrollableSheet(
                  context,
                  childrens: <Widget>[
                    Text(
                      "Personnaliser vos Etudes faites",
                      style: GoogleFonts.lato(
                          fontSize: 18.0, fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 20.0),
                    StandardInput(
                      hintText: "Université...",
                      icon: Icons.account_balance_outlined,
                      controller: textEntite,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "Etude...",
                      icon: Icons.cast_for_education_sharp,
                      controller: textEtude,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: StatefulBuilder(builder: (context, setter) {
                            return DatePicker(
                              hintText: "Période début",
                              selectedDate: dateStart,
                              showDate: () async {
                                DateTime date = await showDateBox(context);
                                print(date);
                                if (date != null) {
                                  setter(() {
                                    dateStart = dateFromString(date);
                                  });
                                }
                              },
                            );
                          }),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Flexible(
                            child: StatefulBuilder(builder: (context, setter) {
                          return DatePicker(
                            hintText: "Période fin",
                            selectedDate: dateEnd,
                            showDate: () async {
                              DateTime date = await showDateBox(context);
                              print(date);
                              if (date != null) {
                                setter(() {
                                  dateEnd = dateFromString(date);
                                });
                              }
                            },
                          );
                        }))
                      ],
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StatefulBuilder(
                      builder: (context, setter) => FileUploader(
                        onCanceled: () {
                          setter(() {
                            certificatPic = "";
                          });
                        },
                        onUpload: () async {
                          var pic =
                              await takePhoto(source: ImageSource.gallery);
                          if (pic != null) {
                            var bytes = File(pic.path).readAsBytesSync();
                            setter(() {
                              certificatPic = base64Encode(bytes);
                            });
                          }
                        },
                        uploadFile: certificatPic,
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "Pays...",
                      icon: CupertinoIcons.flag_circle_fill,
                      controller: textPays,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "ville...",
                      icon: Icons.location_city,
                      controller: textVille,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    StandardInput(
                      hintText: "Adresse...",
                      icon: Icons.location_on,
                      controller: textAdresse,
                      radius: 5.0,
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    Container(
                      height: 50.0,
                      width: MediaQuery.of(context).size.width,
                      child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        color: primaryColor,
                        onPressed: () async {
                          List<String> fields = [
                            textEntite.text,
                            textEtude.text,
                            dateStart,
                            certificatPic,
                            dateEnd,
                            textVille.text,
                            textPays.text,
                            textAdresse.text
                          ];
                          for (var i = 0; i < fields.length; i++) {
                            if (fields[i].isEmpty || fields[i] == null) {
                              Get.snackbar(
                                "Saisie obligatoire!",
                                "vous devez renseigner tous les champs requis !",
                                snackPosition: SnackPosition.TOP,
                                colorText: Colors.white,
                                backgroundColor: Colors.amber[900],
                                maxWidth: MediaQuery.of(context).size.width - 4,
                                borderRadius: 2,
                                duration: const Duration(seconds: 3),
                              );
                              return;
                            }
                          }

                          final medecin = Medecins(
                            institut: textEntite.text,
                            certificat: certificatPic,
                            etude: textEtude.text,
                            periodeDebut: dateStart,
                            periodeFin: dateEnd,
                            pays: textPays.text,
                            ville: textVille.text,
                            adresse: textAdresse.text,
                          );

                          Xloading.showLottieLoading(context);
                          var res = await MedecinApi.configProfil(
                              key: "etude", medecin: medecin);
                          if (res != null) {
                            Xloading.dismiss();
                            if (res["reponse"]["status"] != null) {
                              XDialog.showSuccessAnimation(context);
                              await medecinController.refreshDatas();
                              clean();
                            }
                          } else {
                            Xloading.dismiss();
                            Get.snackbar(
                              "Echec!",
                              "echec survenu lors de l'envoi de données au serveur!,\nveuillez réessayer svp!",
                              snackPosition: SnackPosition.TOP,
                              colorText: Colors.white,
                              backgroundColor: Colors.amber[900],
                              maxWidth: MediaQuery.of(context).size.width - 4,
                              borderRadius: 2,
                              duration: const Duration(seconds: 3),
                            );
                          }
                        },
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                    )
                  ],
                );
              },
            ),
            const SizedBox(
              width: 10.0,
            ),
            MenuCard(
              color: Colors.blue[900],
              subColor: Colors.indigo[100],
              icon: "speech-svgrepo-com.svg",
              title: "Langues parlées",
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.zero,
                      ),
                    ),
                    builder: (context) {
                      return Container(
                        height: 150.0,
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Langues parlées",
                              style: GoogleFonts.lato(
                                  fontSize: 18.0, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              height: 50.0,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: Colors.grey[200],
                                border:
                                    Border.all(color: primaryColor, width: 1),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(.3),
                                    blurRadius: 12.0,
                                    offset: const Offset(0, 3),
                                  )
                                ],
                              ),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: StatefulBuilder(
                                      builder: (context, setter) {
                                        return Container(
                                          height: 50,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          padding:
                                              const EdgeInsets.only(right: 5),
                                          child: DropdownButton<String>(
                                            menuMaxHeight: 300,
                                            alignment: Alignment.centerRight,
                                            dropdownColor: Colors.grey[100],
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            style: GoogleFonts.lato(
                                                color: Colors.black54),
                                            value: selectedLangue,
                                            underline: const SizedBox(),
                                            hint: Text(
                                              "   Sélectionnez une langue",
                                              style: GoogleFonts.mulish(
                                                  color: Colors.grey[600],
                                                  fontSize: 15.0,
                                                  fontStyle: FontStyle.italic),
                                            ),
                                            isExpanded: true,
                                            items: langues.map((e) {
                                              return DropdownMenuItem<String>(
                                                  value: e,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Text(
                                                      "$e",
                                                      style: GoogleFonts.lato(
                                                          fontWeight:
                                                              FontWeight.w400),
                                                    ),
                                                  ));
                                            }).toList(),
                                            onChanged: (value) {
                                              setter(() {
                                                selectedLangue = value;
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      if (selectedLangue == null ||
                                          selectedLangue == langues[0]) {
                                        Get.snackbar(
                                          "champs obligatoire!",
                                          "vous devez sélectionner une langue dans la liste !",
                                          snackPosition: SnackPosition.TOP,
                                          colorText: Colors.white,
                                          backgroundColor: Colors.amber[900],
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              4,
                                          borderRadius: 2,
                                          duration: const Duration(seconds: 3),
                                        );
                                        return;
                                      }
                                      Medecins medecin =
                                          Medecins(langue: selectedLangue);
                                      Xloading.showLottieLoading(context);
                                      var res = await MedecinApi.configProfil(
                                          key: "langue", medecin: medecin);
                                      if (res != null) {
                                        Xloading.dismiss();
                                        if (res["reponse"]["status"] ==
                                            "success") {
                                          XDialog.showSuccessAnimation(context);
                                          setState(() {
                                            selectedLangue = langues[0];
                                          });
                                          await medecinController
                                              .refreshDatas();
                                        }
                                      } else {
                                        Xloading.dismiss();
                                        Get.snackbar(
                                          "Echec!",
                                          "echec survenu lors de l'envoi de données au serveur!,\nveuillez réessayer svp!",
                                          snackPosition: SnackPosition.TOP,
                                          colorText: Colors.white,
                                          backgroundColor: Colors.pinkAccent,
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              4,
                                          borderRadius: 2,
                                          duration: const Duration(seconds: 3),
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: 50.0,
                                      width: 70.0,
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                      ),
                                      child: const Center(
                                        child: Icon(CupertinoIcons.add,
                                            color: Colors.white, size: 18.0),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              },
            ),
          ],
        ),
      ],
    );
  }
}

class LargeBtn extends StatelessWidget {
  final Function onPressed;
  const LargeBtn({
    Key key,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.0,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage("assets/images/shapes/bg10.jpg"),
          fit: BoxFit.cover,
          scale: 1.5,
        ),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            blurRadius: 10.0,
            offset: const Offset(0, 3),
            color: Colors.black.withOpacity(.1),
          )
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.green[700].withOpacity(.8),
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              blurRadius: 10.0,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: Material(
          borderRadius: BorderRadius.circular(5),
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(5),
            onTap: onPressed,
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    CupertinoIcons.check_mark_circled_solid,
                    color: Colors.white,
                    size: 16.0,
                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  Text(
                    "Enregistrer votre numéro d'ordre",
                    style: GoogleFonts.lato(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
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
