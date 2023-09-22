class Article {
  final String idLot;
  final int numeroCoupon;
  bool isLot;
  final String prixVente;
  final String homologation;
  final String type;
  final String marque;
  final String modele;
  final String couleur;
  final String annee;
  final String pTVMin;
  final String pTVMax;
  final String taille;
  final String commentaire;
  final int heureVolesVoile;

  Article(
      {this.idLot = "",
      this.numeroCoupon = 0,
      this.isLot = false,
      this.prixVente = "",
      this.homologation = "",
      this.type = "",
      this.marque = "",
      this.modele = "",
      this.couleur = "",
      this.annee = "",
      this.pTVMin = "",
      this.pTVMax = "",
      this.taille = "",
      this.heureVolesVoile = 0,
      this.commentaire = ""});

  factory Article.fromJson(Map<String, dynamic> json) {
    final List<String> types = [
      '🪂Voile',
      '💺Sellette',
      '🆘Secours',
      '🛠️Accessoire'
    ];
    // Use a Try/Catch and show error message
    try {
      return Article(
          idLot: json['idLot'],
          numeroCoupon: int.parse(json['numeroCoupon']),
          isLot: false,
          prixVente: json['prixVente'],
          // Replace &amp; by & in homologation
          homologation: json['homologation'].replaceAll("&amp;", "&"),
          type: types[int.parse(json['type'])],
          marque: json['marque'] ?? "",
          modele: json['modele'] ?? "",
          couleur: json['couleurVoile'] ?? "",
          // annee: json['annee'],
          pTVMin: json['PTVMin'] != '0' ? json['PTVMin'] : "",
          pTVMax: json['PTVMax'] != '0' ? json['PTVMax'] : "",
          // Remove "taille " from taille, regardless of CAPS
          taille: json['taille'].replaceAll(RegExp(r'taille ', caseSensitive: false), ""),
          // commentaire: concatenate taille ("Taille: xyz.") if not empty, and heuresDeVol ("Heures de vol: xyz.") if is not 0, and commentaire
          commentaire: (
              ((json['heureVolesVoile'] != '0' && json['heureVolesVoile'] != '' && json['heureVolesVoile'] != null) ? "Heures de vol: ${json['heureVolesVoile']}. " : "") +
              (json['commentaire'] ?? ""))
      );

    }
    // Catch the error and print it
    catch (e) {
      print(e);
      return Article();
    }
  }

  Map<String, dynamic> toJson() => {
        'idLot': idLot,
        'numeroCoupon': numeroCoupon,
        'isLot': isLot,
        'prixVente': prixVente,
        'homologation': homologation,
        'type': type,
        'marque': marque,
        'modele': modele,
        'couleurVoile': couleur,
        // 'annee': annee,
        'PTVMin': pTVMin,
        'PTVMax': pTVMax,
        'taille': taille,
        'heureVolesVoile': heureVolesVoile,
        'commentaire': commentaire,
      };
}
