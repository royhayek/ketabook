import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/speciality.dart';
import 'package:ketabook/screens/faculties_screen/widgets/faculty_list_item.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class MajorsScreen extends StatefulWidget {
  static String routeName = "/faculties_screen";

  final College faculty;

  const MajorsScreen({Key key, this.faculty}) : super(key: key);

  @override
  _MajorsScreenState createState() => _MajorsScreenState();
}

class _MajorsScreenState extends State<MajorsScreen> {
  AppNotifier application;
  List<Speciality> allMajors;
  List<Speciality> majors;
  College faculty;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    allMajors = application.getSpecialities();
    majors = allMajors.where((f) => f.collegeId == widget.faculty.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: isEnglish(context)
            ? EdgeInsets.only(left: getProportionateScreenWidth(16))
            : EdgeInsets.only(right: getProportionateScreenWidth(16)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              trans(context, 'majors'),
              style: Theme.of(context).textTheme.headline6.merge(
                    TextStyle(
                      color: Colors.black,
                      fontSize: getProportionateScreenWidth(25),
                    ),
                  ),
            ),
            SizedBox(height: getProportionateScreenHeight(20)),
            Expanded(
              child: ListView.builder(
                cacheExtent: 50,
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: majors.length,
                itemBuilder: (context, index) => FacultyListItem(
                  major: majors[index],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
