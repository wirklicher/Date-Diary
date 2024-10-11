import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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
  bool click = true;

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
                        child: ListView(
                          children: snapshot.data!.map((date) {
                            return Center(
                                child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(0.0),
                              ),
                              color: Color(0xFF9A3135),
                              elevation: 0,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
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
                                                        0.125,
                                                maxWidth: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.125),
                                            child: Container(
                                              decoration: BoxDecoration(
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
                                            Text(date.name,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "ArgentumSans",
                                                    fontSize: 16)),
                                            Text(date.date,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "ArgentumSans",
                                                    fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                                  Container(
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20.0),
                                      child: IconButton(
                                        icon: click
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
                                        onPressed: () {
                                          setState(() {
                                            print("Changed");
                                            click = !click;
                                          });
                                          ;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          }).toList(),
                        ),
                      );
              }),
        ));
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
                      var image = await ImagePicker().pickMultiImage();
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
    await DatabaseHelper.instance.add(Date(
        name: _nameController.text,
        date: _dateControlller.text.split(" ")[0],
        boardingGames: _boardingGamesController.text));
    setState(() {
      _nameController.clear();
      _dateControlller.clear();
      _boardingGamesController.clear();
    });
    Navigator.of(context).pop();
  }
}

class Date {
  final int? id;
  String name;
  String date;
  String? boardingGames;

  Date({this.id, required this.name, required this.date, this.boardingGames});

  factory Date.fromMap(Map<String, dynamic> json) => new Date(
      id: json['id'],
      name: json['name'],
      date: json['date'],
      boardingGames: json['boardingGames']);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'date': date,
      'boardingGames': boardingGames
    };
  }
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
boardingGames TEXT
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
}
