import "dart:async";
import "dart:io";

import "package:flutter/services.dart";

import "package:camera_platform_interface/camera_platform_interface.dart";
import "package:fluent_ui/fluent_ui.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:gap/gap.dart";

import "package:otoscopia/src/config/config.dart";
import "package:otoscopia/src/core/core.dart";
import "package:otoscopia/src/features/nurse/nurse.dart";

class CameraScreen extends ConsumerStatefulWidget {
  const CameraScreen(this.position, {super.key});
  final int position;

  @override
  ConsumerState<CameraScreen> createState() => _CameraState();
}

class _CameraState extends ConsumerState<CameraScreen> {
  /// Stores list of cameras found on device.
  List<CameraDescription> _cameras = [];

  /// Used to iter through _cameras.
  int _cameraIndex = 0;

  /// Used to store camera ID.
  int _cameraId = -1;

  /// true if camera is initialised, otherwise false.
  bool _initialised = false;

  /// sets preview size of the camera, can be null.
  Size? _previewSize;

  /// sets resolution of the preview
  final ResolutionPreset _resolutionPreset = ResolutionPreset.veryHigh;

  /// Subscribes to camera error stream.
  StreamSubscription<CameraErrorEvent>? _errorStreamSubscription;

  /// Subscribes to camera closing stream i.e. on dispose.
  StreamSubscription<CameraClosingEvent>? _cameraClosingStreamSubscription;

  bool _hasNoCamera = false;

  String get positionString => widget.position == 0 ? "Left" : "Right";

