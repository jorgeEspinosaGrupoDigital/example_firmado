import 'package:flutter/material.dart';
import 'package:pki_pdf_signer/page_widget/document_pki.dart';
import 'package:pki_pdf_signer/page_widget/page_signer.dart';

class SignView extends StatefulWidget {

  final DocumentPki doc;
  final void Function(BuildContext, InfoSign) callback;

  const SignView({super.key, required this.doc, required this.callback});

  @override
  State<SignView> createState() => _SignView();

}

class _SignView extends State<SignView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page Signer"),),
      body: PageSigner(
          document: widget.doc,
          callback: widget.callback,
          style: const StyleIconButtons(
              background: Colors.blueAccent,
              backgroundDisable: Colors.grey,
              color: Colors.black,
              colorDisable: Colors.black54
          )
      ),
    );
  }

}