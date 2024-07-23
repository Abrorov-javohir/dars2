import 'package:dars2/ui/screens/homeScreen.dart';
import 'package:dars2/utils/config/graphql_config.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: GraphqlConfig.initializeClient(),
      child: const CacheProvider(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeScreen(),
        ),
      ),
    );
  }
}