  @override
  Widget build(BuildContext context) {
    bool hasMultipleCameras = _cameras.length > 1;

    return Card(
      padding: const EdgeInsets.all(5),
      child: CardOpacity(
        padding: const EdgeInsets.all(16),
        child: _initialised
            ? Camera(
                cameraId: _cameraId,
                takePicture: _takePicture,
                previewSize: _previewSize,
                switchCamera: _switchCamera,
                continueButton: continueButton,
                hasMultipleCameras: hasMultipleCameras,
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(hasMultipleCameras
                        ? kMultipleCamera
                        : !_hasNoCamera
                            ? kNoCamera
                            : kOneCamera),
                    const Gap(8),
                    if (hasMultipleCameras)
                      ComboBox<CameraDescription>(
                        placeholder: const Text(kSelectCameraPlaceholder),
                        value: _cameras[_cameraIndex],
                        onChanged: (value) {
                          _cameraIndex = _cameras.indexOf(value!);
                          setState(() {});
                        },
                        items: _cameras.map((e) {
                          return ComboBoxItem(
                            value: e,
                            child: Text("${e.name.split(" ").first} Camera"),
                          );
                        }).toList(),
                      ),
                    const Gap(8),
                    CameraInitializeButtons(
                        _initiliaseCamera, _fetchCameras, !_hasNoCamera),
                  ],
                ),
              ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();

    /// Ensures that at first the available cameras are found.
    _fetchCameras();
  }

  @override
  void dispose() {
    /// ends current preview
    _disposeCurrentCamera();

    /// both the streams are canceled and reset to null just in case

    _errorStreamSubscription?.cancel();
    _errorStreamSubscription = null;

    _cameraClosingStreamSubscription?.cancel();
    _cameraClosingStreamSubscription = null;
    super.dispose();
  }

  /// Fetch list of available cameras from camera_windows_plugin
  Future<void> _fetchCameras() async {
    List<CameraDescription> cameras = [];

    int cameraIndex = 0;

    try {
      cameras = await CameraPlatform.instance.availableCameras();
      if (cameras.isNotEmpty) {
        _hasNoCamera = true;
        cameraIndex = _cameraIndex % cameras.length;
      } else {
        _hasNoCamera = false;
      }
    } on PlatformException catch (e) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        popUpInfoBar(
          kErrorTitle,
          "$kFailedToGetCamera ${e.code} : ${e.message}",
          context,
        );
      });
    }

    if (mounted) {
      setState(() {
        _cameraIndex = cameraIndex;
        _cameras = cameras;
      });
    }
  }

  /// Initialises the camera on device
  Future<void> _initiliaseCamera() async {
    assert(!_initialised);

    if (_cameras.isEmpty) {
      return;
    }

    int cameraId = -1;
    try {
      final int cameraIndex = _cameraIndex % _cameras.length;
      final CameraDescription camera = _cameras[cameraIndex];

      cameraId =
          await CameraPlatform.instance.createCamera(camera, _resolutionPreset);

      _errorStreamSubscription?.cancel();
      _errorStreamSubscription = CameraPlatform.instance
          .onCameraError(cameraId)
          .listen(_onCameraError);

      _cameraClosingStreamSubscription?.cancel();

      final Future<CameraInitializedEvent> initiliazed =
          CameraPlatform.instance.onCameraInitialized(cameraId).first;

      await CameraPlatform.instance.initializeCamera(
        cameraId,
        imageFormatGroup: ImageFormatGroup.unknown,
      );

      final CameraInitializedEvent event = await initiliazed;

      _previewSize = Size(
        event.previewWidth,
        event.previewHeight,
      );

      if (mounted) {
        setState(() {
          _initialised = true;
          _cameraId = cameraId;
          _cameraIndex = cameraIndex;
        });
      }
    } on CameraException catch (_) {
      try {
        /// in case the streams are running
        /// i.e. the cameraId was successfully set and the error occurred later
        if (cameraId >= 0) {
          await CameraPlatform.instance.dispose(cameraId);
        }
      } on CameraException catch (e) {
        WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
          popUpInfoBar(
            kErrorTitle,
            "$kFailedToDisposeCamera ${e.code}: ${e.description}",
            context,
          );
        });
      }

      /// Reset State
      if (mounted) {
        setState(() {
          _initialised = false;
          _cameraId = -1;
          _cameraIndex = 0;
          _previewSize = null;
        });
      }
    }
  }

  /// Disposes the current camera view
  Future<void> _disposeCurrentCamera() async {
    if (_cameraId >= 0 && _initialised) {
      try {
        await CameraPlatform.instance.dispose(_cameraId);

        if (mounted) {
          setState(() {
            _initialised = false;
            _cameraId = -1;
            _cameraIndex = 0;
            _previewSize = null;
          });
        }
      } on CameraException catch (e) {
        if (mounted) {
          popUpInfoBar(kErrorTitle,
              "$kFailedToDisposeCamera ${e.code}: ${e.description}", context);
        }
      }
    }
  }

  /// Takes a photo and stores it in the Photos folder in C:/Users/OneDrive/Photos
  Future<void> _takePicture() async {
    CameraPlatform.instance.takePicture(_cameraId).then((value) async {
      var fileName = value.name;

      await CameraPlatform.instance.pausePreview(_cameraId);

      Future.delayed(const Duration(milliseconds: 500), () async {
        await CameraPlatform.instance.resumePreview(_cameraId);
      });

      moveFile(File.fromUri(Uri.file(value.path)), fileName);
    });
  }

  moveFile(File sourceFile, String fileName) async {
    final patientUid = ref.watch(patientProvider)!.id;
    final String filePath = "$applicationDirectory\\$patientUid";
    Directory(filePath).createSync(recursive: true);
    final String filePosition = "$positionString-$fileName";
    final String finalFilePath = "$filePath\\$filePosition";

    await sourceFile.rename(finalFilePath);

    ref.read(screeningInformationProvider.notifier).setImage(finalFilePath);
  }

  /// This switches camera provided the device is connected to multiple cameras.
  Future<void> _switchCamera() async {
    if (_cameras.isNotEmpty) {
      /// select next index
      _cameraIndex = (_cameraIndex + 1) % _cameras.length;
      if (_initialised && _cameraId >= 0) {
        await _disposeCurrentCamera();
        await _fetchCameras();
        if (_cameras.isNotEmpty) {
          await _initiliaseCamera();
        } else {
          await _fetchCameras();
        }
      }
    }
  }

  /// This function handles camera error by disposing the active camera.
  /// It then fetches a new camera.
  void _onCameraError(CameraErrorEvent event) {
    if (mounted) {
      popUpInfoBar("Ohh noo!,", event.description, context);

      /// Dispose camera on camera error as it can't be used anymore
      _disposeCurrentCamera();
      _fetchCameras();
    }
  }

  void continueButton(BuildContext context) {
    String patientUid = ref.watch(patientProvider)!.id;
    final directory = Directory("$applicationDirectory\\$patientUid");

    if (directory.listSync().isEmpty) {
      popUpInfoBar(kErrorTitle, kNoFilesFound, context);
    } else {
      List<FileSystemEntity> files = directory.listSync();

      bool fileExist = false;

      for (FileSystemEntity file in files) {
        if (FileSystemEntity.isFileSync(file.path) &&
            file.path.contains('$positionString-')) {
          fileExist = true;
          break;
        }
      }

      if (fileExist) {
        _disposeCurrentCamera();
        if (widget.position == 0) {
          ref.read(addPatientTabProvider.notifier).addRightCamera();
        } else {
          ref.read(addPatientTabProvider.notifier).addScreeningInformation();
        }
      }
    }
  }
}
