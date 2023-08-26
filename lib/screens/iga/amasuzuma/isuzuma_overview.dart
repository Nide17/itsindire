import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tegura/firebase_services/isomodb.dart';
import 'package:tegura/models/isuzuma.dart';
import 'package:tegura/models/isuzuma_score.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_attempt.dart';
import 'package:tegura/screens/iga/amasuzuma/isuzuma_score_review.dart';
import 'package:tegura/utilities/appbar.dart';

class IsuzumaOverview extends StatefulWidget {
  final IsuzumaModel isuzuma;
  final IsuzumaScoreModel? scoreUserIsuzuma;
  const IsuzumaOverview(
      {super.key, required this.isuzuma, required this.scoreUserIsuzuma});

  @override
  State<IsuzumaOverview> createState() => _IsuzumaOverviewState();
}

class _IsuzumaOverviewState extends State<IsuzumaOverview> {
  List<String> amasomo = [];

  Future<void> fetchAmasomoTitles() async {
    List<String> amasomoTitles = await IsomoService()
        .getAmasomoTitlesByIds(widget.isuzuma.getIsomoIDs());

    setState(() {
      amasomo =
          amasomoTitles;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchAmasomoTitles();
  }

  @override
  Widget build(BuildContext context) {
    String scoreID = widget.scoreUserIsuzuma != null
        ? '${widget.scoreUserIsuzuma!.takerID}_${widget.scoreUserIsuzuma!.isuzumaID}'
        : '';

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 71, 103, 158),

      // APP BAR
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: AppBarTegura(),
      ),

      body: ListView(children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          margin: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.05,
            vertical: MediaQuery.of(context).size.height * 0.05,
          ),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  // ICON
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 6.0,
                    ),
                    child: Image.asset(
                      'assets/images/isuzuma.png',
                      height: MediaQuery.of(context).size.height * 0.028,
                    ),
                  ),

                  // TEXT WIDGET
                  Flexible(
                    child: Text(
                      widget.isuzuma.title.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.045,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
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
                child: Text(
                    'Iri suzumabumenyi rigizwe n’ibibazo 20 kumasomo akurikira:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      color: const Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.w500,
                    )),
              ),

              // ORDERED LIST OF amasomo - HEIGHT = HEIGHT OF LIST amasomo
              SizedBox(
                height:
                    MediaQuery.of(context).size.height * 0.08 * amasomo.length,
                child:
                    // IF NOT LOADED YET - SHOW LOADING SPINNER
                    amasomo.isEmpty
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 255, 255, 255),
                              backgroundColor: Color(0xFF7ED957),
                            ),
                          )
                        : ListView.builder(
                            itemCount: amasomo.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                dense: true,
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 0.0),
                                visualDensity: const VisualDensity(
                                    horizontal: 0, vertical: -4),
                                leading: Text(
                                  '${index + 1}.',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                title: Text(
                                  '${amasomo[index][0].toUpperCase()}${amasomo[index].substring(1).toLowerCase()}',
                                  style: TextStyle(
                                    fontSize:
                                        MediaQuery.of(context).size.width *
                                            0.04,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ),
              )
            ],
          ),
        ),

        // REVIEW THE SCORE
        widget.scoreUserIsuzuma != null
            ? Container(
                width: MediaQuery.of(context).size.width * 0.5,
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => IsuzumaScoreReview(
                              scoreId: scoreID, isuzuma: widget.isuzuma),
                        ));
                  },
                  style: ElevatedButton.styleFrom(
                    alignment: Alignment.center,
                    fixedSize: Size(
                      MediaQuery.of(context).size.width * 0.5,
                      MediaQuery.of(context).size.height * 0.0,
                    ),
                    foregroundColor: const Color.fromARGB(255, 0, 0, 0),
                    backgroundColor: const Color.fromARGB(255, 187, 201, 221),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                  child: Text(
                    'Reba uko wakoze',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.04,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              )
            : Container(),

        // BUTTON TANGIRA UKORE
        Container(
          width:
              MediaQuery.of(context).size.width * 0.5, // Set the desired width
          alignment: Alignment.center,
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => IsuzumaAttempt(
                        isuzuma: widget.isuzuma,
                        scoreUserIsuzuma: widget.scoreUserIsuzuma)),
              );
            },
            style: ElevatedButton.styleFrom(
              fixedSize: Size(
                MediaQuery.of(context).size.width * 0.5,
                MediaQuery.of(context).size.height * 0.0,
              ),
              foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              backgroundColor: const Color(0xFF7ED957),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ),
            child: Row(
              children: [
                // PLAY BUTTON PNG
                Align(
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    'assets/images/play.svg',
                    height: MediaQuery.of(context).size.height * 0.03,
                  ),
                ),
                Text(
                  widget.scoreUserIsuzuma == null
                      ? '  Tangira ukore'
                      : '  Subiramo',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.042,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
