import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:funday_flutter_interview/domain/usecase/get_guide_spots_usecase.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/fund/lang.dart';
import 'package:funday_flutter_interview/presentation/guide_spots_page/guide_spots_page_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'guide_spots_page_bloc_test.mocks.dart';

@GenerateMocks([GetGuideSpotsUsecase])
void main() {
  late MockGetGuideSpotsUsecase mockGetGuideSpotsUsecase;
  late GuideSpotsPageBloc bloc;
  late DateTime fixedDateTime;

  setUp(() {
    mockGetGuideSpotsUsecase = MockGetGuideSpotsUsecase();
    fixedDateTime = DateTime(2024, 1, 1, 12, 0, 0);
    bloc = GuideSpotsPageBloc(
      GuideSpotsPageState(
        guideSpots: const [],
        lastUpdated: fixedDateTime,
        currentPage: 1,
        isLoadingMore: false,
      ),
      mockGetGuideSpotsUsecase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('GuideSpotsPageBloc', () {
    final mockGuideSpots = [
      GuideSpot(
        title: '臺北市立動物園',
        modifiedDate: DateTime(2024, 11, 15, 13, 35, 9),
        audioUrl: 'https://www.travel.taipei/audio/27',
      ),
      GuideSpot(
        title: '陽明公園',
        modifiedDate: DateTime(2024, 11, 15, 13, 35, 5),
        audioUrl: 'https://www.travel.taipei/audio/30',
      ),
    ];

    test(
      'initial state should have empty guide spots and correct defaults',
      () {
        expect(bloc.state.guideSpots, isEmpty);
        expect(bloc.state.lastUpdated, equals(fixedDateTime));
        expect(bloc.state.currentPage, equals(1));
        expect(bloc.state.isLoadingMore, isFalse);
      },
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'emits new state with guide spots when GetGuideSpotsPageEvent is successful',
      build: () {
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 1,
          ),
        ).thenAnswer((_) async => mockGuideSpots);
        return bloc;
      },
      act: (bloc) => bloc.add(GetGuideSpotsPageEvent(lang: Lang.zhTw)),
      expect: () => [
        isA<GuideSpotsPageState>()
            .having((s) => s.guideSpots.length, 'guide spots count', 2)
            .having(
              (s) => s.guideSpots.first.title,
              'first spot title',
              '臺北市立動物園',
            )
            .having((s) => s.lastUpdated, 'lastUpdated', isA<DateTime>())
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
      verify: (_) {
        verify(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 1,
          ),
        ).called(1);
      },
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'emits empty list when usecase returns empty list',
      build: () {
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(lang: Lang.en, page: 1),
        ).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(GetGuideSpotsPageEvent(lang: Lang.en)),
      expect: () => [
        isA<GuideSpotsPageState>().having(
          (s) => s.guideSpots,
          'guideSpots',
          isEmpty,
        ),
      ],
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'handles different languages and pages correctly',
      build: () {
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(lang: Lang.ja, page: 1),
        ).thenAnswer((_) async => mockGuideSpots);
        return bloc;
      },
      act: (bloc) => bloc.add(GetGuideSpotsPageEvent(lang: Lang.ja)),
      expect: () => [
        isA<GuideSpotsPageState>().having(
          (s) => s.guideSpots.length,
          'guide spots count',
          2,
        ),
      ],
      verify: (_) {
        verify(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(lang: Lang.ja, page: 1),
        ).called(1);
      },
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'emits loading state and appends guide spots on subsequent loads',
      build: () {
        // Pre-populate bloc with existing data
        return GuideSpotsPageBloc(
          GuideSpotsPageState(
            guideSpots: [mockGuideSpots.first],
            lastUpdated: fixedDateTime,
            currentPage: 2,
            isLoadingMore: false,
          ),
          mockGetGuideSpotsUsecase,
        );
      },
      setUp: () {
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 2,
          ),
        ).thenAnswer((_) async => [mockGuideSpots.last]);
      },
      act: (bloc) => bloc.add(GetGuideSpotsPageEvent(lang: Lang.zhTw)),
      expect: () => [
        // First emission: loading state
        isA<GuideSpotsPageState>()
            .having((s) => s.guideSpots.length, 'guide spots count', 1)
            .having((s) => s.isLoadingMore, 'isLoadingMore', true)
            .having((s) => s.currentPage, 'currentPage', 2),
        // Second emission: loaded state with appended data
        isA<GuideSpotsPageState>()
            .having((s) => s.guideSpots.length, 'guide spots count', 2)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.currentPage, 'currentPage', 3),
      ],
      verify: (_) {
        verify(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 2,
          ),
        ).called(1);
      },
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'handles error during initial load gracefully',
      build: () {
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 1,
          ),
        ).thenThrow(Exception('API Error'));
        return bloc;
      },
      act: (bloc) => bloc.add(GetGuideSpotsPageEvent(lang: Lang.zhTw)),
      expect: () => [
        isA<GuideSpotsPageState>()
            .having((s) => s.guideSpots, 'guideSpots', isEmpty)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.currentPage, 'currentPage', 1),
      ],
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'handles error during pagination load gracefully',
      build: () {
        return GuideSpotsPageBloc(
          GuideSpotsPageState(
            guideSpots: [mockGuideSpots.first],
            lastUpdated: fixedDateTime,
            currentPage: 2,
            isLoadingMore: false,
          ),
          mockGetGuideSpotsUsecase,
        );
      },
      setUp: () {
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 2,
          ),
        ).thenThrow(Exception('Network Error'));
      },
      act: (bloc) => bloc.add(GetGuideSpotsPageEvent(lang: Lang.zhTw)),
      expect: () => [
        // Loading state
        isA<GuideSpotsPageState>().having(
          (s) => s.isLoadingMore,
          'isLoadingMore',
          true,
        ),
        // Error state - keeps existing data
        isA<GuideSpotsPageState>()
            .having((s) => s.guideSpots.length, 'guide spots count', 1)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false)
            .having((s) => s.currentPage, 'currentPage', 2),
      ],
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'RefreshGuideSpotsPageEvent refreshes all existing pages',
      build: () {
        return GuideSpotsPageBloc(
          GuideSpotsPageState(
            guideSpots: [...mockGuideSpots, ...mockGuideSpots],
            lastUpdated: fixedDateTime,
            currentPage:
                3, // Has loaded 2 pages (currentPage = nextPage to load)
            isLoadingMore: false,
          ),
          mockGetGuideSpotsUsecase,
        );
      },
      setUp: () {
        // Mock responses for all pages that were previously loaded
        // currentPage is 3, so refresh will call pages 1, 2, and 3
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 1,
          ),
        ).thenAnswer((_) async => [mockGuideSpots.first]);
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 2,
          ),
        ).thenAnswer((_) async => [mockGuideSpots.last]);
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 3,
          ),
        ).thenAnswer((_) async => []);
      },
      act: (bloc) => bloc.add(RefreshGuideSpotsPageEvent(lang: Lang.zhTw)),
      expect: () => [
        isA<GuideSpotsPageState>()
            .having((s) => s.guideSpots.length, 'guide spots count', 2)
            .having((s) => s.currentPage, 'currentPage', 3)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
      verify: (_) {
        verify(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 1,
          ),
        ).called(1);
        verify(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 2,
          ),
        ).called(1);
        verify(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 3,
          ),
        ).called(1);
      },
    );

    blocTest<GuideSpotsPageBloc, GuideSpotsPageState>(
      'RefreshGuideSpotsPageEvent handles error gracefully',
      build: () {
        return GuideSpotsPageBloc(
          GuideSpotsPageState(
            guideSpots: mockGuideSpots,
            lastUpdated: fixedDateTime,
            currentPage: 2,
            isLoadingMore: false,
          ),
          mockGetGuideSpotsUsecase,
        );
      },
      setUp: () {
        when(
          mockGetGuideSpotsUsecase.getGuideSpotsByPage(
            lang: Lang.zhTw,
            page: 1,
          ),
        ).thenThrow(Exception('Refresh Error'));
      },
      act: (bloc) => bloc.add(RefreshGuideSpotsPageEvent(lang: Lang.zhTw)),
      expect: () => [
        isA<GuideSpotsPageState>()
            .having((s) => s.guideSpots.length, 'guide spots count', 2)
            .having((s) => s.currentPage, 'currentPage', 2)
            .having((s) => s.isLoadingMore, 'isLoadingMore', false),
      ],
    );

    test('GuideSpotsPageState equality works correctly', () {
      final state1 = GuideSpotsPageState(
        guideSpots: mockGuideSpots,
        lastUpdated: fixedDateTime,
        currentPage: 1,
        isLoadingMore: false,
      );
      final state2 = GuideSpotsPageState(
        guideSpots: mockGuideSpots,
        lastUpdated: fixedDateTime,
        currentPage: 1,
        isLoadingMore: false,
      );

      expect(state1, equals(state2));
    });

    test('GetGuideSpotsPageEvent creates correctly', () {
      final event = GetGuideSpotsPageEvent(lang: Lang.zhTw);
      expect(event.lang, equals(Lang.zhTw));
    });

    test('RefreshGuideSpotsPageEvent creates correctly', () {
      final event = RefreshGuideSpotsPageEvent(lang: Lang.en);
      expect(event.lang, equals(Lang.en));
    });
  });
}
