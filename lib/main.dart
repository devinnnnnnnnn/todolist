import 'package:flutter/material.dart';
import 'package:flutter_animation_progress_bar/flutter_animation_progress_bar.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.blue,
        accentColor: Colors.orange),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  String input = "";  //the word you type to display on mission list
  int EXP = 0;  //the current EXP in progress bar
  int EXP_MAX = 1;  //the maximum value of EXP for each level
  int level = 0;  //the level of user
  String EXP_MAX_Str = "10";  //to display EXP_MAX in String type(because the required type in dependency:
  // "flutter_animation_progress_bar" is String type)

  //a list to store each mission
  GlobalKey<ScaffoldState> _key = GlobalKey(); // added
  List<String> todos = List.generate(0, (index) => "${index}");

  //If you run the app, the home page will show the following 3 mission
  void initState() {
    super.initState();
    todos.add("按加號以新增任務");
    todos.add("右滑以刪除任務");
    todos.add("完成任務請打勾");
    todos.add("完成任務將增加一點經驗值");
  }

  @override
  Widget build(BuildContext context) {

    //the loop to combine the EXP and level function. When EXP>EXP_MAX, then user levels up.
    while( EXP >= EXP_MAX ){
      EXP = EXP - EXP_MAX;
      level++;
      EXP_MAX = level*2;
      EXP_MAX_Str = "$EXP_MAX ";
    }

    return Scaffold(
      key: _key,
        appBar: AppBar(
        title: Text("mytodos"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  title: Text("增加新任務"),

                  //the keyboard for mission naming
                  content: TextField(
                    decoration: new InputDecoration(labelText: "請輸入任務名稱"),
                    keyboardType: TextInputType.text,
                    onChanged: (String value) {
                      input = value;
                    },
                  ),

                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          setState(() {
                            todos.add(input);
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text("新增"),
                    )
                  ],
                );
            },
          );
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),

      body: ListView.builder(
          shrinkWrap: true,
          itemCount: todos.length,
          itemBuilder: (BuildContext context, int index) {

            //with this, you can create a mission list and each mission is dismissible.
            return Dismissible(
                key: Key(todos[index]),
                child: Card(
                  elevation: 4,
                  margin: EdgeInsets.all(8),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),

                  //the content in each Dismissible
                  child: ListTile(
                    title: Text(todos[index]),
                    trailing: IconButton(
                        icon: Icon(
                          Icons.check,
                          color: Colors.red,
                        ),

                        // when you complete the mission, please press the check icon.
                        onPressed: () {
                          setState(() {
                            todos.removeAt(index);
                            EXP = EXP + 1;
                          });
                        }),
                  ),
                ),

              //delete the mission when user swipe the mission
              onDismissed: (direction) {
                setState(() {
                  // added this block
                  String deletedItem = todos.removeAt(index);

                  //in a few second after mission deleted, user can undo the action in a few second.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Deleted \"${deletedItem}\""),
                      action: SnackBarAction(
                          label: "UNDO",
                          onPressed: () => setState(() => todos.insert(index, deletedItem),)
                      ),
                    ),
                  );
                });
              },
            );
          }),

      //the progress bar is put in the drawer
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text('使用者名稱'),
              accountEmail: Text('test_mail@gmail.com'),
              currentAccountPicture: Image.asset('assets/cat.jpg'),
              decoration: BoxDecoration(color: Colors.deepOrange),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('LV:',),
                Text('$level',),
                Container(
                  padding: const EdgeInsets.only(bottom: 8),

                  //the import package
                  child: FAProgressBar(
                    currentValue: EXP,
                    displayText: '/$EXP_MAX_Str',
                    maxValue: EXP_MAX,
                  ),
                ),
              ],
            ),


          ]
      ),
      )
    );
  }
}