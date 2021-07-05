import 'dart:convert';

import 'package:appentus_assessment/model/api_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<ApiModel> dataList = [];

  @override
  void initState() {
    super.initState();
    getApiData();
  }

  getApiData() async {
    var response = await http.get(Uri.parse('https://picsum.photos/v2/list'));
    print(jsonDecode(response.body));
    var jsonResponse = jsonDecode(response.body);
    jsonResponse.forEach((element) {
      ApiModel model = ApiModel.fromJson(element);
      dataList.add(model);
    });
    print(dataList.length);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Second Screen'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height - kToolbarHeight - 30,
            width: MediaQuery.of(context).size.width,
            child: dataList.length == 0
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    itemCount: dataList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Container(
                        width: MediaQuery.of(context).size.width / 2 - 5,
                        child: Card(
                          elevation: 5.0,
                          child: Column(
                            children: [
                              CachedNetworkImage(
                                placeholder: (context, url) => CircularProgressIndicator(
                                  strokeWidth: 0.5,
                                ),
                                placeholderFadeInDuration: Duration(milliseconds: 100),
                                useOldImageOnUrlChange: true,
                                imageUrl: dataList[index].downloadUrl.toString(),
                                height: MediaQuery.of(context).size.width / 2 - 30,
                                width: MediaQuery.of(context).size.width / 2 - 10,
                              ),
                              Text(
                                dataList[index].author.toString(),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ),
      ),
    );
  }
}
