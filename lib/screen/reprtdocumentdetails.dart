import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportDocumentDetails extends StatefulWidget {
final product;
ReportDocumentDetails(this.product ,{super.key});

  @override
  State<ReportDocumentDetails> createState() => _ReportDocumentDetailsState();
}

class _ReportDocumentDetailsState extends State<ReportDocumentDetails> {
  @override
  Widget build(BuildContext context) {
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
        title:   Text('Document', textAlign: TextAlign.center,
            style:GoogleFonts.aleo(textStyle: TextStyle(color: Colors.black))

          //TextStyle(color: Colors.white ),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor:   Colors.white,
      ),
      body: Image.network(widget.product['image']),
    );
  }
}
