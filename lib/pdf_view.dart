import 'package:example_firmado/sign_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pki_pdf_signer/page_widget/document_pki.dart';
import 'package:pki_pdf_signer/page_widget/page_signer.dart';
import 'package:pki_pdf_signer/pki_pdf_signer.dart';
import 'package:pki_pdf_signer/styles_main_button.dart';
import 'package:share_plus/share_plus.dart';

class PdfView extends StatefulWidget {
  final String path;
  final bool showButton;
  final String? signatures;
  final void Function(BuildContext,InfoSign) callback;

  const PdfView({super.key, required this.path, required this.showButton, required this.callback, this.signatures});

  @override
  State<PdfView> createState() => _PdfView();

}

class _PdfView extends State<PdfView> {

  Future<void> _myCallBack(DocumentPki doc) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (ctx) => SignView(doc: doc, callback: widget.callback)
        )
    );
  }

  void share() {
    Share.shareXFiles([XFile(widget.path)]);
  }

  final StyleMainButton _styleMainButton = StyleMainButton(
      textStyle: const TextStyle(color: Colors.black),
      disableTextStyle: const TextStyle(color: Colors.black54),
      lottieLoading: Container(),
      text: 'Firmar',
      color: Colors.blueAccent,
      disableColor: Colors.grey
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PDF VIEW"),
        actions: !widget.showButton ? [
          IconButton(onPressed: share, icon: const Icon(CupertinoIcons.share)),
        ] : null,
      ),
      body: PdfVisor.fromPath(
          path: widget.path,
          showButton: widget.showButton,
          tenantLanguage: "ES",
          callback: _myCallBack,
          styleMainButton: _styleMainButton,
          appBarBackgroundColor: Colors.black,
          marginWidget: Container(),
          signatures: widget.signatures,
      ),
    );
  }

}