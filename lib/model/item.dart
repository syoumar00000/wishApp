class Item {
  int id;
  String nom;
  //je cree un constructeur vide
  Item();
  // je cree une map qui va recuperer les donnees saisies par l'user dynamiquement
  // fromMap configure notre Item() en map
  void fromMap(Map<String, dynamic> map){
    this.id = map['id'];
    this.nom = map['nom'];
  }

// toMap convertir notre Item() en map et lenvoyer vers notre bd
   Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      'nom': this.nom
    };
    if(id != null) {
      map['id'] = this.id;
     }
    return map;
   }
}