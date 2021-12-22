import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

List<String> langues = [
  "Sélectionnez une langue",
  "langue",
  "Français",
  "Anglais",
  "Lingala",
  "Swahili",
  "Kikongo",
  "Tshiluba",
  "Espagnol",
  "Portugais",
  "Italien"
];

List<String> specialities = [
  "Sélectionnez une spécialité",
  "Immunologie",
  "Anesthésiologie",
  "Andrologie",
  "Cardiologie",
  "chirurgie générale",
  "Dermatologie",
  "Androcrinologie",
  "Gastro-entérologie",
  "Gériatrie",
  "Gynécologie",
  "Hématologie",
  "Hépatologie",
  "Infectiologie",
  "Médecine interne",
  "Médecine aiguë",
  "Médecine générale",
  "Médecine nucléaire",
  "Médecine palliative",
  "Médecine physique",
  "Médecine préventive",
  "Néonatologie",
  "Néphrologie",
  "Neurologie",
  "Odontologie",
  "Oncologie",
  "Obstétrique",
  "Ophtalmologie",
  "Orthopédie",
  "Octo-rhino-laryngologie",
  "Pédiatrie",
  "Pneumologie",
  "Psychiatrie",
  "Radiologie",
  "Radiothérapie",
  "Rhumatologie",
  "Urologie"
];

List<Specialities> specialitiesList = [
  Specialities(
    icon: "assets/icons/immunity.svg",
    title: "Immunologie",
  ),
  Specialities(
    icon: "assets/icons/syringe.svg",
    title: "Anesthésiologie",
  ),
  Specialities(
    icon: "assets/icons/condom.svg",
    title: "Andrologie",
  ),
  Specialities(icon: "assets/icons/healthcare.svg", title: "Cardiologie"),
  Specialities(
    icon: "assets/icons/surgeon.svg",
    title: "chirurgie générale",
  ),
  Specialities(
    icon: "assets/icons/doctor-trichologist.svg",
    title: "Dermatologie",
  ),
  Specialities(
    icon: "assets/icons/medical-svgrepo-com.svg",
    title: "Androcrinologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-gastroenterologist.svg",
    title: "Gastro-entérologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-team.svg",
    title: "Gériatrie",
  ),
  Specialities(
    icon: "assets/icons/doctor-gynecologist.svg",
    title: "Gynécologie",
  ),
  Specialities(
    icon: "assets/icons/blood-test.svg",
    title: "Hématologie",
  ),
  Specialities(
      icon: "assets/icons/doctor-nephrologist.svg", title: "Hépatologie"),
  Specialities(
    icon: "assets/icons/doctor-infection.svg",
    title: "Infectiologie",
  ),
  Specialities(
    icon: "assets/icons/medical-svgrepo-com.svg",
    title: "Médecine interne",
  ),
  Specialities(
    icon: "assets/icons/medical-svgrepo-com.svg",
    title: "Médecine aiguë",
  ),
  Specialities(
    icon: "assets/icons/medical-svgrepo-com.svg",
    title: "Médecine générale",
  ),
  Specialities(
    icon: "assets/icons/atoms-medical-svgrepo-com.svg",
    title: "Médecine nucléaire",
  ),
  Specialities(
    icon: "assets/icons/medical-svgrepo-com.svg",
    title: "Médecine palliative",
  ),
  Specialities(
    icon: "assets/icons/chemist.svg",
    title: "Médecine physique",
  ),
  Specialities(
    icon: "assets/icons/doctor-gynecologist.svg",
    title: "Néonatologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-nephrologist.svg",
    title: "Néphrologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-neurologist.svg",
    title: "Neurologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-dentist.svg",
    title: "Odontologie",
  ),
  Specialities(
    icon: "assets/icons/radiology-machine.svg",
    title: "Oncologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-gynecologist.svg",
    title: "Obstétrique",
  ),
  Specialities(
    icon: "assets/icons/doctor-optometrist.svg",
    title: "Ophtalmologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-orthopaedic.svg",
    title: "Orthopédie",
  ),
  Specialities(
    icon: "assets/icons/mental-health.svg",
    title: "Octo-rhino-laryngologie",
  ),
  Specialities(
    icon: "assets/icons/medical-svgrepo-com.svg",
    title: "Pédiatrie",
  ),
  Specialities(
    icon: "assets/icons/doctor-nephrologist.svg",
    title: "Pneumologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-nephrologist.svg",
    title: "Psychiatrie",
  ),
  Specialities(
    icon: "assets/icons/radiology-machine.svg",
    title: "Radiologie",
  ),
  Specialities(
    icon: "assets/icons/radiology-machine.svg",
    title: "Radiothérapie",
  ),
  Specialities(
    icon: "assets/icons/doctor-orthopaedic.svg",
    title: "Rhumatologie",
  ),
  Specialities(
    icon: "assets/icons/doctor-team.svg",
    title: "Urologie",
  ),
];

class Specialities {
  String title;
  String icon;
  bool isActive = false;
  Specialities({this.title, this.icon});
}

void showScrollableSheet(context, {List<Widget> childrens}) {
  showModalBottomSheet(
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    context: context,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.8,
        minChildSize: 0.5,
        maxChildSize: 0.8,
        builder: (_, controller) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20.0)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.all(16.0),
                  child: ListView(
                    controller: controller,
                    children: childrens,
                  ),
                ),
                Positioned(
                  top: -25,
                  right: 10,
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.red[200],
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.withOpacity(.4),
                              blurRadius: 12.0,
                              offset: const Offset(0, 3))
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          CupertinoIcons.clear,
                          color: Colors.red[800],
                          size: 18.0,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
    },
  );
}
