import 'package:flutter/material.dart';
import 'dart:io';
import 'package:my_wishes/model/article.dart';
import 'package:my_wishes/model/databaseClient.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';


class Ajout extends StatefulWidget {

  int id;

  Ajout(int id){
    this.id = id;
  }

  @override
  _AjoutState createState() => new _AjoutState();

}
class _AjoutState extends State<Ajout> {
  String image;
  String nom;
  String prix;
  String magasin;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Ajouter"),
        actions: <Widget>[
          new FlatButton(
            onPressed: ajouter,
            child: new Text('Valider', style: new TextStyle(color: Colors.white),),
          ),
        ],
      ),
      body: new SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: new Column(
          children: <Widget>[
            new Text('Article à ajouter', textScaleFactor: 1.4, style: new TextStyle(color: Colors.red, fontStyle: FontStyle.italic),),
            SingleChildScrollView(
              child: new Card(
                elevation: 10.0,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    (image == null)? new Image.asset('images/no_image.jpg'): new Image.file(new File(image)),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        new IconButton(icon: new Icon(Icons.camera_enhance), onPressed: (() => getImage(ImageSource.camera))),
                        new IconButton(icon: new Icon(Icons.photo_library), onPressed: (() => getImage(ImageSource.gallery))),
                      ],
                    ),
                    textField(TypeTextField.nom, ' Le nom de l\'article'),
                    textField(TypeTextField.prix, ' Le prix de l\'article'),
                    textField(TypeTextField.magasin, ' Magasin'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextField textField(TypeTextField type, String label) {
    return new TextField(
      decoration: new InputDecoration(labelText: label),
      onChanged: (String string){
        switch(type) {
          case TypeTextField.nom:
            nom = string;
            break;
          case TypeTextField.prix:
            prix = string;
            break;
          case TypeTextField.magasin:
            magasin = string;
            break;
        }
      },
    );
  }
  //fonction pour ajouter nos champs dans la bd
  void ajouter() {
    if(nom != null){
      Map<String, dynamic> map = {'nom': nom, 'item': widget.id};
      if(magasin != null){
        map['magasin'] = magasin;
      }
      if(prix != null){
        map['prix'] = prix;
      }
      if(image != null){
        map['image'] = image;
      }
      Article article = new Article();
      article.fromMap(map);
      DatabaseClient().ajoutArticle(article).then((value){
        image = null;
        magasin = null;
        prix = null;
        nom = null;
        Navigator.pop(context);
      });
    }
  }

  //fonction pour recuperer mon image
  Future getImage(ImageSource source) async {
    var nouvelleImage = await ImagePicker.pickImage(source: source);
    setState(() {
      image = nouvelleImage.path;
    });
  }

}

enum TypeTextField { nom, prix, magasin}