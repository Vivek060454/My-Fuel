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

class UploadReportDocumnent extends StatefulWidget {



  const UploadReportDocumnent({super.key});

  @override
  UploadReportDocumnentState createState() {
    return UploadReportDocumnentState();
  }
}

class UploadReportDocumnentState extends State<UploadReportDocumnent> {
  final _formKey = GlobalKey<FormState>();

  var title = '';



  final LocalStorage storagee2 = new LocalStorage('localstorage_app');
  final TextEditingController _titleController = new TextEditingController();


  final _auth = FirebaseAuth.instance;

  static String? get uid => null;

  @override
  void dispose() {
    _titleController.dispose();



    super.dispose();
  }

  Future<void> addUser() async {
    UploadTask? uploadTask;
    final path='files/${imageName}';
    final file =File(imagePath!.path);
    final ref=FirebaseStorage.instance.ref().child(path);
    uploadTask =ref.putFile(file);
    final snapshot=await uploadTask;
    var url = await snapshot.ref.getDownloadURL();
    var uuid = Uuid();
    final curUuid = uuid.v1();
    CollectionReference usersell = FirebaseFirestore.instance
        .collection('usersell')
        .doc(_auth.currentUser?.uid)
        .collection('reportdocument');
    usersell
        .doc(curUuid)
        .set({
      "image": url,
      "title": title,

      'datee': DateTime.now().toString().substring(0, 10)
    })
        .then((valure) => print('Product Added'))
        .catchError((error) => print('failed to add Product:$error'));
    Navigator.pop(context);
  }

  clearText() {
    _titleController.clear();

  }

  String imageName = '';
  XFile? imagePath;
  final ImagePicker _picker = ImagePicker();

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
          backgroundColor: Colors.white,),
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
                          'Upload Image*',
                          style: GoogleFonts.signika(textStyle: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w400, )),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: Column(
                      children: [

                        imageName == '' ? Container() : Text(
                          '${imageName}', maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,),


                      ],
                    ),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),

                    child: IconButton(icon: Icon(Icons.add),
                      onPressed: () {
                        imagePicker();
                      },),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: TextFormField(
                      controller: _titleController,
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
                            title = _titleController.text;


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

  imagePicker() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        imagePath = image;
        imageName = image.name.toString();
      });
    }
  }
}