class FlowMeterData {
  final DateTime time;
  final double flowRate;
  final double totalVolume;
  final double avgFlowRate;

  FlowMeterData({
    required this.time,
    required this.flowRate,
    required this.totalVolume,
    required this.avgFlowRate,
  });

  static double _toDouble(dynamic value) {
    if (value == null) return 0.0;
    if (value is num) return value.toDouble();
    return double.tryParse(value.toString()) ?? 0.0;
  }

  factory FlowMeterData.fromJson(Map<String, dynamic> r) {
    final rawTime = r['time'] ?? r['timestamp'] ?? r['Timestamp'];

    DateTime parsedTime;
    if (rawTime == null || rawTime.toString().trim().isEmpty) {
      parsedTime = DateTime.now();
    } else {
      parsedTime = DateTime.tryParse(rawTime.toString()) ?? DateTime.now();
    }

    return FlowMeterData(
      time: parsedTime,
      flowRate: _toDouble(r['flowRate'] ?? r['flowrate'] ?? r['FlowRate']),
      totalVolume: _toDouble(r['totalVolume'] ?? r['total_volume'] ?? r['TotalVol']),
      avgFlowRate: _toDouble(r['avgFlowRate'] ?? r['avg_flowrate'] ?? r['AvgFlowRate']),
    );
  }
}