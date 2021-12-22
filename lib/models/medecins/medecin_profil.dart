class MedecinProfil {
  MedecinDatas datas;

  MedecinProfil({this.datas});

  MedecinProfil.fromJson(Map<String, dynamic> json) {
    datas = json['reponse'] != null
        ? new MedecinDatas.fromJson(json['reponse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.datas != null) {
      data['reponse'] = this.datas.toJson();
    }
    return data;
  }
}

class MedecinDatas {
  String medecinId;
  String photo;
  String nom;
  String telephone;
  String email;
  String sexe;
  String pass;
  String medecinStatus;
  String dateEnregistrement;
  List<ProfilSpecialites> profilSpecialites;
  List<ProfilEtudesFaites> profilEtudesFaites;
  List<ProfilAgenda> profilAgenda;

  MedecinDatas(
      {this.medecinId,
      this.photo,
      this.nom,
      this.telephone,
      this.email,
      this.sexe,
      this.pass,
      this.medecinStatus,
      this.dateEnregistrement,
      this.profilSpecialites,
      this.profilEtudesFaites,
      this.profilAgenda});

  MedecinDatas.fromJson(Map<String, dynamic> json) {
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
      profilSpecialites = new List<ProfilSpecialites>();
      json['specialites'].forEach((v) {
        profilSpecialites.add(new ProfilSpecialites.fromJson(v));
      });
    }
    if (json['etudes_faites'] != null) {
      profilEtudesFaites = new List<ProfilEtudesFaites>();
      json['etudes_faites'].forEach((v) {
        profilEtudesFaites.add(new ProfilEtudesFaites.fromJson(v));
      });
    }
    if (json['agenda'] != null) {
      profilAgenda = new List<ProfilAgenda>();
      json['agenda'].forEach((v) {
        profilAgenda.add(new ProfilAgenda.fromJson(v));
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
    if (this.profilSpecialites != null) {
      data['specialites'] =
          this.profilSpecialites.map((v) => v.toJson()).toList();
    }
    if (this.profilEtudesFaites != null) {
      data['etudes_faites'] =
          this.profilEtudesFaites.map((v) => v.toJson()).toList();
    }
    if (this.profilAgenda != null) {
      data['agenda'] = this.profilAgenda.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProfilSpecialites {
  String medecinSpecialiteId;
  String medecinId;
  String specialite;
  String medecinSpecialiteStatus;
  String dateEnregistrement;

  ProfilSpecialites(
      {this.medecinSpecialiteId,
      this.medecinId,
      this.specialite,
      this.medecinSpecialiteStatus,
      this.dateEnregistrement});

  ProfilSpecialites.fromJson(Map<String, dynamic> json) {
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

class ProfilEtudesFaites {
  String medecinEtudesFaiteId;
  String medecinId;
  String institut;
  String etude;
  String periodeDebut;
  String periodeFin;
  String certificat;
  String adresseId;
  String medecinEtudesFaitesStatus;
  String dateEnregistrement;
  MedecinAdresse adresse;

  ProfilEtudesFaites(
      {this.medecinEtudesFaiteId,
      this.medecinId,
      this.institut,
      this.etude,
      this.periodeDebut,
      this.periodeFin,
      this.certificat,
      this.adresseId,
      this.medecinEtudesFaitesStatus,
      this.dateEnregistrement,
      this.adresse});

  ProfilEtudesFaites.fromJson(Map<String, dynamic> json) {
    medecinEtudesFaiteId = json['medecin_etudes_faite_id'];
    medecinId = json['medecin_id'];
    institut = json['institut'];
    etude = json['etude'];
    periodeDebut = json['periode_debut'];
    periodeFin = json['periode_fin'];
    certificat = json['certificat'];
    adresseId = json['adresse_id'];
    medecinEtudesFaitesStatus = json['medecin_etudes_faites_status'];
    dateEnregistrement = json['date_enregistrement'];
    adresse = json['adresse'] != null
        ? new MedecinAdresse.fromJson(json['adresse'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medecin_etudes_faite_id'] = this.medecinEtudesFaiteId;
    data['medecin_id'] = this.medecinId;
    data['institut'] = this.institut;
    data['etude'] = this.etude;
    data['periode_debut'] = this.periodeDebut;
    data['periode_fin'] = this.periodeFin;
    data['certificat'] = this.certificat;
    data['adresse_id'] = this.adresseId;
    data['medecin_etudes_faites_status'] = this.medecinEtudesFaitesStatus;
    data['date_enregistrement'] = this.dateEnregistrement;
    if (this.adresse != null) {
      data['adresse'] = this.adresse.toJson();
    }
    return data;
  }
}

class MedecinAdresse {
  String pays;
  String ville;
  String adresse;

  MedecinAdresse({this.pays, this.ville, this.adresse});

  MedecinAdresse.fromJson(Map<String, dynamic> json) {
    pays = json['pays'];
    ville = json['ville'];
    adresse = json['adresse'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pays'] = this.pays;
    data['ville'] = this.ville;
    data['adresse'] = this.adresse;
    return data;
  }
}

class ProfilAgenda {
  String medecinDatesDisponibleId;
  String medecinId;
  String date;
  String medecinDateDisponibleStatus;
  String dateEnregistrement;
  List<DispoHeures> heures;

  ProfilAgenda(
      {this.medecinDatesDisponibleId,
      this.medecinId,
      this.date,
      this.medecinDateDisponibleStatus,
      this.dateEnregistrement,
      this.heures});

  ProfilAgenda.fromJson(Map<String, dynamic> json) {
    medecinDatesDisponibleId = json['medecin_dates_disponible_id'];
    medecinId = json['medecin_id'];
    date = json['date'];
    medecinDateDisponibleStatus = json['medecin_date_disponible_status'];
    dateEnregistrement = json['date_enregistrement'];
    if (json['heures'] != null) {
      heures = new List<DispoHeures>();
      json['heures'].forEach((v) {
        heures.add(new DispoHeures.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medecin_dates_disponible_id'] = this.medecinDatesDisponibleId;
    data['medecin_id'] = this.medecinId;
    data['date'] = this.date;
    data['medecin_date_disponible_status'] = this.medecinDateDisponibleStatus;
    data['date_enregistrement'] = this.dateEnregistrement;
    if (this.heures != null) {
      data['heures'] = this.heures.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DispoHeures {
  String medecinHeuresDisponibleId;
  String medecinDatesDisponibleId;
  String medecinId;
  String heureDebut;
  String heureFin;
  String medecinHeuresDisponibleStatus;
  String dateEnregistrement;

  DispoHeures(
      {this.medecinHeuresDisponibleId,
      this.medecinDatesDisponibleId,
      this.medecinId,
      this.heureDebut,
      this.heureFin,
      this.medecinHeuresDisponibleStatus,
      this.dateEnregistrement});

  DispoHeures.fromJson(Map<String, dynamic> json) {
    medecinHeuresDisponibleId = json['medecin_heures_disponible_id'];
    medecinDatesDisponibleId = json['medecin_dates_disponible_id'];
    medecinId = json['medecin_id'];
    heureDebut = json['heure_debut'];
    heureFin = json['heure_fin'];
    medecinHeuresDisponibleStatus = json['medecin_heures_disponible_status'];
    dateEnregistrement = json['date_enregistrement'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['medecin_heures_disponible_id'] = this.medecinHeuresDisponibleId;
    data['medecin_dates_disponible_id'] = this.medecinDatesDisponibleId;
    data['medecin_id'] = this.medecinId;
    data['heure_debut'] = this.heureDebut;
    data['heure_fin'] = this.heureFin;
    data['medecin_heures_disponible_status'] =
        this.medecinHeuresDisponibleStatus;
    data['date_enregistrement'] = this.dateEnregistrement;
    return data;
  }
}
