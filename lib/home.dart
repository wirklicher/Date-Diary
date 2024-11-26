import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import './datescreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePage();
}

class _HomePage extends State<HomePage> {
  TextEditingController _dateControlller = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _boardingGamesController = TextEditingController();
  bool isFav = false;
  List<String> imagesPath = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF9A3135),
        appBar: AppBar(
          title: Text(
            "Date Diary",
            style: TextStyle(
                fontFamily: 'ArgentumSans', color: Colors.white, fontSize: 32),
          ),
          centerTitle: true,
          backgroundColor: Color(0xFFFC4850),
          toolbarHeight: MediaQuery.of(context).size.height * 0.105,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          )),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            openDialog(context);
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Color(0xFFFC4850),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        ),
        body: Center(
          child: FutureBuilder<List<Date>>(
              future: DatabaseHelper.instance.getDates(),
              builder:
                  (BuildContext context, AsyncSnapshot<List<Date>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: Text("Loading..."),
                  );
                }
                return snapshot.data!.isEmpty
                    ? Center(
                        child: Text("No dates in database..."),
                      )
                    : Container(
                        child: ListView.builder(
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Center(
                                  child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => Datescreen(
                                          date: snapshot.data![index],
                                        ),
                                      ));
                                },
                                onLongPress: () {
                                  DatabaseHelper.instance
                                      .remove(snapshot.data![index]);
                                  setState(() {});
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(0.0),
                                  ),
                                  color: Color(0xFF9A3135),
                                  elevation: 0,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                          child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ConstrainedBox(
                                                constraints: BoxConstraints(
                                                    maxHeight:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.170,
                                                    maxWidth:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.170),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    image: new DecorationImage(
                                                        image: new FileImage(
                                                            File(snapshot
                                                                .data![index]
                                                                .imagesPath!
                                                                .first)),
                                                        fit: BoxFit.fill),
                                                    color: Colors.grey.shade200,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  width: 75,
                                                  height: 75,
                                                )),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 1.0),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(snapshot.data![index].name,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "ArgentumSans",
                                                        fontSize: 16)),
                                                Text(snapshot.data![index].date,
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily:
                                                            "ArgentumSans",
                                                        fontSize: 12)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                      Container(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(top: 14.0),
                                          child: IconButton(
                                            icon: Date.intToBool(snapshot
                                                    .data![index].isFavorite)
                                                ? Icon(
                                                    Icons.favorite,
                                                    size: 50,
                                                    color: Colors.white,
                                                  )
                                                : Icon(
                                                    Icons.favorite_border,
                                                    size: 50,
                                                    color: Colors.white,
                                                  ),
                                            onPressed: () async {
                                              isFav = Date.intToBool(snapshot
                                                  .data![index].isFavorite);
                                              isFav = !isFav;
                                              await DatabaseHelper.instance
                                                  .update(Date(
                                                      id: snapshot
                                                          .data![index].id,
                                                      name: snapshot
                                                          .data![index].name,
                                                      date: snapshot
                                                          .data![index].date,
                                                      boardingGames: snapshot
                                                          .data![index]
                                                          .boardingGames,
                                                      description:
                                                          snapshot.data![index]
                                                              .description,
                                                      imagesPath: snapshot
                                                          .data![index]
                                                          .imagesPath,
                                                      isFavorite:
                                                          Date.boolToInt(
                                                              isFav)));
                                              setState(() {});
                                            },
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ));
                            }),
                      );
              }),
        ));
  }

  Future<File> saveImagePernamently(String path) async {
    final dir = await getApplicationDocumentsDirectory();
    final name = basename(path);
    final image = File('${dir.path}/$name');
    return File(path).copy(image.path);
  }

  Future openDialog(context) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Add a date"),
            content: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: "Name of the date",
                  ),
                ),
                TextField(
                  controller: _boardingGamesController,
                  decoration: InputDecoration(
                      hintText: "Name of played boarding games"),
                ),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(hintText: "Description"),
                ),
                TextField(
                  controller: _dateControlller,
                  decoration: InputDecoration(
                      labelText: "DATE",
                      filled: true,
                      prefixIcon: Icon(Icons.calendar_today)),
                  readOnly: true,
                  onTap: () {
                    openDatePickDialog(context);
                  },
                ),
                TextButton(
                    onPressed: () async {
                      try {
                        var images = await ImagePicker().pickMultiImage();
                        images.forEach((image) async {
                          var imagePernament =
                              await saveImagePernamently(image.path);
                          imagesPath.add(imagePernament.path);
                        });
                      } on PlatformException catch (e) {
                        print("Failed to pick image: $e");
                      }
                    },
                    child: Text("Choose a photos"))
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    submit(context);
                  },
                  child: Text("Submit"))
            ],
          ));

  Future<void> openDatePickDialog(context) async {
    DateTime? _picked = await showDatePicker(
        context: context, firstDate: DateTime(1900), lastDate: DateTime(2100));

    if (_picked != null) {
      _dateControlller.text = _picked.toString().split(" ")[0];
    }
  }

  void submit(context) async {
    if (_nameController.text == "" || _dateControlller.text == "") {
      Text("Neplatný název nebo datum");
      return;
    }
    if (_boardingGamesController.text == "") {
      _boardingGamesController.text = "Deskovky se nehrály";
    }
    if (_descriptionController.text == "") {
      _descriptionController.text = "Bez popisku";
    }
    if (imagesPath.isEmpty) {
      imagesPath = ["notExists"];
    }
    await DatabaseHelper.instance.add(Date(
        name: _nameController.text,
        date: _dateControlller.text.split(" ")[0],
        boardingGames: _boardingGamesController.text,
        description: _descriptionController.text,
        imagesPath: imagesPath,
        isFavorite: 0));
    setState(() {
      _nameController.clear();
      _dateControlller.clear();
      _boardingGamesController.clear();
      _descriptionController.clear();
      imagesPath.clear();
    });
    Navigator.of(context).pop();
  }
}

