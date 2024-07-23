import 'package:flutter/material.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/ibimurika_row.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/qb_app_bar.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/qb_app_footer.dart';
import 'package:itsindire/screens/iga/igazetinibimenyetso/utils/qb_title.dart';
import 'package:transparent_image/transparent_image.dart';

class IgazetiIbimurika extends StatefulWidget {
  const IgazetiIbimurika({super.key});

  @override
  State<IgazetiIbimurika> createState() => _IgazetiIbimurikaState();
}

class _IgazetiIbimurikaState extends State<IgazetiIbimurika> {
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
                            child: QBTitle(title: 'IBIMENYETSO BIMURIKA'),
                          ),

                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image:
                                  'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/ibimurika%2FIbimenyetso%20bimurika.png?alt=media&token=324800c8-f077-47f3-95df-3d6deb3aff21',
                              fit: BoxFit.cover,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.symmetric(
                              vertical:
                                  MediaQuery.of(context).size.width * 0.04,
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.02,
                            ),
                            child: Text(
                                '📝 Amatara y\'ibimenyetso bimurika mu buryo bw\'amatara atatu asobanuye atya:',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: const Color.fromARGB(255, 0, 0, 0),
                                  fontSize:
                                      MediaQuery.of(context).size.width * 0.04,
                                )),
                          ),

                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ibimurika.length,
                            itemBuilder: (context, index) {
                              return IbimurikaRow(
                                title: ibimurika[index]['title'],
                                txt: ibimurika[index]['txt'],
                                imgUrl: ibimurika[index]['imgUrl'],
                                color: ibimurika[index]['color'],
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

// ibimurika list
List<Map<String, dynamic>> ibimurika = [
  {
    'title': 'Itara ritukura:',
    'txt': ' Riravuga ngo birabujijwe kurenga icyo kimenyetso.',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/ibimurika%2Fritukura.png?alt=media&token=ef65dd00-82eb-4c4a-928f-d08d8ea6a3ab',
    'color': 'red',
  },
  {
    'title': 'Itara ry\'umuhondo:',
    'txt':
        ' birabujijwe gutambuka umurongo wo guhagarara umwanya muto, cyangwa igihe uwo murongo werekana udahari icyo kimenyetso ubwacyo, keretse igihe ryatse umuyobozi akiri hafi cyane ku buryo yaba atagishobora guhagarara mu buryo butamuteza ibyago. Nyamara iyo ikimenyetso kiri mu masangangano umuyobozi arenze umurongo wo guhagarara cyangwa ikimenyetso muri ubwo buryo, ashobora kwambukiranya amasangano gusa ari uko atateza abandi ibyago.',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/ibimurika%2Fumuhondo.png?alt=media&token=ed4cb7cb-c9b0-466a-a769-7b62cc1866ac',
    'color': 'yellow',
  },
  {
    'title': 'Itara ry\'icyatsi:',
    'txt': ' Rivuga uburenganzira bwo kurenga icyo kimenyetso.',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/ibimurika%2Ficyatsi.png?alt=media&token=972888c1-6272-46e0-8890-106a3789496c',
    'color': 'green',
  },
];
