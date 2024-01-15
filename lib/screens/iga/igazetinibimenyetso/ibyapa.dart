import 'package:flutter/material.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/ikimenyetso_row.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_app_bar.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_app_footer.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_subtitle.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_title.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/data/biburira.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/data/gutambuka_mbere.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/data/bibuza.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/data/bitegeka.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/data/ndanga.dart';

class IgazetiIbyapa extends StatefulWidget {
  const IgazetiIbyapa({super.key});

  @override
  State<IgazetiIbyapa> createState() => _IgazetiIbyapaState();
}

class _IgazetiIbyapaState extends State<IgazetiIbyapa> {
  @override
  Widget build(BuildContext context) {
    List<String> list = [
      'Ibyapa biburira',
      'Ibyapa byo gutambuka mbere',
      'Ibyapa byo bibuza',
      'Ibyapa byo bitegeka',
      'Ibyapa ndanga cga biyobora',
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      //   Body with a floating top bar
      body: CustomScrollView(
        slivers: [
          const QBAppBar(),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Container(
                  padding:
                      EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                  child: Column(
                    children: [
                      const Center(
                        child: QBTitle(title: 'Ibyapa byo kumihanda'),
                      ),
                      Text(
                          'Ibyapa byo ku mihanda bigizwe n\'amoko 5 akurikira:',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontSize: MediaQuery.of(context).size.width * 0.04,
                          )),

                      //   ordered list of text
                      Container(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.02),
                        child: Column(
                          children: [
                            for (var i = 0; i < list.length; i++)
                              Row(
                                children: [
                                  Text(
                                    '\t\t\t\t\t\t\t${i + 1}. ${list[i]}',
                                    style: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      fontSize:
                                          MediaQuery.of(context).size.width *
                                              0.04,
                                    ),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),

                      // sub title: 1. IBYAPA BIBURIRA
                      const QBSubTitle(
                        no: '1',
                        title: 'Ibyapa biburira',
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ibyapaBiburira.length,
                        itemBuilder: (context, index) {
                          return IkimenyetsoRow(
                            txt: ibyapaBiburira[index]['txt'],
                            imgUrl: ibyapaBiburira[index]['imgUrl'],
                          );
                        },
                      ),

                      // sub title: 2. IBYAPA BYO GUTAMBUKA MBERE
                      const QBSubTitle(
                        no: '2',
                        title: 'Ibyapa byo gutambuka mbere',
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: gutambukaMbere.length,
                        itemBuilder: (context, index) {
                          return IkimenyetsoRow(
                            txt: gutambukaMbere[index]['txt'],
                            imgUrl: gutambukaMbere[index]['imgUrl'],
                          );
                        },
                      ),

                      // sub title: 3. IBYAPA BIBUZA
                      const QBSubTitle(
                        no: '3',
                        title: 'Ibyapa bibuza',
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ibyapaBibuza.length,
                        itemBuilder: (context, index) {
                          return IkimenyetsoRow(
                            txt: ibyapaBibuza[index]['txt'],
                            imgUrl: ibyapaBibuza[index]['imgUrl'],
                          );
                        },
                      ),

                      // sub title: 4. IBYAPA BITEGEKA
                      const QBSubTitle(
                        no: '4',
                        title: 'Ibyapa bitegeka',
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ibyapaBitegeka.length,
                        itemBuilder: (context, index) {
                          return IkimenyetsoRow(
                            txt: ibyapaBitegeka[index]['txt'],
                            imgUrl: ibyapaBitegeka[index]['imgUrl'],
                          );
                        },
                      ),

                      // sub title: 5. IBYAPA NDANGA CG BIYOBORA
                      const QBSubTitle(
                        no: '5',
                        title: 'Ibyapa ndanga (biyobora)',
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: ibyapaNdanga.length,
                        itemBuilder: (context, index) {
                          return IkimenyetsoRow(
                            txt: ibyapaNdanga[index]['txt'],
                            imgUrl: ibyapaNdanga[index]['imgUrl'],
                          );
                        },
                      ),

                      // FOOTER
                      const QBAppFooter(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
