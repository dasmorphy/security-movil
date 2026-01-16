import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:zentinel/presentation/views/views.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class HomeScreen extends StatefulWidget {

  static const name = 'home-screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final viewRoutes = const <Widget> [
    HomeView(),
    CategoryView(),
    Center(child: Text('Favoritos')),
    Center(child: Text('Perfil')),
  ];

  void _onTabTapped(int index, BuildContext context) {
    print(index);
    // if (index == 4) {
    //   context.go('/home/depature-report');
    //   return;
    // }
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: PreferredSize(
      //   preferredSize: const Size.fromHeight(300),
      //   child: const CustomAppbar(),
      // ),
      // resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
      body: IndexedStack( //Widget para conservar el estado de la pagina (ej Si hace scroll dejarlo tal cual)
        index: _currentIndex,
        children: viewRoutes,
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => _onTabTapped(index, context),
      ),
    );
  }
}