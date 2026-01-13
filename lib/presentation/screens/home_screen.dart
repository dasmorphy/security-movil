import 'package:flutter/material.dart';
import 'package:zentinel/presentation/views/views.dart';
// import 'package:flutter_application_1/presentation/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {

  static const name = 'home-screen';
  final int pageIndex;

  const HomeScreen({super.key, required this.pageIndex});

  final viewRoutes = const <Widget> [
    HomeView(),
    SizedBox(), //Caategories View
    // FavoritesView()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack( //Widget para conservar el estado de la pagina (ej Si hace scroll dejarlo tal cual)
        index: pageIndex,
        children: viewRoutes,
      ),
      // bottomNavigationBar: CustomBottomNavigationbar(currentIndex: pageIndex),
    );
  }
}