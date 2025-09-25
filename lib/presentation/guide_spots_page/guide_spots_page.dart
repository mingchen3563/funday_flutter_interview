import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funday_flutter_interview/domain/usecase/get_guide_spots_usecase.dart';
import 'package:funday_flutter_interview/fund/lang.dart';
import 'package:funday_flutter_interview/presentation/guide_spots_page/guide_spot_item.dart';
import 'package:funday_flutter_interview/presentation/guide_spots_page/guide_spots_page_bloc.dart';

class GuideSpotsPage extends StatefulWidget {
  GuideSpotsPage({super.key});

  @override
  State<GuideSpotsPage> createState() => _GuideSpotsPageState();
}

class _GuideSpotsPageState extends State<GuideSpotsPage> {
  final ScrollController scrollController = ScrollController();
  late GuideSpotsPageBloc bloc;
  bool _wasLoadingMore = false;
  @override
  void initState() {
    super.initState();
    bloc = GuideSpotsPageBloc(
      GuideSpotsPageState(
        guideSpots: [],
        lastUpdated: DateTime.now(),
        currentPage: 1,
        isLoadingMore: false,
      ),
      GetGuideSpotsUsecase(),
    );
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        bloc.add(GetGuideSpotsPageEvent(lang: Lang.zhTw));
      }
    });
  }

  void _scrollUpAfterFetch() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (scrollController.hasClients) {
        final currentOffset = scrollController.offset;
        final targetOffset = (currentOffset + 100).clamp(
          0.0,
          scrollController.position.maxScrollExtent,
        );

        scrollController.animateTo(
          targetOffset,
          duration: Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc..add(GetGuideSpotsPageEvent(lang: Lang.zhTw)),
      child: BlocBuilder<GuideSpotsPageBloc, GuideSpotsPageState>(
        builder: (context, state) {
          // Detect when loading has finished and trigger scroll up
          if (_wasLoadingMore && !state.isLoadingMore) {
            _scrollUpAfterFetch();
          }
          _wasLoadingMore = state.isLoadingMore;

          return Scaffold(
            appBar: AppBar(title: Row(children: [Text('Funday')])),
            body: SafeArea(
              child: Stack(
                children: [
                  RefreshIndicator(
                    onRefresh: () async {
                      bloc.add(RefreshGuideSpotsPageEvent(lang: Lang.zhTw));
                    },
                    child: Scrollbar(
                      controller: scrollController,
                      thumbVisibility: true,
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: state.guideSpots.length,
                        itemBuilder: (context, index) {
                          return GuideSpotItem(
                            guideSpot: state.guideSpots[index],
                          );
                        },
                      ),
                    ),
                  ),
                  if (state.isLoadingMore)
                    Positioned(
                      bottom: 16.0,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(12.0),
                          decoration: BoxDecoration(
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: CircularProgressIndicator(strokeWidth: 2.0),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
