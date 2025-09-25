import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:funday_flutter_interview/domain/usecase/download_audio_from_url_usecase.dart';
import 'package:funday_flutter_interview/domain/usecase/get_file_path_with_name_usecase.dart';
import 'package:funday_flutter_interview/domain/usecase/save_file_with_name_usecase.dart';

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
      final audioFilePath = await saveFileWithNameUsecase.call(
        fileName: event.fileName,
        audioFile: file,
      );
      emit(
        GuideSpotItemState(
          fileName: event.fileName,
          audioFilePath: audioFilePath,
        ),
      );
    }
  }

  FutureOr<void> _onCheckAudioFileExistsEvent(
    CheckAudioFileExistsEvent event,
    Emitter<GuideSpotItemState> emit,
  ) async {
    final String? audioFilePath = await getFilePathWithNameUsecase.call(
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
