import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sos_docteur/constants/style.dart';

import '../../index.dart';

class PatientProfilPage extends StatefulWidget {
  @override
  _PatientProfilPageState createState() => _PatientProfilPageState();
}

class _PatientProfilPageState extends State<PatientProfilPage> {
  final ScrollController _scrollController = ScrollController();
  double position = 0;

  @override
  void initState() {
    super.initState();
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
            )),
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
              child: ListView(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 20.0),
                physics: const ScrollPhysics(),
                controller: _scrollController,
                children: [_header(), const SizedBox(height: 30.0), _profils()],
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
                  )),
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              "Personnalisation Profil",
              style: style1(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20.0),
            )
          ],
        ),
        Container(
          height: 40.0,
          width: 40.0,
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
            child: Icon(CupertinoIcons.person, color: Colors.white),
          ),
        )
      ],
    );
  }

  Widget _profils() {
    return Column(
      children: [
        Column(
          children: [
            Stack(
              overflow: Overflow.visible,
              children: [
                Container(
                  height: 100.0,
                  width: 100.0,
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
                      print("edit photo");
                    },
                    child: Container(
                      height: 50.0,
                      width: 50.0,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: primaryColor),
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
            Text("Bobby Parker",
                style: style1(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0)),
            const SizedBox(height: 8.0),
            Text("bobbyParker@gmail.com",
                style: style1(
                    color: Colors.grey[100],
                    fontWeight: FontWeight.w700,
                    fontSize: 12.0)),
          ],
        )
      ],
    );
  }
}
