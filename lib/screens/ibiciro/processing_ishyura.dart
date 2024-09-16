import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/models/ifatabuguzi.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/ifatabuguzi.dart';
import 'package:tegura/utilities/appbar.dart';

class ProcessingIshyura extends StatefulWidget {
  // INSTANCE VARIABLES

  final IfatabuguziModel ifatabuguzi;

  // CONSTRUCTOR
  const ProcessingIshyura({Key? key, required this.ifatabuguzi})
      : super(key: key);

  @override
  State<ProcessingIshyura> createState() => _ProcessingIshyuraState();
}

class _ProcessingIshyuraState extends State<ProcessingIshyura> {
  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);

    return Scaffold(
        backgroundColor: const Color(0xFF5B8BDF),

        // APP BAR
        appBar: const PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarTegura(),
        ),

        // PAGE BODY
        body: ListView(
          // YELLOW MOMO PAYING CONTAINER
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.03,
              ),
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.04,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFDE59),
                border: Border.all(
                  width: 2.0,
                  color: const Color.fromARGB(255, 255, 204, 0),
                ),
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 59, 57, 77),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                    spreadRadius: -7,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Ishyura ${widget.ifatabuguzi.igiciro} RWF kuri MoMo: 0780044110 \n Cyangwa ukande ino mibare kuri telefone yawe ukoreshe numero yawe ya MTN maze wishyure: \n*182*8*1*36921*${widget.ifatabuguzi.igiciro}#',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),

            // CONFIRM PAYMENT
            GestureDetector(
              // NAVIGATE TO THE CHILD PAGE
              onTap: () {
                print(widget.ifatabuguzi);
                // DateTime createdAt;
                // DateTime endAt;
                // String? userId;
                // String? ifatabuguziID;

                // CREATE A NEW PAYMENT OBJECT
                PaymentModel payment = PaymentModel(
                  createdAt: DateTime.now(),
                  endAt: widget.ifatabuguzi.getEndDate(),
                  userId: usr != null ? usr.uid : '',
                  ifatabuguziID: widget.ifatabuguzi.id,
                );

                // CREATE THE PAYMENT IN FIRESTORE
                PaymentService().createPayment(payment);
              },
              child: Container(
                width: MediaQuery.of(context).size.width *
                    0.5, // Set to 50% of the width
                margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width *
                      0.25, // Center horizontally
                  vertical: MediaQuery.of(context).size.height * 0.03,
                ),
                padding: EdgeInsets.all(
                  MediaQuery.of(context).size.width * 0.024,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF00A651),
                  border: Border.all(
                    width: 2.0,
                    color: const Color.fromARGB(255, 255, 255, 255),
                  ),
                  borderRadius: BorderRadius.circular(24.0),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(255, 59, 57, 77),
                      offset: Offset(0, 3),
                      blurRadius: 8,
                      spreadRadius: -7,
                    ),
                  ],
                ),
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'EMEZA KWISHYURA',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ),
              ),
            ),

            // WHITE CONTAINER URAHITA
            Container(
              width: MediaQuery.of(context).size.width * 0.8,
              margin: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: MediaQuery.of(context).size.height * 0.03,
              ),
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width * 0.04,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFD9D9D9),
                border: Border.all(
                  width: 2.0,
                  color: const Color.fromARGB(255, 240, 238, 231),
                ),
                borderRadius: BorderRadius.circular(24.0),
                boxShadow: const [
                  BoxShadow(
                    color: Color.fromARGB(255, 59, 57, 77),
                    offset: Offset(0, 3),
                    blurRadius: 8,
                    spreadRadius: -7,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Urahita wemererwa gutangira kwiga aka kanya!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),

            // IFATABUGUZI UGIYE KUGURA
            Ifatabuguzi(
                title: "IFATABUGUZI UGIYE KUGURA:",
                ifatabuguzi: widget.ifatabuguzi,
                curWidget: runtimeType.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            )
          ],
        ));
  }
}
