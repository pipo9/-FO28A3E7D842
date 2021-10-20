import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/model/orderModel.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../const.dart';
import '../strings.dart';
import 'order-card.dart';

class SubScreenOrders extends StatefulWidget {
  final status;
  final time;
  SubScreenOrders({@required this.status, @required this.time});
  @override
  _SubScreenOrdersState createState() => _SubScreenOrdersState();
}

class _SubScreenOrdersState extends State<SubScreenOrders> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List stateOrder = ["pendingrejected", "processingprepared", "delivered"];
  List stateSubs = [
    'pendingrejectedsuspended',
    'processingpreparedsubscribed',
    'delivered'
  ];

  void _onRefresh() async {
    await Future.delayed(Duration(milliseconds: 3000));
    _refreshController.refreshCompleted();
  }

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    SharedData _sharedData = Provider.of<SharedData>(context, listen: false);

    // final _height = MediaQuery.of(context).size.height;
    final year = widget.time.year.toString();
    final month = widget.time.month.toString().length == 1
        ? "0" + widget.time.month.toString()
        : widget.time.month.toString();
    final day = widget.time.day.toString().length == 1
        ? "0" + widget.time.day.toString()
        : widget.time.day.toString();
    final time = year + '-' + month + '-' + day;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: TabBar(
          indicatorColor: kColor,
          labelColor: kColor,
          unselectedLabelColor: kColor.withOpacity(0.5),
          labelStyle: GoogleFonts.robotoSlab(fontWeight: FontWeight.bold),
          tabs: [
            Tab(
              text: orders_tab_simple,
            ),
            Tab(
              text: orders_tab_subs,
            ),
          ],
        ),
        body: SmartRefresher(
          enablePullDown: true,
          header: WaterDropMaterialHeader(
            backgroundColor: kColor,
          ),
          controller: _refreshController,
          onRefresh: _onRefresh,
          child: TabBarView(
            children: [
              SingleChildScrollView(
                  child: StreamBuilder(
                      stream: _firestore
                          .collection("orders")
                          .where(
                              SharedData.user.role == "vendor"
                                  ? "vendorId"
                                  : "deliveryId",
                              isEqualTo: SharedData.user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        var data = snapshot.data;
                        if (data == null) {
                          return Padding(
                              padding: EdgeInsets.only(top: 70),
                              child: Center(
                                child: Text(
                                  "You Have No Order Today",
                                  style: GoogleFonts.robotoSlab(
                                    color: kBlueAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ));
                        }
                        final List<DocumentSnapshot> docs = data.docs;

                        return Column(
                            children: docs.map((order) {
                          OrderModel localOrderContainer =
                              OrderModel(order.id, order.data());
                          if (order["purchased_at"].toString().contains(time) &&
                              stateOrder[widget.status]
                                  .toString()
                                  .contains(order['situation'])) {
                            return OrderCard(
                              orderId: order["orderId"],
                              onTap: () {
                                _sharedData.order = localOrderContainer;

                                Navigator.pushNamed(context, '/order');
                              },
                              status: order["situation"],
                            );
                          } else {
                            return SizedBox();
                          }
                        }).toList());
                      })),
              SingleChildScrollView(
                  child: StreamBuilder(
                      stream: _firestore
                          .collection("subscribes")
                          .where(
                              SharedData.user.role == "vendor"
                                  ? "vendorId"
                                  : "deliveryId",
                              isEqualTo: SharedData.user.uid)
                          .snapshots(),
                      builder: (context, snapshot) {
                        var data = snapshot.data;
                        if (data == null) {
                          return Padding(
                              padding: EdgeInsets.only(top: 70),
                              child: Center(
                                child: Text(
                                  "You Have No Order Today",
                                  style: GoogleFonts.robotoSlab(
                                    color: kBlueAccent,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ));
                        }
                        final List<DocumentSnapshot> docs = data.docs;
                        return Column(
                            children: docs.map((order) {
                          OrderModel localOrderContainer =
                              OrderModel(order.id, order.data());
                          if (order["purchased_at"].toString().contains(time) &&
                              stateSubs[widget.status]
                                  .toString()
                                  .contains(order['situation'])) {
                            return OrderCard(
                              orderId: order["orderId"],
                              onTap: () {
                                _sharedData.order = localOrderContainer;
                                Navigator.popAndPushNamed(
                                    context, '/subscripton');
                              },
                              status: order["situation"],
                            );
                          } else {
                            return SizedBox();
                          }
                        }).toList());
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
