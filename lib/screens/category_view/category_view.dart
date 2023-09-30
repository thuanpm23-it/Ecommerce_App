import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../constants/routes.dart';
import '../../firebase_helper/firebase_firestore_helper/firebase_firestore.dart';
import '../../models/category_model/category_model.dart';
import '../../models/product_model/product_model.dart';
import '../product_details/product_details.dart';

class CategoryView extends StatefulWidget {
  final CategoryModel categoryModel;
  const CategoryView({super.key, required this.categoryModel});

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  List<ProductModel> productsList = [];

  bool isLoading = false;
  void getCategoryList() async {
    setState(() {
      isLoading = true;
    });
    productsList = await FirebaseFirestoreHelper.instance
        .getCategoryViewProduct(widget.categoryModel.id);
    productsList.shuffle();
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCategoryList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          widget.categoryModel.name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18.0,
            // fontWeight: FontWeight.bold,
          ),
        ),
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
                  const SizedBox(height: 12),
                  productsList.isEmpty
                      ? const Center(
                          child: Text("Products is empty!"),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: GridView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              primary: false,
                              itemCount: productsList.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 0.7,
                                      crossAxisCount: 2),
                              itemBuilder: (ctx, index) {
                                ProductModel singleProduct =
                                    productsList[index];
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
                              }),
                        ),
                  const SizedBox(
                    height: 12.0,
                  ),
                ],
              ),
            ),
    );
  }
}
