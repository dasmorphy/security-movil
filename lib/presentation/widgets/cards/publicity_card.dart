import 'package:flutter/material.dart';

class PublicityCard extends StatelessWidget {
  const PublicityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        // color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: 
      
          Image.asset( 'assets/images/banner.png', width: double.infinity, height: 170, fit: BoxFit.fill,),
      
      
      // Row(
      //   children: [
      //     // Logo placeholder
      //     Container(
      //       width: 60,
      //       height: 60,
      //       decoration: BoxDecoration(
      //         color: Colors.grey[200],
      //         borderRadius: BorderRadius.circular(8),
      //       ),
      //     ),
      //     const SizedBox(width: 16),

      //     Image.asset( 'lib/assets/images/banner.png', width: 60, height: 60,),


      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(
      //             'Rastreo Satelital',
      //             style: Theme.of(context).textTheme.titleMedium?.copyWith(
      //               fontWeight: FontWeight.w600,
      //             ),
      //           ),
      //           const SizedBox(height: 4),
      //           Text(
      //             'Localiza tus camiones en tiempo real',
      //             style: Theme.of(
      //               context,
      //             ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
      //           ),
      //           const SizedBox(height: 8),
      //           Text(
      //             'Ver más',
      //             style: Theme.of(context).textTheme.bodySmall?.copyWith(
      //               color: const Color.fromARGB(255, 0, 188, 212),
      //               fontWeight: FontWeight.w500,
      //             ),
      //           ),
      //         ],
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
