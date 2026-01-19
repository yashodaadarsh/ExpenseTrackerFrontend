import 'package:expense_tracker/features/addExpense/presentation/ui/addexpense.dart';
import 'package:expense_tracker/features/profile/presentation/ui/profile.dart';
import 'package:expense_tracker/features/transactions/presentation/ui/transactions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:telephony/telephony.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

import '../../../../service_locator.dart';
import '../../background/background_service_locator.dart';
import '../../data/source/message_handling_api_service.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_event.dart';
import '../bloc/home_state.dart';

// Top-level background handler (Required by Telephony)
@pragma('vm:entry-point')
void backgroundMessageHandler(SmsMessage message) async {
  debugPrint("Background Message Received: ${message.body}");
  WidgetsFlutterBinding.ensureInitialized();

  setupBackgroundServiceLocator(); // ⭐ REQUIRED

  final service = GetIt.instance<MessageHandlingApiService>();
  await service.sendMessage(message);
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Telephony telephony = Telephony.instance;

  List<Map<String, dynamic>> transactions = [
    {
      'title': 'Grocery Shopping',
      'amount': '- \$150.00',
      'date': 'Today',
      'icon': Icons.shopping_cart,
      'color': Colors.orange,
      'isExpense': true,
    },
  ];

  final homeBloc = s1<HomePageBloc>();

  @override
  void initState() {
    super.initState();
    homeBloc.add(LoadTransactionsEvent());
    _initSmsListener();
  }

  @override
  void dispose() {
    homeBloc.close();
    super.dispose();
  }



  void _initSmsListener() async {
    if (Platform.isAndroid) {
      // 1. Ask for permissions
      bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

      if (permissionsGranted == true) {
        debugPrint("✅ SMS Permissions Granted. Listening...");

        // 2. Start Listening (With Background Enabled)
        telephony.listenIncomingSms(
          // FOREGROUND Handler (App is Open)
          onNewMessage: (SmsMessage message) async {
            debugPrint("☀️ FOREGROUND MESSAGE: ${message.body}");
            homeBloc.add(IncomingSmsEvent(message));
          },

          // BACKGROUND Handler (App is Minimized/Closed)
          onBackgroundMessage: backgroundMessageHandler,

          // ✅ IMPORTANT: Set this to true to enable the background isolate
          listenInBackground: true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomePageBloc, HomePageState>(
      bloc: homeBloc,
      listener: (context, state) {
        if (state is HomePageErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        if (state is HomePageLoadingState) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is HomePageLoadedState) {
          final transactions = state.transactions;

          return Scaffold(
            backgroundColor: Colors.grey[100],
            body: Stack(
              children: [
                Container(
                  height: 280,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30),
                    ),
                  ),
                ),
                SafeArea(
                  child: Column(
                    children: [
                      _buildHeader(state),
                      const SizedBox(height: 20),
                      _buildGraphAndInsightsCard(  state  ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Recent Transactions",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87),
                            ),
                            TextButton(onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AllTransactions(transactions: transactions))
                              );
                            }, child: const Text("See All"))
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            return _buildTransactionTile(transactions[index]);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            bottomNavigationBar: BottomAppBar(
              shape: const CircularNotchedRectangle(),
              notchMargin: 8.0,
              child: SizedBox(
                height: 60,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(icon: const Icon(Icons.home, color: Colors.deepPurple), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.bar_chart, color: Colors.grey), onPressed: () {}),
                    const SizedBox(width: 40),
                    IconButton(icon: const Icon(Icons.wallet, color: Colors.grey), onPressed: () {}),
                    IconButton(icon: const Icon(Icons.person, color: Colors.grey), onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(currentUser: state.userDto)));
                    }),
                  ],
                ),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddExpensePage())
                );
                if (result == true) {
                  homeBloc.add(LoadTransactionsEvent());
                }
              },
              backgroundColor: Colors.deepPurple,
              child: const Icon(Icons.add, color: Colors.white),
            ),
            floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          );
        }

        return const SizedBox();
      },
    );

  }

  // --- Helper Widgets (Same as before) ---
  Widget _buildHeader(HomePageLoadedState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Hello ,",
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              Text(
                "${state.userDto.firstName}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildGraphAndInsightsCard( HomePageLoadedState state ) {
    int monthlyLimit = state.userDto.limit;
    double percentage = monthlyLimit == 0 ? 0.0 : ( ( state.totalExpense / monthlyLimit ) * 100 );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      height: 180,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 4,
            child: CircularPercentIndicator(
              radius: 60.0,
              lineWidth: 10.0,
              percent: (percentage/100) >= 1 ? 1 : percentage/100,
              animation: true,
              animationDuration: 2000,
              center: Text(
                "${percentage.toInt()}%",
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: (percentage/100) >= 1 ? Colors.red : Color(0xFF2ecc71),
              backgroundColor: const Color(0xFF2ecc71).withOpacity(0.2),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            flex: 6,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInsightText("1. Status:", (percentage < 85) ? "Good" : "At Risk"),
                const SizedBox(height: 8),
                _buildInsightText("2. Limit:", "${state.userDto.limit} Rs."),
                if (monthlyLimit == 0) ...[
                  const SizedBox(height: 12),
                  Material(
                    color: Colors.deepPurple.withOpacity(0.1), // Soft background
                    borderRadius: BorderRadius.circular(30),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(30),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilePage(currentUser: state.userDto,)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                        child: Row(
                          mainAxisSize: MainAxisSize.min, // Hugs content
                          children: const [
                            Icon(Icons.add_card_rounded, size: 18, color: Colors.deepPurple),
                            SizedBox(width: 8),
                            Text(
                              "Set Monthly Budget",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildInsightText(String label, String value) {
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          color: Colors.black87,
          fontSize: 13,
          fontFamily: 'Roboto',
        ),
        children: [
          TextSpan(text: "$label "),
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionTile( Map<String, dynamic> item) {
    final bool isExpense = item['isExpense'] ?? true;
    final Color baseColor = item['color'] as Color;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Matches Signup Container Radius
        boxShadow: [
          BoxShadow(
            // Using deepPurple for the shadow creates a "glow" effect
            // consistent with the gradient background of the app
            color: Colors.deepPurple.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
            spreadRadius: 2,
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            // Handle tap
          },
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Icon Box
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                    // Matches the "filled: true" look of your input fields
                    color: baseColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Icon(item['icon'], color: baseColor, size: 28),
                  ),
                ),
                const SizedBox(width: 16),

                // Title and Date
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['title']?.toString() ?? 'Unknown',
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item['date']?.toString() ?? '--',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                // Amount
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${isExpense ? "-" : "+"} \₹${item['amount']}',
                      style: TextStyle(
                        // Expenses are Red, Income matches your Primary Brand Color
                        color: isExpense ? Colors.redAccent : Colors.deepPurple,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
