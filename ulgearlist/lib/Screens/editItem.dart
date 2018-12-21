import 'package:ulgearlist/FileMethods.Dart';
import 'package:flutter/material.dart';
import 'mainPage.dart';
//import 'dart:io';
//import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'package:ulgearlist/GearItem.dart';

class EditScreen extends State<EditStatefulWidget> {
  static const String routeName = "/editScreen";
  String name, weight, notes;

  bool hiddenPass = false;
  String switchWord = "Show";
  final formKey = new GlobalKey<FormState>();
  bool autoValidate = false;
  bool isGrams = true;
  String isGramsString = "g";
  final TextEditingController nameController = new TextEditingController();
  final TextEditingController weightController = new TextEditingController();
  final TextEditingController notesController = new TextEditingController();

  //File gearImage;
  @override
  void initState() {
    nameController.text = currItem.name;
    notesController.text = currItem.notes;
    weightController.text = currItem.weight;
    //gearImage = currItem.image;
    return super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Edit Page'),
          leading: new IconButton(
            tooltip: 'Previous choice',
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              //returns home
              Navigator.pop(context);
            },
          ),
        ),
        body: new Center(
          child: new Column(children: [
            //allows the image to be clicked on so it can be changed
            /*   new GestureDetector(
              onTap: getImage,
              child: new Image.file(
                gearImage,
                width: MediaQuery.of(context).size.width * .5,
                height: MediaQuery.of(context).size.width * .5,
              ),
            ),*/
            //the text fields to change text values
            Form(
              key: formKey,
              autovalidate: autoValidate,
              child: new Column(
                children: [
                  new TextField(
                    onChanged: (String value) {
                      name = value;
                    },
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'Enter Name',
                      labelText: 'Name',
                    ),
                  ),
                  new Row(children: [
                    new FractionallySizedBox(
                        widthFactor: 50.0,
                        child: new TextFormField(
                          validator: (input) {
                            final isDigitsOnly = double.tryParse(input);
                            return isDigitsOnly == null
                                ? 'Input needs to be a valid number'
                                : null;
                          },
                          onSaved: (val) => weight = val,
                          keyboardType: TextInputType.numberWithOptions(),
                          decoration: const InputDecoration(
                            hintText: 'Enter weight',
                            labelText: 'Weight',
                          ),
                        )),
                    new FractionallySizedBox(
                        widthFactor: 50.0,
                        child: new SwitchListTile(
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
                        )),
                  ]),
                  new TextField(
                    onChanged: (String value) {
                      notes = value;
                    },
                    controller: notesController,
                    decoration: const InputDecoration(
                      icon: const Icon(Icons.lock),
                      hintText: 'Enter Notes',
                      labelText: 'Notes',
                    ),
                  ),
                  new FittedBox(
                    fit: BoxFit.fill,
                    child: new RaisedButton(
                      onPressed: () {
                        updateItem(context);
                      },
                      child: new Text("Update Item"),
                    ),
                  ),
                ],
              ),
            ),
          ]),
          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

//saves the updated item
  updateItem(BuildContext c) {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      FileUpater f = new FileUpater();
      currItem = new GearItem(
        name, weight, isGrams, notes,
        //gearImage
      );
      f.updateItem(currItem, c);
    } else {
      autoValidate = true;
    }
  }

//allows the user to change the image associated with the piece of gear
  Future getImage() async {
    // var imagePicked = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      //gearImage = imagePicked;
    });
  }
}

class EditStatefulWidget extends StatefulWidget {
  @override
  EditScreen createState() => new EditScreen();
}
