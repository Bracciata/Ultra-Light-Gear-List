import 'package:flutter/material.dart';
import 'editItem.dart';
import 'package:ulgearlist/fileMethods.dart';
import 'dart:async';
import 'mainPage.dart';

String isGramsString = "g";
bool isGrams = true;

class ViewScreen extends State<ViewStatefulWidget> {
  static const String routeName = "/viewScreen";
  @override
  Widget build(BuildContext context) {
    TextStyle main = new TextStyle(color: Colors.black, fontSize: 18.0);
    TextStyle secondary = new TextStyle(color: Colors.grey, fontSize: 12.0);

    return new Scaffold(
      appBar: new AppBar(
          title: new Text(currItem.name),
          leading: new IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              //returns home
              Navigator.pop(context);
            },
          ),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.edit),
              tooltip: 'Edit',
              onPressed: () {
                editAccount(context);
              },
            ),
            new IconButton(
              icon: new Icon(Icons.delete),
              tooltip: 'Delete',
              onPressed: () {
                deleteDialog(context);
              },
            ),
          ]),
      body: new Center(
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //new Image.file(currItem.image,width:MediaQuery.of(context).size.width*.5,height:MediaQuery.of(context).size.width*.5,),
            new Column(
              children: <Widget>[
                new Text(
                  currItem.name +
                      ' (' +
                      getGearWeight(
                          currItem.weight, currItem.isGrams, isGrams) +
                      ')',
                  style: main,
                ),
                new SwitchListTile(
                  title: new Text(isGramsString),
                  value: isGrams,
                  onChanged: (bool value) {
                    setState(() {
                      isGrams = value;
                      if (isGrams) {
                        isGramsString = 'g';
                      } else {
                        isGramsString = 'oz';
                      }
                    });
                  },
                ),
              ],
            ),
            new Text(currItem.notes, style: secondary),
          ],
        ),
      ),
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

  editAccount(BuildContext c) {
    Navigator.pushNamed(c, EditScreen.routeName);
  }

  deleteItem(BuildContext c) {
    FileUpater f = new FileUpater();
    f.removeItem(c);
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
}

class ViewStatefulWidget extends StatefulWidget {
  @override
  ViewScreen createState() => new ViewScreen();
}
