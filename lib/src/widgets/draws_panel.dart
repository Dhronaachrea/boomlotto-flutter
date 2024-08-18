import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:velocity_x/velocity_x.dart';

typedef StringCallback = void Function(int val);

class DrawsPanel extends StatefulWidget {
  final ScrollController controller;
  final PanelController panelController;
  final List drawRespVOs;
  final StringCallback callback;

  const DrawsPanel({
    Key? key,
    required this.controller,
    required this.panelController,
    required this.drawRespVOs,
    required this.callback,
  }) : super(key: key);

  @override
  _DrawsPanelState createState() => _DrawsPanelState();
}

class _DrawsPanelState extends State<DrawsPanel> {
  int selectedDraw = 1;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: const [
            Text(
              'Select Number Of Draws',
              style: TextStyle(fontSize: 18),
            ),
            Text(
              '("1 Draw" is mandatory to proceed)',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ).p16(),
        widget.drawRespVOs.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                controller: widget.controller,
                children: [
                  GridView.builder(
                    shrinkWrap: true,
                    itemCount: widget.drawRespVOs.length,
                    key: ValueKey(widget.drawRespVOs.length),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: widget.drawRespVOs.length < 4
                          ? widget.drawRespVOs.length
                          : 4,
                      crossAxisSpacing: 1,
                      mainAxisSpacing: 1,
                      childAspectRatio: 1.5,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      return MaterialButton(
                        padding: EdgeInsets.zero,
                        height: 40,
                        onPressed: () => {
                          setState(() {
                            selectedDraw = index + 1;
                            widget.callback(selectedDraw);
                          })
                        },
                        elevation: 0,
                        color: selectedDraw == index + 1
                            ? Colors.orange[800]
                            : Colors.white,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style: TextStyle(
                                color: selectedDraw == index + 1
                                    ? Colors.white
                                    : Colors.blueGrey[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                            Text(
                              '${index + 1} Draw',
                              style: TextStyle(
                                color: selectedDraw == index + 1
                                    ? Colors.white
                                    : Colors.blueGrey[700],
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                          side: BorderSide(color: Colors.orange[800]!),
                        ),
                      ).p8();
                    },
                  ),
                ],
              )
            : Container(),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: MaterialButton(
              onPressed: () => {
                widget.panelController.close(),
              },
              color: Colors.purple,
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50.0),
              ),
            ).p12(),
          ),
        ),
      ],
    );
  }
}
