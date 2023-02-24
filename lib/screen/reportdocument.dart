



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfuel/screen/reprtdocumentdetails.dart';
import 'package:myfuel/screen/uploaddatalist.dart';
import 'package:myfuel/screen/uploadreportdocument.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import 'edit.dart';




class ReportDocument extends StatefulWidget {

  @override
  State<ReportDocument > createState() => _ReportDocumentState();
}

class _ReportDocumentState extends State<ReportDocument> {


  late User? user;
  late final Stream<QuerySnapshot> orderStream;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    orderStream = FirebaseFirestore.instance
        .collection('usersell')
        .doc(user?.uid)
        .collection("reportdocument")
        .snapshots();

  }
  Future<void> deleteUser(id) {
    return FirebaseFirestore.instance
        .collection('usersell')
        .doc(user?.uid)
        .collection("reportdocument").doc(id)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }

// const ProductList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(stream:orderStream,
        builder: (BuildContext context,AsyncSnapshot<QuerySnapshot>snapshot) {
          if (snapshot.hasError) {
            print("Something Went Wrong");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final List  storedocs  = [];
          snapshot.data!.docs.map((DocumentSnapshot document) async {
            Map a = document.data() as Map<String,dynamic>;
            storedocs .add(a);
            a['id'] = document.id;
          }).toList();
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
                title:   Text('Report Document', textAlign: TextAlign.center,
                    style:GoogleFonts.aleo(textStyle: TextStyle(color: Colors.black))

                  //TextStyle(color: Colors.white ),
                ),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                backgroundColor:   Colors.white,
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:   ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>UploadReportDocumnent()));
                    }, child: Text('Add')),
                  )


                ],
              ),

              body:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(

                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context,index){
                      final  product = snapshot.data!.docs[index];
                      return ListTile(
                      leading: Image.network(product['image']),
                        title: Text(product['title'].toString()),

                        subtitle: Text(product['datee'].toString()),

                        onTap: (){
                     Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportDocumentDetails(product)));
                        },
                        trailing: IconButton(onPressed: () {

                          setState(() {
                            deleteUser(product.id);
                          });
                        }, icon: Icon(Icons.delete),

                        ),
                      );
                    }),
              )
          );

        }
    );

  }


}


