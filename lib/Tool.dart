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
    return SingleChildScrollView(
        child: Center(
            child: Container(
                constraints: BoxConstraints(
                  maxWidth: 700,
                  minHeight: MediaQuery.of(context).size.height -
                      AppBar().preferredSize.height -
                      58, //BottomNavigationBar Height
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children: <Widget>[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.monitor_heart),
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
                  ],
                ))));
  }
}
