import 'package:flutter/material.dart';
import 'package:itsindire/utilities/app_bar.dart';
import 'package:pdfrx/pdfrx.dart';

const String pdfUrl =
    'https://firebasestorage.googleapis.com/v0/b/tegura-rw.appspot.com/o/docs%2FIGAZETI-%5BShared%20by%20QuizBlog%5D.PDF?alt=media&token=dd96dc37-679a-48c8-8416-0312d615dc76';

class IgazetiBook extends StatefulWidget {
  const IgazetiBook({super.key});

  @override
  State<IgazetiBook> createState() => _IgazetiBookState();
}

class _IgazetiBookState extends State<IgazetiBook> {
  final controller = PdfViewerController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(58.0),
          child: AppBarItsindire(),
        ),
        body: PdfViewer.uri(Uri.parse(pdfUrl),
            controller: controller,
            params: PdfViewerParams(
              enableTextSelection: true,
              loadingBannerBuilder: _buildLoadingBanner,
              viewerOverlayBuilder: _buildViewerOverlay,
              pageOverlaysBuilder: _buildPageOverlays,
            )));
  }

  Widget _buildLoadingBanner(BuildContext context, int bytesDownloaded, int? totalBytes) {
    return Center(
      child: CircularProgressIndicator(
        value: totalBytes != null ? bytesDownloaded / totalBytes : null,
        backgroundColor: Colors.grey,
      ),
    );
  }

  List<Widget> _buildViewerOverlay(BuildContext context, Size size, void Function(Offset) handleLinkTap) {
    return [
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: () {
          controller.zoomUp(loop: true);
        },
        onTapUp: (details) {
          handleLinkTap(details.localPosition);
        },
        child: IgnorePointer(
          child: SizedBox(width: size.width, height: size.height),
        ),
      ),
    ];
  }

  List<Widget> _buildPageOverlays(BuildContext context, Rect pageRect, PdfPage page) {
    return [
      Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          page.pageNumber.toString(),
          style: const TextStyle(color: Colors.red),
        ),
      ),
    ];
  }
}
