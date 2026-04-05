import 'package:flutter/material.dart';
import 'dashboard.dart';
import 'api_flask.dart';
import 'flow_meter_data_model.dart';
import 'package:intl/intl.dart';


class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => SummaryPageState();
}

class SummaryPageState extends State<SummaryPage> {
  FlowMeterData? retrievedData;
  bool isLoading = true;

    @override
    void initState() {
      super.initState();
      _loadData();
    }

    void _loadData() async {
      try {
        final api = FlowApi();
        final liveData = await api.fetchLive();
        setState(() {
          retrievedData = liveData;
          isLoading = false;
        });
      } 
      catch (e) {
        debugPrint('Error fetching data: $e');
        setState(() {
          isLoading = false;
        });
      }
    }

  @override
  Widget build(BuildContext context) {
    // check if loading
    if (isLoading) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xFFF0F9FF),
                Color(0xFFE0F2FE),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    // Check if data is null
    if (retrievedData == null) {
      return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment(0.8, 1),
              colors: <Color>[
                Color(0xFFF0F9FF),
                Color(0xFFE0F2FE),
              ],
              tileMode: TileMode.mirror,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                const Text(
                  'No data available',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isLoading = true;
                    });
                    _loadData();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final data = retrievedData;
    final updatedTime = DateFormat('h:mm a').format(data!.time).toUpperCase();
    final updatedDate = DateFormat('MMMM d').format(data.time);

    return Scaffold(
      body: Container(
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment(0.8, 1),
            colors: <Color>[
            Color(0xFFF0F9FF),
            Color(0xFFE0F2FE),
            ],
            tileMode: TileMode.mirror,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // Welcome heading
                  const Text(
                    'Welcome back!',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  const Text(
                    'FlowMeter Summary',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  
                  Text(
                    'Last updated on $updatedDate at $updatedTime EST',
                    style: const TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Volume Card
                  summaryCard(
                    title: 'Volume',
                    value: '${data.totalVolume} mL water used',
                    trailing: Image.asset(
                      'assets/waterDroplets.png',
                      width: 80,
                      height: 80,
                      fit: BoxFit.contain,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Flow Rate Card
                  summaryCard(
                    title: 'Flow Rate',
                    value: '${data.flowRate} mL/min',
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Average Flow Rate Card
                  summaryCard(
                    title: 'Average Flow Rate',
                    value: '${data.avgFlowRate} mL/min',
                  ),
                  
                  const SizedBox(height: 32),

                  Align(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DashboardPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF3B82F6),
                        foregroundColor: Colors.white,
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
                        'Go to Dashboard',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }


    Widget summaryCard({
    required String title,
    required String value,
    Widget? trailing,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            Color(0xFFDBEAFE),
            Color(0xFFBFDBFE),
          ],
          tileMode: TileMode.mirror,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFFBFDBFE),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: text
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E40AF),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  color: Color(0xFF4B5563),
                ),
              ),
            ],
          ),

          // Right: optional trailing widget
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing,
          ],
        ],
      ),
    );
  } 
}