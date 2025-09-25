import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funday_flutter_interview/domain/usecase/download_audio_from_url_usecase.dart';
import 'package:funday_flutter_interview/domain/usecase/get_file_path_with_name_usecase.dart';
import 'package:funday_flutter_interview/domain/usecase/save_file_with_name_usecase.dart';
import 'package:funday_flutter_interview/domain/value_object/guide_spot.dart';

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
                    ? IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow))
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

class GuideSpotItemBloc extends Bloc<GuideSpotItemEvent, GuideSpotItemState> {
  final GetFilePathWithNameUsecase getFilePathWithNameUsecase;
  final SaveFileWithNameUsecase saveFileWithNameUsecase;
  final DownloadAudioFromUrlUsecase downloadAudioFromUrlUsecase;
  GuideSpotItemBloc(
    super.initialState,
    GetFilePathWithNameUsecase? getFilePathWithNameUsecase,
    SaveFileWithNameUsecase? saveFileWithNameUsecase,
    DownloadAudioFromUrlUsecase? downloadAudioFromUrlUsecase,
  ) : getFilePathWithNameUsecase =
          getFilePathWithNameUsecase ?? GetFilePathWithNameUsecase(),
      saveFileWithNameUsecase =
          saveFileWithNameUsecase ?? SaveFileWithNameUsecase(),
      downloadAudioFromUrlUsecase =
          downloadAudioFromUrlUsecase ?? DownloadAudioFromUrlUsecase() {
    on<CheckAudioFileExistsEvent>(_onCheckAudioFileExistsEvent);
    on<DownLoadAudioEvent>(_onDownLoadAudioEvent);
  }

  FutureOr<void> _onDownLoadAudioEvent(
    DownLoadAudioEvent event,
    Emitter<GuideSpotItemState> emit,
  ) async {
    log('downloading audio from url: ${event.audioUrl}');
    emit(GuideSpotItemState(fileName: event.fileName, downloadProgress: 0.0));
    final file = await downloadAudioFromUrlUsecase.call(url: event.audioUrl);
    if (file != null) {
      await saveFileWithNameUsecase.call(
        fileName: event.fileName,
        audioFile: file,
      );
      emit(
        GuideSpotItemState(fileName: event.fileName, audioFilePath: file.path),
      );
    }
  }

  FutureOr<void> _onCheckAudioFileExistsEvent(
    CheckAudioFileExistsEvent event,
    Emitter<GuideSpotItemState> emit,
  ) async {
    final audioFilePath = await getFilePathWithNameUsecase.call(
      fileName: event.fileName,
    );
    if (audioFilePath != null) {
      emit(
        GuideSpotItemState(
          fileName: event.fileName,
          audioFilePath: audioFilePath,
        ),
      );
    }
  }
}

class GuideSpotItemState extends Equatable {
  final String fileName;
  final String? audioFilePath;
  final double? downloadProgress;
  const GuideSpotItemState({
    required this.fileName,
    this.audioFilePath,
    this.downloadProgress,
  });
  @override
  List<Object?> get props => [fileName, audioFilePath, downloadProgress];
}

abstract class GuideSpotItemEvent {}

class DownLoadAudioEvent extends GuideSpotItemEvent {
  final String fileName;
  final String audioUrl;
  DownLoadAudioEvent({required this.fileName, required this.audioUrl});
}

class CheckAudioFileExistsEvent extends GuideSpotItemEvent {
  final String fileName;
  CheckAudioFileExistsEvent({required this.fileName});
}
