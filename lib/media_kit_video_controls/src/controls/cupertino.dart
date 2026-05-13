/// This file is a part of media_kit (https://github.com/media-kit/media-kit).
///
/// Copyright © 2021 & onwards, Hitesh Kumar Saini &lt;saini123hitesh@gmail.com&gt;.
/// All rights reserved.
/// Use of this source code is governed by MIT license that can be found in the LICENSE file.
library;

// ignore_for_file: non_constant_identifier_names
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:media_kit_video/media_kit_video.dart';

import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/widgets/video_controls_theme_data_injector.dart';

/// {@template cupertino_video_controls}
///
/// [Video] controls which use Cupertino design.
///
/// {@endtemplate}
Widget CupertinoVideoControls(VideoState state) {
  return const VideoControlsThemeDataInjector(child: _CupertinoVideoControls());
}

/// [MaterialDesktopVideoControlsThemeData] available in this [context].
CupertinoVideoControlsThemeData _theme(BuildContext context) =>
    FullscreenInheritedWidget.maybeOf(context) == null
    ? CupertinoVideoControlsTheme.maybeOf(context)?.normal ??
          kDefaultCupertinoVideoControlsThemeData
    : CupertinoVideoControlsTheme.maybeOf(context)?.fullscreen ??
          kDefaultCupertinoVideoControlsThemeDataFullscreen;

/// Default [CupertinoVideoControlsThemeData].
const kDefaultCupertinoVideoControlsThemeData =
    CupertinoVideoControlsThemeData();

/// Default [CupertinoVideoControlsThemeData] for fullscreen.
const kDefaultCupertinoVideoControlsThemeDataFullscreen =
    CupertinoVideoControlsThemeData();

/// {@template cupertino_video_controls_theme_data}
///
/// Theming related data for [CupertinoVideoControls]. These values are used to theme the descendant [CupertinoVideoControls].
///
/// {@endtemplate}
class CupertinoVideoControlsThemeData {
  /// Whether to display seek bar.
  final bool displaySeekBar;

  /// Whether a skip next button should be displayed if there are more than one videos in the playlist.
  final bool automaticallyImplySkipNextButton;

  /// Whether a skip previous button should be displayed if there are more than one videos in the playlist.
  final bool automaticallyImplySkipPreviousButton;

  /// Whether to toggle controls visibility on tap.
  final bool toggleControlsOnTap;

  /// Whether the controls are initially visible.
  final bool visibleOnMount;

  /// Color of backdrop that comes up when controls are visible.
  final Color? backdropColor;

  /// Padding around the controls.
  ///
  /// * Default: `EdgeInsets.zero`
  /// * Fullscreen: `MediaQuery.of(context).padding`
  final EdgeInsets? padding;

  /// [Duration] after which the controls will be hidden.
  final Duration controlsHoverDuration;

  /// [Duration] for which the controls will be animated when shown or hidden.
  final Duration controlsTransitionDuration;

  /// Builder for the buffering indicator.
  final Widget Function(BuildContext)? bufferingIndicatorBuilder;

  /// Buttons to be displayed in the primary button bar.
  final List<Widget> primaryButtonBar;

  /// Buttons to be displayed in the top button bar.
  final List<Widget> topButtonBar;

  /// Margin around the top button bar.
  final EdgeInsets topButtonBarMargin;

  /// Buttons to be displayed in the bottom button bar.
  final List<Widget> bottomButtonBar;

  /// Margin around the bottom button bar.
  final EdgeInsets bottomButtonBarMargin;

  /// Height of the button bar.
  final double buttonBarHeight;

  /// Size of the button bar buttons.
  final double buttonBarButtonSize;

  /// Color of the button bar buttons.
  final Color buttonBarButtonColor;

  /// Margin around the seek bar.
  final EdgeInsets seekBarMargin;

  /// [Color] of the seek bar.
  final Color seekBarColor;

  /// [Color] of the playback position section in the seek bar.
  final Color seekBarPositionColor;

