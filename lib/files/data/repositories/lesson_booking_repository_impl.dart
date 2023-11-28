import 'package:dartz/dartz.dart';
import 'package:tuiibookings_domain_data_firestore/files/data/datasources/lesson_booking_datasource.dart';
import 'package:tuiibookings_domain_data_firestore/files/domain/repositories/lesson_booking_repository.dart';
import 'package:tuiicore/core/enums/enums.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';

class LessonBookingRepositoryImpl extends LessonBookingRepository {
  final LessonBookingDataSource dataSource;
  LessonBookingRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<Either<Failure, LessonModel>> bookLesson(LessonModel booking) async {
    try {
      LessonModel newBooking = await dataSource.bookLesson(booking);
      return Right(newBooking);
    } on Failure catch (err) {
      return Left(err);
    }
  }

  @override
  Future<String> getZoomMeetingUrl(String zoomServiceUrl, String topic,
      ZoomMeetingType type, DateTime startTime, int duration) async {
    final zoomUrl = await dataSource.getZoomMeetingUrl(
        zoomServiceUrl, topic, type, startTime, duration);
    return zoomUrl;
  }
}
