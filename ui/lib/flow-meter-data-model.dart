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

  factory FlowMeterData.csvToFlowData(List<dynamic> r) {
    return FlowMeterData(
      time: DateTime.parse(r[0]),
      flowRate: double.parse(r[1].toString()),
      totalVolume: double.parse(r[2].toString()),
      avgFlowRate: double.parse(r[3].toString()),
    );
  }
}