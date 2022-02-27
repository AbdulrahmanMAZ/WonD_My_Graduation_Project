import 'package:coffre_app/modules/routingdata.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    Uri uriData = Uri.parse(this);
    return RoutingData(
        route: uriData.path, queruParameters: uriData.queryParameters);
  }
}
