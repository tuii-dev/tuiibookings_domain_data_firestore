import 'package:tuiicore/core/enums/zoom_meeting_type.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';

abstract class LessonBookingDataSource {
  Future<LessonModel> bookLesson(LessonModel lesson);
  Future<String> getZoomMeetingUrl(String zoomSeviceUrl, String topic,
      ZoomMeetingType type, DateTime startTime, int duration);
}
