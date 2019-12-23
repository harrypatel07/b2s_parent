import 'dart:typed_data';

import 'package:b2s_parent/src/app/core/baseViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
import 'dart:ui' as ui;

import 'package:printing/printing.dart';

class StudentCardViewModel extends ViewModelBase {
  bool isCardVertical = false;
  final GlobalKey<State<StatefulWidget>> studentCardVerticalKey = GlobalKey();
  final GlobalKey<State<StatefulWidget>> studentCardHorizontalKey = GlobalKey();
  onSwitchCardVerticalAndHorizontal() {
    isCardVertical = !isCardVertical;
    this.updateState();
  }
  Future<void> printScreen() async {
    RenderRepaintBoundary boundary =
    (isCardVertical)? studentCardVerticalKey.currentContext.findRenderObject():studentCardHorizontalKey.currentContext.findRenderObject();
    final ui.Image im = await boundary.toImage(pixelRatio: 3.0);
    final ByteData bytes =
    await im.toByteData(format: ui.ImageByteFormat.rawRgba);
    print('Print Screen ${im.width}x${im.height} ...');

    Printing.layoutPdf(onLayout: (PdfPageFormat format) {
      final pdf.Document document = pdf.Document();

      final PdfImage image = PdfImage(document.document,
          image: bytes.buffer.asUint8List(),
          width: im.width,
          height: im.height);

      document.addPage(pdf.Page(
          pageFormat: format,
          build: (pdf.Context context) {
            return pdf.Center(
              child: pdf.Expanded(
                child: pdf.Image(image),
              ),
            ); // Center
          })); // Page

      return document.save();
    });
  }
}
