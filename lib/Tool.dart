import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/material.dart';

// class ToolPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: SizedBox(
//         width: 400,
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             Container(
//               padding: const EdgeInsets.all(10),
//               height: 120,
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 icon: const Icon(Icons.monitor_heart_outlined),
//                 label: Text('Status'),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/status');
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(10),
//               height: 120,
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 icon: const Icon(Icons.monitor_heart_outlined),
//                 label: Text('VPN'),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/vpn');
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(10),
//               height: 120,
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 icon: const Icon(Icons.monitor_heart_outlined),
//                 label: Text('ShortURL'),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/shorturl');
//                 },
//               ),
//             ),
//             Container(
//               padding: const EdgeInsets.all(10),
//               height: 120,
//               width: double.infinity,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 icon: const Icon(Icons.monitor_heart_outlined),
//                 label: Text('LongURL'),
//                 onPressed: () {
//                   Navigator.pushNamed(context, '/longurl');
//                 },
//               ),
//             ),
//           ],
//         ),
//       )
//     );
//   }
// }

class ToolPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SingleChildScrollView(
            child: Container(
      constraints: BoxConstraints(maxWidth: 400,),
      padding: const EdgeInsets.all(10),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 20,
        children: <Widget>[
          ElevatedButton.icon(
            icon: const Icon(Icons.monitor_heart_outlined),
            label: Text('Status'),
            onPressed: () {
              Navigator.of(context).pushNamed('/status');
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.vpn_key),
            label: Text('VPN'),
            onPressed: () {
              Navigator.of(context).pushNamed('/vpn');
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.link),
            label: Text('ShortURL'),
            onPressed: () {
              Navigator.of(context).pushNamed('/shorturl');
            },
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.link),
            label: Text('LongURL'),
            onPressed: () {
              Navigator.of(context).pushNamed('/longurl');
            },
          ),
        ],
      ),
    )));
  }
}
