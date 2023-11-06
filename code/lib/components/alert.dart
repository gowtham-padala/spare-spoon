import 'package:flutter/material.dart';
import 'package:quickalert/quickalert.dart';

/// A utility class for displaying custom modal dialogs using QuickAlert library.
/// This class provides methods to show error, warning, and success modals.
class Alert {
  /// Displays an error modal dialog with the given error message.
  void errorAlert(BuildContext context, String errMsg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      title: "Error",
      text: errMsg,
      confirmBtnColor: Colors.deepPurple[300]!,
    );
  }

  /// Displays a warning modal dialog with the given warning message.
  void warningAlert(BuildContext context, String warningMsg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.info,
      title: "Warning",
      text: warningMsg,
      confirmBtnColor: Colors.deepPurple[300]!,
    );
  }

  /// Displays a success modal dialog with the given success message.
  void successAlert(BuildContext context, String successMsg) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      title: "Success",
      text: successMsg,
      confirmBtnColor: Colors.deepPurple[300]!,
    );
  }
}
