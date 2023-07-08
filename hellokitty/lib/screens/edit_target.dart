import 'package:flutter/material.dart';
import 'package:hellokitty/model/pet_data.dart';
import 'package:hellokitty/widgets/appbar_widget.dart';

// This class handles the Page to edit the target Section of the User Profile.
class EditTargetFormPage extends StatefulWidget {
  const EditTargetFormPage({Key? key}) : super(key: key);

  @override
  EditTargetFormPageState createState() {
    return EditTargetFormPageState();
  }
}

class EditTargetFormPageState extends State<EditTargetFormPage> {
  final _formKey = GlobalKey<FormState>();
  final targetController = TextEditingController();
  var pet = PetData.myPet;

  @override
  void dispose() {
    targetController.dispose();
    super.dispose();
  }

  void updatePetValue(String target) {
    pet.target_weight = target;
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
                      "Set a target weight(kg) for your pet",
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
                              return 'Please enter the target weight.';
                            }
                            return null;
                          },
                          decoration: const InputDecoration(
                              labelText: 'The target weight(kg) of your pet'),
                          controller: targetController,
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
                              updatePetValue(targetController.text);
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
