import 'package:flutter/material.dart';
import 'package:ulgearlist/Classes/FileMethods.dart';
import 'package:ulgearlist/Screens/addGearItem.dart';
import 'package:ulgearlist/Screens/viewItem.dart';
import 'package:ulgearlist/Screens/editItem.dart';
import 'package:ulgearlist/Screens/mainPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gear List',
      theme: new ThemeData(
        //earthy green
        primarySwatch: Colors.green,
      ),
      home: new MyHomePage(title: 'Gear List'),
      routes: <String, WidgetBuilder>{
        // define the routes
        MyHomePage.routeName: (BuildContext context) => new MyHomePage(),
        AddScreen.routeName: (BuildContext context) => new AddStatefulWidget(),
        EditScreen.routeName: (BuildContext context) =>
            new EditStatefulWidget(),
        ViewScreen.routeName: (BuildContext context) =>
            new ViewStatefulWidget(),
        MainScreen.routeName: (BuildContext context) => new MainStatefulWidget()
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  //this is flutter framework to set up home page
  MyHomePage({Key key, this.title}) : super(key: key);
  static const String routeName = "/homeScreen";

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    //there is where the views are located
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[],
          leading: new Container(),
        ),
        body: new Center(
            child: new Column(children: [
          new Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                /// Loader Animation Widget
                CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.green),
                ),
                Text("Loading"),
              ],
            ),
          ),
        ])));
  }

  @override
  void initState() {
    getGear();
    super.initState();
  }

  getGear() async {
    //gets the saved gear from the file
    FileUpater f = new FileUpater();
    listItems = await f.readList();
    if (listItems == null || listItems.length == 0) {
      listItemsNull = true;
    } else {
      listItemsNull = false;
    }
    Navigator.pushAndRemoveUntil(
        context,
        new MaterialPageRoute(
            builder: (BuildContext context) => new MainStatefulWidget()),
        (Route<dynamic> route) {
      return false;
    });
  }
}
