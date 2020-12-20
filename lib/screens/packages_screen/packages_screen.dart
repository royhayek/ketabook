import 'package:flutter/material.dart';
import 'package:ketabook/models/package.dart';
import 'package:ketabook/screens/checkout_screen/checkout_screen.dart';
import 'package:ketabook/screens/packages_screen/widgets/package_list_item.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/default_button.dart';

class PackagesScreen extends StatefulWidget {
  static String routeName = "/packages_screen";

  const PackagesScreen({Key key}) : super(key: key);

  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  List<Package> packages = [];
  Package selectedPackage = Package();

  @override
  void initState() {
    super.initState();
    getPackages();
  }

  getPackages() async {
    await HttpService().getPackages().then((p) {
      setState(() {
        packages = p.where((package) => package.id != '1').toList();
        selectedPackage = packages.first;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: getProportionateScreenWidth(16),
            ),
            child: Text(
              trans(context, 'packages'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(30),
                    ),
                  ),
            ),
          ),
          SizedBox(height: getProportionateScreenHeight(2)),
          Divider(
            height: 10,
            thickness: 1,
            color: Color(0xFFEFEFF4),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(
                left: getProportionateScreenWidth(16),
                top: getProportionateScreenHeight(10),
              ),
              shrinkWrap: true,
              itemCount: packages.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedPackage = packages[index];
                    });
                  },
                  child: PackageListItem(
                    name: isEnglish(context)
                        ? packages[index].nameEn
                        : packages[index].nameAr,
                    description: isEnglish(context)
                        ? packages[index].descriptionEn
                        : packages[index].descriptionAr,
                    totalBooks: packages[index].booksLimit,
                    price: packages[index].price,
                    selected:
                        selectedPackage.id == packages[index].id ? true : false,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: getProportionateScreenWidth(16)),
            child: Column(
              children: [
                SizedBox(height: getProportionateScreenHeight(5)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      trans(context, 'price'),
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(17),
                            ),
                          ),
                    ),
                    Text(
                      '${selectedPackage.price} ${trans(context, 'kd')}',
                      style: Theme.of(context).textTheme.headline6.merge(
                            TextStyle(
                              color: Colors.black,
                              fontSize: getProportionateScreenWidth(17),
                            ),
                          ),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
                DefaultButton(
                  press: () =>
                      Navigator.pushNamed(context, CheckoutScreen.routeName),
                  text: trans(context, 'checkout'),
                ),
                SizedBox(height: getProportionateScreenHeight(15)),
              ],
            ),
          )
        ],
      ),
    );
  }
}
