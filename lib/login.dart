
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:localstorage/localstorage.dart';
import 'package:myfuel/regis.dart';

import 'Home.dart';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();

  final TextEditingController passwordController = new TextEditingController();
  final TextEditingController nameController = new TextEditingController();
  final _auth = FirebaseAuth.instance;
  final storage2 = new FlutterSecureStorage();

  final LocalStorage stor1 = new LocalStorage('localstorage_app');
  final LocalStorage name = new LocalStorage('localstorage_app');

  @override
  Widget build(BuildContext context) {
    final emailFeild = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      onSaved: (value) {
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.email),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (emailController) {
        if (!emailController.toString().contains("@")) {
          return "Please enter the valid email";
        }
        if (emailController!.isEmpty) {
          return ("Please enter the value");
        }
        //  if (!RegExp("^[a-ZA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(emailController))
        //   {
        //     return ("please enter the valid email");
        //   }
        //   return null;
      },
    );
    final nameFeild = TextFormField(
      autofocus: false,
      controller: nameController,
      keyboardType: TextInputType.name,
      onSaved: (value) {
        nameController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.people_outline),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Full Name",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (nameController) {
        if (nameController!.isEmpty) {
          return ("Please enter the value");
        }
        //  if (!RegExp("^[a-ZA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(emailController))
        //   {
        //     return ("please enter the valid email");
        //   }
        //   return null;
      },
    );
    final passwordFeild = TextFormField(
      autofocus: false,
      obscureText: true,
      controller: passwordController,
      onSaved: (value) {
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "password",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      validator: (value) {
        // RegExp regex= new RegExp(r'^.{6,}$');
        print(value);
        if (value!.isEmpty) {
          return (" Please enter password");
        }
        // if(!regex.hasMatch(value)){
        //
        //   return ("Please enter password");
        // }
      },
    );
    final forgotpassword = TextButton(
      child: Row(
        children: [
          Text(
            'Forgot Password?',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.blue),
            textAlign: TextAlign.right,
          ),
        ],
      ),
      onPressed: () {
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>Reset()));
      },
    );
    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(40),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          login(
            emailController.text,
            passwordController.text,
          );

          stor1.setItem('email', emailController.text);
        },
        child: Text(
          'Login',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 256,
                      width: 350,
                      child: Image.asset("assets/abc.jpg"),
                    ),
                    nameFeild,
                    SizedBox(
                      height: 30,
                    ),
                    emailFeild,
                    SizedBox(
                      height: 30,
                    ),
                    passwordFeild,
                    SizedBox(
                      height: 5,
                    ),
                    forgotpassword,
                    SizedBox(
                      height: 5,
                    ),
                    loginButton,
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Dont have a account?"),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Regis()));
                          },
                          child: Text(
                            'Signup',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
          //   print(uid),
          storage2.write(key: 'uid', value: uid.toString()),
        stor1.setItem('name', nameController.text),
          Fluttertoast.showToast(msg: "Login Successful"),

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => Home())),
        })
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      }
    }
  }
}
