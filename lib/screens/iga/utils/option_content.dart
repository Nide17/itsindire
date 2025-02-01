import 'package:flutter/material.dart';
import 'package:itsindire/models/ingingo.dart';
import 'package:transparent_image/transparent_image.dart';

class OptionContent extends StatelessWidget {
  final Option? option;

  const OptionContent({super.key, this.option});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (option?.title != null && option?.title != '')
        SizedBox(height: MediaQuery.of(context).size.height * 0.023),
      _buildTextContent(context),
      if (option?.imageUrl != null && option?.imageUrl != '')
        _buildImageContent(context),
    ]);
  }

  Widget _buildTextContent(BuildContext context) {
    final parts = option?.text?.split('*') ?? [];
    final spans = <TextSpan>[];

    for (var i = 0; i < parts.length; i++) {
      final isBold = i % 2 == 1;
      spans.add(TextSpan(
          text: parts[i],
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.height * 0.023,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal)));
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).size.height * 0.015),
          child: Row(
            children: [
              if (option?.leftImageUrl != null && option?.leftImageUrl != '')
                _buildLeftImage(context),
              Flexible(
                flex: 4,
                child: Text.rich(
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.height * 0.023),
                    TextSpan(
                      children: [
                        if (option?.title != null && option?.title != '')
                          TextSpan(
                            text: '${option?.title}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        if (option?.text != null)
                          TextSpan(
                            children: spans,
                          ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLeftImage(BuildContext context) {
    return Flexible(
      flex: 1,
      fit: FlexFit.loose,
      child: GestureDetector(
        onTap: () {
          _showZoomDialog(context, option!.leftImageUrl!);
        },
        child: Container(
          margin: EdgeInsets.only(
              right: MediaQuery.of(context).size.width * 0.023),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.13,
            child: FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: kTransparentImage,
              image: option!.leftImageUrl!,
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width * 0.001,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageContent(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(0.0, 12.0, 0.0, 14.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.5),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: kTransparentImage,
              image: option!.imageUrl!,
              height: MediaQuery.of(context).size.height * 0.2,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  void _showZoomDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: InteractiveViewer(
            child: FadeInImage.memoryNetwork(
              fadeInDuration: const Duration(milliseconds: 200),
              placeholder: kTransparentImage,
              image: imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
