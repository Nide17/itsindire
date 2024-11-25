import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:itsindire/firebase_services/isuzuma_score_db.dart';
import 'package:provider/provider.dart';
import 'package:itsindire/firebase_services/payment_db.dart';
import 'package:itsindire/models/isuzuma.dart';
import 'package:itsindire/models/isuzuma_score.dart';
import 'package:itsindire/models/payment.dart';
import 'package:itsindire/screens/auth/iyandikishe.dart';
import 'package:itsindire/screens/iga/amasuzuma/amanota.dart';
import 'package:itsindire/screens/iga/utils/itsindire_alert.dart';
import 'package:itsindire/screens/iga/amasuzuma/isuzuma_overview.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class AmasuzumaCard extends StatefulWidget {
  final IsuzumaModel isuzuma;

  const AmasuzumaCard({super.key, required this.isuzuma});

  @override
  State<AmasuzumaCard> createState() => _AmasuzumaCardState();
}

class _AmasuzumaCardState extends State<AmasuzumaCard> {

  dynamic payment;
  bool loading = false;

  Future<bool> _isPaymentApproved() async {
    setState(() => loading = true);

    if (FirebaseAuth.instance.currentUser != null) {
      PaymentModel? pymt = FirebaseAuth.instance.currentUser != null
          ? await PaymentService()
              .getUserLatestPytData(FirebaseAuth.instance.currentUser!.uid)
          : null;

      setState(() {
        payment = pymt;
        loading = false;
      });

      if (payment != null &&
          payment.isApproved &&
          payment.endAt.isAfter(DateTime.now())) {
        return true;
      } else {
        return false;
      }
    } else {
      loading = false;
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

    final usr = FirebaseAuth.instance.currentUser;

    return loading
        ? const LoadingWidget()
        : MultiProvider(
      providers: [
        StreamProvider<IsuzumaScoreModel?>.value(
          value: usr == null
              ? null
              :
          IsuzumaScoreService()
              .getScoreByID('${usr.uid}_${widget.isuzuma.id}'),
          initialData: null,
          catchError: (context, error) {
            return null;
          },
        ),
      ],
      child:
          Consumer<IsuzumaScoreModel?>(builder: (context, userScore, _) {
            return Column(
                children: [
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
                                      builder: (context) => const Iyandikishe(
                                          message:
                                              'Banza wiyandikishe, wishyure ubone aya masuzumabumenyi yose!')))
                              : payment != null &&
                                      payment.isApproved &&
                                      payment.endAt.isAfter(DateTime.now())
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => IsuzumaOverview(
                                                isuzuma: widget.isuzuma,
                                              )),
                                    )
                                  : showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return ItsindireAlert(
                                          errorTitle: 'Ntibyagenze neza',
                                          errorMsg: payment == null
                                              ? 'Nturishyura'
                                              : payment.isApproved == false
                                                  ? 'Ifatabuguzi ryawe ntiriremezwa'
                                                  : !payment.endAt
                                                          .isAfter(DateTime.now())
                                                      ? 'Ifatabuguzi ryawe ryararangiye'
                                                      : 'Ibyo wifuza ntibyagenze neza. Ongera ushyure kugira ngo ugerageze!',
                                          alertType: 'error',
                                          secondButtonTitle: 'Ishyura',
                                          secondButtonFunction: () {
                                            Navigator.pop(context);
                                            Navigator.pushReplacementNamed(
                                                context, '/ibiciro');
                                          },
                                          secondButtonColor: Color(0xFF00A651),
                                        );
                                      });
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          decoration: BoxDecoration(
                            color: const Color(0xFF00CCE5),
                            borderRadius: BorderRadius.circular(
                                MediaQuery.of(context).size.width * 0.03),
                            border: Border.all(
                              width: MediaQuery.of(context).size.width * 0.006,
                              color: const Color(0xFFFFBD59),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.all(
                                  MediaQuery.of(context).size.width * 0.01,
                                ),
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
                              Container(
                                color: const Color(0xFFFFBD59),
                                height: MediaQuery.of(context).size.height * 0.009,
                              ),
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
                      usr == null
                          ? Text(
                              '/${widget.isuzuma.questions.length}',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: MediaQuery.of(context).size.width * 0.08,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Amanota(userScore: userScore)
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.04,
                  ),
                ],
              );
          }),
    );
  }
}
