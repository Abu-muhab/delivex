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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Ordered Items",
              style: TextStyle(color: kLeichtPrimaryColor)),
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
                    return Center(
                      child: Text("You have not pending deliveries"),
                    );
                  }

                  return ListView.builder(
                      itemBuilder: (context, count) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PickupDetail(
                              order: orderProvider.orders[count],
                            ),
                            Divider(thickness: 1.5)
                          ],
                        );
                      },
                      itemCount: orderProvider.orders.length);
                },
              ),
              ListView(
                children: [
                  Divider(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
