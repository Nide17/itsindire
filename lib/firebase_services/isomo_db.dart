import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:itsindire/models/isomo.dart';

class IsomoService {
  final CollectionReference amasomoCollection =
      FirebaseFirestore.instance.collection('amasomo');

  IsomoService();

  // GET AMASOMO FROM A SNAPSHOT USING THE ISOMO MODEL - _amasomoFromSnapshot
  // FUNCTION CALLED EVERY TIME THE AMASOMO DATA CHANGES
  List<IsomoModel> _amasomoFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final id = data.containsKey('id') ? data['id'] : '';
      final title = data.containsKey('title') ? data['title'] : '';
      final description =
          data.containsKey('description') ? data['description'] : '';
      final introText = data.containsKey('introText') ? data['introText'] : '';
      final conclusion =
          data.containsKey('conclusion') ? data['conclusion'] : '';
      final duration = data.containsKey('duration') ? data['duration'] : 0;

      return IsomoModel(
        id: id is int
            ? id
            : id is String
                ? int.parse(id)
                : 0,
        title: title,
        description: description,
        introText: introText,
        conclusion: conclusion,
        duration: duration,
      );
    }).toList();
  }

  Stream<List<IsomoModel?>>? getAllAmasomo(String? uid) {
    if (uid == null) return null;
    return amasomoCollection.snapshots().map(_amasomoFromSnapshot);
  }

  // GET AMASOMO BY ID
  Future<IsomoModel?> getIsomoById(int id) async {
    final amasomoDocument = await amasomoCollection.doc(id.toString()).get();

    if (amasomoDocument.exists) {
      final data = amasomoDocument.data() as Map<String, dynamic>;

      final title = data.containsKey('title') ? data['title'] : '';
      final description =
          data.containsKey('description') ? data['description'] : '';
      final introText = data.containsKey('introText') ? data['introText'] : '';
      final conclusion =
          data.containsKey('conclusion') ? data['conclusion'] : '';
      final duration = data.containsKey('duration') ? data['duration'] : 0;

      return IsomoModel(
        id: id,
        title: title,
        description: description,
        introText: introText,
        conclusion: conclusion,
        duration: duration,
      );
    } else {
      print('\nIsomo document does not exist\n');
      return null;
    }
  }

  Future<List<String>> getAmasomoTitlesByIds(List<String> ids) async {
    List<String> amasomoTitles = [];
    for (var id in ids) {
      final amasomoDocument = await amasomoCollection.doc(id).get();

      if (amasomoDocument.exists) {
        final data = amasomoDocument.data() as Map<String, dynamic>;
        final title = data.containsKey('title') ? data['title'] : '';
        amasomoTitles.add(title);
      } else {
        print('\nAmasomo document does not exist\n');
      }
    }
    return amasomoTitles;
  }
}
