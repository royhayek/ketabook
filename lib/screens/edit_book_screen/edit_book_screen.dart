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
import 'package:fluttertoast/fluttertoast.dart';

class EditBookScreen extends StatefulWidget {
  final Book book;

  const EditBookScreen({Key key, this.book}) : super(key: key);

  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  AppNotifier application;
  AuthProvider auth;
  DataProvider data;
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
  String userId;
  bool isEditing = false;

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
    auth = Provider.of<AuthProvider>(context, listen: false);
    data = Provider.of<DataProvider>(context, listen: false);

    session.getUserId().then((id) {
      setState(() {
        userId = id;
      });
    });

    allUnis = application.getUniversities();
    allColleges = application.getColleges();
    allMajors = application.getSpecialities();

    getBookImages();

    setState(() {
      facultiesEnabled = true;
      majorsEnabled = true;
      availableFaculties = allColleges
          .where((e) => e.universityId == widget.book.universityId)
          .toList();
      availableMajors =
          allMajors.where((e) => e.collegeId == widget.book.collegeId).toList();
    });

    University selUni =
        allUnis.where((u) => u.id == widget.book.universityId).single;
    College selCol = allColleges
        .where((u) =>
            u.id == widget.book.collegeId &&
            u.universityId == widget.book.universityId)
        .single;
    Speciality selMaj = allMajors
        .where((u) =>
            u.id == widget.book.specialityId &&
            u.collegeId == widget.book.collegeId)
        .single;

    selUniversity = isEnglish(context) ? selUni.nameEn : selUni.nameAr;
    selFaculty = isEnglish(context) ? selCol.nameEn : selCol.nameAr;
    selMajor = isEnglish(context) ? selMaj.nameEn : selMaj.nameAr;
    nameController.text = widget.book.name;
    descController.text = widget.book.descp;
    priceController.text = widget.book.price;
    //image = widget.book.photo;
    // image2 = widget.book.photo2;
    // image3 = widget.book.photo3;
    // image4 = widget.book.photo4;
  }

  getBookImages() async {
    await HttpService().getBookImages(widget.book.id).then((p) {
      setState(() {
        images = p;
        images.forEach((i) {
          setState(() {
            imagesString.add(i.photo);
          });
        });
        if (images.length > 0) image = imagesString[0];
        // if (images.length > 1) image2 = images[1].photo;
        // if (images.length > 2) image3 = images[2].photo;
        // if (images.length > 3) image4 = images[3].photo;
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
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                trans(context, 'edit_book'),
                style: Theme.of(context).textTheme.headline6.merge(
                      TextStyle(
                        color: Colors.black,
                        fontSize: getProportionateScreenWidth(30),
                      ),
                    ),
              ),
              SizedBox(height: getProportionateScreenHeight(14)),
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
                        if (!isEditing) availableMajors.add(m);
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
                height: getProportionateScreenHeight(162),
                decoration: BoxDecoration(
                  color: Color(0xFFEFEFF4),
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth / 50),
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(6, 10, 6, 0),
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
                              image: _image1,
                              photo: images.length > 0 ? images[0] : null),
                          imagePickerSingleField(2,
                              image: _image2,
                              photo: images.length > 1 ? images[1] : null),
                          imagePickerSingleField(3,
                              image: _image3,
                              photo: images.length > 2 ? images[2] : null),
                          imagePickerSingleField(4,
                              image: _image4,
                              photo: images.length > 3 ? images[3] : null),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: getProportionateScreenHeight(15)),
              DefaultButton(
                text: trans(context, 'update_book'),
                press: () {
                  _addBook();
                },
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
            images.length != 0 ||
        _image1 != null) {
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
          .where((u) => u.nameEn == selUniversity || u.nameAr == selUniversity)
          .single
          .id;
      book.collegeId = allColleges
          .where((c) =>
              (c.nameEn == selFaculty || c.nameAr == selFaculty) &&
              c.universityId == book.universityId)
          .single
          .id;
      book.specialityId = allMajors
          .where((m) =>
              (m.nameEn == selMajor || m.nameAr == selMajor) &&
              m.collegeId == book.collegeId)
          .single
          .id;
      book.name = nameController.text;
      book.descp = descController.text;
      book.price = priceController.text;
      book.deliveryFee = application.getDeliveryFee().first.fee;
      book.datePost = dateFormat.format(DateTime.now());
      book.timePost = timeFormat.format(DateTime.now());
      book.id = widget.book.id;
      book.isUpdateData = "1";

      List<String> fileNames = [];
      fileNames.add(_fileName);
      fileNames.add(_fileName2);
      fileNames.add(_fileName3);
      fileNames.add(_fileName4);

      List<PhotoPicker> photos = [];
      if (_image1 != null)
        photos.add(PhotoPicker(no: '1', image: _image1, imageName: _fileName));
      if (_image2 != null)
        photos.add(PhotoPicker(no: '2', image: _image2, imageName: _fileName2));
      if (_image3 != null)
        photos.add(PhotoPicker(no: '3', image: _image3, imageName: _fileName3));
      if (_image4 != null)
        photos.add(PhotoPicker(no: '4', image: _image4, imageName: _fileName4));

      await HttpService().addBook(context, book, photos);
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
    } else {
      Fluttertoast.showToast(
          msg: trans(context, 'please_fill_all_information'),
          fontSize: getProportionateScreenWidth(14));
    }
  }

  Widget imagePickerSingleField(int imageNo, {File image, Photo photo}) {
    return Expanded(
      child: InkWell(
        onTap: () => _showPicker(context, imageNo),
        child: Container(
          width: getProportionateScreenWidth(90),
          height: getProportionateScreenHeight(110),
          padding: EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(SizeConfig.screenWidth / 50)),
          child: Card(
              elevation: 0,
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(SizeConfig.screenWidth / 50)),
              child: image == null
                  ? photo == null
                      ? Icon(Icons.add, color: Color(0xFF8A8A8F))
                      : Stack(
                          children: [
                            Image.network(
                              '${WebService.getImageUrl()}${photo.photo}',
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            Container(color: Colors.black12),
                            Center(
                              child: InkWell(
                                onTap: () async {
                                  await HttpService().removePhoto(photo);
                                  images.clear();
                                  getBookImages();
                                },
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 25,
                                ),
                              ),
                            )
                          ],
                        )
                  : Stack(
                      children: [
                        Image.file(
                          image,
                          width: double.infinity,
                          height: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Container(color: Colors.black12),
                        Center(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (imageNo == 1)
                                  _image1 = null;
                                else if (imageNo == 2)
                                  _image2 = null;
                                else if (imageNo == 3)
                                  _image3 = null;
                                else
                                  _image4 = null;
                              });
                            },
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                        )
                      ],
                    )),
        ),
      ),
    );
  }
}
