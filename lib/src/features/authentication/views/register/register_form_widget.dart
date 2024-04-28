import 'package:bustrack/src/features/authentication/views/login/login_widget.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  List<Step> getSteps() => [
        Step(
          state: currentStep > 0 ? StepState.complete : StepState.indexed,
          isActive: currentStep >= 0,
          title: Text('Account Info'),
          content: Column(
            children: <Widget>[
              TextFormField(
                validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter an Email";
                          }

                          return null;
                        },
                controller: email,
                decoration: InputDecoration(labelText: "Email Address"),

              ),
              TextFormField(
                obscureText: true,
                obscuringCharacter: '*',
                validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter a Password";
                          }

                          return null;
                        },
                controller: password,
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

  int currentStep = 0;
  bool isCompleted = false;

  final email = TextEditingController();
  final password = TextEditingController();
  final id_number = TextEditingController();
  final fName = TextEditingController();
  final lName = TextEditingController();
  final ic_number = TextEditingController();

  onStepTapped(int value) {
    setState(() {
      currentStep = value;
    });
  }

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
            child: Stepper(
              type: StepperType.horizontal,
              steps: getSteps(),
              currentStep: currentStep,
              onStepContinue: () {
                final isLastStep = currentStep == getSteps().length - 1;

                if (isLastStep) {
                  setState(() => isCompleted = true);
                  print('Completed');
                  toLogin();
                  //Add the function call the firebase
                } else {
                  setState(() {
                    currentStep += 1;
                  });
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
            )));
  }
}
