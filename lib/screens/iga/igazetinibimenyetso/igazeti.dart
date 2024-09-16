import 'package:flutter/material.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:itsindire/utilities/loading_widget.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:pdf_render/pdf_render_widgets.dart';
// https://pub.dev/packages/pdf_render/example

class IgazetiBook extends StatefulWidget {
  const IgazetiBook({super.key});

  @override
  State<IgazetiBook> createState() => _IgazetiBookState();
}

class _IgazetiBookState extends State<IgazetiBook> {
  final controller = PdfViewerController();
  TapDownDetails? _doubleTapDetails;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<String> _loadPdf() async {
    try {
      // Load PDF file from network
      print('Loading PDF...');
      final file = await DefaultCacheManager().getSingleFile(
          'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/docs%2FIGAZETI-%5BShared%20by%20QuizBlog%5D.PDF?alt=media&token=dd96dc37-679a-48c8-8416-0312d615dc76');
      return file.path;
    } catch (e) {
      print('Error loading PDF: $e');
      return ''; // Return an empty string if there is an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(58.0),
        child: AppBarItsindire(),
      ),
      body:  GestureDetector(
        // Supporting double-tap gesture on the viewer.
        onDoubleTapDown: (details) => _doubleTapDetails = details,
        onDoubleTap: () => controller.ready?.setZoomRatio(
          zoomRatio: controller.zoomRatio * 1.5,
          center: _doubleTapDetails!.localPosition,
        ),
        child: FutureBuilder<String>(
          future: _loadPdf(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the Future to complete
              print('Loading PDFss...');
              return const LoadingWidget();
            } else if (snapshot.hasError || snapshot.data!.isEmpty) {
              // If there was an error or the path is empty
              print('Failed to load PDF');
              return Center(child: Text('Failed to load PDF'));
            } else {
              print('PDF loaded');
              // When the Future completes successfully
              return PdfViewer.openFile(
                snapshot.data!,
                viewerController: controller,
                onError: (err) => print(err),
                params: const PdfViewerParams(
                  padding: 10,
                  minScale: 1.0,
                  // scrollDirection: Axis.horizontal,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
