import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
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
  final StyleMainButtonSigner styleMainButton = const StyleMainButtonSigner(
  textStyle: TextStyle(
  color: Color(0xff141D1E),
  fontSize: 16,
  fontWeight: FontWeight.w600,
  ),
  disableTextStyle: TextStyle(
  color: Color(0xff3F4849),
  fontSize: 16,
  fontWeight: FontWeight.w600,
  ),
  color: Color(0xff25DFEB),
  disableColor: Color(0xff293233),
  cornerRadius: 16
  );
  Color appBarColor = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff0C0C0C),
        title: const Text("Page Signer", style: TextStyle(color: Color(0xffDAE4E5)),),
        ),
      body: PageSigner(
          document: widget.doc,
          callback: widget.callback,
          appBarBackgroundColor: appBarColor,
        styleMainButton: styleMainButton,
        styleSecondaryButton: StyleSecondaryButtonSigner(
            borderColor: const Color(0xff25DFEB),
            backgroundColor: appBarColor,
            textStyle: const TextStyle(
              color: Color(0xff25DFEB),
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
            cornerRadius: 16
        ),
        showDialog: () {
            showSignatureToSmall();
        },
        showToast: () {
          toast();
        },
      ),
    );
  }

  void toast() {

    Widget myToast = ClipRRect(
        child: Container(
          color: Colors.purple.withOpacity(0.3),
          child: Text(PageSignerTextUtils.getToastMessage(widget.doc.tenantLanguage), style: const TextStyle(color: Color(0xffDAE4E5)),),
        ),
      );

    showToastWidget(myToast, duration: const Duration(seconds: 5), position: StyledToastPosition.top, context: context, startOffset: const Offset(0, 600));
  }

  Widget _customDialog() {
    const styleDialog = StyleDialog(
        backgroundColor: Color(0xff141D1E),
        bodyTextStyle:  TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Color(0xffA3ADAE)
        ),
        iconColor: Color(0xffBEC8C9),
        titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xffBEC8C9)
        )
    );
    String titleText = PageSignerTextUtils.getDialogTitle(widget.doc.tenantLanguage);
    String text = PageSignerTextUtils.getDialogMessage(widget.doc.tenantLanguage);
    String buttonText = PageSignerTextUtils.getDialogButtonText(widget.doc.tenantLanguage);

    return Dialog(
      child: Container(
        padding: const EdgeInsets.all(24),
        color: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Center(
              child: Text(titleText, style: styleDialog.titleTextStyle,),
            ),
            const SizedBox(height: 15,),
            Text(text, style: styleDialog.bodyTextStyle,),
            const SizedBox(height: 15,),
            Center(
              child: SizedBox(
                height: 60,
                child: _getElevatedButton(
                    text: buttonText,
                    textStyle: styleMainButton.textStyle,
                    icon: Icons.check,
                    radius: styleMainButton.cornerRadius,
                    backgroundColor:styleMainButton.color,
                    borderColor: styleMainButton.color,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> showSignatureToSmall() {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return _customDialog();
      },
    );
  }

  _getElevatedButton({
    required String text,
    required TextStyle textStyle,
    required IconData icon,
    required double radius,
    required Color backgroundColor,
    required Color? borderColor,
    required void Function() onPressed
  })
  {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(radius),
        ),
        side: BorderSide(color: borderColor ?? backgroundColor),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        backgroundColor: backgroundColor,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,// Ensure the row takes only the required space
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.left, // Left-aligned text
              style: textStyle,
            ),
          ),
          const SizedBox(width: 8.0), // Space between text and icon
          Icon(icon, color: textStyle.color,), // Right-aligned icon
        ],
      ),
    );
  }

}

class StyleDialog {
  final Color backgroundColor;
  final TextStyle titleTextStyle;
  final TextStyle bodyTextStyle;
  final Color iconColor;

  const StyleDialog({
    required this.backgroundColor,
    required this.bodyTextStyle,
    required this.iconColor,
    required this.titleTextStyle
  });
}