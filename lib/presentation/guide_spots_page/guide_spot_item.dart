import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funday_flutter_interview/domain/usecase/download_audio_from_url_usecase.dart';
import 'package:funday_flutter_interview/domain/usecase/get_file_path_with_name_usecase.dart';
import 'package:funday_flutter_interview/domain/usecase/save_file_with_name_usecase.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';
import 'package:funday_flutter_interview/presentation/guide_spot_detail_page/guide_spot_detail_page.dart';
import 'package:funday_flutter_interview/presentation/guide_spots_page/guide_spot_item_bloc.dart';

class GuideSpotItem extends StatelessWidget {
  const GuideSpotItem({super.key, required this.guideSpot});
  final GuideSpot guideSpot;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GuideSpotItemBloc(
        GuideSpotItemState(fileName: guideSpot.title),
        GetFilePathWithNameUsecase(),
        SaveFileWithNameUsecase(),
        DownloadAudioFromUrlUsecase(),
      )..add(CheckAudioFileExistsEvent(fileName: guideSpot.title)),
      child: BlocBuilder<GuideSpotItemBloc, GuideSpotItemState>(
        builder: (context, state) {
          state.audioFilePath;
          return ListTile(
            title: Text(guideSpot.title),
            trailing: Column(
              children: [
                state.audioFilePath != null
                    ? IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GuideSpotDetailPage(
                                guideSpot: guideSpot,
                                audioFile: File(state.audioFilePath!),
                              ),
                            ),
                          );
                        },
                        icon: Icon(Icons.play_arrow),
                      )
                    : state.downloadProgress != null
                    ? CircularProgressIndicator()
                    : IconButton(
                        onPressed: () {
                          context.read<GuideSpotItemBloc>().add(
                            DownLoadAudioEvent(
                              fileName: guideSpot.title,
                              audioUrl: guideSpot.audioUrl,
                            ),
                          );
                        },
                        icon: Icon(Icons.download),
                      ),
              ],
            ),
          );
        },
      ),
    );
  }
}
