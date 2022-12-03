extension CapExtension on String? {
  String get inCaps => isValid ? (this!.isNotEmpty ? '${this![0].toUpperCase()}${this!.substring(1)}' : '') : '';
  String get capitalizeFirstOfEach => isValid ? (this!.replaceAll(RegExp(' +'), ' ').split(" ").map((str) => str.inCaps).join(" ")) : '';
  bool get isValid => this != null && this!.isNotEmpty;
  bool get isNotValid => this == null || this!.isEmpty;
  bool get isEmail =>
      RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this!);
  bool get isNotEmail =>
      !(RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
          .hasMatch(this!));
  String get initials {
    if (isValid) {
      var list = this!.trim().split(' ');
      if (list.length > 1) {
        return (list.first.isValid ? list.first[0] : '') + (list.last.isValid ? list.last[0] : '');
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
}

extension DateTimeExtension on DateTime? {
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

extension Sum on List {
  int get getSum {
    var sum = 0.0;
    for (var element in this) {
      sum += int.parse("$element");
    }
    return sum.toInt();
  }
}
