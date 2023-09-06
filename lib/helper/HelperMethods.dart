// Return a formated data as string

import 'package:cloud_firestore/cloud_firestore.dart';

class HelperMethods {

  static String formatDate(Timestamp timestamp){

  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();

  String formatedData = day + '/' + month + '/' + year;

  return formatedData;


}
}

