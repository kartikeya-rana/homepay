import 'package:flutter/material.dart';
import 'package:homepay/utilities/dialogs/generic_dialog.dart';

Future<void> showInfoDialog(BuildContext context, String title, String text) {
  return showGenericDialog<void>(
    context: context,
    title: title,
    content: text,
    optionsBuilder: () => {
      "Dismiss": null,
    },
  );
}
