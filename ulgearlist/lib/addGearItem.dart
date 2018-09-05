import 'package:flutter/material.dart';

class AddScreen extends State<AddStatefulWidget> {
  static const String routeName = "/addScreen";
  String name, weight, notes;
  int weightValue = 0;
  final formKey = new GlobalKey<FormState>();
  String isGramsString = "g";
  bool isGrams;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Add Item'),
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
        child: new Form(
          key: formKey,
          child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              new TextFormField(
                validator: (value) => value == "" ? "Can't be empty." : null,
                onSaved: (val) => name = val,
                decoration: const InputDecoration(
                  hintText: 'Item Name',
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
              new TextFormField(
                onSaved: (val) => notes = val,
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
                  },
                  child: new Text("Add Item"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class AddStatefulWidget extends StatefulWidget {
  @override
  AddScreen createState() => new AddScreen();
}
