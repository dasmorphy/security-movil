import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zentinel/presentation/widgets/widgets.dart';

class CategoryView extends ConsumerStatefulWidget {
  const CategoryView({super.key});

  @override
  CategoryViewState createState() => CategoryViewState();
}

class CategoryViewState extends ConsumerState<CategoryView> {
  //SINO SE ESPECIFICA NOTIFIER DEVUELVE EL ESTADO POR DEFECTO, ES DECIR EL VALOR DE ESE PROVIDER

  @override
  void initState() {
    //En los metodos llmar el metodo read en los providers (flutter favorite)
    super.initState();
    // ref.read(getAllCategories.notifier).getAllCategories();
  }

  @override
  Widget build(BuildContext context) {
    // final allCategories = ref.watch(getAllCategories);
    // print(allCategories);

    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          //HEADER CON VIDEO
          const HeaderCategory(),
      
          SizedBox(height: 20),
          _buildTabBar(),
          SizedBox(height: 12),
      
          // 👇 CONTENIDO CAMBIA SEGÚN TAB
          Expanded(
            child: TabBarView(
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [


                // TAB 1
                // SingleChildScrollView(
                //   padding: const EdgeInsets.all(16),
                //   physics: const BouncingScrollPhysics(
                //     parent: AlwaysScrollableScrollPhysics(),
                //   ),
                //   child: BasicServicesSection(),
                // ),

                // TAB 1
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: ServicesBiomar(),
                ),
      
                // TAB 2
                SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  child: FavoritesCategorySection(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 17.0),
        height: 35.0,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: TabBar(
          // physics: BouncingScrollPhysics(),
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.tab,
          indicatorPadding: EdgeInsets.zero,
          indicator: BoxDecoration(
            color: const Color.fromARGB(255, 30, 145, 139),
            borderRadius: BorderRadius.circular(25),
          ),
          indicatorColor: Colors.white,
          labelColor: const Color.fromARGB(255, 255, 255, 255),
          labelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          unselectedLabelColor: const Color.fromARGB(255, 46, 45, 45),
          tabs: [
            Tab(
              child: SizedBox(child: Center(child: Text('Servicios'))),
            ),
            Tab(
              child: SizedBox.expand(child: Center(child: Text('Favoritos'))),
            ),
          ],
        ),
    );
  }
}
