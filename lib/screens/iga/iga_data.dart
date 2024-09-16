// DATA FOR THE LIST VIEW
import 'package:tegura/screens/iga/amasuzuma/amasuzuma.dart';
import 'package:tegura/screens/iga/hagati/hagati.dart';
import 'package:tegura/screens/iga/igazetinibimenyetso/igazeti_n_ibimenyetso.dart';
import 'package:tegura/screens/iga/wasoje/wasoje.dart';
import 'package:tegura/screens/iga/bibaza/bibaza.dart';
import 'package:tegura/screens/iga/baza/baza.dart';

final List<Map<String, dynamic>> igaList = [
  {
    'icon': 'assets/images/video_icon.svg',
    'text': 'Amasomo ugezemo hagati',
    'route': 'hagati',
    'screen': const Hagati(),
  },
  {
    'icon': 'assets/images/course_list.svg',
    'text': 'Amasomo wasoje kwiga',
    'route': 'wasoje',
    'screen': const Wasoje(),
  },
  {
    'icon': 'assets/images/amasuzumabumenyi.svg',
    'text': 'Amasuzumabumenyi yose',
    'route': 'amasuzumabumenyi',
    'screen': const Amasuzumabumenyi(),
  },
    {
    'icon': 'assets/images/igazeti.svg',
    'text': 'Igazeti n\'ibimenyetso',
    'route': 'igazeti',
    'screen': const Igazeti(),
  },
  {
    'icon': 'assets/images/ibibazo_bibaza.svg',
    'text': 'Ibibazo abanyeshuri bibaza',
    'route': 'bibaza',
    'screen': const Bibaza()
  },
  {
    'icon': 'assets/images/baza_mwarimu.svg',
    'text': 'Baza mwarimu',
    'route': 'baza',
    'screen': const Baza()
  },
];
