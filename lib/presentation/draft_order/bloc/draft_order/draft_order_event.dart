part of 'draft_order_bloc.dart';

@freezed
class DraftOrderEvent with _$DraftOrderEvent {
  const factory DraftOrderEvent.started() = _Started;

  const factory DraftOrderEvent.getAllDraftOrder() = _GetAllDraftOrder;
}