import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/screens/universities_colleges_screen/widgets/university_list_item.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class UniversitiesCollegesScreen extends StatefulWidget {
  static String routeName = "/universities_colleges_screen";

  const UniversitiesCollegesScreen({Key key}) : super(key: key);

  @override
  _UniversitiesCollegesScreenState createState() =>
      _UniversitiesCollegesScreenState();
}

class _UniversitiesCollegesScreenState
    extends State<UniversitiesCollegesScreen> {
  AppNotifier application;
  List<University> universities = [];

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);

    universities = application.getUniversities();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: isEnglish(context)
              ? EdgeInsets.only(left: getProportionateScreenWidth(16))
              : EdgeInsets.only(right: getProportionateScreenWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans(context, 'universities_and_colleges'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(25),
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(20)),
              ListView.builder(
                cacheExtent: 50,
                itemCount: universities.length,
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return UniversityListItem(university: universities[index]);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
