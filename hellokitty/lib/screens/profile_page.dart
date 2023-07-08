import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hellokitty/components/custom_appbar.dart';
import 'package:hellokitty/components/path_config.dart';
import 'package:hellokitty/screens/edit_age.dart';
import 'package:hellokitty/screens/edit_gender.dart';
import 'package:hellokitty/screens/edit_name.dart';
import 'package:hellokitty/screens/edit_target.dart';
import 'package:hellokitty/widgets/linechart.dart';
import '../model/pet.dart';
import '../model/pet_data.dart';
import '../widgets/display_image_widget.dart';

// Pet Profile Page
class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final pet = PetData.myPet;

    return Scaffold(
      appBar: CustomAppBar(
        title: "Pet Profile",
        iconPath: IconPath.customOptions[0][1],
        backgroudColor: Colors.black,
        height: 40,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              toolbarHeight: 10,
            ),
            Center(
                child: DisplayImage(
              imagePath: pet.image,
              onPressed: () {},
            )),
            buildPetInfoDisplay(pet.name, 'Name', EditNameFormPage()),
            buildPetInfoDisplay(pet.age, 'Age', EditAgeFormPage()),
            buildPetInfoDisplay(pet.gender, 'Gender', EditGenderFormPage()),
            buildPetInfoDisplay(pet.advice, 'Weight Advice', null),
            buildPetInfoDisplay(pet.target_weight + " KG", 'Target Weight',
                EditTargetFormPage()),
            const SizedBox(height: 10),
            buildWeightChart(pet)
          ],
        ),
      ),
    );
  }

  // Widget builds the display item with the proper formatting to display the user's info
  Widget buildPetInfoDisplay(String getValue, String title, Widget? editPage) =>
      Padding(
          padding: EdgeInsets.only(bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(
                height: 1,
              ),
              if (editPage != null)
                Container(
                    width: 350,
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ))),
                    child: Row(children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {
                                navigateSecondPage(editPage);
                              },
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  getValue,
                                  style: TextStyle(fontSize: 16, height: 1.4),
                                  textAlign: TextAlign.left,
                                ),
                              ))),
                      Icon(
                        Icons.edit,
                        color: Colors.black,
                        size: 20,
                      ),
                    ]))
              else
                Container(
                    width: 350,
                    height: 80,
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                      color: Colors.grey,
                      width: 1,
                    ))),
                    child: Row(children: [
                      Expanded(
                          child: TextButton(
                              onPressed: () {},
                              child: Text(
                                getValue,
                                style: TextStyle(fontSize: 16, height: 1.4),
                                textAlign: TextAlign.left,
                              )))
                    ]))
            ],
          ));

  // Widget builds the Advice Section
  Widget buildAdvice(Pet pet) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Target Weight',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 1),
          Container(
              width: 350,
              height: 200,
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                color: Colors.grey,
                width: 1,
              ))),
              child: Row(children: [
                Expanded(
                    child: TextButton(
                        onPressed: () {
                          navigateSecondPage(EditTargetFormPage());
                        },
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  pet.target_weight + " " + "kg",
                                  style: TextStyle(
                                    fontSize: 16,
                                    height: 1.4,
                                  ),
                                ))))),
                Icon(
                  Icons.keyboard_arrow_right,
                  color: Colors.grey,
                  size: 40.0,
                )
              ]))
        ],
      ));

  // Refrshes the Page after updating user info.
  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  // Handles navigation and prompts refresh.
  void navigateSecondPage(Widget editForm) {
    Route route = MaterialPageRoute(builder: (context) => editForm);
    Navigator.push(context, route).then(onGoBack);
  }

  Widget buildWeightChart(Pet pet) => Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              'Weight Records',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ),
          WeightChart(),
        ],
      ));
}
