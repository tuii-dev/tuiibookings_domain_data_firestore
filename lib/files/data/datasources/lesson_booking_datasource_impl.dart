import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuiibookings_domain_data_firestore/files/data/datasources/lesson_booking_datasource.dart';
import 'package:tuiicore/core/config/paths.dart';
import 'package:tuiicore/core/enums/enums.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiientitymodels/files/bookings/data/models/zoom_meeting_request_model.dart';
import 'package:tuiientitymodels/files/bookings/data/models/zoom_meeting_response_model.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';

class LessonBookingDataSourceImpl extends LessonBookingDataSource {
  LessonBookingDataSourceImpl({required this.firestore});

  final FirebaseFirestore firestore;

  @override
  Future<LessonModel> bookLesson(LessonModel lesson) async {
    try {
      final docRef = firestore.collection(Paths.lessons).doc();
      final newBooking = lesson.copyWith(id: docRef.id);
      await docRef.set(newBooking.toMap());

      return newBooking;
    } on Exception {
      throw const Failure(message: 'Failed to book lesson.');
    }
  }

  @override
  Future<String> getZoomMeetingUrl(String zoomSeviceUrl, String topic,
      ZoomMeetingType type, DateTime startTime, int duration) async {
    try {
      final url = Uri.parse(zoomSeviceUrl);
      final request = ZoomMeetingRequestModel(
          topic: topic,
          type: type,
          startTime: startTime,
          duration: duration,
          scheduleFor: '');
      final response = await http.post(url, body: request.toJson());
      final meetingResponse = ZoomMeetingResponseModel.fromJson(response.body);

      return meetingResponse.joinUrl ?? '';
    } on Exception {
      return '';
    }
  }
}
