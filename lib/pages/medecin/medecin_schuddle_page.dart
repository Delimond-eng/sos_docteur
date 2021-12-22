import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:flutter/cupertino.dart';
import 'package:sos_docteur/video_calls/models/call_model.dart';
import 'package:sos_docteur/video_calls/pages/call_screen.dart';
import 'package:sos_docteur/video_calls/permissions.dart';
import 'package:sos_docteur/video_calls/resources/call_methods.dart';
import 'package:sos_docteur/widgets/med_shedule_card.dart';
import 'package:sos_docteur/widgets/user_session_widget.dart';
import 'dart:math' as math;

import '../../index.dart';

class MedecinScheddulePage extends StatefulWidget {
  MedecinScheddulePage({Key key}) : super(key: key);

  @override
  _MedecinScheddulePageState createState() => _MedecinScheddulePageState();
}

class _MedecinScheddulePageState extends State<MedecinScheddulePage> {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      uid: storage.read("medecin_id").toString(),
      scaffold: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image:
                    AssetImage("assets/images/vector/undraw_medicine_b1ol.png"),
                fit: BoxFit.cover),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.blue[900],
                  Colors.white.withOpacity(.9),
                  Colors.white.withOpacity(.9),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SafeArea(
              child: Obx(() {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
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
                              const SizedBox(
                                width: 8.0,
                              ),
                              Text(
                                "Mes rendez-vous",
                                style: GoogleFonts.lato(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          if (storage.read("isMedecin") == true) UserSession()
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0, top: 5.0, right: 16.0, left: 16.0),
                      child: Row(
                        children: [
                          Flexible(
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              height: 40.0,
                              width: MediaQuery.of(context).size.width,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                elevation: 10.0,
                                color: Colors.blue[900],
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0)),
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
                            // ignore: sized_box_for_whitespace
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 40.0,
                              // ignore: deprecated_member_use
                              child: RaisedButton(
                                elevation: 5.0,
                                color: Colors.white.withOpacity(.7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5.0),
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
                    const SizedBox(height: 10.0),
                    Expanded(child: _listSchedule(context))
                  ],
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _listSchedule(context) {
    return ListView.builder(
      padding: const EdgeInsets.only(
          bottom: 60.0, right: 15.0, left: 15.0, top: 10.0),
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: medecinController.medecinRdvs.length,
      itemBuilder: (context, index) {
        var data = medecinController.medecinRdvs[index];
        return MedScheduleCard(
          data: data,
          onCalling: () async {
            // update input validation
            await handleCameraAndMic(Permission.camera);
            await handleCameraAndMic(Permission.microphone);

            String uid = storage.read("medecin_id");
            String uName = storage.read('medecin_nom');
            String uPic = storage.read('photo');

            Call call = Call(
                callerId: uid,
                callerName: uName,
                callerPic: uPic,
                callerType: "medecin",
                receiverName: data.nom,
                receiverPic: "",
                receiverType: "medecin",
                receiverId: data.patientId,
                channelId:
                    '$uid${data.patientId}${math.Random().nextInt(1000).toString()}');
            await CallMethods.makeCall(call: call);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CallScreen(
                  role: ClientRole.Broadcaster,
                  call: call,
                  hasCaller: true,
                ),
              ),
            );
          },
          onCancelled: () {},
        );
      },
    );
  }
}
