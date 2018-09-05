import 'dart:io';

class GearItem {
  String name;
  String weight;
  String notes;
  bool isGrams;
  File image;
  GearItem(this.name, this.weight, this.isGrams, this.notes, this.image);
  GearItem.fromJson(Map<String, dynamic> json)
      : name = json['gearName'],
        weight = json['gearWeight'],
        isGrams = json['gearIsGrams'],
        notes = json['gearNotes'],
        image = json['gearImage'];

  Map<String, dynamic> toJson() => {
        'gearName': name,
        'gearWeight': weight,
        'gearIsGrams': isGrams,
        'gearNotes': notes,
        'gearImage': image
      };
}
