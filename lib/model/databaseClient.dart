import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:my_wishes/model/item.dart';
import 'article.dart';

class DatabaseClient {
  Database _database;
  // acceder et obtenir les infos de ma bd
  Future<Database> get database async {
    if(_database != null){
      return _database;
    } else {
      //creer cette database
      _database = await create();
      return _database;
    }
  }

  //fonction pour creer la database
  Future create() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String database_directory = join(directory.path, 'database.db');
    var bdd = await openDatabase(database_directory, version: 1, onCreate: _onCreate);
    return bdd;
  }
  // je cree une table "item" avec un "id" et un "nom"
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE item (
    id INTEGER PRIMARY KEY, 
    nom TEXT NOT NULL)
    ''');
    await db.execute('''
    CREATE TABLE article(
    id INTEGER PRIMARY KEY,
    nom TEXT NOT NULL,
    item INTEGER,
    prix TEXT,
    magasin TEXT,
    image TEXT
    )
    ''');
  }
  /*  debut de fonctions pour ecriture des donnees */
  //celle ci ajoute mes donnees a ma bd
  Future<Item> ajoutItem(Item item) async{
    //je verifie d'abord que ma db a été crée
    Database maDatabase = await database;
    //j'insere id dans maDatabase plus precisement dans la table "item" avec pour valeur un entier contenu dans item.toMap.
    item.id = await maDatabase.insert('item', item.toMap());
    return item;
  }

  //recupere un int(id) de la data et modifie cette data
  Future<int> modifierItem(Item item) async {
    //appel la db dabord
    Database maDatabase =  await database;
    return maDatabase.update('item', item.toMap(), where: 'id: ?', whereArgs: [item.id]);
  }
  //fonction qui modifie(met a jours) ou insere selon ce qu'on a.
  Future<Item> modifOuInser(Item item) async{
    //appel la db dabord
    Database maDatabase =  await database;
    if(item.id == null){
      item.id = await maDatabase.insert('item', item.toMap());
    } else {
      await maDatabase.update('item', item.toMap(), where: 'id = ?', whereArgs: [item.id]);
    }
    return item;
  }

  //fonction qui ajoute des articles,
  //si id de article est nul alors je fais une insertion sinon je fais une modification
  Future<Article> ajoutArticle(Article article) async {
    Database maDatabase = await database;
    (article.id == null)? article.id = await maDatabase.insert('article', article.toMap())
        : maDatabase.update('article', article.toMap(), where: 'id = ?', whereArgs: [article.id]);
    return article;
  }



  //recupere un int(id) de la data et supprime cette data
  Future<int> supprimer(int id, String table) async {
    //appel la db dabord
    Database maDatabase = await database;
    //je supprime les infos de l'item correspondant a la data qui es supprimé
    await maDatabase.delete('article', where: 'item = ?', whereArgs: [id]);
    return await maDatabase.delete(table, where: 'id = ?', whereArgs: [id]);
  }
  /* fin fonctions pour ecriture des donnees */

  /*  debut de fonctions pour lecture des donnees */
  // fonction pour recuperer  touts les infos contenus dans item dou je cree une liste
  Future<List<Item>> allItem() async {
    //je verifie d'abord que ma db a été crée
    Database maDatabase = await database;
    //je cree une liste de map qui va selectionner tout dans ma table item
    List<Map<String, dynamic>> resultat = await maDatabase.rawQuery('SELECT * FROM item');
    // je cree une liste vide de item
    List<Item> items =[];
    resultat.forEach((map) {
      Item item = new Item();
      item.fromMap(map);
      items.add(item);
    });
    return items;
  }

  // fonction qui recupere et affiche les articles d'un item precis en provenance de la bd
  Future<List<Article>> itemArticles (int item) async{
    Database maDatabase =  await database;
    List<Map<String, dynamic>> resultat = await maDatabase.query('article', where: 'item = ?', whereArgs: [item]);
    List<Article> articles = [];
    resultat.forEach((map) {
      Article article = new Article();
      article.fromMap(map);
      articles.add(article);
    });
    return articles;

  }



/*  fin de fonctions pour lecture des donnees */
}