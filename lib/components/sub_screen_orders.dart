import 'dart:async';

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
  var status;
  List<OrderModel> orders = [];
  List<OrderModel> subs = [];
  List stateOrder = [
    "pendingrejecteddispatchedprocessingprepared",
    "delivered"
  ];
  List stateSubs = [
    'pendingrejectedsuspendedprocessingpreparedsubscribeddispatched',
    'delivered'
  ];
  @override
  void initState() {
    SharedData _sharedData = Provider.of<SharedData>(context, listen: false);
    Future.delayed(Duration.zero, () {
      Order().getOrders(widget.time, _sharedData);
      Order().getSubs(widget.time, _sharedData);
      setState(() {
        orders = _sharedData.orders;
        subs = _sharedData.subs;
      });
    });
    super.initState();
  }

  void _onRefresh() async {
    SharedData _sharedData = Provider.of<SharedData>(context, listen: false);
    await Order().getOrders(widget.time, _sharedData);
    await Order().getSubs(widget.time, _sharedData);

    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    SharedData _sharedData = Provider.of<SharedData>(context);
    double _height = MediaQuery.of(context).size.height;
    orders = _sharedData.orders;
    subs = _sharedData.subs;

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
                child: orders.length <= 0
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: _height * 0.13,
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: kColor,
                              size: _height * 0.1,
                            ),
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            Text(
                              "You have No Order Today",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.022,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(children: [
                        for (var i = 0; i < orders.length; i++)
                          if (stateOrder[widget.status]
                                  .toString()
                                  .contains(orders[i].situation) &&
                              orders[i].purchasedAt.split(" ")[0].compareTo(
                                      DateFormat('yyyy-MM-dd')
                                          .format(widget.time)
                                          .toString()) ==
                                  0)
                            OrderCard(
                                orderId: orders[i].id,
                                onTap: () async {
                                  _sharedData.order = orders[i];

                                  await Order().updateOrder(orders[i]);
                                  Navigator.pushNamed(context, '/order');
                                },
                                status: orders[i].situation,
                                isSimple: true,
                                name: orders[i].user.fullName,
                                address: orders[i].user.address,
                                seen: SharedData.user.role == "vendor"
                                    ? orders[i].vendorSeen
                                    : orders[i].deliverySeen)
                      ]),
              ),
              SingleChildScrollView(
                child: subs.length <= 0
                    ? Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: _height * 0.13,
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: kColor,
                              size: _height * 0.1,
                            ),
                            SizedBox(
                              height: _height * 0.01,
                            ),
                            Text(
                              "You have No subscription Today",
                              style: GoogleFonts.robotoSlab(
                                color: kColor,
                                fontSize: _height * 0.022,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(children: [
                        for (var i = 0; i < subs.length; i++)
                          // if (SharedData().onDateSelectedSubs(
                          //         widget.time, subs[i])["status"] &&
                          //     stateSubs[widget.status].toString().contains(
                          //         SharedData().onDateSelectedSubs(
                          //             widget.time, subs[i])["state"]))
                            OrderCard(
                                orderId: subs[i].id,
                                onTap: () async {
                                  _sharedData.order = subs[i];

                                  await Order()
                                      .updateSubs(subs[i], widget.time);
                                  Navigator.pushNamed(context, '/subscripton');
                                },
                                status: subs[i].situation,
                                isSimple: true,
                                name: subs[i].user.fullName,
                                address: subs[i].user.address,
                                seen: SharedData.user.role == "vendor"
                                    ? subs[i].vendorSeen
                                    : subs[i].deliverySeen)
                      ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
