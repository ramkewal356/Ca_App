import 'package:ca_app/utils/constanst/colors.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Utils {
  static void toastErrorMessage(String message) {
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM_LEFT,
        backgroundColor: ColorConstants.redColor,
        textColor: ColorConstants.white,
        toastLength: Toast.LENGTH_SHORT, // or LENGTH_LONG
        webPosition: 'Left');
  }

  static void toastSuccessMessage(String message) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: ColorConstants.greenColor,
      textColor: ColorConstants.white,
    );
  }
}
