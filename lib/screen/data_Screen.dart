import 'dart:convert';

import 'package:database/screen/data_s.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Data_Screen extends StatefulWidget {
  const Data_Screen({Key? key}) : super(key: key);

  @override
  State<Data_Screen> createState() => _Data_ScreenState();
}

class _Data_ScreenState extends State<Data_Screen> {
  TextEditingController txname = TextEditingController();
  TextEditingController txprname = TextEditingController();
  TextEditingController txno = TextEditingController();
  TextEditingController txstd = TextEditingController();
  List<Map<String, dynamic>> l2 = [];
  XFile? f1;
  String livedata = "";

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<List<Map<String, dynamic>>> getData({String? std}) async {
    DBHelper dbHelper = DBHelper();
    List<Map<String, dynamic>> l1 = await dbHelper.readData(std);
    setState(() {
      l2 = l1;
    });
    return l1;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            PopupMenuButton(itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      getData(std: "12");
                    },
                    child: Text("12"),
                  ),
                ),
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      getData(std: "10");
                    },
                    child: Text("10"),
                  ),
                ),
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      getData(std: "9");
                    },
                    child: Text("9"),
                  ),
                ),
                PopupMenuItem(
                  child: InkWell(
                    onTap: () {
                      getData(std: "8");
                    },
                    child: Text("8"),
                  ),
                ),
              ];
            })
          ],
        ),
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  ImagePicker p1 = ImagePicker();
                  f1 = await p1.pickImage(source: ImageSource.gallery);
                },
                child: Text("Image"),
              ),
              ElevatedButton(
                onPressed: () async {
                  String imageData = base64Encode(await f1!.readAsBytes());

                  DBHelper db = DBHelper();
                  var res = await db.insert(
                      "Jensi", "8678326489", "12", "Amitbhai", "$imageData");
                  getData();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$res"),
                    ),
                  );
                },
                child: Text("Insert"),
              ),
              Card(
                child: Container(
                  height: 60,
                  alignment: Alignment.center,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "search",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() {
                        livedata = value;
                      });
                      search(livedata);
                    },
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: l2.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text("${l2[index]['id']}"),
                        title: Text("${l2[index]['name']}"),
                        subtitle: Text(
                            "${l2[index]['parentname']},${l2[index]['no']},${l2[index]['std']}"),
                        trailing: SizedBox(
                          width: 150,
                          child: Row(
                            children: [
                              Container(
                                  height: 30,
                                  width: 20,
                                  child: Image.memory(
                                    base64Decode(l2[index]['image']),
                                    fit: BoxFit.fill,
                                  )),
                              IconButton(
                                onPressed: () {
                                  txname = TextEditingController(
                                      text: l2[index]['name']);
                                  txprname = TextEditingController(
                                      text: l2[index]['parentname']);
                                  txno = TextEditingController(
                                      text: l2[index]['no']);
                                  txstd = TextEditingController(
                                      text: l2[index]['std']);
                                  updateDB(l2[index]['id']);
                                  getData();
                                },
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.green.shade900,
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  DBHelper().delete(l2[index]['id']);
                                  getData();
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void search(String later) async {
    List<Map<String, dynamic>> data = await getData();
    List<Map<String, dynamic>> filterdata = [];

    for (int i = 0; i < data.length; i++) {
      if (data[i]['name']
          .toString()
          .toLowerCase()
          .contains(later.toLowerCase())) {
        filterdata.add(data[i]);
        setState(() {
          l2 = filterdata;
        });
      }
    }
  }

  void updateDB(int id) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            actions: [
              SizedBox(
                height: 300,
                child: Column(
                  children: [
                    TextField(
                      controller: txname,
                      decoration: InputDecoration(
                        hintText: "NAME",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txprname,
                      decoration: InputDecoration(
                        hintText: "PARENTNAME",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txno,
                      decoration: InputDecoration(
                        hintText: "NO",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextField(
                      controller: txstd,
                      decoration: InputDecoration(
                        hintText: "STD",
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        DBHelper().update(id, txname.text, txno.text,
                            txstd.text, txprname.text);
                        getData();
                        Navigator.pop(context);
                      },
                      child: Text("UPDATE"),
                    ),
                  ],
                ),
              ),
            ],
          );
        });
  }
}
