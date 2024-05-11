import 'package:bustrack/src/features/authentication/views/login/login_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:bustrack/src/features/authentication/views/login/firebaseauth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  int currentStep = 0;
  bool isCompleted = false;
  final formKey = GlobalKey<FormState>();

  RegExp regExp = new RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final email = TextEditingController();
  final password = TextEditingController();
  final id_number = TextEditingController();

  final fName = TextEditingController();
  final lName = TextEditingController();
  final ic_number = TextEditingController();

  onStepTapped(int step) {
    formKey.currentState!.validate();
    setState(() {
      currentStep = step;
    });
  }

  bool isDetailComplete() {
    if (currentStep == 0) {
      if (email.text.isEmpty ||
          password.text.isEmpty ||
          id_number.text.isEmpty) {
        return false;
      } else if (!regExp.hasMatch(email.text)) {
        return false; //Add Password length check
      } else {
        return true;
      }
    } else if (currentStep == 1) {
      if (fName.text.isEmpty || lName.text.isEmpty || ic_number.text.isEmpty) {
        return false;
      } else {
        return true;
      }
    }

    return false;
  }

  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Account Info'),
          content: Column(
            children: <Widget>[
              TextFormField(
                controller: email,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter an Email";
                  }

                  return null;
                },
                decoration: InputDecoration(labelText: "Email Address"),
              ),
              TextFormField(
                obscureText: true,
                obscuringCharacter: '*',
                controller: password,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a Password";
                  }

                  return null;
                },
                decoration: InputDecoration(labelText: "Password"),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a MatricNumber/Staff ID";
                  }

                  return null;
                },
                controller: id_number,
                decoration:
                    InputDecoration(labelText: "Matric Number/Staff ID"),
              ),
            ],
          ),
        ),
        Step(
            isActive: currentStep >= 1,
            title: Text('Personal Info'),
            content: Column(
              children: <Widget>[
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your first name.";
                    }

                    return null;
                  },
                  controller: fName,
                  decoration: InputDecoration(labelText: "First Name"),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a last name.";
                    }

                    return null;
                  },
                  controller: lName,
                  decoration: InputDecoration(labelText: "Last Name"),
                ),
                TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your IC number.";
                    }

                    return null;
                  },
                  controller: ic_number,
                  decoration: InputDecoration(labelText: "IC Number"),
                ),
              ],
            )),
      ];

  toLogin() => {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false,
        ),
      };

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final dBase = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            style: TextStyle(color: Color.fromRGBO(124, 0, 0, 1)),
            "Regiser Account",
          ),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(primary: Colors.redAccent),
          ),
          child: Form(
              key: formKey,
              child: Stepper(
                type: StepperType.horizontal,
                steps: getSteps(),
                currentStep: currentStep,
                onStepContinue: () {
                  final isLastStep = currentStep == getSteps().length - 1;
                  formKey.currentState!.validate();

                  bool isDetailValid = isDetailComplete();

                  if (isDetailValid) {
                    if (isLastStep) {
                      setState(() => isCompleted = true);
                      print('Complete');
                      _firebaseAuth
                          .createUserWithEmailAndPassword(
                              email: email.text, password: password.text)
                          .then((value) {
                        final User? user = _firebaseAuth.currentUser;
                        final userInformation = <String, String>{
                          "email": email.text,
                          "fName": fName.text,
                          "icNum": ic_number.text,
                          "idNum": id_number.text,
                          "lName": lName.text,
                          "password": password.text,
                          "profilePice": "",
                        };

                        dBase
                            .collection("User")
                            .doc(user?.uid)
                            .set(userInformation)
                            .onError((error, stackTrace) {
                          print("Error ${error.toString()}");
                        });
                      }).then((value) {
                        toLogin();
                      }).onError((error, stackTrace) {
                        print("Error ${error.toString()}");
                      });

                      //Add the function call the firebase
                    } else {
                      setState(() {
                        currentStep += 1;
                      });
                    }
                  }
                },
                onStepCancel: currentStep == 0
                    ? null
                    : () => setState(() => currentStep -= 1),
                onStepTapped: onStepTapped,
                controlsBuilder: (context, details) {
                  return Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Text('Proceed'),
                            onPressed: details.onStepContinue,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            child: Text('Back'),
                            onPressed: details.onStepCancel,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
        ));
  }
}
