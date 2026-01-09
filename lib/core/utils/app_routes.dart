import 'package:flutter/material.dart';
import '../../presentation/screens/auth/login_screen.dart';
import '../../presentation/screens/auth/register_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/send_money/send_money_screen.dart';
import '../../presentation/screens/history/history_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/bills/bills_screen.dart';
import '../../presentation/screens/report/report_screen.dart';
import '../../presentation/screens/support/support_screen.dart';
import '../../presentation/screens/complaint/complaint_screen.dart';
import '../../presentation/screens/check_complaint/check_complaint_screen.dart';

class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const sendMoney = '/send';
  static const history = '/history';
  static const profile = '/profile';
  static const bills = '/bills';
  static const report = '/report';
  static const support = '/support';
  static const complaint = '/complaint';
  static const checkComplaint = '/check_complaint';
  static const more = '/more';

  static Map<String, WidgetBuilder> routes = {
    login: (_) => const LoginScreen(),
    register: (_) => const RegisterScreen(),
    home: (_) => const HomeScreen(),
    sendMoney: (_) => const SendMoneyScreen(),
    history: (_) => const HistoryScreen(),
    profile: (_) => const ProfileScreen(),
    bills: (_) => const BillsScreen(),
    report: (_) => const ReportScreen(),
    support: (_) => const SupportScreen(),
    complaint: (_) => const ComplaintScreen(),
    checkComplaint: (_) => const CheckComplaintScreen(),
  };
}
