import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:localstorage/localstorage.dart';
import 'package:myfuel/screen/datalist.dart';
import 'package:myfuel/screen/reportdocument.dart';
import 'package:myfuel/widget/datalistwidget.dart';
import 'package:myfuel/widget/youtubevideorefernce.dart';
import 'package:pedometer/pedometer.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';



import 'login.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  String _status = '?', _steps = '?';
  final LocalStorage storagee2 = new LocalStorage('localstorage_app');

  final LocalStorage stor1 = new LocalStorage('localstorage_app');
  final LocalStorage name = new LocalStorage('localstorage_app');



  void onStepCount(StepCount event) {
    /// Handle step count changed
    print(event);
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onPedestrianStatusChanged(PedestrianStatus event) {
    print(event);
    setState(() {
      _status = event.status;
    });
  }
  final storage2 = new FlutterSecureStorage();
  void onPedestrianStatusError(error) {
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    print(_status);
  }

  void onStepCountError(error) {
    print('onStepCountError: $error');
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  Future<void> initPlatformState() async {
    /// Init streams
    _pedestrianStatusStream = Pedometer.pedestrianStatusStream;
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    _stepCountStream = Pedometer.stepCountStream;
    _stepCountStream.listen(onStepCount).onError(onStepCountError);

    if (!mounted) return;




  }
  int water=0;
  final _scaffoldKey = GlobalKey<ScaffoldState>();


 _incrementCounter() {
      setState(() {
        water++;
      });

}
  @override
  Widget build(BuildContext context) {
    double stepcount=0.1;
    stepcount=(double.parse((10*100).toString())/5000);
    double s=0.1;
    s=(double.parse((10*100).toString())/5000);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,




        backgroundColor: Colors.white,
title: Text('My Fuel',style: TextStyle(color: Colors.black),),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              _scaffoldKey.currentState!.openDrawer();
            },
            child: Container(

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey, //New
                      blurRadius: 5.0,
                    )
                  ],
                ),
                child: Icon(Icons.menu,color: Colors.black)),
          ),
        ),
      ),

      drawer: Drawer(
          child: Container(
            child: ListView(
              //Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: <Widget>[
                SizedBox(
                  height: 190,
                  child:UserAccountsDrawerHeader(
                    accountName: Text(name
                        .getItem('name'), style: GoogleFonts.signika(textStyle: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400, ))),
                    accountEmail: Text(stor1
                        .getItem('email'), style: GoogleFonts.signika(textStyle: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w400, ))),
                    currentAccountPicture: CircleAvatar(
                      child: Text(name
                          .getItem('name').toString().substring(0,1), style: GoogleFonts.signika(textStyle: TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w400,))),
                      // backgroundImage: AssetImage("assets/Tritan-bike.png",),

                    ),
                  ),


                ),



                ListTile(
                  leading: const Icon(Icons.contacts_rounded,color:Color.fromARGB(255,0 , 18, 50),),
                  title: const Text("Contact Us"),
                  onTap: ()  async {
                    // Navigator.push(context, MaterialPageRoute(
                    //     builder: (context) =>ContactUs()));
                    //  Navigator.popAndPushNamed(context, 'login');
                  },
                ),



                ListTile(
                  leading: const Icon(Icons.logout_outlined,color: Color.fromARGB(255,0 , 18, 50),),
                  title: const Text("Sign Out"),
                  onTap: ()  async {
                    FirebaseAuth.instance.signOut();
                    await storage2.delete(key: 'uid');
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const Login()));
                    //  Navigator.popAndPushNamed(context, 'login');
                  },
                ),
              ],
            ),
          )
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [



             Table(
               children: [
                 TableRow(
                   children: [
                     Text
                       ('Hi ,'+ name
                         .getItem('name'), style: GoogleFonts.signika(textStyle: TextStyle(
                       fontSize: 25, fontWeight: FontWeight.w400, ))),
                    Row(
                       children: [
                          Icon(
                           _status == 'walking'
                               ? Icons.directions_walk
                               : _status == 'stopped'
                               ? Icons.accessibility_new
                               : Icons.error,

                         ),
                         Column(
                           children: [
                             Text(_status=='?'?'Not Support':_status),
                           ],
                         )
                       ],
                     ),
                   ]
                 )
               ],
             ),




              SizedBox(
                height: 10,
              ),
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 150,
                          width: 150,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularPercentIndicator(
                                  radius: 80.0,
                                  startAngle: 1.0,
                                  lineWidth: 5.0,
                                  percent: 0.2,
                                  center: new Text(_steps=='?'?'N/A':_steps),
                                  progressColor: Colors.orange,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Steps'),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 150,
                          width: 150,
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
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CircularPercentIndicator(
                                  radius: 80.0,
                                  startAngle: 1.0,
                                  lineWidth: 5.0,
                                  percent: double.parse(stepcount.toString()),
                                  center: new Text(_steps=='?'?'N/A':_steps),
                                  progressColor: Colors.orange,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text('Calories'),
                              ),
                            ],
                          )),
                    ),
                  ])
                ],
              ),
              Table(
                children: [
                  TableRow(
                    children: [
                      Text('Tracker',  style: GoogleFonts.signika(textStyle: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400, )),),
                      Align(
                          alignment: Alignment.topRight,
                          child: InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>DataList()));
                            },
                            child: Text('See All',  style: GoogleFonts.signika(textStyle: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400, ))),
                          )),
                    ]
                  )
                ],
              ),

              SizedBox(
                height: 10,
              ),
              DataListWidget(),
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
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
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(Icons.local_fire_department_rounded),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(_steps=='?'?'N/A':_steps),
                                  ),
                                ],
                              )),
                          Text('Calories')
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          _incrementCounter();
                        },
                        child: Column(
                          children: [
   Container(
    height: 60,
    width: 60,
    decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(40),
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
    Padding(
    padding: const EdgeInsets.all(4.0),
    child: Icon(Icons.water_drop),
    ),
    Padding(
    padding: const EdgeInsets.all(4.0),
    child: Text(water.toString()+'L'),
    ),
    ],
    )),
                            Text('Water')
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
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
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Icon(Icons.directions_run_sharp),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(_steps=='?'?'N/A':_steps),
                                  ),
                                ],
                              )),
                          Text('Steps')
                        ],
                      ),
                    ),

                  ])
                ],
              ),
              Table(
                children: [
                  TableRow(children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){

                        },
                        child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
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
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(Icons.analytics),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('Dietchart',maxLines: 1,overflow: TextOverflow.ellipsis,),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.data_exploration),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Progress'),
                              ),
                            ],
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>ReportDocument()));
                        },
                        child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
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
                                Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Icon(Icons.report),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text('Report'),
                                ),
                              ],
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
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
                              Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(Icons.auto_graph_sharp),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Text('Grapic'),
                              ),
                            ],
                          )),
                    ),
                  ])
                ],
              ),
              Youtubereference()
            ],
          ),
        ),
      ),
    );
  }
}
