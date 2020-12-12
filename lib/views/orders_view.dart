import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:node_auth/constants/colors.dart';
import 'package:node_auth/providers/orders_provider.dart';
import 'package:node_auth/widgets/pickup_detail.dart';
import 'package:node_auth/widgets/retry.dart';
import 'package:provider/provider.dart';

class Orders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    OrderProvider provider = Provider.of<OrderProvider>(context, listen: false);
    if (provider.orders != null) {
      provider.fetchOrders(context);
    }
    if (provider.history != null) {
      provider.fetchHistory(context);
    }
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title:
              Text("Deliveries", style: TextStyle(color: kLeichtPrimaryColor)),
          iconTheme: IconThemeData(color: kLeichtPrimaryColor),
          backgroundColor: Colors.white,
          bottom: TabBar(
            tabs: <Widget>[
              Tab(icon: Icon(Icons.hourglass_empty), text: "Pending"),
              Tab(icon: Icon(Icons.history), text: "History"),
            ],
          ),
        ),
        body: Container(
          color: Colors.white,
          child: TabBarView(
            children: <Widget>[
              Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  if (orderProvider.orders == null) {
                    return FutureBuilder<bool>(
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.data == true) {
                          return Container();
                        }

                        return RetryWidget(
                          onTap: () {
                            return orderProvider.fetchOrders(context);
                          },
                          errorMessage: "Could not get your orders. Try again",
                        );
                      },
                      future: orderProvider.fetchOrders(context),
                    );
                  }

                  if (orderProvider.orders.length == 0) {
                    return RefreshIndicator(
                        child: Center(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              Center(
                                child: Text("You have no pending deliveries"),
                              )
                            ],
                          ),
                        ),
                        onRefresh: () async {
                          await orderProvider.fetchOrders(context);
                        });
                  }

                  return RefreshIndicator(
                      child: ListView.builder(
                          itemBuilder: (context, count) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PickupDetail(
                                  order: orderProvider.orders[count],
                                ),
                                Container(
                                  height: 15,
                                  color: Colors.grey[50],
                                )
                              ],
                            );
                          },
                          itemCount: orderProvider.orders.length),
                      onRefresh: () async {
                        await orderProvider.fetchOrders(context);
                      });
                },
              ),
              Consumer<OrderProvider>(
                builder: (context, orderProvider, _) {
                  if (orderProvider.history == null) {
                    return FutureBuilder<bool>(
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: SizedBox(
                              height: 25,
                              width: 25,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }

                        if (snapshot.data == true) {
                          return Container(
                            color: Colors.red,
                          );
                        }

                        return RetryWidget(
                          onTap: () {
                            return orderProvider.fetchHistory(context);
                          },
                          errorMessage:
                              "Could not get your order history. Try again",
                        );
                      },
                      future: orderProvider.fetchHistory(context),
                    );
                  }

                  if (orderProvider.history.length == 0) {
                    return RefreshIndicator(
                        child: Center(
                          child: ListView(
                            children: [
                              SizedBox(
                                height: 200,
                              ),
                              Center(
                                child: Text("Nothing to see here yet"),
                              )
                            ],
                          ),
                        ),
                        onRefresh: () async {
                          await orderProvider.fetchHistory(context);
                        });
                  }

                  return RefreshIndicator(
                      child: ListView.builder(
                          itemBuilder: (context, count) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                PickupDetail(
                                  order: orderProvider.history[count],
                                ),
                                Container(
                                  height: 15,
                                  color: Colors.grey[50],
                                )
                              ],
                            );
                          },
                          itemCount: orderProvider.history.length),
                      onRefresh: () async {
                        await orderProvider.fetchHistory(context);
                      });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
