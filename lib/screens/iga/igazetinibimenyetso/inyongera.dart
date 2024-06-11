import 'package:flutter/material.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/inyongera_row.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_app_bar.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_app_footer.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_subtitle.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/utils/qb_title.dart';

class IgazetiInyongera extends StatefulWidget {
  const IgazetiInyongera({super.key});

  @override
  State<IgazetiInyongera> createState() => _IgazetiInyongeraState();
}

class _IgazetiInyongeraState extends State<IgazetiInyongera> {
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
                      padding:
                          EdgeInsets.all(MediaQuery.of(context).size.width * 0.02),
                      child: Column(
                        children: [
                          const Center(
                            child:
                                QBTitle(title: 'IBYAPA NYONGERA N\'IBINTU NGOBOKA'),
                          ),
          
                          const QBSubTitle(
                            no: '',
                            title: 'A) IBYAPA NYONGERA ',
                          ),
          
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: nyongera.length,
                            itemBuilder: (context, index) {
                              return InyongeraRow(
                                txt: nyongera[index]['txt'],
                                imgUrl: nyongera[index]['imgUrl'],
                              );
                            },
                          ),
                          const QBSubTitle(
                            no: '',
                            title: 'B) IBINTU NGOBOKA',
                          ),
          
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: ngoboka.length,
                            itemBuilder: (context, index) {
                              return InyongeraRow(
                                txt: ngoboka[index]['txt'],
                                imgUrl: ngoboka[index]['imgUrl'],
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

// nyongera list
List<Map<String, dynamic>> nyongera = [
  {
    'txt':
        'Aka kapa karererekana intera iri hagati y’icyapa n’intangiriro y’ahantu hatera ibyago cyangwa ahantu amabwiriza y’icyo cyapa agomba gukurikizwa.',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fnyongera%2FNyongera%20200m.png?alt=media&token=39ab92ee-3f61-484e-b9d5-504c0af2fc9b',
  },
  {
    'txt':
        '📝 Aka kapa karererekana “uburebure bw’igice cyatera ibyago cyangwa cyangwa bw’ahantu amabwiriza y’icyo cyapa agomba gukurikiza.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fnyongera%2FNyongera%20habujijwe%20%20guhagarara%201.png?alt=media&token=e14f6400-cd5a-4e59-b417-67b503152510',
  },
  {
    'txt':
        'Aka kapa karererekana umwanya w’ahantu habujijwe guhagarara umwanya munini cyangwa umwanya muto ku binyabiziga bibujijwe cyangwa bigenwe.',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fnyongera%2FNyongera%20habujijwe%20%20guhagarara%201.png?alt=media&token=e14f6400-cd5a-4e59-b417-67b503152510',
  },
  {
    'txt':
        ' “Akapa 1” kareba igice cy’umuhanda kiri hirya y’ikimenyetso,  “akapa 2” kareba ibice by’umuhanda biri hirya no hino y’icyo kimenyetso, “naho 3” kareba igice cy’umuhanda kiri hino y’icyo kimenyetso.',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fnyongera%2FNyongera%20Hirya%20no%20Hino%201.png?alt=media&token=0cf70561-9429-445e-90ae-67e1eec0bafa',
  },
];

// ngoboka list
List<Map<String, dynamic>> ngoboka = [
  {
    'txt': ' “Aho bagobokera ibinyabiziga.” (Igaraje).',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FAho%20bogobokera%20ibinyabiziga.png?alt=media&token=fa19cec4-ed97-4c19-9166-e5982178d90f',
  },
  {
    'txt': ' “Ahari Lisansi na mazutu.” (Sitasiyo).',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FAhari%20Lisansi%20na%20mazutu.png?alt=media&token=9057d7b3-a197-467a-9385-9afc96dac99e',
  },
  {
    'txt': ' “Ahari telefoni.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FAhari%20telefoni..png?alt=media&token=06ef6b20-cd4c-4b2f-8e51-00ae6c0ac7fb',
  },
  {
    'txt': ' “Hoteli cyangwa ahari icumbi.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FHoteli%20cyangwa%20ahari%20icumbi%201.png?alt=media&token=046476af-d975-4190-ab99-a21d39eb3697',
  },
  {
    'txt': ' “Aho bafatira ifunguro.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FAho%20bafatira%20ifunguro%201.png?alt=media&token=51ec3aa6-1075-4724-a4d4-6ceb3b8a2803',
  },
  {
    'txt': ' “Urunywero cyangwa urusamuriro.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FUrunywero%20cyangwa%20urusamuriro.png?alt=media&token=536bb8a7-6a21-47b0-b559-e0e54b368c2a',
  },
  {
    'txt': ' “Ahateganirijwe ururiro rw’abahisi.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FAhateganirijwe%20ururiro%20rw%E2%80%99abahisi.png?alt=media&token=8b9dc72a-f13e-4c32-88f0-e4129842e92d',
  },
  {
    'txt': ' “Aho bahagurukira batembera ku maguru.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FAho%20bahagurukira%20batembera%20ku%20maguru..png?alt=media&token=01f59998-1cf4-4ced-8c6e-36790343bd4a',
  },
  {
    'txt': ' “Ikibanza cy’ingando.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FIkibanza%20cy%E2%80%99ingando%202.png?alt=media&token=30ce568f-6e59-4ad8-9324-886928d418a4',
  },
  {
    'txt': ' “Ikibanza cy’abantu bagendera ku nyamaswa.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FIkibanza%20cy%E2%80%99ingando%20cyangwa%20cy%E2%80%99abantu%20benshi%20bagendera%20ku%20nyamaswa.png?alt=media&token=8e5b3b67-ff4a-43b9-9e47-1583799729f6',
  },
  {
    'txt':
        ' “📝 Ikibanza cy’ingando cyangwa cy’abantu benshi bagendera ku nyamaswa.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FIkibanza%20cy%E2%80%99abantu%20bagendera%20ku%20nyamaswa.png?alt=media&token=81111467-b8d6-4a87-9a41-d1f0d77efd5b',
  },
  {
    'txt': ' “Icumbi ry’urubyiruko.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FIcumbi%20ry%E2%80%99urubyiruko.png?alt=media&token=a63b5277-4b38-44e5-b994-e9464bf41c32',
  },
  {
    'txt': ' 📝 “Ahari ubutabazi.” ',
    'imgUrl':
        'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/nyongera_ngoboka%2Fngoboka%2FAhari%20ubutabazi..png?alt=media&token=8152e702-36cc-4bdc-818c-07ee6b5e88e6',
  },
];
