import 'package:flutter/material.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/speciality.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/custom_filled_drop_down.dart';
import 'package:ketabook/widgets/custom_filled_text_field.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:provider/provider.dart';

class FilterScreen extends StatefulWidget {
  static String routeName = "/filter_screen";

  final Function applyFilter;

  const FilterScreen({Key key, this.applyFilter}) : super(key: key);

  @override
  _FilterScreenState createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  AppNotifier application;
  TextEditingController nameController = new TextEditingController();

  List<University> allUnis = [];
  List<College> allColleges = [];
  List<Speciality> allMajors = [];
  List<College> availableFaculties = [];
  List<Speciality> availableMajors = [];

  String selUniversity;
  String selFaculty;
  String selMajor;

  String univeristyId;
  String collegeId;
  String majorId;

  bool facultiesEnabled = false;
  bool majorsEnabled = true;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);

    setState(() {
      allUnis = application.getUniversities();
      allColleges = application.getColleges();
      allMajors = application.getSpecialities();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans(context, 'search_filter'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(30),
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(50)),
              CustomFilledDropDown(
                height: SizeConfig.screenHeight / 16,
                hint: trans(context, 'choose_the_university_or_college'),
                items: allUnis.map((University value) {
                  return new DropdownMenuItem<String>(
                    value: isEnglish(context) ? value.nameEn : value.nameAr,
                    child: new Text(
                        isEnglish(context) ? value.nameEn : value.nameAr),
                  );
                }).toList(),
                selectedValue: selUniversity,
                onChanged: (value) {
                  setState(() {
                    availableFaculties.clear();
                    availableMajors.clear();
                    selFaculty = null;
                    selMajor = null;
                    selUniversity = value;
                    univeristyId = isEnglish(context)
                        ? allUnis
                            .singleWhere((u) => u.nameEn == selUniversity)
                            .id
                        : allUnis
                            .singleWhere((u) => u.nameAr == selUniversity)
                            .id;
                  });
                  if (univeristyId.isNotEmpty && univeristyId != '') {
                    allColleges.forEach((c) {
                      if (c.universityId == univeristyId) {
                        setState(() {
                          availableFaculties.add(c);
                          facultiesEnabled = true;
                        });
                      }
                    });
                  }
                },
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              CustomFilledDropDown(
                height: SizeConfig.screenHeight / 16,
                hint: trans(context, 'choose_the_faculty'),
                items: facultiesEnabled
                    ? availableFaculties.map((College c) {
                        return new DropdownMenuItem<String>(
                          value: isEnglish(context) ? c.nameEn : c.nameAr,
                          child: new Text(
                            isEnglish(context) ? c.nameEn : c.nameAr,
                          ),
                        );
                      }).toList()
                    : null,
                selectedValue: selFaculty,
                onChanged: (value) {
                  setState(() {
                    availableMajors.clear();
                    selMajor = null;
                    selFaculty = value;
                    collegeId = isEnglish(context)
                        ? availableFaculties
                            .singleWhere((f) =>
                                f.nameEn == selFaculty &&
                                f.universityId == univeristyId)
                            .id
                        : availableFaculties
                            .singleWhere((f) =>
                                f.nameAr == selFaculty &&
                                f.universityId == univeristyId)
                            .id;
                  });
                  allMajors.forEach((m) {
                    if (m.collegeId == collegeId) {
                      setState(() {
                        availableMajors.add(m);
                        majorsEnabled = true;
                      });
                    }
                  });
                },
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              CustomFilledDropDown(
                height: SizeConfig.screenHeight / 16,
                hint: trans(context, 'choose_the_major'),
                items: majorsEnabled
                    ? availableMajors.map(
                        (Speciality s) {
                          return DropdownMenuItem<String>(
                            value: isEnglish(context) ? s.nameEn : s.nameAr,
                            child: Text(
                              isEnglish(context) ? s.nameEn : s.nameAr,
                            ),
                          );
                        },
                      ).toList()
                    : null,
                selectedValue: selMajor,
                onChanged: (value) {
                  setState(() {
                    selMajor = value;
                    majorId = isEnglish(context)
                        ? availableMajors
                            .singleWhere((f) =>
                                f.nameEn == value && f.collegeId == collegeId)
                            .id
                        : availableMajors
                            .singleWhere((f) =>
                                f.nameAr == value && f.collegeId == collegeId)
                            .id;
                  });
                },
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              CustomFilledTextField(
                height: SizeConfig.screenHeight / 16,
                hint: trans(context, 'book_name'),
                controller: nameController,
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              DefaultButton(
                text: trans(context, 'apply_filter'),
                press: () {
                  widget.applyFilter(
                      univeristyId, collegeId, majorId, nameController.text);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
