import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer2/advance_pdf_viewer.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/loading_widget.dart';

class IgazetiBook extends StatefulWidget {
  const IgazetiBook({super.key});

  @override
  State<IgazetiBook> createState() => _IgazetiBookState();
}

class _IgazetiBookState extends State<IgazetiBook> {
  bool _isLoading = true;
  late PDFDocument document = PDFDocument();

  @override
  void initState() {
    super.initState();
    _loadPdfDoc();
  }

  _loadPdfDoc() async {
    try {
      document = await PDFDocument.fromURL(
          "https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/docs%2FIGAZETI-%5BShared%20by%20QuizBlog%5D.PDF?alt=media&token=dd96dc37-679a-48c8-8416-0312d615dc76");
    } catch (e) {
      print("\n$e");

      // show error snackbar and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to load document'),
          duration: const Duration(seconds: 3),
        ),
      );
      Navigator.pop(context);
    }
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    print(_isLoading);

    if (_isLoading) {
      return const LoadingWidget();
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: AppBarItsindire(),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: _isLoading
            ? const LoadingWidget()
            : PDFViewer(
                document: document,
                zoomSteps: 8,
              ),
      ),
    );
  }
}
