import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/productPage.dart';
import 'package:fashion_hub/widgets/productCard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../size_config.dart';
import '../cart_page.dart';
import '../searchPage.dart';

class CategoryPage extends StatefulWidget {
  static String routeName = "/newHits";
  final String? heading, category;

  CategoryPage({Key? key, this.heading, this.category}) : super(key: key);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  RangeValues sliderValues = RangeValues(0, 4000);
  bool descending = false;
  int minValue = 0;
  int maxValue = 4000;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        toolbarHeight: 60,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            FontAwesomeIcons.chevronLeft,
            color: primaryColor,
          ),
        ),
        centerTitle: true,
        title: Hero(
          tag: widget.category!,
          child: Text(
            widget.heading!,
            style: GoogleFonts.playfairDisplay(
              color: primaryColor,
              fontSize: 25,
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, SearchPage.routeName);
              },
              icon: Icon(
                Icons.search,
                color: primaryColor,
              )),
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, CartPage.routeName);
              },
              icon: Icon(
                Icons.shopping_cart_outlined,
                color: primaryColor,
              )),
        ],
      ),
      body: StreamBuilder(
        stream: getOptions(minValue, maxValue, descending),
        // .orderBy('Name')
        // .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          Widget? ui;
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> products = [];
            for (var doc in snapshot.data!.docs) {
              if (doc.get("Category") == widget.category) {
                products.add(doc);
              }
            }
            ui = ListView(physics: NeverScrollableScrollPhysics(), children: [
              ExpansionTile(
                textColor: primaryColor,
                iconColor: primaryColor,
                title: Text("Filter"),
                leading: Icon(Icons.filter_list),
                children: [
                  RangeSlider(
                    activeColor: Colors.grey,
                    divisions: 8,
                    min: 0,
                    max: 4000,
                    values: sliderValues,
                    onChanged: (RangeValues value) {
                      setState(() {
                        minValue = value.start.floor();
                        maxValue = value.end.floor();
                        sliderValues = value;
                      });
                    },
                    labels:
                        RangeLabels(minValue.toString(), maxValue.toString()),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text("MIN"), Text("MAX")],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                textColor: primaryColor,
                iconColor: primaryColor,
                title: Text("Sort"),
                leading: Icon(Icons.sort),
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: SizeConfig.width(context) * 0.9,
                      child: DropdownButtonFormField(
                          value: 0,
                          onChanged: (value) {
                            if (value == 0) {
                              setState(() {
                                descending = false;
                              });
                            } else if (value == 1) {
                              setState(() {
                                descending = true;
                              });
                            } else if (value == 2) {
                              setState(() {
                                descending = false;
                              });
                            }
                          },
                          items: [
                            DropdownMenuItem(
                              child: Text("Relevant"),
                              value: 0,
                            ),
                            DropdownMenuItem(
                                child: Text("HIGH TO LOW"), value: 1),
                            DropdownMenuItem(
                                child: Text("LOW TO HIGH"), value: 2),
                          ]),
                    ),
                  ),
                ],
              ),
              Container(
                width: SizeConfig.width(context),
                height: SizeConfig.height(context) - 249,
                child: GridView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    itemCount: products.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: SizeConfig.width(context) *
                            0.45 /
                            (SizeConfig.height(context) * 0.45),
                        crossAxisCount: 2),
                    itemBuilder: (context, index) {
                      return Hero(
                        tag: products[index].get("Name"),
                        child: ProductCard(
                          name: products[index].get("Name"),
                          discription: products[index].get("Discription"),
                          price: products[index].get("Price"),
                          image: products[index].get("image"),
                          discountVal: products[index].get("discountVal"),
                          discount: products[index].get("Discount"),
                          onpressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ProductPage(id: products[index].id);
                            }));
                          },
                        ),
                      );
                    }),
              ),
            ]);
          } else {
            ui = Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }
          return ui;
        },
      ),
    ));
  }

  Stream<QuerySnapshot> getOptions(
      int minValue, int maxValue, bool descending) {
    return FirebaseFirestore.instance
        .collection("products")
        .where('Price', isGreaterThan: minValue, isLessThan: maxValue)
        .orderBy('Price', descending: descending)
        .snapshots();
  }
}
