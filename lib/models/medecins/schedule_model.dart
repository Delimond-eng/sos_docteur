class ScheduleModel {
  List<ScheduleConsultationsRdv> consultationsRdv;

  ScheduleModel({this.consultationsRdv});

  ScheduleModel.fromJson(Map<String, dynamic> json) {
    if (json['consultations_rdv'] != null) {
      consultationsRdv = new List<ScheduleConsultationsRdv>();
      json['consultations_rdv'].forEach((v) {
        consultationsRdv.add(new ScheduleConsultationsRdv.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.consultationsRdv != null) {
      data['consultations_rdv'] =
          this.consultationsRdv.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ScheduleConsultationsRdv {
  String consultationRdvId;
  String patientId;
  String nom;
  String telephone;
  String consultationDate;
  String heureDebut;
  String heureFin;

  ScheduleConsultationsRdv(
      {this.consultationRdvId,
      this.patientId,
      this.nom,
      this.telephone,
      this.consultationDate,
      this.heureDebut,
      this.heureFin});

  ScheduleConsultationsRdv.fromJson(Map<String, dynamic> json) {
    consultationRdvId = json["consultation_rdv_id"];
    patientId = json['patient_id'];
    nom = json['nom'];
    telephone = json['telephone'];
    consultationDate = json['consultation_date'];
    heureDebut = json['heure_debut'];
    heureFin = json['heure_fin'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consultation_rdv_id'] = this.consultationRdvId;
    data['patient_id'] = this.patientId;
    data['nom'] = this.nom;
    data['telephone'] = this.telephone;
    data['consultation_date'] = this.consultationDate;
    data['heure_debut'] = this.heureDebut;
    data['heure_fin'] = this.heureFin;
    return data;
  }
}
