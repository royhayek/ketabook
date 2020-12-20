import 'package:flutter/material.dart';
import 'package:ketabook/constants.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';

class PackageListItem extends StatelessWidget {
  final String name;
  final String totalBooks;
  final String description;
  final String price;
  final bool selected;

  const PackageListItem({
    Key key,
    this.name,
    this.description,
    this.totalBooks,
    this.price,
    this.selected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(right: getProportionateScreenWidth(16)),
            child: Container(
              padding: EdgeInsets.all(5),
              decoration: selected != null
                  ? selected
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(
                              SizeConfig.screenWidth / 50),
                          border: Border.all(color: kPrimaryColor, width: 1.8),
                        )
                      : BoxDecoration(
                          border:
                              Border.all(width: 1.8, color: Colors.transparent),
                        )
                  : BoxDecoration(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: getProportionateScreenWidth(80),
                    height: getProportionateScreenHeight(120),
                    child: Card(
                      margin: EdgeInsets.all(0),
                      elevation: 5,
                      color: Color(0xFFC8C7CC),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SizeConfig.screenWidth / 50),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(
                            'assets/images/PileOfBooks.jpg',
                            fit: BoxFit.fill,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                          Container(color: Colors.black12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                totalBooks,
                                style:
                                    Theme.of(context).textTheme.headline6.merge(
                                          TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getProportionateScreenWidth(18),
                                          ),
                                        ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                trans(context, 'books'),
                                style:
                                    Theme.of(context).textTheme.headline6.merge(
                                          TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize:
                                                getProportionateScreenWidth(17),
                                          ),
                                        ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: getProportionateScreenWidth(12)),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style:
                                    Theme.of(context).textTheme.headline6.merge(
                                          TextStyle(
                                            color: Colors.black,
                                            fontSize:
                                                getProportionateScreenWidth(16),
                                          ),
                                        ),
                              ),
                            ),
                            Text(
                              '$price ${trans(context, 'kd')}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .merge(
                                    TextStyle(
                                      color: Colors.black,
                                      fontSize: getProportionateScreenWidth(15),
                                    ),
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: getProportionateScreenHeight(10)),
                        SizedBox(
                          width: getProportionateScreenWidth(185),
                          child: Text(
                            description,
                            style: Theme.of(context).textTheme.headline6.merge(
                                  TextStyle(
                                    color: Color(0xFF666666),
                                    fontSize: getProportionateScreenWidth(14),
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
