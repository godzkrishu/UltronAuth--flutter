//import 'package:ecommerce/controllers/authController.dart';
import 'package:flutter/material.dart';
import 'package:ultron/controllers/authcontroller.dart';

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen'; //name of this route
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isSigningEnabled = false;
  bool isPasswordVisible = false;

  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  var signUpkey = GlobalKey<FormState>(); // for form key
  var signInkey = GlobalKey<FormState>(); // form key
  void _signUpSubmit(String name, String email, String password) {
    final isValid = signUpkey.currentState!.validate(); //is user is valid( all details are correct)
    if (!isValid) //is not valid
        {
      return;
    }
    signUpkey.currentState!.save(); //save current state of user
    Authcontroller().UserSignUp(
        context: context, name: name, email: email, password: password);
  }

  void _signInSubmit(String email, String password) {
    final isValid = signInkey.currentState!
        .validate(); //is user is valid( all details are correct)
    if (!isValid) //is not valid
        {
      return;
    }
    signInkey.currentState!.save(); //save the user to data base
    print("signin funtion called");
   Authcontroller().signInUser(context: context, email: email, password: password);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
            preferredSize:Size.fromHeight(65),
            child: AppBar(
              flexibleSpace: Container(// for background color of appbar
                decoration: BoxDecoration(color: Colors.blueAccent),
              ),
              title: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Spacer(),
                    Image.asset("assets/images/applogo.png",height: 150,width: 200,),
                    Spacer(),

                  ],

                ),
              ),

            )) ,
        body: isSigningEnabled
            ? SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: signInkey,
                  child: Column(
                    children: [
                      const Text("Sign in With your email Id",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 25,
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Sign In",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              )),
                          TextButton(
                              onPressed: () {},
                              child: const Text("Forget Password",
                                  style: TextStyle(
                                    fontSize: 17,
                                  ))),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {//value of email controller
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                        //color for the various state
                        decoration: const InputDecoration(
                            hintText: "Email",
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {//validate funtion
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          } else {
                            if (value.length < 6) {
                              return 'Enter valid 6 digit password';
                            } else {
                              return null;
                            }
                          }
                        },
                        obscureText: !isPasswordVisible, // Use the variable here
                        decoration: const InputDecoration(
                            hintText: "Password",
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                      const Text(
                        "Rule:-Password must atleast 6digit long",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (value) {
                          setState(() {
                            isPasswordVisible = value!; // Toggle visibility
                          });
                        },
                        title: const Text("Show Password"),
                      ),
                      CheckboxListTile(
                        value: true,
                        onChanged: (value) {},
                        title: const Text("Keep Me Signed In"),
                      ),
                      InkWell(
                        onTap: () => _signInSubmit(emailController.text,
                            passwordController.text),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width / 2 -
                                  60,
                              vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            border: const Border(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text("Sign In"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text("New to UltraCart ?"),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSigningEnabled = false;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width / 2 -
                                  90,
                              vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.orange[200],
                            border: const Border(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text("Create New Account"),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                              "Condition of Use and Privacy Notice")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )

        /////CREATE ACCOUNT
        ////CREATE ACCOUNT
        /////CREATE ACCOUNT
            : SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Form(
                  key: signUpkey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text("Create Account",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 25,
                              )),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        controller: nameController,
                        keyboardType: TextInputType.name,
                        validator: (value) {
                          if (value!.isEmpty) return "Please enter Name";
                          return null; //else
                        },
                        decoration: const InputDecoration(
                            hintText: "Name",
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value!.isEmpty ||
                              !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                  .hasMatch(value)) {
                            return 'Enter a valid email!';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            hintText: "Email",
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: passwordController,
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Please enter password';
                          } else {
                            if (value.length < 6) {
                              return 'Enter valid password';
                            } else {
                              return null;
                            }
                          }
                        },
                        obscureText:
                        true, //hide the password while typing
                        decoration: const InputDecoration(
                            hintText: "Password",
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        validator: (value) {
                         if (value!.isEmpty) {
                            return 'Please re-enter password';

                          } else {

                            if (value != passwordController.text) {
                              return 'Password do not match ';
                            }
                             else {
                              return null;
                            }
                          }
                        },
                        obscureText:
                        true, //hide the password while typing
                        decoration: const InputDecoration(
                            hintText: "Re-Enter Password",
                            focusedErrorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red,
                                )),
                            enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                )),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ))),
                      ),
                      const Text(
                        "Rule:-Password must atleast atleast 6digit",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          _signUpSubmit(
                              nameController.text,
                              emailController.text,
                              passwordController.text);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width / 2 -
                                  90,
                              vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            border: const Border(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text("Create Account"),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Divider(
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      const Text("Already a Customer ?"),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            isSigningEnabled = true;
                          });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                              MediaQuery.of(context).size.width / 2 -
                                  90,
                              vertical: 20),
                          decoration: BoxDecoration(
                            color: Colors.orange[200],
                            border: const Border(),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Text("Sign in "),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                          onPressed: () {},
                          child: const Text(
                              "By Creating a Account You Agree UltraCart Condition of Use and Privacy Notice")),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}
