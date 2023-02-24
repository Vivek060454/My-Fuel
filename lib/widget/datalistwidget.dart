
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../screen/edit.dart';




class DataListWidget extends StatefulWidget {

  @override
  State<DataListWidget > createState() => _DataListWidgetState();
}

class _DataListWidgetState extends State<DataListWidget> {


  late User? user;
  late final Stream<QuerySnapshot> orderStream;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    orderStream = FirebaseFirestore.instance
        .collection('usersell')
        .doc(user?.uid)
        .collection("datalist")
        .snapshots();

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

            return    Container(
            height: 150,
            width: 400,
            child: Stack(children: [
              Container(
                height: 150,
                width: 400,
                child: Stack(children: [
                  Container(
                    height: 120,
                    width: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey, //New
                          blurRadius: 5.0,
                        )
                      ],
                    ),
                    child: Column(
                      children: [
                        Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(storedocs[0]['CurrentValue'], style: GoogleFonts.signika(textStyle: TextStyle(
                                      fontSize:16, fontWeight: FontWeight.w400, )),),
                                    Text(storedocs[0]['CurrentKey'], style: GoogleFonts.signika(textStyle: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black26 )),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(storedocs[0]['TargetValue'], style: GoogleFonts.signika(textStyle: TextStyle(
                                      fontSize:16, fontWeight: FontWeight.w400, )),),
                                    Text(storedocs[0]['TargetKey'], style: GoogleFonts.signika(textStyle: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black26 )),),
                                  ],
                                ),
                              )
                            ])
                          ],
                        ),
                        Table(
                          children: [
                            TableRow(children: [
                              Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(storedocs[0]['datee'], style: GoogleFonts.signika(textStyle: TextStyle(
                                      fontSize:16, fontWeight: FontWeight.w400, )),),
                                    Text('Last Update', style: GoogleFonts.signika(textStyle: TextStyle(
                                        fontSize: 16, fontWeight: FontWeight.w400,color: Colors.black26 )),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircularPercentIndicator(
                                      radius: 50.0,
                                      startAngle: 1.0,
                                      lineWidth: 5.0,
                                      percent: 0.2,
                                      center: new Text("100%"),
                                      progressColor: Colors.pinkAccent,
                                    ),
                                  ],
                                ),
                              )
                            ])
                          ],
                        )
                      ],
                    ),
                  ),
                  Positioned(
                      top: 100,
                      right: 100,
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>Editdatalist(storedocs[0])));
                        },
                        child: Container(
                          width: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.orange,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey, //New
                                blurRadius: 5.0,
                              )
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text('Click To'),
                                Text('Update'),
                              ],
                            ),
                          ),
                        ),
                      ))
                ]),
              ),

            ]),
          );
        }
    );

  }


}