  /// [Color] of the seek bar thumb.
  final Color seekBarThumbColor;

  /// Whether to shift the subtitles upwards when the controls are visible.
  final bool shiftSubtitlesOnControlsVisibilityChange;

  /// {@macro cupertino_video_controls_theme_data}
  const CupertinoVideoControlsThemeData({
    this.displaySeekBar = true,
    this.automaticallyImplySkipNextButton = true,
    this.automaticallyImplySkipPreviousButton = true,
    this.toggleControlsOnTap = true,
    this.visibleOnMount = false,
    this.backdropColor = const Color(0x66000000),
    this.padding,
    this.controlsHoverDuration = const Duration(seconds: 3),
    this.controlsTransitionDuration = const Duration(milliseconds: 250),
    this.bufferingIndicatorBuilder,
    this.primaryButtonBar = const [
      Spacer(flex: 2),
      CupertinoSkipPreviousButton(),
      Spacer(),
      CupertinoPlayOrPauseButton(iconSize: 56.0),
      Spacer(),
      CupertinoSkipNextButton(),
      Spacer(flex: 2),
    ],
    this.topButtonBar = const [],
    this.topButtonBarMargin = const EdgeInsets.symmetric(horizontal: 16.0),
    this.bottomButtonBar = const [
      CupertinoPositionIndicator(),
      Spacer(),
      CupertinoFullscreenButton(),
    ],
    this.bottomButtonBarMargin = const EdgeInsets.only(left: 16.0, right: 8.0),
    this.buttonBarHeight = 56.0,
    this.buttonBarButtonSize = 24.0,
    this.buttonBarButtonColor = const Color(0xFFFFFFFF),
    this.seekBarMargin = EdgeInsets.zero,
    this.seekBarColor = const Color(0x4DFFFFFF),
    this.seekBarPositionColor = const Color(0xFFFFFFFF),
    this.seekBarThumbColor = const Color(0xFFFFFFFF),
    this.shiftSubtitlesOnControlsVisibilityChange = false,
  });

  /// Creates a copy of this [CupertinoVideoControlsThemeData] with the given fields replaced by the non-null parameter values.
  CupertinoVideoControlsThemeData copyWith({
    bool? displaySeekBar,
    bool? automaticallyImplySkipNextButton,
    bool? automaticallyImplySkipPreviousButton,
    bool? toggleControlsOnTap,
    bool? visibleOnMount,
    Color? backdropColor,
    EdgeInsets? padding,
    Duration? controlsHoverDuration,
    Duration? controlsTransitionDuration,
    Widget Function(BuildContext)? bufferingIndicatorBuilder,
    List<Widget>? primaryButtonBar,
    List<Widget>? topButtonBar,
    EdgeInsets? topButtonBarMargin,
    List<Widget>? bottomButtonBar,
    EdgeInsets? bottomButtonBarMargin,
    double? buttonBarHeight,
    double? buttonBarButtonSize,
    Color? buttonBarButtonColor,
    EdgeInsets? seekBarMargin,
    Color? seekBarColor,
    Color? seekBarPositionColor,
    Color? seekBarThumbColor,
    bool? shiftSubtitlesOnControlsVisibilityChange,
  }) {
    return CupertinoVideoControlsThemeData(
      displaySeekBar: displaySeekBar ?? this.displaySeekBar,
      automaticallyImplySkipNextButton:
          automaticallyImplySkipNextButton ??
          this.automaticallyImplySkipNextButton,
      automaticallyImplySkipPreviousButton:
          automaticallyImplySkipPreviousButton ??
          this.automaticallyImplySkipPreviousButton,
      toggleControlsOnTap: toggleControlsOnTap ?? this.toggleControlsOnTap,
      visibleOnMount: visibleOnMount ?? this.visibleOnMount,
      backdropColor: backdropColor ?? this.backdropColor,
      padding: padding ?? this.padding,
      controlsHoverDuration:
          controlsHoverDuration ?? this.controlsHoverDuration,
      controlsTransitionDuration:
          controlsTransitionDuration ?? this.controlsTransitionDuration,
      bufferingIndicatorBuilder:
          bufferingIndicatorBuilder ?? this.bufferingIndicatorBuilder,
      primaryButtonBar: primaryButtonBar ?? this.primaryButtonBar,
      topButtonBar: topButtonBar ?? this.topButtonBar,
      topButtonBarMargin: topButtonBarMargin ?? this.topButtonBarMargin,
      bottomButtonBar: bottomButtonBar ?? this.bottomButtonBar,
      bottomButtonBarMargin:
          bottomButtonBarMargin ?? this.bottomButtonBarMargin,
      buttonBarHeight: buttonBarHeight ?? this.buttonBarHeight,
      buttonBarButtonSize: buttonBarButtonSize ?? this.buttonBarButtonSize,
      buttonBarButtonColor: buttonBarButtonColor ?? this.buttonBarButtonColor,
      seekBarMargin: seekBarMargin ?? this.seekBarMargin,
      seekBarColor: seekBarColor ?? this.seekBarColor,
      seekBarPositionColor: seekBarPositionColor ?? this.seekBarPositionColor,
      seekBarThumbColor: seekBarThumbColor ?? this.seekBarThumbColor,
      shiftSubtitlesOnControlsVisibilityChange:
          shiftSubtitlesOnControlsVisibilityChange ??
          this.shiftSubtitlesOnControlsVisibilityChange,
    );
  }
}

