// ignore_for_file: deprecated_member_use, prefer_collection_literals
import 'package:get/get.dart';
import 'package:sos_docteur/models/configs_model.dart';
import 'package:sos_docteur/models/inernal_data_model.dart';
import 'package:sos_docteur/models/patients/home_model.dart';
import 'package:sos_docteur/models/patients/meeting_model.dart';
import 'package:sos_docteur/models/patients/patient_diagnostics_model.dart';
import 'package:sos_docteur/services/db_service.dart';
import 'package:sos_docteur/services/globals_api/globals_api.dart';
import 'package:sos_docteur/services/patient_api_services/patient_api.dart';
import 'package:sos_docteur/utilities/utilities.dart';

class PatientController extends GetxController {
  static PatientController instance = Get.find();
  // ignore: deprecated_member_use, prefer_collection_literals
  var platformMedecins = List<HomeMedecins>().obs;

  var specialities = List<Specialites>().obs;

  var currentMedecins = List<IMedecins>().obs;

  var meetings = List<ConsultationsRdv>().obs;

  var diagnostics = List<ExamensPatient>().obs;

  var patientId = storage.read("patient_id");

  @override
  onInit() {
    super.onInit();
    refreshDatas();
  }

  Future<List<HomeMedecins>> get medecinsList async {
    var homeDatas = await PatientApi.viewHomeContents();
    if (homeDatas != null) {
      var data = homeDatas.content.medecins;
      return data;
    } else {
      return null;
    }
  }

  Future<void> refreshDatas() async {
    //var homeDatas = await PatientApi.viewHomeContents();

    /*if (homeDatas != null) {
      platformMedecins.value = homeDatas.content.medecins;
    }*/
    var s = await GlobalApi.viewHomeConfigs();
    if (s != null) {
      specialities.value = s.config.specialites;
    }
    var m = await DBService.getCurrentSearch();
    if (m != null) {
      currentMedecins.value = m;
    }

    if (patientId != null) {
      var r = await PatientApi.voirRdvEnLigne();
      if (r != null) {
        meetings.value = r.consultationsRdv;
      }

      var d = await PatientApi.voirDiagnostics();
      if (d != null) {
        diagnostics.value = d.examens;
      }
    }
  }

  Future<void> refreshCurrents() async {
    var m = await DBService.getCurrentSearch();
    if (m != null) {
      currentMedecins.value = m;
    }
  }

  Future<void> refreshDiagnostics() async {
    var d = await PatientApi.voirDiagnostics();
    if (d != null) {
      diagnostics.value = d.examens;
    }
  }
}
