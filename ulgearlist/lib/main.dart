import 'package:flutter/material.dart';
import 'package:ulgearlist/GearItem.dart';
import 'package:ulgearlist/FileMethods.dart';
import 'package:ulgearlist/Screens/addGearItem.dart';
import 'package:ulgearlist/Screens/viewItem.dart';
import 'dart:async';

GearItem currItem;
List<GearItem> listItems;
int currObjPos;
bool prefersGrams = true;
String isGramsString = "g";
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
        ViewScreen.routeName: (BuildContext context) =>
            new ViewStatefulWidget(),
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

final TextEditingController searchController = new TextEditingController();
String searchText;
bool isSearching;
List<GearItem> searchList;

class _MyHomePageState extends State<MyHomePage> {
  bool searchVisibleBool = false;

  searchListState() {
    searchController.addListener(() {
      if (searchController.text.isEmpty) {
        setState(() {
          isSearching = false;
          searchText = "";
        });
      } else {
        setState(() {
          isSearching = true;
          searchText = searchController.text;
        });
      }
    });
  }

  bool listItemsNull = true;
  @override
  Widget build(BuildContext context) {
    //there is where the views are located
    return new Scaffold(
        appBar: new AppBar(
          title: new Text(widget.title),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.add),
              tooltip: 'Add New Item',
              onPressed: () {
                addItem(context);
              },
            ),
          ],
          leading: new Container(),
        ),
        body: new Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          !listItemsNull
              ? new SwitchListTile(
                  title: new Text(isGramsString),
                  value: prefersGrams,
                  onChanged: (bool value) {
                    setState(() {
                      prefersGrams = value;
                      if (prefersGrams) {
                        isGramsString = 'g';
                      } else {
                        isGramsString = 'oz';
                      }
                    });
                  },
                )
              : new Container(),
          new Expanded(
            child: new FutureBuilder(
                future: getGear(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return new Text('loading...');
                    default:
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      else
                        return getGearWidgets(context);
                  }
                }),
          ),
          searchVisibleBool
              ? new Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                  new Expanded(
                      child: new TextField(
                    controller: searchController,
                    onChanged: (String searchTerm) {
                      setState(() {
                        searchController.text = searchTerm;
                      });
                    },
                  )),
                  new Expanded(
                      child: new IconButton(
                    icon: new Icon(
                      Icons.close,
                    ),
                    onPressed: () {
                      setState(() {
                        searchVisibleBool = false;
                        searchController.text = "";
                        searchList = null;
                      });
                    },
                  ))
                ])
              : new Container() //replaces the searchbar with empty container
        ]),
        floatingActionButton: !searchVisibleBool
            ? new FloatingActionButton(
                onPressed: () {
                  setState(() {
                    searchVisibleBool = true;
                  });
                },
                tooltip: 'Search',
                child: new Icon(Icons.search),
              )
            : new Container()

        /* may want to use below but otherwise just make an icon in toolbar
      
      floatingActionButton: new FloatingActionButton(
        onPressed: addNewItem,
        tooltip: 'Add New Item',
        child: new Icon(Icons.add),
      ),*/
        );
  }

  addItem(BuildContext c) {
    //moves page to the add item page
    Navigator.pushNamed(c, AddScreen.routeName);
  }

  getGear() async {
    //gets the saved gear from the file
    FileUpater f = new FileUpater();
    listItems = await f.readList();
  }

  ListTile getTotalPackContents(bool searching) {
    //TODO find a way to have this be called so it will be at top and hopefully make the rest indented
    double weight = 0.0;
    if (searching) {
      for (int i = 0; i < searchList.length; i++) {
        String weightString;
        if (prefersGrams) {
          weightString = getGearWeight(
              searchList[i].weight, searchList[i].isGrams, prefersGrams);
          weightString = weightString.substring(0, weightString.length - 2);
        } else {
          weightString = getGearWeight(
              searchList[i].weight, searchList[i].isGrams, prefersGrams);
          weightString = weightString.substring(0, weightString.length - 3);
        }
        weight = weight + double.parse(weightString);
      }
    } else {
      for (int i = 0; i < listItems.length; i++) {
        String weightString;
        if (prefersGrams) {
          weightString = getGearWeight(
              listItems[i].weight, listItems[i].isGrams, prefersGrams);
          weightString = weightString.substring(0, weightString.length - 2);
        } else {
          weightString = getGearWeight(
              listItems[i].weight, listItems[i].isGrams, prefersGrams);
          weightString = weightString.substring(0, weightString.length - 3);
        }
        weight = weight + double.parse(weightString);
      }
    }
    String finalWeightString;
    if (prefersGrams) {
      finalWeightString = weight.toString() + " g";
    } else {
      finalWeightString = weight.toString() + " oz";
    }
    return new ListTile(
        title: new Text("Pack"), subtitle: new Text(finalWeightString));
  }

  ListView getGearWidgets(BuildContext bc) {
    //determines if there is any saved gear
    if (listItems == null) {
      //this is no saved gear so just lets you press anywhere to add new item
      var singleItemNull = List<ListTile>();
      singleItemNull.add(new ListTile(
          title: new Text('No Items Added!'),
          subtitle: new Text('Click here to add one'),
          onTap: () {
            addItem(bc);
          }));
      ListView plainListView = new ListView(
        children: singleItemNull,
      );

      return plainListView;
    } else {
      //this means there is saved gear
      ListView gearListView;
      if (searchController.text == null||searchController.text=="") {
        //this is used if the search text is empty
        gearListView = new ListView(
            children: new List.generate(listItems.length, (int index) {
              
          return createItemTile(listItems[index], bc, index);
        }));
      } else {
        //otherwise this means we are searching so must find the ones that fit the search parameter
        searchList = new List<GearItem>();
        for (int i = 0; i < listItems.length; i++) {
          if (listItems[i]
                  .name
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              listItems[i]
                  .notes
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              listItems[i]
                  .weight
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase())) {
            searchList.add(listItems[i]);
          }
        }
        //this is where it goes if there is nothing that fits the parameters and lets you add a new item
        if (searchList.length < 1) {
          var singleItemNull = List<ListTile>();
          singleItemNull.add(new ListTile(
              title: new Text('No Items Fit The Search!'),
              subtitle: new Text('Click here to add one'),
              onTap: () {
                addItem(bc);
              }));
          ListView plainListView = new ListView(
            children: singleItemNull,
          );

          return plainListView;
        } else {
          //this recreates the list to display where there is items that fit the search parameteres
          gearListView = new ListView(
              children: new List.generate(searchList.length, (int index) {
            return createItemTile(searchList[index], bc, index);
          }));
        }
      }
      return gearListView;
    }
  }

  String getGearWeight(String weight, bool isGrams, bool prefersGrams) {
    //this converts the weight into an easily readable string
    if (isGrams == prefersGrams) {
      if (prefersGrams == true) {
        return weight + ' g';
      } else {
        return weight + ' oz';
      }
    } else if (isGrams) {
      return (double.parse(weight) * .03527396).toString() + ' oz';
    } else {
      return (double.parse(weight) * 28.3495231).toString() + ' g';
    }
  }

  viewGearPage(BuildContext c, int pos) {
    //when an item in the list is pressed it opens the view page with full information and the options to edit or delete

    currObjPos = pos;
    if (searchController != null) {
      currItem = listItems
          .where((g) => g == searchList.elementAt(pos))
          .toList()
          .elementAt(0);
    } else {
      currItem = listItems.elementAt(pos);
    }
    Navigator.pushNamed(c, ViewScreen.routeName);
  }

  ListTile createItemTile(GearItem item, BuildContext bc, int index) {
    //this create the list items for both searching and not searching to display the items
  
    return new ListTile(
      title: new Text(item.name),
      //leading: new Image.file(
      //item.image,
      //),
      contentPadding: new EdgeInsets.fromLTRB(
          MediaQuery.of(context).size.width / 9, 0.0, 0.0, 0.0),
      subtitle:
          new Text(getGearWeight(item.weight, item.isGrams, prefersGrams)),
      trailing: new Text(
        item.notes,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
      onTap: () {
        viewGearPage(bc, index);
      },
      onLongPress: () {
        deleteDialog(context);
        if (searchController == null) {
          currObjPos = index;
        } else {
          currObjPos =
              listItems.indexWhere((g) => g == searchList.elementAt(index));
        }
      },
    );
  }

  Future<bool> deleteDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text('Are you sure you want to delete this item?'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  deleteItem(context);
                },
              ),
              new FlatButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              )
            ],
          );
        });
  }

  deleteItem(BuildContext c) {
    FileUpater f = new FileUpater();
    f.removeItem(c);
  }
}
