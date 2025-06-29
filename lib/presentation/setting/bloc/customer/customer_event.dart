import 'package:freezed_annotation/freezed_annotation.dart';

part 'customer_event.freezed.dart';

@freezed
class CustomerEvent with _$CustomerEvent {
  const factory CustomerEvent.fetch() = _Fetch;
}
