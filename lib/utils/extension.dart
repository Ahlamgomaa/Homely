import 'package:homely/generated/l10n.dart';
import 'package:homely/utils/const_res.dart';
import 'package:intl/intl.dart';

extension A on int {
  String get numberFormat {
    return NumberFormat.compact().format(this);
  }

  String get getUserType {
    return this == 0
        ? S.current.buyer
        : this == 1
            ? S.current.seller
            : this == 2
                ? S.current.broker
                : S.current.agency;
  }
}

extension O on String {
  String get image {
    return '${ConstRes.itemBase}$this';
  }

  String getUserType(int userType) {
    return userType == 0
        ? S.current.buyer
        : userType == 1
            ? S.current.seller
            : userType == 2
                ? S.current.broker
                : S.current.agency;
  }
}
