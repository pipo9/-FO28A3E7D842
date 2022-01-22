import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grocery/controllers/orderController.dart';
import 'package:grocery/model/orderModel.dart';
import 'package:grocery/shared_Pref.dart';
import 'package:intl/intl.dart';
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
  Order _order = Order();

  List stateOrder = [
    "pendingrejecteddispatchedprocessingprepared",
    "delivered"
  ];
  List stateSubs = [
    'pendingrejectedsuspendedprocessingpreparedsubscribeddispatched',
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
                          if (stateOrder[widget.status]
                              .toString()
                              .contains(order['situation'])) {
                            return OrderCard(
                                orderId: order["orderId"],
                                onTap: () async {
                                  _sharedData.order = localOrderContainer;
                                  await Order().updateOrder(_sharedData.order);
                                  Navigator.pushNamed(context, '/order');
                                },
                                status: order["situation"],
                                seen: SharedData.user.role == "vendor"
                                    ? localOrderContainer.vendorSeen
                                    : localOrderContainer.deliverySeen);
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
                          if (localOrderContainer.statusDay == null ||
                              localOrderContainer.statusDay !=
                                  DateFormat('yyyy-MM-dd')
                                      .format(DateTime.now())) {
                            localOrderContainer.statusDay =
                                DateFormat('yyyy-MM-dd').format(DateTime.now());
                            localOrderContainer.situation = "pending";
                            _order.updateSubs(localOrderContainer);
                          }

                          if (SharedData().onDateSelectedSubs(
                              widget.time, localOrderContainer)) {
                            return OrderCard(
                                orderId: order["orderId"],
                                onTap: () async {
                                  _sharedData.order = localOrderContainer;
                                  await Order().updateSubs(_sharedData.order);
                                  Navigator.pushNamed(context, '/subscripton');
                                },
                                status: order["situation"],
                                seen: SharedData.user.role == "vendor"
                                    ? localOrderContainer.vendorSeen
                                    : localOrderContainer.deliverySeen);
                          }
                          return SizedBox();
                        }).toList());
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
