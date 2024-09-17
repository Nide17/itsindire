import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/payment_db.dart';
import 'package:itsindire/models/ifatabuguzi.dart';
import 'package:itsindire/models/payment.dart';
import 'package:itsindire/screens/ibiciro/ifatabuguzi.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/default_input.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class ProcessingIshyura extends StatefulWidget {
  final IfatabuguziModel ifatabuguzi;

  const ProcessingIshyura({super.key, required this.ifatabuguzi});

  @override
  State<ProcessingIshyura> createState() => _ProcessingIshyuraState();
}

class _ProcessingIshyuraState extends State<ProcessingIshyura> {
  final _formKey = GlobalKey<FormState>();
  String phone = '';
  String error = '';
  dynamic payment;
  bool loading = false;

  Future<void> _loadPaymentData() async {
    if (FirebaseAuth.instance.currentUser != null) {
      PaymentModel pymt = FirebaseAuth.instance.currentUser != null
          ? await PaymentService()
              .getUserLatestPytData(FirebaseAuth.instance.currentUser!.uid)
          : null;
      setState(() => payment = pymt);
    }
  }

  @override
  Widget build(BuildContext context) {
    final String message = widget.ifatabuguzi.type != 'ur'
        ? 'Andika nimero ugiye kwishyurisha hasi aho, ubundi wishyure ${widget.ifatabuguzi.igiciro} RWF kuri MoMo: 0794033360 [Patrice]'
        : 'Provide your payment number below, then pay ${widget.ifatabuguzi.igiciro} RWF on MoMo: 0794033360 [Patrice]';

    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 71, 103, 158),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
        ),
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
                      fontSize: MediaQuery.of(context).size.width * 0.032,
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
                    DefaultInput(
                      placeholder: widget.ifatabuguzi.type == 'ur'
                          ? 'Your MTN Number'
                          : 'Nimero yawe ya MTN wishyurisha',
                      validation: widget.ifatabuguzi.type == 'ur'
                          ? 'Please provide your MTN number'
                          : 'Injiza numero ya MTN telefone yawe!',
                      onChanged: (value) => setState(() => phone = value),
                    ),
                    loading
                        ? const LoadingWidget()
                        : GestureDetector(
                            onTap: () async {
                              setState(() => loading = true);

                              // GET THE CURRENT USER
                              User? usr = FirebaseAuth.instance.currentUser;
                              PaymentModel? payment = usr != null
                                  ? PaymentModel(
                                      createdAt: DateTime.now(),
                                      endAt: widget.ifatabuguzi.getEndDate(),
                                      userId: usr.uid,
                                      ifatabuguziID: widget.ifatabuguzi.id,
                                      igiciro:
                                          '${widget.ifatabuguzi.igiciro} RWF',
                                      isApproved: false,
                                      phone: phone)
                                  : null;

                              // CREATE THE PAYMENT IN FIRESTORE
                              if (_formKey.currentState!.validate() &&
                                  payment != null) {
                                _formKey.currentState!.save();

                                // PAY THE MONEY
                                dynamic payRes = await PaymentService()
                                    .createPayment(payment);

                                // CHECK IF PAYMENT SUCCESSFUL & LOAD PAYMENT DATA
                                if (payRes != null) {
                                  await _loadPaymentData();

                                  // NAVIGATE TO THE PREVIOUS 2 PAGES
                                  if (!mounted) return;

                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();

                                  // SHOW THE ALERT DIALOG
                                  showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return ItsindireAlert(
                                            errorTitle:
                                                widget.ifatabuguzi.type == 'ur'
                                                    ? 'Pay via MOMO'
                                                    : 'Ishyura na MOMO',
                                            errorMsg: widget.ifatabuguzi.type ==
                                                    'ur'
                                                ? 'You can now pay on 0794033360 and you should be confirmed shortly!'
                                                : 'Ubu noneho wakwishyura kuri 0794033360, ugategereza gato bikemezwa!',
                                            alertType: 'success');
                                      });
                                } else {
                                  setState(() => error =
                                      'Error occured, please try again!');
                                }
                              } else {
                                setState(() =>
                                    error = 'Error occured, please try again!');
                              }
                              // SET THE LOADING STATE TO FALSE
                              setState(() => loading = false);

                              if (error.isNotEmpty)
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return ItsindireAlert(
                                          errorTitle: 'Error',
                                          errorMsg: error,
                                          alertType: 'error');
                                    });
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
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
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
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
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
                        ? 'You will be allowed to continue once your payment is confirmed!'
                        : 'Urahita wemererwa gukomeza nusoza kwishyura!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.032,
                      fontWeight: FontWeight.w900,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
            ),

            // IFATABUGUZI UGIYE KUGURA
            Ifatabuguzi(
                index: 0,
                ifatabuguzi: widget.ifatabuguzi,
                curWidget: runtimeType.toString()),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            )
          ],
        ));
  }
}
