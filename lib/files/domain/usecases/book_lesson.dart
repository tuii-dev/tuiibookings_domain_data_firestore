import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:tuiibookings_domain_data_firestore/files/domain/repositories/lesson_booking_repository.dart';
import 'package:tuiicore/core/enums/enums.dart';
import 'package:tuiicore/core/errors/failure.dart';
import 'package:tuiicore/core/usecases/usecase.dart';
import 'package:tuiientitymodels/files/classroom/data/models/lesson_model.dart';

class BookLesson implements UseCase<LessonModel, BookLessonParams> {
  final LessonBookingRepository repository;

  BookLesson({required this.repository});

  @override
  Future<Either<Failure, LessonModel>> call(BookLessonParams params) async {
    if (params.lesson.rtcProviderType == RtcProviderType.jitsi) {
      final newBooking = params.lesson.copyWith(
          rtcConferenceLink:
              _getJitsiMeetingRoot(params.lesson.lessonCategory!));
      params = params.copyWith(lesson: newBooking);
    } else {
      final zoomLink = await repository.getZoomMeetingUrl(
          params.zoomServiceUrl,
          params.lesson.lessonCategory!,
          ZoomMeetingType.scheduled,
          params.lesson.startDate ?? DateTime.now(),
          60);

      debugPrint('Zoom Link: $zoomLink');

      final newBooking = params.lesson.copyWith(rtcConferenceLink: zoomLink);
      params = params.copyWith(lesson: newBooking);
    }
    return await repository.bookLesson(params.lesson);
  }

  String _getJitsiMeetingRoot(String category) {
    final cat = category.replaceAll(' ', '');
    return 'org.jitsi.meet://meet.jit.si/TuiiMeet$cat${_getRandomRoomName(12)}';
  }

  String _getRandomRoomName(int len) {
    final random = Random.secure();
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return String.fromCharCodes(Iterable.generate(
        len, (_) => chars.codeUnitAt(random.nextInt(chars.length))));
  }
}

class BookLessonParams extends Equatable {
  final String zoomServiceUrl;
  final LessonModel lesson;

  const BookLessonParams({
    required this.zoomServiceUrl,
    required this.lesson,
  });

  @override
  List<Object> get props {
    return [
      zoomServiceUrl,
      lesson,
    ];
  }

  BookLessonParams copyWith({
    String? zoomServiceUrl,
    LessonModel? lesson,
  }) {
    return BookLessonParams(
      zoomServiceUrl: zoomServiceUrl ?? this.zoomServiceUrl,
      lesson: lesson ?? this.lesson,
    );
  }
}
