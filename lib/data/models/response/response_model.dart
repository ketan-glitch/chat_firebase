class ResponseModel {
  final bool _isSuccess;
  final String _message;
  final dynamic _data;
  ResponseModel(this._isSuccess, this._message,[this._data]);

  String get message => _message;
  bool get isSuccess => _isSuccess;
  dynamic get data => _data;


  Map<String, dynamic> toJson() => {
    "isSuccess": _isSuccess,
    "message": _message,
    "data": _data,
  };

}