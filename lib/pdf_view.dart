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
      textStyle: const TextStyle(
          color: Color(0xff141D1E),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      disableTextStyle: const TextStyle(color: Color(0xff141D1E)),
      lottieLoading: Container(),
      text: 'Firmar',
      color: const Color(0xff25DFEB),
      disableColor: const Color(0xff25DFEB),
      cornerRadius: 16
  );

  final StyleSecondaryButton _styleSecondaryButton = StyleSecondaryButton(
      text: "Rechazar",
      borderColor: const Color(0xff25DFEB),
      backgroundColor: const Color(0xff0C0C0C),
      textStyle: const TextStyle(
        color: Color(0xff25DFEB),
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      cornerRadius: 16,
      onPressed: () {}
  );


  @override
  Widget build(BuildContext context) {
    const AppBarStyle appBarStyle = AppBarStyle(backgroundColor: Color(0xff0C0C0C), textColor: Color(0xffDAE4E5));
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarStyle.backgroundColor,
        title: const Text("PDF VIEW", style: TextStyle(color: Color(0xffDAE4E5)),),
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
          styleSecondaryButton: _styleSecondaryButton,
          appBarStyle: appBarStyle,
          marginWidget: Container(),
          signatures: widget.signatures,
      ),
    );
  }

}