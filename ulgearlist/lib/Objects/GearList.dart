import 'package:ulgearlist/Objects/GearItem.dart';

class GearList {
  final List<GearItem> gearList;
  GearList(this.gearList);
  GearList.fromJson(Map<String, dynamic> json)
      : gearList = convert(json['gearList']);

  Map<String, dynamic> toJson() => {
        'gearList': gearList,
      };

  static convert(List<dynamic> listOfGearToConvert) {
    List<GearItem> gearListConverted = new List<GearItem>();
    for (int i = 0; i < listOfGearToConvert.length; i++) {
      gearListConverted.add(new GearItem(
          listOfGearToConvert[i]['gearName'],
          listOfGearToConvert[i]['gearWeight'],
          listOfGearToConvert[i]['gearIsGrams'],
          listOfGearToConvert[i]['gearNotes']));
      //listOfGearToConvert[i]['gearImage']));
    }
    return gearListConverted;
  }
}
