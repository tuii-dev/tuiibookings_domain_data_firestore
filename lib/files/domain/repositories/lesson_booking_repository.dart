import 'package:dartz/dartz.dart';
import 'package:tuiicore/core/enums/enums.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';

abstract class LessonBookingRepository {
  Future<Either<Failure, LessonModel>> bookLesson(LessonModel booking);

  Future<String> getZoomMeetingUrl(String zoomServiceUrl, String topic,
      ZoomMeetingType type, DateTime startTime, int duration);
}
