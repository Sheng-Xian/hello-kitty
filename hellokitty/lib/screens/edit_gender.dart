import 'package:flutter/material.dart';
import 'package:hellokitty/model/pet_data.dart';
import 'package:hellokitty/widgets/appbar_widget.dart';

// This class handles the Page to edit the target Section of the User Profile.
class EditGenderFormPage extends StatefulWidget {
  const EditGenderFormPage({Key? key}) : super(key: key);

  @override
  EditGenderFormPageState createState() {
    return EditGenderFormPageState();
  }
}

class EditGenderFormPageState extends State<EditGenderFormPage> {
  final _formKey = GlobalKey<FormState>();
  final genderController = TextEditingController();
  var pet = PetData.myPet;

  @override
  void dispose() {
    genderController.dispose();
    super.dispose();
  }

  void updatePetValue(String gender) {
    pet.gender = gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(context),
        body: Form(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                    width: 320,
                    child: const Text(
                      "Enter the gender of your pet",
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    )),
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: SizedBox(
                        height: 100,
                        width: 320,
                        child: TextFormField(
                          // Handles Form Validation
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your pet' 's Gender.';
                            }
                            return null;
                          },
                          decoration:
                              const InputDecoration(labelText: 'Male / Female'),
                          controller: genderController,
                        ))),
                Padding(
                    padding: EdgeInsets.only(top: 150),
                    child: Align(
                        alignment: Alignment.bottomCenter,
                        child: SizedBox(
                          width: 320,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              updatePetValue(genderController.text);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Update',
                              style: TextStyle(fontSize: 15),
                            ),
                          ),
                        )))
              ]),
        ));
  }
}
