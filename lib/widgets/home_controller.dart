import 'package:flutter/material.dart';
import 'dart:async';
import 'package:my_wishes/model/item.dart';
import 'package:my_wishes/widgets/donnees_vides.dart';
import 'package:my_wishes/model/databaseClient.dart';
import 'itemDetail.dart';

class HomeController extends StatefulWidget {
  HomeController({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomeControllerState createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  String nouvelleListe;
  List<Item> items;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    recuperer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
          actions: <Widget>[
            new FlatButton(
              onPressed: (() => ajouter(null)),
              child: new Text("Ajouter", style: new TextStyle(color: Colors.white),),)
          ],
        ),
        //si item est nul ou vide on retourne "donnesvides" sinon on retourne la liste des items
        body: (items == null || items.length == 0)?
        new DonneesVides():
        new ListView.builder(
          itemCount: items.length,
            itemBuilder: (context, i){
            Item item = items[i];
              return new ListTile(
                title: new Text(item.nom),
                trailing: new IconButton(
                    icon: new Icon(Icons.delete),
                    onPressed: (){
                  DatabaseClient().supprimer(item.id, 'item').then((int){
                    recuperer();
                  });
                }),
                leading: new IconButton(
                  icon: new Icon(Icons.edit),
                  onPressed: (() => ajouter(item)),
                ),
                // on va sur la page qui contient toutes les infos de la data qui a subit le clique
                onTap: () {
                  Navigator.push(context, new MaterialPageRoute(builder: (BuildContext buildContext){
                    return new ItemDetail(item);
                  }));
                },
              );
            }
        )

    );
  }

  //ajouter un souhait grace a une alertdialog
  Future<Null> ajouter(Item item) async {
    await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext buildContext){
          return new AlertDialog(
            title: new Text("Ajouter votre liste de souhaits"),
            content: new TextField(
              decoration: new InputDecoration(
                labelText: "Liste",
                hintText: (item == null)?"Ex: mes prochains jeux videos": item.nom,
              ),
              onChanged: (String str){
                nouvelleListe = str;
              },
            ),
            actions: <Widget>[
              //lors du clique sur "annuler" alors le alertdialog se ferme
              new FlatButton(onPressed: (() => Navigator.pop(buildContext)), child: new Text("Annuler")),
              //lors du clique sur "valider",on ajoute dans la bd et on ferme le alertdialog
              new FlatButton(onPressed: (){
                // code pour le mettre dans notre base de données
                if(nouvelleListe != null){
                  if(item == null){
                    item = new Item();
                    Map<String, dynamic> map ={'nom': nouvelleListe};
                    item.fromMap(map);
                  } else {
                    item.nom = nouvelleListe;
                  }
                   DatabaseClient().modifOuInser(item).then((i) => recuperer());
                   nouvelleListe = null;
                }
                // code pour fermer le alertdialog
                Navigator.pop(buildContext);
              }, child: new Text("Valider", style: new TextStyle(color: Colors.blue),)),
            ],
          );
        }
    );
  }
  // fonction de recuperation de donnees
  void recuperer() {
    DatabaseClient().allItem().then((items) {
      setState(() {
        this.items = items;
      });
    });
  }
}
