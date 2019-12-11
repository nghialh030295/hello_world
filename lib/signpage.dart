import 'package:flutter/material.dart';

import 'Model/SignModel.dart';
import 'Model/SignTypeModel.dart';
import 'processdatabase.dart';

class SignPage extends StatefulWidget {
  @override
  _SignPageState createState() => _SignPageState();
}

class _SignPageState extends State<SignPage> {
  SignModel sign;
  List<SignModel> listSign = [];
  List<SignTypeModel> listModelSignType = [];
  List listSignType = [];
  List<Widget> tabs = [];
  List<Widget> bodyTabs = new List();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initDatabase().then((v) async {
      for (int type = 9; type <= 16; type++) {
        this.listSign = await getListSign(v, type);
        bodyTabs.add(buildListView(listSign));
      }
      for (SignModel s in listSign) {
        this.sign = s;
      }
      this.listModelSignType = await getListSignType(v);
      for (var type in listModelSignType) {
        listSignType.add(type.zTypeSign);
      }
      setState(() {});
    });
  }

  Widget build(BuildContext context) {

    if (listSign.length == 0)
      return Container(
        color: Colors.white,
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
        ),
      );

    if (listSign.length != 0){
      tabs.clear();
      for (var i in listSignType) {
        tabs.add(tabBar(i));
      }}

    return DefaultTabController(
      length: listSignType.length,
      child: Scaffold(
          appBar: AppBar(
            title: Text(
              'Biển báo giao thông',
              style: TextStyle(fontSize: 20.0),
            ),
            bottom: PreferredSize(
                child: TabBar(
                  isScrollable: true,
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  indicatorColor: Colors.white,
                  tabs: tabs,
                ),
                preferredSize: Size.fromHeight(40.0)),
          ),
          body: TabBarView(children: bodyTabs)),
    );
  }

  Widget tabBar(String signType) {
    return Text(
      signType,
      style: TextStyle(fontSize: 16),
    );
  }

  Widget buildListView(List<SignModel> list) {
    return ListView(
      children: list.map((f) => trafficSign(f)).toList(),
    );
  }

  Widget trafficSign(SignModel sign) {
    return Card(
      elevation: 3,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(5),
            height: 100,
            width: 100,
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("assets/imageapp/${sign.zImageSign}"),fit: BoxFit.contain
                )),
          ),
          Flexible(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(
                    sign.zNameSign,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    sign.zDescSign,
                    style: TextStyle(fontSize: 16),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
