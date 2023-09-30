import 'package:firebase_app/firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import 'package:firebase_app/models/category_model/category_model.dart';
import 'package:firebase_app/models/product_model/product_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/routes.dart';
import '../../provider/app_provider.dart';
import '../cart_screen/cart _screen.dart';
import '../category_view/category_view.dart';
import '../product_details/product_details.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categoriesList = [];
  List<ProductModel> productsList = [];
  List<ProductModel> searchList = [];

  bool isLoading = false;

  TextEditingController search = TextEditingController();

  @override
  void initState() {
    super.initState();
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
    appProvider.getUserInfoFirebase();
    getCategoryList();
  }

  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });

    // FirebaseFirestoreHelper.instance.updateTokenFromFirebase();
    categoriesList = await FirebaseFirestoreHelper.instance.getCategories();
    productsList = await FirebaseFirestoreHelper.instance.getBestProducts();
    productsList.shuffle();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchProducts(String value) {
    searchList = productsList
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
    setState(() {});
  }

  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text(
          "TNH Shop",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Routes.instance
                  .push(widget: const CartScreen(), context: context);
            },
            icon: const Icon(Icons.shopping_cart),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: Container(
                height: 100,
                width: 100,
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TextFormField(
                      controller: search,
                      onChanged: (String value) {
                        searchProducts(value);
                        setState(() {
                          isSearching = value.isNotEmpty;
                        });
                      },
                      decoration: const InputDecoration(hintText: "Search...."),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  Visibility(
                    visible: !isSearching,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Text(
                            "Categories",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: categoriesList
                                .map(
                                  (e) => Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: CupertinoButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {
                                        Routes.instance.push(
                                          widget:
                                              CategoryView(categoryModel: e),
                                          context: context,
                                        );
                                      },
                                      child: Card(
                                        color: Colors.white,
                                        elevation: 3.0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(0),
                                        ),
                                        child: SizedBox(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(e.image),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Padding(
                          padding: EdgeInsets.all(12),
                          child: Text(
                            "Products",
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                            padding: const EdgeInsets.only(bottom: 60),
                            shrinkWrap: true,
                            primary: false,
                            itemCount: productsList.length,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                              childAspectRatio: 0.7,
                              crossAxisCount: 2,
                            ),
                            itemBuilder: (ctx, index) {
                              ProductModel singleProduct = productsList[index];
                              return Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(0),
                                ),
                                child: CupertinoButton(
                                  onPressed: () {
                                    Routes.instance.push(
                                      widget: ProductDetails(
                                        singleProduct: singleProduct,
                                      ),
                                      context: context,
                                    );
                                  },
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 12.0),
                                      Image.network(
                                        singleProduct.image,
                                        height: 130,
                                        width: 130,
                                      ),
                                      const SizedBox(height: 12.0),
                                      Text(
                                        singleProduct.name,
                                        style: const TextStyle(
                                          fontSize: 18.0,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Price: \$${singleProduct.price}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      // const SizedBox(height: 30.0),
                                      // SizedBox(
                                      //   height: 45,
                                      //   width: 140,
                                      //   child: OutlinedButton(
                                      //     onPressed: () {
                                      //       Routes.instance.push(
                                      //         widget: ProductDetails(
                                      //           singleProduct: singleProduct,
                                      //         ),
                                      //         context: context,
                                      //       );
                                      //     },
                                      //     child: const Text("Details"),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: isSearching,
                    child: searchList.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: GridView.builder(
                              padding: const EdgeInsets.only(bottom: 50),
                              shrinkWrap: true,
                              primary: false,
                              itemCount: searchList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 20,
                                childAspectRatio: 0.7,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (ctx, index) {
                                ProductModel singleProduct = searchList[index];
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  child: CupertinoButton(
                                    onPressed: () {
                                      Routes.instance.push(
                                        widget: ProductDetails(
                                          singleProduct: singleProduct,
                                        ),
                                        context: context,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        const SizedBox(height: 12.0),
                                        Image.network(
                                          singleProduct.image,
                                          height: 130,
                                          width: 130,
                                        ),
                                        const SizedBox(height: 12.0),
                                        Text(
                                          singleProduct.name,
                                          style: const TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          "Price: \$${singleProduct.price}",
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        // const SizedBox(height: 30.0),
                                        // SizedBox(
                                        //   height: 45,
                                        //   width: 140,
                                        //   child: OutlinedButton(
                                        //     onPressed: () {
                                        //       Routes.instance.push(
                                        //         widget: ProductDetails(
                                        //           singleProduct: singleProduct,
                                        //         ),
                                        //         context: context,
                                        //       );
                                        //     },
                                        //     child: const Text("Details"),
                                        //   ),
                                        // ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : const Center(
                            child: Text("No matching products found"),
                          ),
                  ),
                ],
              ),
            ),
    );
  }

  bool isSearched() {
    if (search.text.isNotEmpty && searchList.isEmpty) {
      return true;
    } else if (search.text.isEmpty && searchList.isNotEmpty) {
      return false;
    } else if (searchList.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }
}
