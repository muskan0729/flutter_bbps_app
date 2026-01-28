import 'package:flutter/material.dart';
import '../../../data/models/biller_model.dart';
import '../../../data/services/biller_service.dart';
import 'biller_info_screen.dart';

class BbpsServiceScreen extends StatefulWidget {
  final String serviceName;

  const BbpsServiceScreen({super.key, required this.serviceName});

  @override
  State<BbpsServiceScreen> createState() => _BbpsServiceScreenState();
}

class _BbpsServiceScreenState extends State<BbpsServiceScreen> {
  final BillerService _billerService = BillerService();

  bool _loading = true;
  List<BillerModel> _billers = [];

  @override
  void initState() {
    super.initState();
    _fetchBillers();
  }

  Future<void> _fetchBillers() async {
    final result = await _billerService.getBillers(widget.serviceName);

    setState(() {
      _billers = result;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.serviceName),
        backgroundColor: const Color.fromARGB(255, 98, 134, 211),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _billers.isEmpty
          ? const Center(child: Text('No billers found'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _billers.length,
              itemBuilder: (context, index) {
                final biller = _billers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    leading: const Icon(Icons.account_balance),
                    title: Text(biller.blrName),
                    subtitle: Text(biller.blrId),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      print('Selected Biller: ${biller.blrName}');
                      print('Biller ID: ${biller.blrId}');

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              BillerInfoScreen(billerId: biller.blrId),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
