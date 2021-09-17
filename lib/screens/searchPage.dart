import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_hub/screens/Category%20Page/categoryPage.dart';
import 'package:fashion_hub/screens/productPage.dart';
import 'package:fashion_hub/size_config.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class SearchPage extends StatefulWidget {
  static String routeName = '/searchPage';

  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController controller = TextEditingController();
  List<Widget> matchList = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: StreamBuilder(
      stream: FirebaseFirestore.instance.collection('products').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Widget ui;
        if (snapshot.hasData) {
          List products = [];
          snapshot.data!.docs.forEach((element) {
            products.add(element.get('Name'));
          });
          print(products.length);
          ui = ListView(children: [
            SizedBox(
              height: 20,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      FontAwesomeIcons.chevronLeft,
                      color: primaryColor,
                    ),
                  ),
                ),
                Container(
                    height: 90,
                    width: SizeConfig.width(context) * 0.7,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 6.0, horizontal: 20),
                      child: TextFormField(
                        onChanged: (value) {
                          int j = -1;
                          List<Widget> temp = [];
                          for (String i in products) {
                            j++;
                            print(j);
                            if (value.isEmpty) {
                              setState(() {
                                matchList = [];
                              });
                            }
                            if (value ==
                                i.substring(0, value.length).toLowerCase()) {
                              String id = snapshot.data!.docs[j].id;
                              temp.add(Padding(
                                padding: EdgeInsets.all(4.0),
                                child: ListTile(
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return ProductPage(id: id);
                                    }));
                                  },
                                  leading: Image.network(
                                    snapshot.data!.docs[j].get('image'),
                                    cacheHeight: (SizeConfig.height(context) *
                                            0.45 *
                                            0.6)
                                        .round(),
                                  ),
                                  title: Text(i),
                                ),
                              ));
                              setState(() {
                                matchList = temp;
                              });
                            }
                          }
                        },
                        controller: controller,
                        style: GoogleFonts.roboto(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        decoration: InputDecoration(
                            hintText: 'Search',
                            focusedBorder: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(color: primaryColor)),
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(7)),
                                borderSide: BorderSide(
                                  color: greyColor,
                                ))),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.0),
                  child: IconButton(
                    onPressed: () {
                      print(controller.text);
                    },
                    icon: Icon(
                      Icons.search,
                      size: 30,
                      color: primaryColor,
                    ),
                  ),
                ),
              ],
            ),
            matchList.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Suggestions',
                          style: homeHeading,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            height: 300,
                            width: 400,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    suggestionTile(
                                      image:
                                          'assets/images/newHitsCategory.jpg',
                                      text: 'New Hits',
                                      category: 'newHits',
                                    ),
                                    suggestionTile(
                                      image: 'assets/images/dressCategory.jpg',
                                      text: 'Dress',
                                      category: 'dress',
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    suggestionTile(
                                      image: 'assets/images/shoesCategory.jpg',
                                      text: 'Shoes',
                                      category: 'shoes',
                                    ),
                                    suggestionTile(
                                      image: 'assets/images/beautyCategory.jpg',
                                      text: 'Beauty',
                                      category: 'beauty',
                                    ),
                                  ],
                                )
                              ],
                            )),
                      ],
                    ),
                  )
                : Container(
                    height: SizeConfig.height(context) * 0.78,
                    width: SizeConfig.width(context),
                    child: ListView(
                      children: matchList,
                    ),
                  ),
          ]);
          return ui;
        } else {
          ui = Center(
            child: CircularProgressIndicator(
              color: primaryColor,
            ),
          );
        }
        return ui;
      },
    )));
  }
}

class suggestionTile extends StatelessWidget {
  final String? image;
  final String? category;
  final String? text;

  const suggestionTile({
    Key? key,
    this.image,
    this.category,
    this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return CategoryPage(
            category: category!,
            heading: text!,
          );
        }));
      },
      child: Row(
        children: [
          Container(
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(
                      image!,
                    ),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(10)),
            height: 70,
            width: 70,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text!,
            style: TextStyle(
                color: primaryColor, fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