/// {@template cupertino_video_controls_theme}
///
/// Inherited widget which provides [CupertinoVideoControlsThemeData] to descendant widgets.
///
/// {@endtemplate}
class CupertinoVideoControlsTheme extends InheritedWidget {
  final CupertinoVideoControlsThemeData normal;
  final CupertinoVideoControlsThemeData fullscreen;
  const CupertinoVideoControlsTheme({
    super.key,
    required this.normal,
    required this.fullscreen,
    required super.child,
  });

  static CupertinoVideoControlsTheme? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<CupertinoVideoControlsTheme>();
  }

  static CupertinoVideoControlsTheme of(BuildContext context) {
    final CupertinoVideoControlsTheme? result = maybeOf(context);
    assert(
      result != null,
      'No [CupertinoVideoControlsTheme] found in [context]',
    );
    return result!;
  }

  @override
  bool updateShouldNotify(CupertinoVideoControlsTheme oldWidget) =>
      !identical(normal, oldWidget.normal) ||
      !identical(fullscreen, oldWidget.fullscreen);
}

/// {@macro cupertino_video_controls}
class _CupertinoVideoControls extends StatefulWidget {
  const _CupertinoVideoControls();

  @override
  State<_CupertinoVideoControls> createState() =>
      _CupertinoVideoControlsState();
}

/// {@macro cupertino_video_controls}
class _CupertinoVideoControlsState extends State<_CupertinoVideoControls> {
  late bool mount = _theme(context).visibleOnMount;
  late bool visible = _theme(context).visibleOnMount;
  late bool buffering = controller(context).player.state.buffering;

  Timer? _timer;

  final List<StreamSubscription> subscriptions = [];

  double get subtitleVerticalShiftOffset =>
      (_theme(context).padding?.bottom ?? 0.0) +
      (_theme(context).bottomButtonBarMargin.vertical) +
      (_theme(context).bottomButtonBar.isNotEmpty
          ? _theme(context).buttonBarHeight
          : 0.0);

  EdgeInsets get controlsPadding =>
      _theme(context).padding ??
      (isFullscreen(context)
          ? MediaQuery.of(context).padding
          : EdgeInsets.zero);

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll([
        controller(context).player.stream.playlist.listen((event) {
          setState(() {});
        }),
        controller(context).player.stream.buffering.listen((event) {
          setState(() {
            buffering = event;
          });
        }),
      ]);

