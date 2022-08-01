import 'package:database/screen/data_s.dart';
import 'package:flutter/material.dart';

class Data_Screen extends StatefulWidget {
  const Data_Screen({Key? key}) : super(key: key);

  @override
  State<Data_Screen> createState() => _Data_ScreenState();
}

class _Data_ScreenState extends State<Data_Screen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              DBHelper db = DBHelper();
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
        ),
      ),
    );
  }
}
