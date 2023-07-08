import 'package:flutter/material.dart';
import 'package:hellokitty/model/pet_data.dart';
import 'package:hellokitty/widgets/appbar_widget.dart';

// This class handles the Page to edit the target Section of the User Profile.
class EditAgeFormPage extends StatefulWidget {
  const EditAgeFormPage({Key? key}) : super(key: key);

  @override
  EditAgeFormPageState createState() {
    return EditAgeFormPageState();
  }
}

class EditAgeFormPageState extends State<EditAgeFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ageController = TextEditingController();
  var pet = PetData.myPet;

  @override
  void dispose() {
    ageController.dispose();
    super.dispose();
  }

  void updatePetValue(String age) {
    pet.age = age;
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
                      "Enter the age of your pet",
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
                              return 'Please enter your pet' 's Age.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'Your pet' 's age'),
                          controller: ageController,
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
                              updatePetValue(ageController.text);
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
