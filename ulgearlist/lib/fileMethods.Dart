import 'Screens/mainPage.dart';
import 'dart:convert';
import 'package:ulgearlist/GearItem.dart';
import 'package:ulgearlist/gearList.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';

//TODO fix deleting so you can delete the entire things
class FileUpater {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/gearList.txt');
  }

  Future<File> writeList(
      List<GearItem> gearListItems, BuildContext bc, bool returnLoc) async {
    final file = await _localFile;
    // Write the file earlier
    Map<String, dynamic> jsonString = new GearList(gearListItems).toJson();
    await file.writeAsString(jsonEncode(jsonString));
    if (returnLoc) {
      Navigator.pop(bc);
    } else {
      Navigator.pushNamed(bc, MainScreen.routeName);
    }

    return file.writeAsString(jsonEncode(jsonString));
  }

  Future<List<GearItem>> readList() async {
    try {
      final file = await _localFile;

      // Read the file
      String contents = await file.readAsString();
      Map fileMap = jsonDecode(contents);
      GearList jsonObject = GearList.fromJson(fileMap);

      return jsonObject.gearList;
    } catch (e) {
      // If we encounter an error, return 0
      return null;
    }
  }

  updateItem(GearItem newItem, BuildContext bc) async {
    //allows updating a new gear item then writes to file
    listItems.elementAt(currObjPos).name = newItem.name;
    listItems.elementAt(currObjPos).weight = newItem.weight;
    listItems.elementAt(currObjPos).isGrams = newItem.isGrams;
    listItems.elementAt(currObjPos).notes = newItem.notes;
    //listItems.elementAt(currObjPos).image = newItem.image;
    listItems.removeAt(0);

    writeList(listItems, bc, true);
  }

  removeItem(BuildContext bc) async {
    //removes the item from the list and writes it to file
    listItems.remove(listItems.elementAt(currObjPos));
    listItems.removeAt(0);
    if(listItems.length==0){
      listItemsNull=true;
      
      listItems=null;
    }

    writeList(listItems, bc, false);
  }

  addItem(GearItem newItem, BuildContext bc) async {
    //adds item to list and writes the list to file.

    if (listItems == null) {
      listItems = new List<GearItem>();
    }else{
      listItems.removeAt(0);
    }
    listItemsNull=false;
    listItems.add(newItem);
    writeList(listItems, bc, true);
  }
}
