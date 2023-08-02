class Article {
  final String idLot;
  final int numeroCoupon;
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

  Article(
      {this.idLot = "",
      this.numeroCoupon = 0,
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
          prixVente: json['prixVente'],
          homologation: json['homologation'],
          type: types[int.parse(json['type'])],
          marque: json['marque'],
          modele: json['modele'],
          couleur: json['couleurVoile'],
          // annee: json['annee'],
          pTVMin: json['PTVMin'],
          pTVMax: json['PTVMax'],
          taille: json['taille'],
          commentaire: json['commentaire']);
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
        'commentaire': commentaire,
      };
}
