import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/causes/view/cause_list_screen.dart';

class BayanaApp extends StatelessWidget {
  const BayanaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cause Explorer',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: const CauseListScreen(),
    );
  }
}
