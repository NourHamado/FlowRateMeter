import 'package:flutter/material.dart';
import 'summary_page.dart';
import 'api_flask.dart';
import 'flow_meter_data_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'settings_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  String timeFilter = 'Weekly';
  List<FlowMeterData> retrievedData = [];
  List<FlowMeterData> flowDataList = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      final api = FlowApi();
      flowDataList = await api.fetchHistory();
    } catch (e) {
      debugPrint('Error fetching data: $e');
    }
    setState(() {
      retrievedData = flowDataList.isNotEmpty ? flowDataList : [];
    });
  }

  // Get data based on time filter
  List<FlSpot> getGraphData(String metric) {
    if (retrievedData.isEmpty) return [];

    switch (timeFilter) {
      case 'Weekly':
        return getWeeklyData(metric);
      case 'Monthly':
        return getMonthlyData(metric);
      case 'Yearly':
        return getYearlyData(metric);
      default:
        return [];
    }
  }

  List<FlSpot> getWeeklyData(String metric) {
    Map<int, List<double>> weeklyData = {
      1: [], // Monday
      2: [], // Tuesday
      3: [], // Wednesday
      4: [], // Thursday
      5: [], // Friday
      6: [], // Saturday
      7: [], // Sunday
    };

    for (var data in retrievedData) {
      int day = data.time.weekday;

      switch (metric) {
        case 'totalVolume':
          weeklyData[day]?.add(data.totalVolume);
          break;
        case 'flowRate':
          weeklyData[day]?.add(data.flowRate);
          break;
        case 'avgFlowRate':
          weeklyData[day]?.add(data.avgFlowRate);
          break;
      }
    }

    // Calculate average for each day
    List<FlSpot> dataPoints = [];
    for (int i = 1; i <= 7; i++) {
      if (weeklyData[i]!.isNotEmpty) {
        double avg =
            weeklyData[i]!.reduce((a, b) => a + b) / weeklyData[i]!.length;
        dataPoints.add(FlSpot((i - 1).toDouble(), avg));
      } else {
        dataPoints.add(FlSpot((i - 1).toDouble(), 0));
      }
    }
    return dataPoints;
  }

  List<FlSpot> getMonthlyData(String metric) {
    if (retrievedData.isEmpty) return [];

    DateTime endDate = retrievedData.last.time;
    DateTime startDate = endDate.subtract(const Duration(days: 29));

    Map<int, List<double>> monthlyData = {};

    for (var data in retrievedData) {
      if (data.time.isAfter(startDate) &&
          data.time.isBefore(endDate.add(const Duration(days: 1)))) {
        int day = data.time.difference(startDate).inDays;
        if (!monthlyData.containsKey(day)) {
          monthlyData[day] = [];
        }
        switch (metric) {
          case 'totalVolume':
            monthlyData[day]?.add(data.totalVolume);
            break;
          case 'flowRate':
            monthlyData[day]?.add(data.flowRate);
            break;
          case 'avgFlowRate':
            monthlyData[day]?.add(data.avgFlowRate);
            break;
        }
      }
    }

    List<FlSpot> dataPoints = [];
    for (int i = 0; i < 30; i++) {
      if (monthlyData[i] != null && monthlyData[i]!.isNotEmpty) {
        double avg =
            monthlyData[i]!.reduce((a, b) => a + b) / monthlyData[i]!.length;
        dataPoints.add(FlSpot(i.toDouble(), avg));
      } else {
        dataPoints.add(FlSpot(i.toDouble(), 0));
      }
    }
    return dataPoints;
  }

  List<FlSpot> getYearlyData(String metric) {
    Map<int, List<double>> yearlyData = {};

    for (int i = 0; i < 12; i++) {
      yearlyData[i] = [];
    }

    for (var data in retrievedData) {
      int month = data.time.month - 1;

      switch (metric) {
        case 'totalVolume':
          yearlyData[month]?.add(data.totalVolume);
          break;
        case 'flowRate':
          yearlyData[month]?.add(data.flowRate);
          break;
        case 'avgFlowRate':
          yearlyData[month]?.add(data.avgFlowRate);
          break;
      }
    }

    List<FlSpot> dataPoints = [];
    for (int i = 0; i < 12; i++) {
      if (yearlyData[i]!.isNotEmpty) {
        double avg =
            yearlyData[i]!.reduce((a, b) => a + b) / yearlyData[i]!.length;
        dataPoints.add(FlSpot(i.toDouble(), avg));
      } else {
        dataPoints.add(FlSpot(i.toDouble(), 0));
      }
    }
    return dataPoints;
  }

  // x axis labels based on time filter
  String getXLabel(double x) {
    switch (timeFilter) {
      case 'Weekly':
        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
        return x.toInt() < days.length ? days[x.toInt()] : '';
      case 'Monthly':
        int day = x.toInt() + 1;
        return day % 5 == 0 || day == 1 ? day.toString() : '';
      case 'Yearly':
        const months = [
          'Jan',
          'Feb',
          'Mar',
          'Apr',
          'May',
          'Jun',
          'Jul',
          'Aug',
          'Sep',
          'Oct',
          'Nov',
          'Dec',
        ];
        return x.toInt() < months.length ? months[x.toInt()] : '';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[Color(0xFFF0F9FF), Color(0xFFE0F2FE)],
            tileMode: TileMode.mirror,
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // Dashboard heading
                    const Text(
                      'Dashboard',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),

                    const SizedBox(height: 8),

                    const Text(
                      'FlowMeter Usage',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Graph section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      graphCard(
                        title: 'Total Volume',
                        metric: 'totalVolume',
                        color: const Color(0xFF3110EB),
                        backgroundColor: const Color.fromARGB(
                          255,
                          177,
                          175,
                          175,
                        ),
                      ),

                      const SizedBox(height: 16),

                      graphCard(
                        title: 'Flow Rate',
                        metric: 'flowRate',
                        color: const Color(0xFF4ECDC4),
                        backgroundColor: const Color.fromARGB(255, 92, 91, 91),
                      ),

                      const SizedBox(height: 16),

                      graphCard(
                        title: 'Average Flow Rate',
                        metric: 'avgFlowRate',
                        color: const Color(0xFFF52D11),
                        backgroundColor: const Color.fromARGB(
                          255,
                          177,
                          175,
                          175,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Go to Summary Button
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SummaryPage(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFABC9F9),
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24),
                            ),
                            elevation: 0,
                            shadowColor: Colors.black,
                          ),
                          child: const Text(
                            'Go to Summary',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // settings and home buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Home Button
                          Container(
                            alignment: Alignment.bottomLeft,
                            child: ElevatedButton(
                              onPressed: () {
                                // Navigate to home page
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                shadowColor: Colors.black,
                              ),
                              child: const Icon(Icons.home, size: 24),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Settings Button
                          Container(
                            alignment: Alignment.bottomRight,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SettingsPage(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: const Color.fromARGB(
                                  255,
                                  0,
                                  0,
                                  0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                elevation: 0,
                                shadowColor: Colors.black,
                              ),
                              child: const Icon(Icons.settings, size: 24),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget graphCard({
    required String title,
    required String metric,
    required Color color,
    required Color backgroundColor,
  }) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: [
                      Icon(Icons.circle, size: 10, color: color),

                      const SizedBox(width: 6),

                      Text(
                        title,
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ],
                  ),
                ],
              ),

              // Time filter
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: DropdownButton<String>(
                  value: timeFilter,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.keyboard_arrow_down, size: 20),
                  items: ['Weekly', 'Monthly', 'Yearly'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? timeSelection) {
                    if (timeSelection != null) {
                      setState(() {
                        timeFilter = timeSelection;
                      });
                    }
                  },
                ),
              ),
            ],
          ),

          const SizedBox(height: 32),

          // Line Chart
          SizedBox(
            height: 160,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(drawVerticalLine: false),
                titlesData: FlTitlesData(
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            getXLabel(value),
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: timeFilter == 'Weekly'
                    ? 6
                    : timeFilter == 'Monthly'
                    ? 29
                    : 11,
                minY: 0,
                lineBarsData: [
                  LineChartBarData(
                    spots: getGraphData(metric),
                    isCurved: true,
                    color: color,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(show: false),
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) =>
                        backgroundColor.withAlpha(200),
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((touchedSpot) {
                        return LineTooltipItem(
                          '${touchedSpot.y.toStringAsFixed(2)}',
                          TextStyle(color: color, fontWeight: FontWeight.bold),
                        );
                      }).toList();
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
