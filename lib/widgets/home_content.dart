import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import './alt_button.dart';

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenTypeLayout(
      tablet: Container(
        height: MediaQuery.of(context).size.height - 130,
        // width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.center,
        constraints: BoxConstraints(
          minHeight: 500,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AltButton(
                  title: 'Approvals',
                  borderRadius: 20,
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
                  width: 300,
                  height: 80,
                  bgColor: Theme.of(context).canvasColor,
                  borderColor: Colors.white,
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => MenuScreen(),
                    //   ),
                    // );
                  },
                ),
                AltButton(
                  title: 'Orders',
                  borderRadius: 20,
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
                  width: 300,
                  height: 80,
                  bgColor: Theme.of(context).canvasColor,
                  borderColor: Colors.white,
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => MenuScreen(),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                AltButton(
                  title: 'Database',
                  borderRadius: 20,
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
                  width: 300,
                  height: 80,
                  bgColor: Theme.of(context).canvasColor,
                  borderColor: Colors.white,
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => MenuScreen(),
                    //   ),
                    // );
                  },
                ),
                AltButton(
                  title: 'Settings',
                  borderRadius: 20,
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
                  width: 300,
                  height: 80,
                  bgColor: Theme.of(context).canvasColor,
                  borderColor: Colors.white,
                  onPressed: () {
                    // Navigator.of(context).pushReplacement(
                    //   MaterialPageRoute(
                    //     builder: (ctx) => MenuScreen(),
                    //   ),
                    // );
                  },
                ),
              ],
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 80,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(),
                  ),
                  Text(
                    'For Approval - ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'XX',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(0xFFFF0000),
                        ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Text(
                    'For Delivery - ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'XX',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(0xFF00a8ff),
                        ),
                  ),
                  Expanded(
                    flex: 2,
                    child: SizedBox(),
                  ),
                  Text(
                    'Delivered - ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'XX',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(0xFF00ff60),
                        ),
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      mobile: Container(
        // height: MediaQuery.of(context).size.height - 130,
        width: MediaQuery.of(context).size.width * 0.8,
        alignment: Alignment.center,
        constraints: BoxConstraints(
          minHeight: 500,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            AltButton(
              title: 'Approvals',
              borderRadius: 20,
              fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
              width: 300,
              height: 80,
              bgColor: Theme.of(context).canvasColor,
              borderColor: Colors.white,
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (ctx) => MenuScreen(),
                //   ),
                // );
              },
            ),
            SizedBox(
              height: 20,
            ),
            AltButton(
              title: 'Orders',
              borderRadius: 20,
              fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
              width: 300,
              height: 80,
              bgColor: Theme.of(context).canvasColor,
              borderColor: Colors.white,
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (ctx) => MenuScreen(),
                //   ),
                // );
              },
            ),
            SizedBox(
              height: 20,
            ),
            AltButton(
              title: 'Database',
              borderRadius: 20,
              fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
              width: 300,
              height: 80,
              bgColor: Theme.of(context).canvasColor,
              borderColor: Colors.white,
              onPressed: () {
                print('asda');
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (ctx) => MenuScreen(),
                //   ),
                // );
              },
            ),
            SizedBox(
              height: 20,
            ),
            AltButton(
              title: 'Settings',
              borderRadius: 20,
              fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 26,
              width: 300,
              height: 80,
              bgColor: Theme.of(context).canvasColor,
              borderColor: Colors.white,
              onPressed: () {
                // Navigator.of(context).pushReplacement(
                //   MaterialPageRoute(
                //     builder: (ctx) => MenuScreen(),
                //   ),
                // );
              },
            ),
            SizedBox(
              height: 30,
            ),
            Container(
              // width: MediaQuery.of(context).size.width * 0.6,
              // height: 300,
              decoration: BoxDecoration(
                color: Theme.of(context).canvasColor,
                border: Border.all(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  // Expanded(
                  //   child: SizedBox(),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'For Approval - ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'XX',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(0xFFFF0000),
                        ),
                  ),
                  // Expanded(
                  //   child: SizedBox(),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'For Delivery - ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'XX',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(0xFF00a8ff),
                        ),
                  ),
                  // Expanded(
                  //   child: SizedBox(),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'Delivered - ',
                    style: Theme.of(context).textTheme.subtitle1,
                  ),
                  Text(
                    'XX',
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: Color(0xFF00ff60),
                        ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  // Expanded(
                  //   child: SizedBox(),
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
