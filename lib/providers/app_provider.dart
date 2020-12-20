import 'package:flutter/material.dart';
import 'package:ketabook/models/college.dart';
import 'package:ketabook/models/delivery_fee.dart';
import 'package:ketabook/models/delivery_time.dart';
import 'package:ketabook/models/page_desc.dart';
import 'package:ketabook/models/slideshow.dart';
import 'package:ketabook/models/speciality.dart';
import 'package:ketabook/models/university.dart';
import 'package:ketabook/models/user_model.dart';

class AppNotifier extends ChangeNotifier {
  String language;
  String keyword;
  String userId;

  List<University> universities = List<University>();
  List<College> colleges = List<College>();
  List<Speciality> specialities = List<Speciality>();
  List<PageDesc> pageDesc = List<PageDesc>();
  List<DeliveryTime> deliveryTime = List<DeliveryTime>();
  List<DeliveryFee> deliveryFee = List<DeliveryFee>();
  List<Slideshow> slideShowImages = List<Slideshow>();

  UserModel user;

  void setCurrentLanguage(String language) {
    this.language = language;
  }

  String getLanguage() {
    return language;
  }

  void addUniversities(List<University> universities) {
    this.universities = universities;
  }

  List<University> getUniversities() {
    return universities;
  }

  void addColleges(List<College> colleges) {
    this.colleges = colleges;
  }

  List<College> getColleges() {
    return colleges;
  }

  void addSpeciality(List<Speciality> specialities) {
    this.specialities = specialities;
  }

  List<Speciality> getSpecialities() {
    return specialities;
  }

  void addPageDesc(List<PageDesc> pageDesc) {
    this.pageDesc = pageDesc;
  }

  List<PageDesc> getPageDesc() {
    return pageDesc;
  }

  void addDeliveryTime(List<DeliveryTime> deliveryTime) {
    this.deliveryTime = deliveryTime;
  }

  List<DeliveryTime> getDeliveryTime() {
    return deliveryTime;
  }

  void addDeliveryFee(List<DeliveryFee> deliveryFee) {
    this.deliveryFee = deliveryFee;
  }

  List<DeliveryFee> getDeliveryFee() {
    return deliveryFee;
  }

  void addSlideShowImages(List<Slideshow> slideShow) {
    this.slideShowImages = slideShow;
  }

  List<Slideshow> getSlideShowImages() {
    return slideShowImages;
  }

  void setKeyword(String keyword) {
    this.keyword = keyword;
  }

  String getKeyword() {
    return keyword;
  }

  notifyListeners();
}
