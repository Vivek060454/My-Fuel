import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:localstorage/localstorage.dart';

import 'package:uuid/uuid.dart';

class Uplaoddatalist extends StatefulWidget {



 const Uplaoddatalist({super.key});

  @override
  UplaoddatalistState createState() {
    return UplaoddatalistState();
  }
}

class UplaoddatalistState extends State<Uplaoddatalist> {
  final _formKey = GlobalKey<FormState>();

  var  currentvalue = '';
  var  currentkey   = '';
  var  targetvalue  = '';
  var targetkey    = '';
  var listname     = '';


  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  final TextEditingController _currentkeyController = new TextEditingController();
  final TextEditingController _currentvalueController = new TextEditingController();
  final TextEditingController _targetkeyController = new TextEditingController();
  final TextEditingController _targetvalueController = new TextEditingController();
  final TextEditingController _listnameController = new TextEditingController();

  final _auth = FirebaseAuth.instance;

  static String? get uid => null;

  @override
  void dispose() {
    _currentkeyController.dispose();
    _currentvalueController.dispose();
    _targetkeyController.dispose();
    _targetvalueController.dispose();
    _listnameController.dispose();


    super.dispose();
  }

  Future<void> addUser() async {

    var uuid = Uuid();
    final curUuid = uuid.v1();
    CollectionReference usersell = FirebaseFirestore.instance
        .collection('usersell')
        .doc(_auth.currentUser?.uid)
        .collection('datalist');
    usersell
        .doc(curUuid)
        .set({
       "CurrentValue":   currentvalue,
       "CurrentKey"  :   currentkey  ,
       "TargetValue" :   targetvalue ,
      "TargetKey"    :  targetkey   ,
      "ListName"     :  listname   ,
      'datee': DateTime.now().toString().substring(0, 10)

    })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));


  }

  clearText() {

    _currentkeyController.clear();
    _currentvalueController.clear();
    _targetkeyController.clear();
    _targetvalueController.clear();
    _listnameController.clear();

  }


  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(0),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey, //New
                    blurRadius: 15.0,
                  )
                ],
              ),
              child: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  )),
            ),
          ),
            title: Text(
              'Add Data',
              textAlign: TextAlign.center,
              style:
              GoogleFonts.aleo(textStyle: TextStyle(color: Colors.black)),
            ),
            //  title: const Text('Tritan Bikes'),
    elevation: 0,
    iconTheme: IconThemeData(color: Colors.white),
    backgroundColor:   Colors.white,),
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Row(
                      children: [
                        Text(
                          'Personal Information*',
                          style: GoogleFonts.signika(
                              textStyle: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 0, 18, 50))),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _listnameController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'List Name ',
                        hintText: 'Eg.Weight Traker,etc ',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter list name ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _currentkeyController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Current Key ',
                        hintText: 'Eg.Current Weight ',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter current key ';
                        }
                        return null;
                      },
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _currentvalueController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Current Value ',
                        hintText: 'Eg.40kg ',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter current value ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _targetkeyController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Target Key ',
                        hintText: 'Eg.Target Weight ',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter target key ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _targetvalueController,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,

                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        labelText: 'Target Value ',
                        hintText: 'Eg. 60kg ',
                        hintStyle: const TextStyle(
                            height: 2, fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(0)),
                      ),
                      // The validator receives the text that the user has entered.
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter target value ';
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.orange,
                        ),
                      ),
//color: Color.fromRGBO(100, 0, 0, 10),

                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            currentkey = _currentkeyController.text;
                            currentvalue = _currentvalueController.text;
                            targetkey = _targetkeyController.text;
                            targetvalue = _targetvalueController.text;
                            listname = _listnameController.text;

                            addUser();
                            clearText();

                            Fluttertoast.showToast(msg: " Added");
                            // Navigator.of(context).pop(Sellpanelupload);
                          });
                        }
                      },
                      child: Text("Add"),
                    ),
                  ),

                ]),
          ),
        ));
  }


}
