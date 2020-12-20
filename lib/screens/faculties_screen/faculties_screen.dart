import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/screens/faculties_screen/widgets/faculty_list_item.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:provider/provider.dart';

class FacultiesScreen extends StatefulWidget {
  static String routeName = "/faculties_screen";
  final University university;

  const FacultiesScreen({Key key, this.university}) : super(key: key);

  @override
  _FacultiesScreenState createState() => _FacultiesScreenState();
}

class _FacultiesScreenState extends State<FacultiesScreen> {
  AppNotifier application;
  List<College> allFaculties;
  List<College> faculties;
  College faculty;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    allFaculties = application.getColleges();

    faculties = allFaculties
        .where((f) => f.universityId == widget.university.id)
        .toList();

    print(widget.university.id);
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
              trans(context, 'faculties'),
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
                itemCount: faculties.length,
                itemBuilder: (context, index) =>
                    FacultyListItem(faculty: faculties[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
