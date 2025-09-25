import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funday_flutter_interview/domain/usecase/get_guide_spots_usecase.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/fund/lang.dart';

class GuideSpotsPageBloc
    extends Bloc<GuideSpotsPageEvent, GuideSpotsPageState> {
  final GetGuideSpotsUsecase getGuideSpotsUsecase;
  GuideSpotsPageBloc(super.initialState, this.getGuideSpotsUsecase) {
    on<GetGuideSpotsPageEvent>(_onGetGuideSpotsPageEvent);
    on<RefreshGuideSpotsPageEvent>(_onRefreshGuideSpotsPageEvent);
  }

  FutureOr<void> _onGetGuideSpotsPageEvent(
    GetGuideSpotsPageEvent event,
    Emitter<GuideSpotsPageState> emit,
  ) async {
    final currentPage = state.currentPage;

    // Emit loading state when fetching more data (not for initial load)
    if (state.guideSpots.isNotEmpty) {
      emit(
        GuideSpotsPageState(
          guideSpots: state.guideSpots,
          lastUpdated: state.lastUpdated,
          currentPage: currentPage,
          isLoadingMore: true,
        ),
      );
    }

    try {
      final guideSpots = await getGuideSpotsUsecase.getGuideSpotsByPage(
        lang: event.lang,
        page: currentPage,
      );
      final newGuideSpots = [...state.guideSpots, ...guideSpots];
      emit(
        GuideSpotsPageState(
          guideSpots: newGuideSpots,
          lastUpdated: DateTime.now(),
          currentPage: currentPage + 1,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      emit(
        GuideSpotsPageState(
          guideSpots: state.guideSpots,
          lastUpdated: DateTime.now(),
          currentPage: currentPage,
          isLoadingMore: false,
        ),
      );
    }
  }

  FutureOr<void> _onRefreshGuideSpotsPageEvent(
    RefreshGuideSpotsPageEvent event,
    Emitter<GuideSpotsPageState> emit,
  ) async {
    try {
      final currentPage = state.currentPage;
      // Get all existing pages of spots
      final allSpots = <GuideSpot>[];
      final futures = List.generate(
        currentPage,
        (index) => getGuideSpotsUsecase.getGuideSpotsByPage(
          lang: event.lang,
          page: index + 1,
        ),
      );

      final results = await Future.wait(futures);
      for (final spots in results) {
        allSpots.addAll(spots);
      }
      emit(
        GuideSpotsPageState(
          guideSpots: allSpots,
          lastUpdated: DateTime.now(),
          currentPage: currentPage,
          isLoadingMore: false,
        ),
      );
    } catch (e) {
      // Keep current state on error
      emit(
        GuideSpotsPageState(
          guideSpots: state.guideSpots,
          lastUpdated: DateTime.now(),
          currentPage: state.currentPage,
          isLoadingMore: false,
        ),
      );
    }
  }
}

class GuideSpotsPageState extends Equatable {
  final List<GuideSpot> guideSpots;
  final DateTime lastUpdated;
  final int currentPage;
  final bool isLoadingMore;

  const GuideSpotsPageState({
    required this.guideSpots,
    required this.lastUpdated,
    required this.currentPage,
    this.isLoadingMore = false,
  });

  @override
  List<Object?> get props => [
    guideSpots,
    lastUpdated,
    currentPage,
    isLoadingMore,
  ];
}

abstract class GuideSpotsPageEvent {}

class GetGuideSpotsPageEvent extends GuideSpotsPageEvent {
  final Lang lang;

  GetGuideSpotsPageEvent({required this.lang});
}

class RefreshGuideSpotsPageEvent extends GuideSpotsPageEvent {
  final Lang lang;

  RefreshGuideSpotsPageEvent({required this.lang});
}
