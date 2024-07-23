import 'package:flutter/material.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/qb_app_bar.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/qb_app_footer.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/qb_title.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/umurongo_row.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/data/imirongo.dart';

class IgazetiImirongo extends StatefulWidget {
  const IgazetiImirongo({super.key});

  @override
  State<IgazetiImirongo> createState() => _IgazetiImirongoState();
}

class _IgazetiImirongoState extends State<IgazetiImirongo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD9D9D9),
      body: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(Color(0xFFFFBD59)),
        ),
        child: Scrollbar(
          child: CustomScrollView(
            slivers: [
              const QBAppBar(),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Container(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: Column(
                        children: [
                          const Center(
                            child:
                                QBTitle(title: 'IBIMENYETSO BIRI MU MUHANDA'),
                          ),
                          Text(
                              '👉 Ibimenyetso birombereje bigizwe n\'imirongo iteganye n\'umurongo ugabanya umuhanda mo kabiri. Ibyo bimenyetso bishobora kuba bigizwe na:',
                              style: TextStyle(
                                color: const Color.fromARGB(255, 0, 0, 0),
                                fontSize:
                                    MediaQuery.of(context).size.width * 0.04,
                              )),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: imirongo.length,
                            itemBuilder: (context, index) {
                              return UmurongoRow(
                                title: imirongo[index]['title'],
                                txt: imirongo[index]['txt'],
                                topTxt: imirongo[index]['top_txt'],
                                imgUrl: imirongo[index]['imgUrl'],
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
        ),
      ),
    );
  }
}
