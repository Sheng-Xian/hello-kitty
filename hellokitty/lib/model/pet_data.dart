import 'dart:convert';
import 'pet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PetData {
  static late SharedPreferences _preferences;
  static const _keyPet = 'pet';

  static Pet myPet = Pet(
    image: "assets/images/guiyuan.jpeg",
    name: 'Machi',
    age: '6',
    gender: 'Male',
    target_weight: '5.5kg',
    advice: 'The recommended healthy weight for Machi is 4kg-5.5kg',
  );

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setPet(Pet pet) async {
    final json = jsonEncode(pet.toJson());

    await _preferences.setString(_keyPet, json);
  }

  static Pet getPet() {
    final json = _preferences.getString(_keyPet);

    return json == null ? myPet : Pet.fromJson(jsonDecode(json));
  }
}