class Date {
  final int? id;
  String name;
  String date;
  String? boardingGames;
  String? description;
  int isFavorite;
  List<String>? imagesPath;

  Date(
      {this.id,
      required this.name,
      required this.date,
      this.boardingGames,
      this.description,
      this.imagesPath,
      required this.isFavorite});

  factory Date.fromMap(Map<String, dynamic> json) => new Date(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      boardingGames: json['boardingGames'],
      description: json['description'],
      imagesPath: json['imagesPath'].toString().split("|"),
      isFavorite: json['isFavorite']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'boardingGames': boardingGames,
      'description': description,
      'imagesPath': imagesPath,
      'isFavorite': isFavorite,
      'imagesPath': imagesPath?.join('|')
    };
  }

  static bool intToBool(int a) => a == 0 ? false : true;
  static int boolToInt(bool a) => a == true ? 1 : 0;
}

class DatabaseHelper {
  DatabaseHelper.privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'date.db');
    return await openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
CREATE TABLE dates(
id INTEGER PRIMARY KEY,
name TEXT,
date TEXT,
boardingGames TEXT,
description TEXT,
imagesPath TEXT,
isFavorite INTEGER
)
''');
  }

  Future<List<Date>> getDates() async {
    Database db = await instance.database;
    var dates = await db.query('dates', orderBy: 'date');
    List<Date> dateList =
        dates.isNotEmpty ? dates.map((c) => Date.fromMap(c)).toList() : [];
    return dateList;
  }

  Future<int> add(Date date) async {
    Database db = await instance.database;
    return await db.insert('dates', date.toMap());
  }

  Future<int> update(Date date) async {
    Database db = await instance.database;
    return await db
        .update('dates', date.toMap(), where: 'id = ?', whereArgs: [date.id]);
  }

  Future<int> remove(Date date) async {
    Database db = await instance.database;
    return await db.delete('dates', where: 'id = ?', whereArgs: [date.id]);
  }
}
