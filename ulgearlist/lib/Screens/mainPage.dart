import 'package:flutter/material.dart';
import 'dart:async';
import 'package:ulgearlist/Objects/GearItem.dart';
import 'package:ulgearlist/Classes/FileMethods.dart';
import 'package:ulgearlist/Screens/addGearItem.dart';
import 'package:ulgearlist/Screens/viewItem.dart';

List<GearItem> listItems;
int currObjPos;
bool prefersGrams = true;
String isGramsString = "g";
GearItem currItem;

class MainStatefulWidget extends StatefulWidget {
  //this is flutter framework to set up home page
  @override
  MainScreen createState() => new MainScreen();
}

final TextEditingController searchController = new TextEditingController();
String searchText;
bool isSearching;
List<GearItem> searchList;
bool listItemsNull;

class MainScreen extends State<MainStatefulWidget> {
  static const String routeName = "/mainScreen";

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

  @override
  Widget build(BuildContext context) {
    //there is where the views are located
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Pack Track"),
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
              ? new Column(children: <Widget>[
                  SwitchListTile(
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
                ])
              : new Container(),
          new Expanded(
            child: getGearWidgets(context),
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
              : new Container()
        ]), //replaces the searchbar with empty container
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
    listItems = null;
    FileUpater f = new FileUpater();
    listItems = await f.readList();
    if (listItems == null) {
      listItemsNull = true;
    } else if (listItems.length == 0) {
      listItemsNull = true;
    } else {
      listItemsNull = false;
    }
  }

  GearItem getTotalPackContents(bool searching) {
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
    /*String finalWeightString;
    if (prefersGrams) {
      finalWeightString = weight.toString() + " g";
    } else {
      finalWeightString = weight.toString() + " oz";
    }*/
    return new GearItem("Pack", weight.toString(), prefersGrams, "");
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
      if (isSearching == null) {
        isSearching = false;
      }
      ListView gearListView;
      if (searchController.text == null || searchController.text == "") {
        //this is used if the search text is empty
        gearListView = generateListItems(listItems, isSearching, bc);
      } else {
        //otherwise this means we are searching so must find the ones that fit the search parameter
        searchList = new List<GearItem>();
        for (int i = 1; i < listItems.length; i++) {
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
          gearListView = generateListItems(searchList, isSearching, bc);
        }
      }
      return gearListView;
    }
  }

  ListView generateListItems(
      List<GearItem> items, bool isSearch, BuildContext bc) {
    List newItems = List.from(items);
    newItems.insert(0, getTotalPackContents(isSearch));
    return new ListView(
        children: new List.generate(newItems.length, (int index) {
      return createItemTile(newItems[index], bc, index);
    }));
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
    if (searchController != null &&
        searchController.text != null &&
        isSearching) {
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
    if (index == 0) {
      return new ListTile(
        title: new Text(item.name),
        subtitle:
            new Text(getGearWeight(item.weight, item.isGrams, prefersGrams)),
      );
    } else {
      return new ListTile(
        title: new Text(item.name),
        //leading: new Image.file(
        //item.image,
        //),
        contentPadding: new EdgeInsets.fromLTRB(
            MediaQuery.of(context).size.width / 6, 0.0, 0.0, 0.0),

        subtitle:
            new Text(getGearWeight(item.weight, item.isGrams, prefersGrams)),
        trailing: new Text(
          item.notes,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        onTap: () {
          viewGearPage(bc, index - 1);
        },
        onLongPress: () {
          deleteDialog(context);
          if (searchController == null) {
            //minus one because will delete at minus one so not pack
            currObjPos = index - 1;
          } else {
            if (searchList == null) {
              searchList = listItems;
            }
            currObjPos = listItems
                .indexWhere((g) => g == searchList.elementAt(index - 1));
          }
        },
      );
    }
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
