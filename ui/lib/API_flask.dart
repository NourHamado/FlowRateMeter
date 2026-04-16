import 'dart:convert';
import 'package:http/http.dart' as http;
import 'flow_meter_data_model.dart';

class FlowApi {
  final String ipAddress;

  FlowApi({String? ipAddress})
    : ipAddress =
          ipAddress ??
          const String.fromEnvironment(
            'FLASK_SERVER_IP',
            defaultValue: '10.100.210.169',
          );

  Future<List<FlowMeterData>> fetchHistory() async {
    final response = await http.get(
      Uri.parse('http://$ipAddress:5000/history'),
    );

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return (jsonData as List).map((e) => FlowMeterData.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<FlowMeterData?> fetchLive() async {
    final response = await http.get(Uri.parse('http://$ipAddress:5000/live'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      if (jsonData is Map<String, dynamic>) {
        return FlowMeterData.fromJson(jsonData);
      }
      return null;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
