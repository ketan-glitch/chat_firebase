import 'package:flutter/material.dart';

import 'date_formatters_and_converters.dart';

extension CapExtension on String? {
  String get inCaps => isValid ? (this!.isNotEmpty ? '${this![0].toUpperCase()}${this!.substring(1)}' : '') : '';
  String get capitalizeFirstOfEach => isValid ? (this!.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ")) : '';
  bool get isValid => this != null && this!.isNotEmpty;
  bool get isNotValid => this == null || this!.isEmpty;
  bool get isEmail => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this!);
  bool get isNotEmail => !(RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(this!));
  String get initials {
    if (isValid) {
      var list = this!.trim().split(' ');
      if (list.length > 1) {
        // log('${list}', name: 'LLLLLLLLLLLLLLLLL');
        return (list.first.isValid ? list.first[0] : '') + (list[1].isValid ? list[1][0] : '');
      } else {
        return this![0];
      }
      // return (this!.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" "));
    } else {
      return '';
    }
  }

  String get getIfValid => isValid ? this! : '';
  String get removeAllWhitespace => isValid ? this!.replaceAll(' ', '') : this!;
  String get obscureText => isValid ? this!.replaceRange(1, 6, '******') : '';
  String get getFirst => isValid ? this!.split(' ').first : '';

  String get extension {
    String extension = isValid ? this!.split('/').last.split('.').last : '';
    if (extension.length > 5) {
      extension = 'jpg';
    }
    return extension;
  }

  String get fileName {
    String extension = isValid ? this!.split('/').last : '';
    return extension;
  }
}

extension DateTimeExtensionNullable on DateTime? {
  bool get isNull {
    if (this == null) {
      return true;
    }
    return false;
  }

  bool get isNotNull {
    if (this != null) {
      return true;
    }
    return false;
  }
}

extension DateTimeExtension on DateTime {
  bool get isToday {
    return DateFormatters().dMy.format(this) == DateFormatters().dMy.format(getDateTime());
  }

  bool get isYesterday {
    return DateFormatters().dMy.format(this) == DateFormatters().dMy.format(getDateTime().subtract(const Duration(days: 1)));
  }

  int get getAge {
    return getDateTime().difference(this).inDays ~/ 365;
  }

  bool compareDate(date) {
    return DateFormatters().dMy.format(this) == DateFormatters().dMy.format(date);
  }

  String get getTimeIfToday {
    if (isNotNull) {
      if (isToday) {
        return 'Today';
      } else if (isYesterday) {
        return 'Yesterday';
      } else {
        return DateFormatters().dMy.format(this);
      }
    } else {
      return '';
    }
  }

  String get getTimeIfTodayV2 {
    if (isNotNull) {
      if (isToday) {
        return hMA;
      } else if (isYesterday) {
        return 'Yesterday';
      } else {
        return DateFormatters().dMy.format(this);
      }
    } else {
      return '';
    }
  }

  String get yMD => DateFormatters().yMD.format(this);
  String get mD => DateFormatters().mD.format(this);
  String get dM => DateFormatters().dM.format(this);
  String get hMA => DateFormatters().hMA.format(this);
  String get hMs => DateFormatters().hMs.format(this);
  String get dMy => DateFormatters().dMy.format(this);
  // ignore: non_constant_identifier_names
  String get My => DateFormatters().My.format(this);
  String get dM2 => DateFormatters().dM2.format(this);
  String get dMyDash => DateFormatters().dMyDash.format(this);
  String get dMonthYear => DateFormatters().dMonthYear.format(this);
  String get dateTime => DateFormatters().dateTime.format(this);
  String get dddMMTime => DateFormatters().ddMMTime.format(this);
  String get dayDMY => DateFormatters().dayDMY.format(this);
  String get dayDateTime => DateFormatters().dayDateTime.format(this);
  String get day => DateFormatters().day.format(this);
  String get dayDate => DateFormatters().dayDate.format(this);
  String get dateDay => DateFormatters().dateDay.format(this);
  String get month => DateFormatters().month.format(this);
  String get date => DateFormatters().date.format(this);
  String timeAgo({bool numericDates = true}) {
    final date2 = DateTime.now();
    final difference = date2.difference(this);

    if ((difference.inDays / 7).floor() >= 1) {
      return (numericDates) ? '1 week ago' : 'Last week';
    } else if (difference.inDays >= 2) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays >= 1) {
      return (numericDates) ? '1 day ago' : 'Yesterday';
    } else if (difference.inHours >= 2) {
      return '${difference.inHours} hours ago';
    } else if (difference.inHours >= 1) {
      return (numericDates) ? '1 hour ago' : 'An hour ago';
    } else if (difference.inMinutes >= 2) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inMinutes >= 1) {
      return (numericDates) ? '1 minute ago' : 'A minute ago';
    } else if (difference.inSeconds >= 3) {
      return '${difference.inSeconds} seconds ago';
    } else {
      return 'Just now';
    }
  }

  DateTime get dateOnly => DateTime(year, this.month, this.day);
}

extension Sum on List {
  int get getSum {
    var sum = 0.0;
    for (var element in this) {
      sum += int.parse("$element");
    }
    return sum.toInt();
  }
}

extension Context on BuildContext {
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
  Color get primaryColor => Theme.of(this).primaryColor;
  Color get secondaryColor => Theme.of(this).colorScheme.secondary;
  double get bottom => MediaQuery.of(this).viewInsets.bottom;
}

extension ColorBrightness on Color {
  Color darken([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));

    return hslDark.toColor();
  }

  Color lighten([double amount = .1]) {
    assert(amount >= 0 && amount <= 1);

    final hsl = HSLColor.fromColor(this);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));

    return hslLight.toColor();
  }
}
