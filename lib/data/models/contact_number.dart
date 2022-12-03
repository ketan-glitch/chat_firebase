class ContactNumber {
  String? number, countryCode;
  ContactNumber({this.number, this.countryCode});

  @override
  String toString() {
    return '$countryCode$number';
  }
}
