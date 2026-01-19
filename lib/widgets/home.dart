import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:telephony/telephony.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Telephony _telephony = Telephony.instance;
  List<SmsMessage> _messages = [];

  @override
  void initState() {
    super.initState();
    _requestSmsPermission();
  }

  Future<void> _requestSmsPermission() async {
    final status = await Permission.sms.request();
    if (status.isGranted) {
      await _getSmsMessages();
    }
  }

  Future<void> _getSmsMessages() async {
    final messages = await _telephony.getInboxSms(
      columns: [
        SmsColumn.ADDRESS,
        SmsColumn.BODY,
        SmsColumn.DATE,
      ],
      sortOrder: [
        OrderBy(
          SmsColumn.DATE,
          sort: Sort.DESC, // ✅ FIXED
        ),
      ],
    );

    setState(() {
      _messages = messages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _messages.isEmpty
          ? const Center(child: Text('No messages found'))
          : ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) {
          final message = _messages[index];
          return ListTile(
            leading: const Icon(Icons.message, color: Colors.deepPurple),
            title: Text(message.address ?? 'Unknown Sender'),
            subtitle: Text(message.body ?? ''),
          );
        },
      ),
    );
  }
}
