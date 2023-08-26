import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/models/ifatabuguzi.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/ibiciro/ifatabuguzi.dart';
import 'package:tegura/screens/ibiciro/subscription.dart';
import 'package:tegura/utilities/appbar.dart';
import 'package:tegura/utilities/default_input.dart';
import 'package:tegura/utilities/spinner.dart';

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
  // DECLARE FORM KEY TO VALIDATE THE FORM
  final _formKey = GlobalKey<FormState>();
  // FORM FIELD VALUES STATE
  String phone = '';
  bool loading = false;
  String error = '';
  dynamic payment;

  Future<void> _loadPaymentData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      PaymentModel pymt = await PaymentService()
          .getUserLatestPaymentData(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        payment = pymt;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);
    final String message = widget.ifatabuguzi.type != 'ur'
        ? 'Andika nimero ugiye gukoresha wishyura yawe hasi aho, ubundi wishyure ${widget.ifatabuguzi.igiciro} RWF kuri MoMo: 0780579067'
        : 'Provide your payment number below, then pay ${widget.ifatabuguzi.igiciro} RWF on MoMo: 0780579067';
    // final String message = widget.ifatabuguzi.type != 'ur'
    //     ? 'Ishyura ${widget.ifatabuguzi.igiciro} RWF kuri MoMo: 0780579067 \n Cyangwa ukande ino mibare kuri telefone yawe ukoreshe numero yawe ya MTN maze wishyure: \n*182*8*1*36921*${widget.ifatabuguzi.igiciro}#'
    //     : 'Provide your number below or Pay ${widget.ifatabuguzi.igiciro} RWF on MoMo: 0780579067 \n or dial the following on your phone using your MTN momo phone number: \n*182*8*1*36921*${widget.ifatabuguzi.igiciro}#';

    return loading
        ? const Spinner()
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 71, 103, 158),

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
                        message,
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

                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.03),
                  child: Form(
                    key: _formKey, // FORM KEY TO VALIDATE THE FORM
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // IJAMBOBANGA
                        DefaultInput(
                          placeholder: 'Your phone number',
                          validation: 'Please provide your phone number first!',

                          // ON CHANGED
                          onChanged: (value) {
                            setState(() {
                              phone = value;
                            });
                          },
                        ),

                        // CONFIRM PAYMENT
                        GestureDetector(
                          // NAVIGATE TO THE CHILD PAGE
                          onTap: () async {
                            // CREATE A NEW PAYMENT OBJECT
                            PaymentModel payment = PaymentModel(
                                createdAt: DateTime.now(),
                                endAt: widget.ifatabuguzi.getEndDate(),
                                userId: usr != null ? usr.uid : '',
                                ifatabuguziID: widget.ifatabuguzi.id,
                                isApproved: false,
                                phone: phone);

                            // CREATE THE PAYMENT IN FIRESTORE
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();

                              // SET THE LOADING STATE TO TRUE
                              setState(() => loading = true);

                              // PAY THE MONEY
                              dynamic payRes =
                                  await PaymentService().createPayment(payment);

                              // CHECK IF PAYMENT SUCCESSFUL
                              if (payRes == null) {
                                setState(() {
                                  error = 'Error occured, please try again!';
                                  loading = false;

                                  // SHOW ALERT DIALOG
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(error),
                                          actions: [
                                            TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('OK'))
                                          ],
                                        );
                                      });
                                });
                              } else {
                                // LOAD PAYMENT DATA
                                await _loadPaymentData();

                                // SET THE LOADING STATE TO FALSE
                                setState(() => loading = false);

                                // NAVIGATE TO THE PREVIOUS 2 PAGES
                                if (!mounted) return;

                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              }
                            } else {
                              print('\nAttempt to pay!!\n');
                            }

                            //
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width *
                                0.5, // Set to 50% of the width
                            margin: EdgeInsets.symmetric(
                              horizontal: MediaQuery.of(context).size.width *
                                  0.25, // Center horizontally
                              vertical:
                                  MediaQuery.of(context).size.height * 0.03,
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
                                widget.ifatabuguzi.type == 'ur'
                                    ? 'CONFIRM'
                                    : 'EMEZA KWISHYURA',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.035,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
                        widget.ifatabuguzi.type == 'ur'
                            ? 'You will be allowed to start studying once your payment is confirmed!'
                            : 'Urahita wemererwa gutangira kwiga aka kanya!',
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
                widget.ifatabuguzi.type == 'ur'
                    ? Subscription(
                        title: 'YOUR SUBSCRIPTION',
                        ifatabuguzi: widget.ifatabuguzi,
                        curWidget: runtimeType.toString(),
                      )
                    : Ifatabuguzi(
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
