part of 'rating_bloc.dart';

@freezed
class RatingEvent with _$RatingEvent {
  const factory RatingEvent.refresh() = _Refresh;
}
