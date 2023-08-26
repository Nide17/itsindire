import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tegura/firebase_services/payment_db.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/models/payment.dart';
import 'package:tegura/models/user.dart';
import 'package:tegura/screens/auth/injira.dart';
import 'package:tegura/screens/auth/iyandikishe.dart';
import 'package:tegura/screens/iga/amasuzuma/amanota.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_overview.dart';
import 'package:tegura/utilities/spinner.dart';

class AmasuzumaCard extends StatefulWidget {
  final IsuzumaModel isuzuma;
  final List<IsuzumaScoreModel>? amaUserScores;

  const AmasuzumaCard({
    Key? key,
    required this.isuzuma,
    required this.amaUserScores,
  }) : super(key: key);

  @override
  State<AmasuzumaCard> createState() => _AmasuzumaCardState();
}

class _AmasuzumaCardState extends State<AmasuzumaCard> {
  dynamic payment;
  bool loading = false;

  Future<bool> _isPaymentApproved() async {
    // SET THE LOADING STATE TO TRUE
    setState(() => loading = true);

    if (FirebaseAuth.instance.currentUser != null) {
      PaymentModel? pymt = await PaymentService()
          .getUserLatestPaymentData(FirebaseAuth.instance.currentUser!.uid);

      setState(() {
        payment = pymt;
        loading = false;
      });

      // IF THE USER HAS A PAYMENT PLAN APPROVED
      if (pymt != null && pymt.isApproved == true) {
        // RETURN TRUE
        return true;
      } else {
        // RETURN FALSE
        return false;
      }
    } else {
      loading = false;
      // RETURN FALSE
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    _isPaymentApproved();
  }

  @override
  Widget build(BuildContext context) {
    final usr = Provider.of<UserModel?>(context);

    // FIND A SCORE WHERE THE TAKER ID IS THE CURRENT USER ID AND THE ISUZUMA ID IS THE CURRENT ISUZUMA ID
    final scoreUserIsuzuma = (usr != null && widget.amaUserScores!.isNotEmpty)
        ? widget.amaUserScores!.firstWhere((element) =>
            element.takerID == usr.uid &&
            element.isuzumaID == widget.isuzuma.id)
        : null;

    return loading
        ? const Spinner()
        : Column(
            children: [
              // CARDS ROW FOR IGAZETI, AND IBYAPA - FLEX 50%
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      usr == null
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Injira(
                                      message:
                                          'Banza winjire, ube warishyuye ubone aya masuzumabumenyi yose!')))
                          : payment != null && payment.isApproved == true
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => IsuzumaOverview(
                                          isuzuma: widget.isuzuma,
                                          scoreUserIsuzuma: scoreUserIsuzuma)),
                                )
                              :
                              // SHOW ALERT DIALOG
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text(
                                        'Ntibyagenze neza',
                                        style: TextStyle(color: Colors.red),
                                      ),
                                      content: Text(payment == null
                                          ? 'Nturishyura'
                                          : payment.isApproved == false
                                              ? 'Ifatabuguzi ryawe ntiriremezwa'
                                              : 'Ongera ugerageze!'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('OK'))
                                      ],
                                    );
                                  });
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      decoration: BoxDecoration(
                        color: const Color(0xFF00CCE5),
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          width: 2.0,
                          color: const Color(0xFFFFBD59),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // TITLE
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Text(
                              widget.isuzuma.title.toUpperCase(),
                              textAlign: TextAlign.center,
                              softWrap: true,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.035,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),

                          // BOTTOM BORDER OF THE ABOVE SECTION
                          Container(
                            color: const Color(0xFFFFBD59),
                            height: MediaQuery.of(context).size.height * 0.009,
                          ),

                          // PNG ICON
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                              vertical: 6.0,
                            ),
                            child: Image.asset(
                              'assets/images/isuzuma.png',
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  scoreUserIsuzuma != null
                      ? Amanota(
                          score: scoreUserIsuzuma.marks,
                          maxScore: scoreUserIsuzuma.totalMarks,
                        )
                      : const Text(
                          'Nturarikora!',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ],
              ),

              // 3. VERTICAL SPACE
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
            ],
          );
  }
}
