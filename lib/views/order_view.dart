import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../widgets/home_content.dart';
import '../extensions/hover_extensions.dart';
// import 'package:cake_admin/locator.dart';
// import 'package:cake_admin/services/navigation_service.dart';

class OrderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInfo) => Container(
        child: Container(
          height: MediaQuery.of(context).size.height - 50,
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/img/bg.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 80,
                  color: Theme.of(context).accentColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: sizingInfo.isDesktop ? 36 : 24,
                    vertical: 15,
                  ),
                  child: Row(
                    children: [
                      Image.asset('assets/img/logo.png'),
                      SizedBox(
                        width: 20,
                      ),
                      GestureDetector(
                        child: Text(
                          'Orders',
                          style: Theme.of(context).textTheme.headline5,
                        ).showCursorOnHover,
                        onTap: () {
                          // locator<NavigationService>().navigateTo('/login');
                        },
                      ),
                      Spacer(),
                      if (sizingInfo.isDesktop) ...[
                        Text(
                          'USERNAME',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                      ],
                      Icon(
                        FontAwesomeIcons.userCircle,
                        color: Colors.white,
                        size: 30,
                      ).showCursorOnHover,
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: <DataColumn>[
                        DataColumn(
                          label: Text(
                            'S.No.',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Name',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Phone Number',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Email',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Occasion',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Date of Delivery',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Message on Cake',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Special Instructions',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Eggless',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Quantity',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Weight (Kg)',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Price',
                            style: TextStyle(fontStyle: FontStyle.italic),
                          ),
                        ),
                      ],
                      rows: <DataRow>[
                        DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text('1'),
                            ),
                            DataCell(
                              Text('Vansh'),
                            ),
                            DataCell(
                              Text('0987654321'),
                            ),
                            DataCell(
                              Text('abc@xyz.com'),
                            ),
                            DataCell(
                              Text('BDAY'),
                            ),
                            DataCell(
                              Text('10/07/2020'),
                            ),
                            DataCell(
                              Text('Vansh'),
                            ),
                            DataCell(
                              Text('ASAP'),
                            ),
                            DataCell(
                              Text('Eggless'),
                            ),
                            DataCell(
                              Text('1'),
                            ),
                            DataCell(
                              Text('1.5'),
                            ),
                            DataCell(
                              Text('500'),
                            ),
                          ],
                        ),
                        DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Text('1'),
                            ),
                            DataCell(
                              Text('Vansh'),
                            ),
                            DataCell(
                              Text('0987654321'),
                            ),
                            DataCell(
                              Text('abc@xyz.com'),
                            ),
                            DataCell(
                              Text('BDAY'),
                            ),
                            DataCell(
                              Text('10/07/2020'),
                            ),
                            DataCell(
                              Text('Vansh'),
                            ),
                            DataCell(
                              Text('ASAP'),
                            ),
                            DataCell(
                              Text('Eggless'),
                            ),
                            DataCell(
                              Text('1'),
                            ),
                            DataCell(
                              Text('1.5'),
                            ),
                            DataCell(
                              Text('500'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
