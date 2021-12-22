import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sos_docteur/constants/style.dart';
import 'package:sos_docteur/models/patients/meeting_model.dart';

class ClientScheduleCard extends StatelessWidget {
  final ConsultationsRdv data;
  final Function onPressed;
  final Function onCancelled;

  const ClientScheduleCard({this.data, this.onPressed, this.onCancelled});
  @override
  Widget build(BuildContext context) {
    var _size = MediaQuery.of(context).size;
    return Stack(
      // ignore: deprecated_member_use
      overflow: Overflow.visible,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(10.0),
          onTap: onPressed,
          child: Container(
            height: 140.0,
            width: _size.width,
            margin: const EdgeInsets.only(bottom: 10.0),
            decoration: BoxDecoration(
              image: const DecorationImage(
                  image:
                      AssetImage("assets/images/vector/undraw_doctor_kw5l.png"),
                  fit: BoxFit.cover),
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(.3),
                  offset: const Offset(0, 4),
                  blurRadius: 12.0,
                )
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(.3),
                      offset: const Offset(0, 4),
                      blurRadius: 12.0,
                    )
                  ],
                  color: Colors.white.withOpacity(.8)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. ${data.medecin.nom}",
                              style: style1(
                                  fontSize: 18.0, fontWeight: FontWeight.w800),
                            ),
                            const SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              data.medecin.specialites[0].specialite,
                              style: style1(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey),
                            ),
                          ],
                        ),
                        if (data.medecin.photo.length > 200 &&
                            data.medecin.photo != null)
                          Container(
                            height: 50.0,
                            width: 50.0,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: MemoryImage(
                                  base64Decode(data.medecin.photo),
                                ),
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                const BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 12.0,
                                  offset: Offset(0, 3),
                                )
                              ],
                            ),
                          )
                        else
                          Container(
                            height: 50.0,
                            width: 50.0,
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blue[800],
                                  Colors.cyan,
                                ],
                              ),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(.4),
                                  blurRadius: 12.0,
                                  offset: const Offset(0, 3),
                                )
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                CupertinoIcons.person_fill,
                                color: Colors.white,
                              ),
                            ),
                          )
                      ],
                    ),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Divider(color: Colors.grey[300], thickness: 0.5),
                    const SizedBox(
                      height: 5.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.calendar,
                                size: 15.0,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(strDateLong(data.date))
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              const Icon(
                                CupertinoIcons.time,
                                size: 15.0,
                              ),
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "${data.heureDebut} -  ${data.heureFin}",
                                style: GoogleFonts.lato(
                                    fontSize: 17,
                                    color: Colors.blue[800],
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          right: -5,
          child: GestureDetector(
            onTap: onCancelled,
            child: Container(
              height: 30.0,
              width: 30.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red[200],
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(.4),
                        blurRadius: 12.0,
                        offset: const Offset(0, 3))
                  ]),
              child: Center(
                child: Icon(
                  CupertinoIcons.minus,
                  color: Colors.red[800],
                  size: 18.0,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
