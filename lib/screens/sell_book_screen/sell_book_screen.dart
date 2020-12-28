import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:ketabook/providers/auth_provider.dart';
import 'package:ketabook/providers/app_provider.dart';
import 'package:ketabook/providers/data_provider.dart';
import 'package:ketabook/models/book.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/photo.dart';
import 'package:ketabook/models/photo_picker.dart';
import 'package:ketabook/models/speciality.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/screens/login_screen/login_screen.dart';
import 'package:ketabook/screens/tabs_screen/tabs_screen.dart';
import 'package:ketabook/services/http_services.dart';
import 'package:ketabook/services/web_service.dart';
import 'package:ketabook/session_manager.dart';
import 'package:ketabook/size_config.dart';
import 'package:ketabook/utils/utils.dart';
import 'package:ketabook/widgets/custom_filled_drop_down.dart';
import 'package:ketabook/widgets/custom_filled_text_field.dart';
import 'package:ketabook/widgets/default_button.dart';
import 'package:ketabook/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class SellBookScreen extends StatefulWidget {
  final Book book;

  const SellBookScreen({Key key, this.book}) : super(key: key);

  @override
  _SellBookScreenState createState() => _SellBookScreenState();
}

class _SellBookScreenState extends State<SellBookScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppNotifier application;
  DataProvider data;
  AuthProvider auth;
  SessionManager session = SessionManager();

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');
  DateFormat timeFormat = DateFormat('kk:mm:ss');

  TextEditingController nameController = new TextEditingController();
  TextEditingController priceController = new TextEditingController();
  TextEditingController descController = new TextEditingController();

  List<University> allUnis = [];
  List<College> allColleges = [];
  List<Speciality> allMajors = [];
  List<College> availableFaculties = [];
  List<Speciality> availableMajors = [];
  List<Photo> images = [];
  List<String> imagesString = [];
  String selUniversity;
  String selFaculty;
  String selMajor;

  bool facultiesEnabled = false;
  bool majorsEnabled = true;
  bool isAddingBook = false;
  String userId;

  String image;
  String image2;
  String image3;
  String image4;

  final picker = ImagePicker();

  File _tempImage1;
  File _tempImage2;
  File _tempImage3;
  File _tempImage4;

  File _image1;
  File _image2;
  File _image3;
  File _image4;

  @override
  void initState() {
    super.initState();
    application = Provider.of<AppNotifier>(context, listen: false);
    data = Provider.of<DataProvider>(context, listen: false);
    auth = Provider.of<AuthProvider>(context, listen: false);

    setState(() {
      allUnis = application.getUniversities();
      allColleges = application.getColleges();
      allMajors = application.getSpecialities();
    });

    session.getUserId().then((id) {
      if (id != null)
        setState(() {
          userId = id;
        });
      else
        showNeedLoginDialog(
          context,
          trans(context, 'sorry_you_need_to_login_to_start_selling_books'),
          () => Navigator.popUntil(
            context,
            ModalRoute.withName(LoginScreen.routeName),
          ),
          () {
            Navigator.pop(context);
            TabsScreen.setPageIndex(context, 0);
          },
        );
    });

    // getAllowedBooksNo();
  }

  // getAllowedBooksNo() async {
  //   await HttpService()
  //       .getUserPackage(application.getUserInfo())
  //       .then((noOfBooks) {
  //     setState(() {
  //       totalBooksAllowed = noOfBooks;
  //     });
  //   });
  // }

  getBookImages() async {
    await HttpService().getBookImages(widget.book.id).then((p) {
      setState(() {
        images = p;
        images.forEach((i) {
          setState(() {
            imagesString.add(i.photo);
          });
        });
        image = imagesString[0];
        if (imagesString.length > 1) image2 = imagesString[1];
        if (imagesString.length > 2) image3 = imagesString[2];
        if (imagesString.length > 3) image4 = imagesString[3];
      });
    });
  }

  _getImage(bool fromCamera, int imageNo) async {
    PickedFile pickedFile;

    if (fromCamera)
      pickedFile = await picker.getImage(
        source: ImageSource.camera,
        imageQuality: 50,
      );
    else
      pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50,
      );

    _cropImage(pickedFile.path, imageNo);
  }

  _cropImage(filePath, imageNo) async {
    File croppedImage = await ImageCropper.cropImage(
      sourcePath: filePath,
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (imageNo == 1)
      setState(() {
        if (croppedImage != null) {
          _tempImage1 = File(croppedImage.path);
          _image1 = File(croppedImage.path);
        } else
          print('Image 1 is not selected.');
      });
    else if (imageNo == 2)
      setState(() {
        if (croppedImage != null) {
          _tempImage2 = File(croppedImage.path);
          _image2 = File(croppedImage.path);
        } else
          print('Image 2 is not selected.');
      });
    else if (imageNo == 3)
      setState(() {
        if (croppedImage != null) {
          _tempImage3 = File(croppedImage.path);
          _image3 = File(croppedImage.path);
        } else
          print('Image 3 is not selected.');
      });
    else if (imageNo == 4)
      setState(() {
        if (croppedImage != null) {
          _tempImage4 = File(croppedImage.path);
          _image4 = File(croppedImage.path);
        } else
          print('Image 4 is not selected.');
      });
  }

  void _showPicker(context, int imageNo) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getImage(false, imageNo);
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getImage(true, imageNo);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: SizeConfig.screenWidth / 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans(context, 'sell_book'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(30),
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(14)),
              // totalBooksAllowed != 0
              // ? booksNo < totalBooksAllowed
              // ? Text(
              //     '${trans(context, 'used')} $booksNo ${trans(context, 'of')} $totalBooksAllowed ${trans(context, 'free_books')}',
              //     style: Theme.of(context).textTheme.headline6.merge(
              //           TextStyle(
              //             color: Color(0xFF666666),
              //             fontSize: getProportionateScreenWidth(13),
              //           ),
              //         ),
              //   )
              // :
              //  Container(
              //     padding: EdgeInsets.all(5),
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(
              //           SizeConfig.screenWidth / 50),
              //       color: Colors.red,
              //     ),
              //     child: Text(
              //       '${trans(context, 'used')} $booksNo ${trans(context, 'of')} $totalBooksAllowed ${trans(context, 'free_books')}',
              //       style: Theme.of(context).textTheme.headline6.merge(
              //             TextStyle(
              //               color: Colors.white,
              //               fontSize: getProportionateScreenWidth(13),
              //             ),
              //           ),
              //     ),
              //   ),
              // : Container(height: 15),
              SizedBox(height: getProportionateScreenHeight(15)),
              CustomFilledDropDown(
                height: SizeConfig.screenHeight / 15,
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
                  String univeristyId;
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
                height: SizeConfig.screenHeight / 15,
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
                  String collegeId;
                  setState(() {
                    availableMajors.clear();
                    selMajor = null;
                    selFaculty = value;
                    collegeId = isEnglish(context)
                        ? availableFaculties
                            .singleWhere((f) => f.nameEn == selFaculty)
                            .id
                        : availableFaculties
                            .singleWhere((f) => f.nameAr == selFaculty)
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
                height: SizeConfig.screenHeight / 15,
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
                  });
                },
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              CustomFilledTextField(
                height: SizeConfig.screenHeight / 15,
                hint: trans(context, 'book_name'),
                controller: nameController,
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              CustomFilledTextField(
                hint: trans(context, 'description'),
                controller: descController,
                height: SizeConfig.screenHeight / 8,
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              CustomFilledTextField(
                height: SizeConfig.screenHeight / 15,
                hint: trans(context, 'price'),
                controller: priceController,
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              Container(
                width: double.infinity,
                height: isEnglish(context)
                    ? SizeConfig.screenHeight / 5
                    : SizeConfig.screenHeight / 4.3,
                decoration: BoxDecoration(
                  color: Color(0xFFEFEFF4),
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth / 50),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      SizeConfig.screenWidth * 0.01,
                      SizeConfig.screenHeight * 0.01,
                      SizeConfig.screenWidth * 0.01,
                      0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        trans(context, 'choose_photos'),
                        style: Theme.of(context).textTheme.headline6.merge(
                              TextStyle(
                                color: Color(0xFF8A8A8F),
                                fontWeight: FontWeight.w400,
                                fontSize: getProportionateScreenWidth(15),
                              ),
                            ),
                      ),
                      SizedBox(height: getProportionateScreenHeight(10)),
                      Row(
                        children: [
                          imagePickerSingleField(1,
                              image: _image1, photo: image),
                          imagePickerSingleField(2,
                              image: _image2, photo: image2),
                          imagePickerSingleField(3,
                              image: _image3, photo: image3),
                          imagePickerSingleField(4,
                              image: _image4, photo: image4),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              DefaultButton(
                text:
                    // booksNo < totalBooksAllowed
                    //     ?
                    trans(context, 'add_book'),
                // : trans(context, 'buy_a_package'),
                press: () {
                  _addBook();
                  // if (booksNo < totalBooksAllowed)
                  //   setState(() {
                  //     booksNo++;
                  //   });
                  // else
                  //   Navigator.pushNamed(context, PackagesScreen.routeName);
                },
                loading: isAddingBook,
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
            ],
          ),
        ),
      ),
    );
  }

  _addBook() async {
    String _fileName = '';
    String _fileName2 = '';
    String _fileName3 = '';
    String _fileName4 = '';

    if (selUniversity != null &&
        selFaculty != null &&
        selMajor != null &&
        nameController.text.isNotEmpty &&
        descController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        _tempImage1 != null) {
      setState(() {
        isAddingBook = true;
      });
      await loadingDialog(context).show();

      if (_tempImage1 != null) {
        _fileName = _tempImage1.path.split('/').last;
      }
      if (_tempImage2 != null) {
        _fileName2 = _tempImage2.path.split('/').last;
      }
      if (_tempImage3 != null) {
        _fileName3 = _tempImage3.path.split('/').last;
      }
      if (_tempImage4 != null) {
        _fileName4 = _tempImage4.path.split('/').last;
      }

      Book book = Book();
      book.userId = userId;
      book.universityId = allUnis
          .firstWhere(
              (u) => u.nameEn == selUniversity || u.nameAr == selUniversity)
          .id;
      book.collegeId = allColleges
          .firstWhere((c) =>
              (c.nameEn == selFaculty || c.nameAr == selFaculty) &&
              c.universityId == book.universityId)
          .id;
      book.specialityId = allMajors
          .firstWhere((m) =>
              (m.nameEn == selMajor || m.nameAr == selMajor) &&
              m.collegeId == book.collegeId)
          .id;

      book.name = nameController.text;
      book.descp = descController.text;
      book.price = priceController.text;
      book.deliveryFee = application.getDeliveryFee().first.fee;
      book.datePost = dateFormat.format(DateTime.now());
      book.timePost = timeFormat.format(DateTime.now());
      book.isUpdateData = "0";

      List<String> fileNames = [];
      fileNames.add(_fileName);
      fileNames.add(_fileName2);
      fileNames.add(_fileName3);
      fileNames.add(_fileName4);

      print('getting all book images');
      List<PhotoPicker> photos = [];
      photos.add(PhotoPicker(no: '1', image: _image1, imageName: _fileName));
      photos.add(PhotoPicker(no: '2', image: _image2, imageName: _fileName2));
      photos.add(PhotoPicker(no: '3', image: _image3, imageName: _fileName3));
      photos.add(PhotoPicker(no: '4', image: _image4, imageName: _fileName4));

      FocusScope.of(context).requestFocus(FocusNode());

      print('sending the post request');
      await HttpService().addBook(context, book, photos);
      clearFields();
      data.clearAllRecentBooks();
      data.fetchAllRecentBooks(
        context: context,
        id: Provider.of<AuthProvider>(context, listen: false).user.id,
      );
      data.clearLimitedRecentBooks();
      data.fetchLimitedRecentBooks(
        context: context,
        id: Provider.of<AuthProvider>(context, listen: false).user.id,
      );
      setState(() {
        isAddingBook = false;
      });
    } else {
      Toast.show(trans(context, 'please_fill_all_information'), context);
    }
  }

  clearFields() {
    setState(() {
      selUniversity = null;
      selFaculty = null;
      selMajor = null;
      availableFaculties.clear();
      availableMajors.clear();
      nameController.clear();
      descController.clear();
      priceController.clear();
      images.clear();
      image = null;
      image2 = null;
      image3 = null;
      image4 = null;
      _tempImage1 = null;
      _tempImage2 = null;
      _tempImage3 = null;
      _tempImage4 = null;
      _image1 = null;
      if (_image2 != null) _image2 = null;
      if (_image3 != null) _image3 = null;
      if (_image4 != null) _image4 = null;
    });
  }

  Widget imagePickerSingleField(int imageNo, {File image, String photo}) {
    return Expanded(
      child: InkWell(
        onTap: () => _showPicker(context, imageNo),
        child: Container(
          height: isEnglish(context)
              ? SizeConfig.screenHeight / 7.2
              : SizeConfig.screenHeight / 7,
          padding: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50)),
          child: Card(
            elevation: 0,
            color: Colors.white,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50),
            ),
            child: image == null
                ? photo == null
                    ? Icon(Icons.add, color: Color(0xFF8A8A8F))
                    : Image.network(
                        '${WebService.getImageUrl()}$photo',
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      )
                : Image.file(image, fit: BoxFit.cover, width: double.infinity),
          ),
        ),
      ),
    );
  }
}
