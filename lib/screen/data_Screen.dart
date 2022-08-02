import 'package:database/screen/data_s.dart';
import 'package:flutter/material.dart';

class Data_Screen extends StatefulWidget {
  const Data_Screen({Key? key}) : super(key: key);

  @override
  State<Data_Screen> createState() => _Data_ScreenState();
}

class _Data_ScreenState extends State<Data_Screen> {
  List<Map<String , dynamic>> l2 =[];
  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData()async {
     DBHelper dbHelper =DBHelper();
    List<Map<String, dynamic>> l1 =await dbHelper.readData();
    setState((){
      l2= l1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  DBHelper db = DBHelper();
                  getData();
                  var res =
                      await db.insert("Jensi", "8678326489", "12", "Amitbhai");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("$res"),
                    ),
                  );
                },
                child: Text("Insert"),
              ),
              Expanded(
                child: ListView.builder(itemCount: l2.length,itemBuilder: (context,index){
                  return ListTile(
                    leading: Text("${l2[index]['id']}"),
                    title: Text("${l2[index]['name']}"),
                    subtitle: Text("${l2[index]['no']},${l2[index]['std']}"),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
