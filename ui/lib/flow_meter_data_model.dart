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

  factory FlowMeterData.fromJson(Map<String,dynamic> r) {
    return FlowMeterData(
      time: DateTime.parse(r['time']),
      flowRate: double.parse(r['flowRate'].toString()),
      totalVolume: double.parse(r['totalVolume'].toString()),
      avgFlowRate: double.parse(r['avgFlowRate'].toString()),
    );
  }
}