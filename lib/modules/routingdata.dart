class RoutingData {
  final String? route;
  final Map<String, String>? _queruParameters;
  RoutingData({this.route, Map<String, String>? queruParameters})
      : _queruParameters = queruParameters;
  operator [](String key) => _queruParameters![key];
}
