import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:node_auth/api/search_api.dart';
import 'package:node_auth/constants/screen_size.dart';
import 'package:node_auth/providers/location_provider.dart';
import 'package:node_auth/widgets/map_location_selector.dart';
import 'package:provider/provider.dart';

class WhereToScreen extends StatefulWidget {
  @override
  _WhereToScreenState createState() => _WhereToScreenState();
}

class _WhereToScreenState extends State<WhereToScreen> {
  bool doneButton = false;
  List<Place> searchResult = new List();
  bool fetchingResult = false;
  TextEditingController destinationController = new TextEditingController();
  GlobalKey mapKey = new GlobalKey();
  bool fetchingInfo = false;
  bool mapCapAlterField = false;
  int mapUpdateCount = 0;

  Place selected;

  KeyboardVisibilityNotification keyBoardNotification;
  int listenerId;

  void getSearchResult(BuildContext context, String searchKey) {
    if (searchKey != "" && searchKey != null) {
      setState(() {
        fetchingInfo = true;
      });
      SearchApi.searchPlace(context, searchKey).then((result) {
        setState(() {
          searchResult = result;
          fetchingInfo = false;
          doneButton = false;
        });
      });
    }
  }

  //locationSelectorKey us used to access the selected location of the MapLocationSelectorWidget
  GlobalKey<MapLocationSelectorState> locationSelectorKey = new GlobalKey();

  void getSearchResultFromMap({LatLng location}) {
    setState(() {
      fetchingInfo = true;
    });
    var search = SearchApi.convertCoordinatesToAddress(location != null
        ? location
        : locationSelectorKey.currentState.markerLocation);
    search.then((result) {
      destinationController.clear();
      destinationController.text = result.name;
      setState(() {
        selected = result;
        doneButton = true;
      });
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        fetchingInfo = false;
      });
    });
    search.catchError((err) {
      setState(() {
        fetchingInfo = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    keyBoardNotification = KeyboardVisibilityNotification();
    listenerId = keyBoardNotification.addNewListener(onHide: () {
      getSearchResult(context, destinationController.text);
    });
  }

  @override
  void dispose() {
    keyBoardNotification.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> searchResultWidgets = new List();
    if (searchResult != null) {
      searchResult.forEach((result) {
        searchResultWidgets.add(InkWell(
          onTap: () {
            destinationController.clear();
            destinationController.text = result.name;
            setState(() {
              doneButton = true;
              selected = result;
            });
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Divider(),
              ListTile(
                title: Text(result.formattedAddress),
                subtitle: Text(result.name),
                leading: Icon(Icons.location_on),
              )
            ],
          ),
        ));
      });
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.white,
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Material(
                    elevation: 2,
                    child: Container(
                      color: Colors.white,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.black,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                              Expanded(
                                  child: TextField(
                                controller: destinationController,
                                onTap: () {
                                  setState(() {
                                    doneButton = false;
                                  });
                                },
                                textInputAction: TextInputAction.search,
                                autofocus: false,
                                // scrollPadding: ,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 10, right: 10, top: 5, bottom: 5),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    focusColor: Colors.transparent,
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[200])),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[200])),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey[200]))),
                              )),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 50),
                            child: Text(
                              "Search location or select from map",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  fetchingInfo == true
                      ? LinearProgressIndicator()
                      : Container(height: 0, width: 0),
                  // Padding(
                  //   padding: EdgeInsets.only(
                  //       left: 30, right: 30, top: 10, bottom: 10),
                  //   child: InkWell(
                  //     onTap: () {
                  //       Navigator.of(context).pushNamed('choose_saved');
                  //     },
                  //     child: Row(
                  //       mainAxisSize: MainAxisSize.max,
                  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //       children: <Widget>[
                  //         Row(
                  //           mainAxisSize: MainAxisSize.min,
                  //           children: <Widget>[
                  //             Icon(
                  //               Icons.stars,
                  //               color: Colors.grey,
                  //               size: MediaQuery.of(context).size.height * 0.05,
                  //             ),
                  //             Text(
                  //               "Choose a saved place",
                  //               style: TextStyle(fontWeight: FontWeight.w500),
                  //             )
                  //           ],
                  //         ),
                  //         Icon(Icons.navigate_next)
                  //       ],
                  //     ),
                  //   ),
                  // ),
                  searchResult == null || doneButton == true
                      ? Container()
                      : searchResult.length > 0
                          ? Container(
                              color: Colors.white,
                              width: width(context),
                              child: searchResultWidgets.length <= 5
                                  ? Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        ...searchResultWidgets
                                      ],
                                    )
                                  : ListView(
                                      children: <Widget>[
                                        ...searchResultWidgets
                                      ],
                                    ),
                            )
                          : Container(),
                ],
              ),
            ),
          ),
          Expanded(
              child: Stack(
            children: [
              Provider.of<LocationProvider>(context, listen: true)
                          .currentLocation ==
                      null
                  ? Container()
                  : Stack(
                      children: [
                        MapLocationSelector(
                          initialLocation: LatLng(
                              Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .currentLocation
                                  .latitude,
                              Provider.of<LocationProvider>(context,
                                      listen: false)
                                  .currentLocation
                                  .longitude),
                          key: locationSelectorKey,
                          onCameraMove: () {
                            if (mapCapAlterField == false &&
                                mapUpdateCount >= 1) {
                              setState(() {
                                mapCapAlterField = true;
                              });
                            }
                            if (mapUpdateCount < 2) {
                              mapUpdateCount++;
                            }
                            if (mapCapAlterField == true) {
                              getSearchResultFromMap();
                            }
                          },
                        ),
                        Align(
                          alignment: Alignment.topLeft,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: RaisedButton(
                              color: Colors.white,
                              onPressed: () {
                                getSearchResultFromMap(
                                  location: LatLng(
                                      Provider.of<LocationProvider>(context,
                                              listen: false)
                                          .currentLocation
                                          .latitude,
                                      Provider.of<LocationProvider>(context,
                                              listen: false)
                                          .currentLocation
                                          .longitude),
                                );
                              },
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.my_location_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("USe current Location")
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
              doneButton == true
                  ? Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 20),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: FlatButton(
                            child: Text(
                              'DONE',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            color: Colors.black,
                            onPressed: () {
                              print(selected.name);
                              Navigator.of(context).pop(selected);
                            },
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 0,
                      width: 0,
                    ),
            ],
          ))
        ],
      ),
    );
  }
}
