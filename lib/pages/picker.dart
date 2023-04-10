import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PickerPage extends StatefulWidget {
  PickerPage({Key? key}) : super(key: key);

  @override
  State<PickerPage> createState() => _PickerPageState();
}

class _PickerPageState extends State<PickerPage> {
  final TextEditingController _controller = TextEditingController();

  double mathSquare() {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    var appBarHeight = AppBar().preferredSize.height;
    var padding = 20;
    if (width >= 640) {
      if (width / 2 < 320) {
        return (320 - padding).toDouble();
      } else if (width / 2 >height - appBarHeight - padding) {
        return height - appBarHeight - padding;
      } else {
        return width / 2 - padding;
      }
    } else {
      return width - padding;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Picker'),
        ),
        body: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Center(
                child: Container(
                    constraints: BoxConstraints(
                      minHeight: MediaQuery.of(context).size.height -
                          AppBar().preferredSize.height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.of(context).padding.bottom,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              constraints: BoxConstraints(
                                minWidth:
                                    MediaQuery.of(context).size.width < 320
                                        ? MediaQuery.of(context).size.width
                                        : 320,
                                maxWidth: MediaQuery.of(context).size.width >=
                                        640
                                    ? MediaQuery.of(context).size.width / 2 <
                                            320
                                        ? 320
                                        : MediaQuery.of(context).size.width / 2
                                    : MediaQuery.of(context).size.width,
                              ),
                              child: SizedBox(
                                  width: mathSquare(),
                                  height: mathSquare(),
                                  child: const Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0))),
                                  )),
                            ),
                            Container(
                                padding: const EdgeInsets.all(10),
                                constraints: BoxConstraints(
                                  minWidth:
                                      MediaQuery.of(context).size.width < 320
                                          ? MediaQuery.of(context).size.width
                                          : 320,
                                  maxWidth: MediaQuery.of(context).size.width >=
                                          640
                                      ? MediaQuery.of(context).size.width / 3 <
                                              320
                                          ? 320
                                          : MediaQuery.of(context).size.width /
                                              3
                                      : MediaQuery.of(context).size.width,
                                ),
                                child: Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(16.0))),
                                    child: Container(
                                        padding: const EdgeInsets.all(10),
                                        child: Column(
                                          children: [
                                            TextField(
                                              controller: _controller,
                                              keyboardType:
                                                  TextInputType.multiline,
                                              maxLines: 15,
                                              minLines: 5,
                                              decoration: const InputDecoration(
                                                  labelText: 'Data',
                                                  hintText:
                                                      'Use newline to separate',
                                                  prefixIcon:
                                                      Icon(Icons.text_fields),
                                                  border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  16.0)))),
                                            ),
                                            const SizedBox(height: 20),
                                            Wrap(
                                              spacing: 10,
                                              children: [
                                                // TODO: add in batch future
                                                ElevatedButton.icon(
                                                    onPressed: () {},
                                                    icon:
                                                        const Icon(Icons.start),
                                                    label: const Text('Start'))
                                              ],
                                            )
                                          ],
                                        )))),
                          ],
                        ),
                      ],
                    )))));
  }
}
