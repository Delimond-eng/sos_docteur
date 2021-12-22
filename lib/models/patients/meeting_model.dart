class Meeting {
  List<ConsultationsRdv> consultationsRdv;

  Meeting({this.consultationsRdv});

  Meeting.fromJson(Map<String, dynamic> json) {
    if (json['consultations_rdv'] != null) {
      consultationsRdv = new List<ConsultationsRdv>();
      json['consultations_rdv'].forEach((v) {
        consultationsRdv.add(new ConsultationsRdv.fromJson(v));
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

class ConsultationsRdv {
  String consultationRdvId;
  String medecinId;
  String date;
  String heureDebut;
  String heureFin;
  MeetMedecin medecin;

  ConsultationsRdv(
      {this.consultationRdvId,
      this.medecinId,
      this.date,
      this.heureDebut,
      this.heureFin,
      this.medecin});

  ConsultationsRdv.fromJson(Map<String, dynamic> json) {
    consultationRdvId = json['consultation_rdv_id'];
    medecinId = json['medecin_id'];
    date = json['date'];
    heureDebut = json['heure_debut'];
    heureFin = json['heure_fin'];
    medecin = json['medecin'] != null
        ? new MeetMedecin.fromJson(json['medecin'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['consultation_rdv_id'] = this.consultationRdvId;
    data['medecin_id'] = this.medecinId;
    data['date'] = this.date;
    data['heure_debut'] = this.heureDebut;
    data['heure_fin'] = this.heureFin;
    if (this.medecin != null) {
      data['medecin'] = this.medecin.toJson();
    }
    return data;
  }
}

class MeetMedecin {
  String medecinId;
  String photo;
  String nom;
  String telephone;
  String email;
  String sexe;
  String pass;
  String medecinStatus;
  String dateEnregistrement;
  List<MeetSpecialites> specialites;

  MeetMedecin(
      {this.medecinId,
      this.photo,
      this.nom,
      this.telephone,
      this.email,
      this.sexe,
      this.pass,
      this.medecinStatus,
      this.dateEnregistrement,
      this.specialites});

  MeetMedecin.fromJson(Map<String, dynamic> json) {
    medecinId = json['medecin_id'];
    photo = json['photo'];
    nom = json['nom'];
    telephone = json['telephone'];
    email = json['email'];
    sexe = json['sexe'];
    pass = json['pass'];
    medecinStatus = json['medecin_status'];
    dateEnregistrement = json['date_enregistrement'];
    if (json['specialites'] != null) {
      specialites = new List<MeetSpecialites>();
      json['specialites'].forEach((v) {
        specialites.add(new MeetSpecialites.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medecin_id'] = this.medecinId;
    data['photo'] = this.photo;
    data['nom'] = this.nom;
    data['telephone'] = this.telephone;
    data['email'] = this.email;
    data['sexe'] = this.sexe;
    data['pass'] = this.pass;
    data['medecin_status'] = this.medecinStatus;
    data['date_enregistrement'] = this.dateEnregistrement;
    if (this.specialites != null) {
      data['specialites'] = this.specialites.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MeetSpecialites {
  String medecinSpecialiteId;
  String medecinId;
  String specialite;
  String medecinSpecialiteStatus;
  String dateEnregistrement;

  MeetSpecialites(
      {this.medecinSpecialiteId,
      this.medecinId,
      this.specialite,
      this.medecinSpecialiteStatus,
      this.dateEnregistrement});

  MeetSpecialites.fromJson(Map<String, dynamic> json) {
    medecinSpecialiteId = json['medecin_specialite_id'];
    medecinId = json['medecin_id'];
    specialite = json['specialite'];
    medecinSpecialiteStatus = json['medecin_specialite_status'];
    dateEnregistrement = json['date_enregistrement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medecin_specialite_id'] = this.medecinSpecialiteId;
    data['medecin_id'] = this.medecinId;
    data['specialite'] = this.specialite;
    data['medecin_specialite_status'] = this.medecinSpecialiteStatus;
    data['date_enregistrement'] = this.dateEnregistrement;
    return data;
  }
}