      if (_theme(context).visibleOnMount) {
        _scheduleHide();
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void shiftSubtitle() {
    if (_theme(context).shiftSubtitlesOnControlsVisibilityChange) {
      state(context).setSubtitleViewPadding(
        state(context).widget.subtitleViewConfiguration.padding +
            EdgeInsets.fromLTRB(0.0, 0.0, 0.0, subtitleVerticalShiftOffset),
      );
    }
  }

  void unshiftSubtitle() {
    if (_theme(context).shiftSubtitlesOnControlsVisibilityChange) {
      state(context).setSubtitleViewPadding(
        state(context).widget.subtitleViewConfiguration.padding,
      );
    }
  }

  void _scheduleHide() {
    _timer?.cancel();
    _timer = Timer(_theme(context).controlsHoverDuration, () {
      if (mounted) {
        setState(() {
          visible = false;
        });
        unshiftSubtitle();
      }
    });
  }

  void onTap() {
    if (!_theme(context).toggleControlsOnTap) {
      return;
    }
    if (!visible) {
      setState(() {
        mount = true;
        visible = true;
      });
      shiftSubtitle();
      _scheduleHide();
    } else {
      setState(() {
        visible = false;
      });
      unshiftSubtitle();
      _timer?.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTheme(
      data: CupertinoTheme.of(
        context,
      ).copyWith(primaryColor: _theme(context).buttonBarButtonColor),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            AnimatedOpacity(
              curve: Curves.easeInOut,
              opacity: visible ? 1.0 : 0.0,
              duration: _theme(context).controlsTransitionDuration,
              onEnd: () {
                if (!visible) {
                  setState(() {
                    mount = false;
                  });
                }
              },
              child: IgnorePointer(
                ignoring: !visible,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: _theme(context).backdropColor,
                        ),
                      ),
                    ),
                    if (mount)
                      Padding(
                        padding: controlsPadding,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              height: _theme(context).buttonBarHeight,
                              margin: _theme(context).topButtonBarMargin,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: _theme(context).topButtonBar,
                              ),
                            ),
                            Expanded(
                              child: AnimatedOpacity(
                                curve: Curves.easeInOut,
                                opacity: buffering ? 0.0 : 1.0,
                                duration: _theme(
                                  context,
                                ).controlsTransitionDuration,
                                child: Center(
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: _theme(context).primaryButtonBar,
                                  ),
                                ),
                              ),
                            ),
                            if (_theme(context).displaySeekBar)
                              CupertinoSeekBar(
                                onSeekStart: () => _timer?.cancel(),
                                onSeekEnd: _scheduleHide,
                              ),
                            if (_theme(context).bottomButtonBar.isNotEmpty)
                              Container(
                                height: _theme(context).buttonBarHeight,
                                margin: _theme(context).bottomButtonBarMargin,
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: _theme(context).bottomButtonBar,
                                ),
                              ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            IgnorePointer(
              child: Padding(
                padding: controlsPadding,
                child: Column(
                  children: [
                    Container(
                      height: _theme(context).buttonBarHeight,
                      margin: _theme(context).topButtonBarMargin,
                    ),
                    Expanded(
                      child: Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween<double>(
                            begin: 0.0,
                            end: buffering ? 1.0 : 0.0,
                          ),
                          duration: _theme(context).controlsTransitionDuration,
                          builder: (context, value, child) {
                            if (value > 0.0) {
                              return Opacity(
                                opacity: value,
                                child:
                                    _theme(context).bufferingIndicatorBuilder
                                        ?.call(context) ??
                                    child!,
                              );
                            }
                            return const SizedBox.shrink();
                          },
                          child: const CupertinoActivityIndicator(
                            color: Color(0xFFFFFFFF),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: _theme(context).buttonBarHeight,
                      margin: _theme(context).bottomButtonBarMargin,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// SEEK BAR

/// Cupertino design seek bar.
class CupertinoSeekBar extends StatefulWidget {
  final VoidCallback? onSeekStart;
  final VoidCallback? onSeekEnd;

  const CupertinoSeekBar({super.key, this.onSeekStart, this.onSeekEnd});

  @override
  State<CupertinoSeekBar> createState() => CupertinoSeekBarState();
}

class CupertinoSeekBarState extends State<CupertinoSeekBar> {
  bool tapped = false;
  double slider = 0.0;

  late Duration position = controller(context).player.state.position;
  late Duration duration = controller(context).player.state.duration;

  final List<StreamSubscription> subscriptions = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll([
        controller(context).player.stream.completed.listen((event) {
          setState(() {
            position = Duration.zero;
          });
        }),
        controller(context).player.stream.position.listen((event) {
          setState(() {
            if (!tapped) {
              position = event;
            }
          });
        }),
        controller(context).player.stream.duration.listen((event) {
          setState(() {
            duration = event;
          });
        }),
      ]);
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  double get positionPercent {
    if (position == Duration.zero || duration == Duration.zero) {
      return 0.0;
    }
    final value = position.inMilliseconds / duration.inMilliseconds;
    return value.clamp(0.0, 1.0);
  }

  void onChanged(double value) {
    widget.onSeekStart?.call();
    setState(() {
      tapped = true;
      slider = value;
    });
  }

  void onChangeEnd(double value) {
    widget.onSeekEnd?.call();
    setState(() {
      tapped = false;
      slider = value;
      position = duration * value;
    });
    controller(context).player.seek(duration * value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: _theme(context).seekBarMargin,
      child: CupertinoSlider(
        value: tapped ? slider : positionPercent,
        activeColor: _theme(context).seekBarPositionColor,
        thumbColor: _theme(context).seekBarThumbColor,
        onChanged: onChanged,
        onChangeEnd: onChangeEnd,
      ),
    );
  }
}

// BUTTON: PLAY/PAUSE

/// A Cupertino design play/pause button.
class CupertinoPlayOrPauseButton extends StatefulWidget {
  /// Overriden icon size.
  final double? iconSize;

  /// Overriden icon color.
  final Color? iconColor;

  const CupertinoPlayOrPauseButton({super.key, this.iconSize, this.iconColor});

  @override
  State<CupertinoPlayOrPauseButton> createState() =>
      CupertinoPlayOrPauseButtonState();
}

class CupertinoPlayOrPauseButtonState
    extends State<CupertinoPlayOrPauseButton> {
  late bool playing = controller(context).player.state.playing;

  StreamSubscription<bool>? subscription;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscription ??= controller(context).player.stream.playing.listen((event) {
      setState(() {
        playing = event;
      });
    });
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.square(_theme(context).buttonBarHeight),
      onPressed: controller(context).player.playOrPause,
      child: Icon(
        playing ? CupertinoIcons.pause_fill : CupertinoIcons.play_fill,
        size: widget.iconSize ?? _theme(context).buttonBarButtonSize,
        color: widget.iconColor ?? _theme(context).buttonBarButtonColor,
      ),
    );
  }
}

// BUTTON: SKIP NEXT

/// Cupertino design skip next button.
class CupertinoSkipNextButton extends StatelessWidget {
  /// Icon for [CupertinoSkipNextButton].
  final Widget? icon;

  /// Overriden icon size.
  final double? iconSize;

  /// Overriden icon color.
  final Color? iconColor;

  const CupertinoSkipNextButton({
    super.key,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!_theme(context).automaticallyImplySkipNextButton ||
        (controller(context).player.state.playlist.medias.length > 1 &&
            _theme(context).automaticallyImplySkipNextButton)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.square(_theme(context).buttonBarHeight),
        onPressed: controller(context).player.next,
        child:
            icon ??
            Icon(
              CupertinoIcons.forward_end_fill,
              size: iconSize ?? _theme(context).buttonBarButtonSize,
              color: iconColor ?? _theme(context).buttonBarButtonColor,
            ),
      );
    }
    return const SizedBox.shrink();
  }
}

// BUTTON: SKIP PREVIOUS

/// Cupertino design skip previous button.
class CupertinoSkipPreviousButton extends StatelessWidget {
  /// Icon for [CupertinoSkipPreviousButton].
  final Widget? icon;

  /// Overriden icon size.
  final double? iconSize;

  /// Overriden icon color.
  final Color? iconColor;

  const CupertinoSkipPreviousButton({
    super.key,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    if (!_theme(context).automaticallyImplySkipPreviousButton ||
        (controller(context).player.state.playlist.medias.length > 1 &&
            _theme(context).automaticallyImplySkipPreviousButton)) {
      return CupertinoButton(
        padding: EdgeInsets.zero,
        minimumSize: Size.square(_theme(context).buttonBarHeight),
        onPressed: controller(context).player.previous,
        child:
            icon ??
            Icon(
              CupertinoIcons.backward_end_fill,
              size: iconSize ?? _theme(context).buttonBarButtonSize,
              color: iconColor ?? _theme(context).buttonBarButtonColor,
            ),
      );
    }
    return const SizedBox.shrink();
  }
}

// BUTTON: FULL SCREEN

/// Cupertino design fullscreen button.
class CupertinoFullscreenButton extends StatelessWidget {
  /// Icon for [CupertinoFullscreenButton].
  final Widget? icon;

  /// Overriden icon size.
  final double? iconSize;

  /// Overriden icon color.
  final Color? iconColor;

  const CupertinoFullscreenButton({
    super.key,
    this.icon,
    this.iconSize,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.square(_theme(context).buttonBarHeight),
      onPressed: () => toggleFullscreen(context),
      child:
          icon ??
          Icon(
            isFullscreen(context)
                ? CupertinoIcons.fullscreen_exit
                : CupertinoIcons.fullscreen,
            size: iconSize ?? _theme(context).buttonBarButtonSize,
            color: iconColor ?? _theme(context).buttonBarButtonColor,
          ),
    );
  }
}

// BUTTON: CUSTOM

/// Cupertino design custom button.
class CupertinoCustomButton extends StatelessWidget {
  /// Icon for [CupertinoCustomButton].
  final Widget? icon;

  /// Icon size for [CupertinoCustomButton].
  final double? iconSize;

  /// Icon color for [CupertinoCustomButton].
  final Color? iconColor;

  /// The callback that is called when the button is tapped or otherwise activated.
  final VoidCallback onPressed;

  const CupertinoCustomButton({
    super.key,
    this.icon,
    this.iconSize,
    this.iconColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: Size.square(_theme(context).buttonBarHeight),
      onPressed: onPressed,
      child:
          icon ??
          Icon(
            CupertinoIcons.gear_solid,
            size: iconSize ?? _theme(context).buttonBarButtonSize,
            color: iconColor ?? _theme(context).buttonBarButtonColor,
          ),
    );
  }
}

// POSITION INDICATOR

/// Cupertino design position indicator.
class CupertinoPositionIndicator extends StatefulWidget {
  /// Text style for [CupertinoPositionIndicator].
  final TextStyle? style;

  const CupertinoPositionIndicator({super.key, this.style});

  @override
  State<CupertinoPositionIndicator> createState() =>
      CupertinoPositionIndicatorState();
}

class CupertinoPositionIndicatorState
    extends State<CupertinoPositionIndicator> {
  late Duration position = controller(context).player.state.position;
  late Duration duration = controller(context).player.state.duration;

  final List<StreamSubscription> subscriptions = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll([
        controller(context).player.stream.completed.listen((event) {
          setState(() {
            position = Duration.zero;
          });
        }),
        controller(context).player.stream.position.listen((event) {
          setState(() {
            position = event;
          });
        }),
        controller(context).player.stream.duration.listen((event) {
          setState(() {
            duration = event;
          });
        }),
      ]);
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${position.label(reference: duration)} / ${duration.label()}',
      style:
          widget.style ??
          TextStyle(
            color: _theme(context).buttonBarButtonColor,
            fontSize: 12.0,
            fontWeight: FontWeight.w500,
          ),
    );
  }
}
