import 'package:sos_docteur/index.dart';
import 'package:sos_docteur/models/medecins/medecin_profil.dart';
import 'package:sos_docteur/models/medecins/medecins_examens_diagnostics_model.dart';
import 'package:sos_docteur/models/medecins/schedule_model.dart';

class MedecinController extends GetxController {
  static MedecinController instance = Get.find();

  @override
  void onInit() {
    super.onInit();
    refreshDatas();
  }

  var medecinProfil = MedecinProfil().obs;

  // ignore: deprecated_member_use, prefer_collection_literals
  var medecinsExamens = List<Examens>().obs;

  // ignore: deprecated_member_use, prefer_collection_literals
  var medecinRdvs = List<ScheduleConsultationsRdv>().obs;

  Future<void> refreshDatas() async {
    var medecinId = storage.read("medecin_id");
    if (medecinId != null) {
      try {
        refreshProfil();
        refreshExamens();
        refreshRdvs();
      } catch (err) {
        print("error from refreshing data $err");
      }
    }
  }

  Future<void> refreshProfil() async {
    var medecin = await MedecinApi.voirProfil();
    if (medecin != null) {
      medecinProfil.value = medecin;
    }
  }

  Future<void> refreshExamens() async {
    var medecinId = storage.read("medecin_id");
    if (medecinId != null) {
      try {
        var e = await MedecinApi.voirExamens();
        medecinsExamens.value = e.examens;
      } catch (err) {
        print("error from refreshing data $err");
      }
    }
  }

  Future<void> refreshRdvs() async {
    var medecinId = storage.read("medecin_id");
    if (medecinId != null) {
      try {
        var r = await MedecinApi.voirRdvs();
        medecinRdvs.value = r.consultationsRdv;
      } catch (err) {
        print("error from refreshing data $err");
      }
    }
  }
}
