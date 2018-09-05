import 'package:flutter/material.dart';
import 'package:ulgearlist/GearItem.dart';
import 'package:ulgearlist/Screens/addGearItem.dart';

GearItem currItem;
List<GearItem> listItems;
int currObjPos;

void main() => runApp(new MyApp());

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
      ),
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[],
      ),

      /* may want to use below but otherwise just make an icon in toolbar
      
      floatingActionButton: new FloatingActionButton(
        onPressed: addNewItem,
        tooltip: 'Add New Item',
        child: new Icon(Icons.add),
      ),*/
    );
  }
}
