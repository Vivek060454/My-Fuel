
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../screen/edit.dart';




class Youtubereference extends StatefulWidget {

  @override
  State<Youtubereference > createState() => _YoutubereferenceState();
}

class _YoutubereferenceState extends State<Youtubereference> {
  bool _isPlayerReady = false;

  late User? user;
  late final Stream<QuerySnapshot> orderStream;

  @override
  void initState() {
    FirebaseAuth auth = FirebaseAuth.instance;
    user = auth.currentUser;
    orderStream = FirebaseFirestore.instance
        .collection('usersell')
        .doc(user?.uid)
        .collection("youtubeReference")
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
         return ListView.builder(
shrinkWrap: true,
             itemCount: snapshot.data!.docs.length,
             itemBuilder: (context,index){
               final prodct=snapshot.data!.docs[index];
           return   Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text('Reference Video',  style: GoogleFonts.signika(textStyle: TextStyle(
                 fontSize: 20, fontWeight: FontWeight.w400, )),),

               Padding(
                 padding: const EdgeInsets.all(13.0),
                 child: Container(
                   width: 400,
                   height: 150,
                   decoration: BoxDecoration(
                       borderRadius: BorderRadius.circular(40)


                   ),
                   child: YoutubePlayer(
                     showVideoProgressIndicator: true,
                     progressIndicatorColor: Colors.blueAccent,
                     controller: YoutubePlayerController(initialVideoId: YoutubePlayer.convertUrlToId(prodct['url']).toString(),
                         flags: YoutubePlayerFlags(autoPlay: false)
                     ),

                     //  showVideoProgressIndicator: false,
                     onReady: () {
                       _isPlayerReady = true;
                     },

                   ),
                 ),
               ),
             ],
           );
         });
        }
    );

  }


}


