import 'package:flutter/material.dart';
import 'package:my_wishes/model/item.dart';
import 'package:my_wishes/model/article.dart';
import 'donnees_vides.dart';
import 'ajout_article.dart';
import 'package:my_wishes/model/databaseClient.dart';
import 'dart:io';

class ItemDetail extends StatefulWidget {
  Item item;

  ItemDetail(Item item){
    this.item = item;
  }
  @override
  _ItemDetailState createState() => _ItemDetailState();

}

class _ItemDetailState extends State<ItemDetail> {
  List<Article> articles;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DatabaseClient().itemArticles(widget.item.id).then((liste) {
      setState(() {
        articles = liste;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.item.nom),
          actions: <Widget>[
            new FlatButton(onPressed: (){
              Navigator.push(context, new MaterialPageRoute(builder: (BuildContext context){
                return new Ajout(widget.item.id);
              })).then((value) {
                DatabaseClient().itemArticles(widget.item.id).then((liste) {
                  setState(() {
                    articles = liste;
                  });
                });
              });
            }, child: new Text('ajouter', style: new TextStyle(color: Colors.white),))
          ],
        ),
        body: (articles == null || articles.length == 0)
            ? new DonneesVides()
            : new GridView.builder(
            itemCount: articles.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, i){
              Article article = articles[i];
              return new Card(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text(article.nom, textScaleFactor: 1.4,),
                    new Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      child:  (article.image == null)? new Image.asset('images/no_image.jpg')
                          : new Image.file(new File(article.image)),
                    ),
                    new Text((article.prix == null)? 'aucun prix renseigné': "prix: ${article.prix}"),
                    new Text((article.magasin == null)? 'aucun magasin renseigné': "magasin: ${article.magasin}"),
                  ],
                ),
              );
            })
    );
  }
}