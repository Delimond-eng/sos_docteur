import 'package:flutter/cupertino.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:sos_docteur/models/patients/account_model.dart';

import '../../index.dart';

class RegisterPage extends StatefulWidget {
  final Function onBackToLogin;

  const RegisterPage({Key key, this.onBackToLogin}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String gender;
  String typeUser;

  final textNom = TextEditingController();
  final textEmail = TextEditingController();
  final textPhone = TextEditingController();
  final textPass = TextEditingController();
  final textConfirmation = TextEditingController();
  String countryCode = "";
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: AuthInputText(
            icon: CupertinoIcons.person,
            hintText: "Entez votre nom complet",
            inputController: textNom,
            isPassWord: false,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: AuthInputText(
            icon: CupertinoIcons.envelope_badge,
            hintText: "Entez votre adresse email",
            inputController: textEmail,
            keyType: TextInputType.emailAddress,
            isPassWord: false,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          margin: const EdgeInsets.only(left: 10.0, right: 10.0),
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  blurRadius: 12.0,
                  offset: const Offset(0, 3))
            ],
          ),
          child: IntlPhoneField(
            controller: textPhone,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              hintMaxLines: 9,
              contentPadding: const EdgeInsets.only(top: 10, bottom: 10),
              hintText: "n° de téléphone",
              hintStyle: const TextStyle(color: Colors.black54, fontSize: 14.0),
              border: InputBorder.none,
              counterText: '',
            ),
            initialCountryCode: 'CD',
            onChanged: (phone) {
              setState(() {
                countryCode = phone.countryCode;
              });
            },
            onCountryChanged: (phone) {
              setState(() {
                countryCode = phone.countryCode;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30.0)),
                  child: DropdownButton<String>(
                    menuMaxHeight: 300,
                    dropdownColor: Colors.white,
                    alignment: Alignment.centerRight,
                    borderRadius: BorderRadius.circular(8.0),
                    style: GoogleFonts.lato(color: Colors.black),
                    value: gender,
                    underline: SizedBox(),
                    hint: Text(
                      "  Sexe...",
                      style: GoogleFonts.mulish(
                          color: Colors.grey[600],
                          fontSize: 15.0,
                          fontStyle: FontStyle.italic),
                    ),
                    isExpanded: true,
                    items: ["Masculin", "Féminin"].map((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "$e",
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w400),
                            ),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        gender = value;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
              Flexible(
                child: Container(
                  height: 50,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: DropdownButton<String>(
                    menuMaxHeight: 300,
                    alignment: Alignment.centerRight,
                    dropdownColor: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    style: GoogleFonts.lato(color: Colors.black),
                    value: typeUser,
                    underline: SizedBox(),
                    hint: Text(
                      "  Vous êtes",
                      style: GoogleFonts.mulish(
                          color: Colors.grey[600],
                          fontSize: 15.0,
                          fontStyle: FontStyle.italic),
                    ),
                    isExpanded: true,
                    items: ["Médecin", "Patient"].map((e) {
                      return DropdownMenuItem<String>(
                          value: e,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "$e",
                              style:
                                  GoogleFonts.lato(fontWeight: FontWeight.w400),
                            ),
                          ));
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        typeUser = value;
                      });
                    },
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: AuthInputText(
            icon: CupertinoIcons.lock,
            hintText: "Entez le mot de passe",
            inputController: textPass,
            isPassWord: true,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          child: AuthInputText(
            icon: CupertinoIcons.checkmark_alt_circle_fill,
            hintText: "Confirmez votre mot de passe",
            inputController: textConfirmation,
            isPassWord: true,
          ),
        ),
        const SizedBox(
          height: 10.0,
        ),
        Container(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
          height: 50.0,
          width: MediaQuery.of(context).size.width,
          // ignore: deprecated_member_use
          child: RaisedButton(
            onPressed: registerMedecin,
            color: primaryColor,
            child: Text("Créer".toUpperCase(),
                style: style1(
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
          ),
        )
      ],
    );
  }

  Future<void> registerMedecin() async {
    if (textNom.text.isEmpty) {
      Get.snackbar(
        " Saisie obligatoire !",
        "vous devez entrer votre nom complet!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 5),
      );
      return;
    }
    if (textEmail.text.isEmpty) {
      Get.snackbar(
        " Saisie obligatoire !",
        "vous devez entrer votre adresse email!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (textPhone.text.isEmpty) {
      Get.snackbar(
        " Saisie obligatoire !",
        "vous devez entrer votre téléphone!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (textPass.text.isEmpty) {
      Get.snackbar(
        " Saisie obligatoire !",
        "vous devez entrer votre mot de passe de sécurité!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (gender.isEmpty) {
      Get.snackbar(
        " Saisie obligatoire !",
        "vous devez sélectionner votre sexe !",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    if (textPass.text != textConfirmation.text) {
      Get.snackbar(
        "Echec de la confirmation de mot de passe!",
        "La confirmation de votre mot de passe a echoué !",
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 5),
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
      );
      return;
    }
    Medecins medecin = Medecins(
      nom: textNom.text,
      email: textEmail.text,
      telephone: '$countryCode${textPhone.text}',
      password: textPass.text,
      gender: gender,
    );

    Patient patient = Patient(
      patientPass: textPass.text,
      patientEmail: textEmail.text,
      patientNom: textNom.text,
      patientPhone: '$countryCode${textPhone.text}',
      patientSexe: gender,
    );

    var result;

    if (typeUser == "Patient") {
      Xloading.showLottieLoading(context);
      result = await PatientApi.registerAccount(patient: patient);
    } else if (typeUser == "Médecin") {
      Xloading.showLottieLoading(context);
      result = await MedecinApi.registerAccount(medecin: medecin);
    } else {
      XDialog.showErrorMessage(
        context,
        color: Colors.amber[900],
        title: "Action obligatoire!",
        message: "vous devez sélectionner le type d'utilisateur que vous êtes!",
      );
      return;
    }

    if (result == null) {
      Xloading.dismiss();
      Get.snackbar(
        "Echec !",
        "la création du compte n'a pas été effectuée!,\nemail ou numéro de téléphone déjà est déjà utilisé pour un autre Médecin!",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.amber[900],
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
        duration: const Duration(seconds: 5),
      );
      return;
    } else {
      Xloading.dismiss();
      Get.snackbar(
        "Félicitation !",
        "votre compte $typeUser a été créé avec succès!\nveuillez utiliser vos identifiants pour vous connecter !",
        snackPosition: SnackPosition.TOP,
        colorText: Colors.white,
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 5),
        maxWidth: MediaQuery.of(context).size.width - 4,
        borderRadius: 2,
      );
      Future.delayed(const Duration(seconds: 3));
      widget.onBackToLogin();
    }
  }
}
