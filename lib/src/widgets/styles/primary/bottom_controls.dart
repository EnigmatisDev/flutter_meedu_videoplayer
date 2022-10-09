import 'package:flutter/material.dart';
import 'package:flutter_meedu/ui.dart';
import 'package:flutter_meedu_videoplayer/meedu_player.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/responsive.dart';
import 'package:flutter_meedu_videoplayer/src/helpers/utils.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/fullscreen_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/mute_sound_button.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/playBackSpeed.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/player_slider.dart';
import 'package:flutter_meedu_videoplayer/src/widgets/video_fit_button.dart';

class PrimaryBottomControls extends StatelessWidget {
  final Responsive responsive;
  const PrimaryBottomControls({Key? key, required this.responsive})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _ = MeeduPlayerController.of(context);
    final fontSize = responsive.ip(2.5);
    final size = MediaQuery.of(context).size;
    final textStyle = TextStyle(
      color: Colors.white,
      fontSize: fontSize > 16 ? 16 : fontSize,
    );
    return Positioned(
      left: 5,
      right: 0,
      bottom: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // START VIDEO POSITION
          if (_.isLive != true)
            RxBuilder(
                //observables: [_.duration, _.position],
                (__) {
              return Text(
                _.duration.value.inMinutes >= 60
                    ? printDurationWithHours(_.position.value)
                    : printDuration(_.position.value),
                style: textStyle,
              );
            }),
          // END VIDEO POSITION
          SizedBox(width: 10),
          _.isLive != true
              ? Expanded(
                  child: PlayerSlider(),
                )
              : Container(
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * 0.02,
                      vertical: size.height * 0.01),
                  height: size.height * 0.03,
                  width: size.width * 0.11,
                  decoration: BoxDecoration(
                      boxShadow: const [
                        BoxShadow(
                            color: Colors.redAccent,
                            offset: Offset(0, 0),
                            blurRadius: 7)
                      ],
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(5)),
                  child: const Center(
                    child: Text(
                      "LIVE",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
          if (_.isLive == true) const Spacer(),
          const SizedBox(width: 10),
          // START VIDEO DURATION
          if (_.isLive != true)
            RxBuilder(
              //observables: [_.duration],
              (__) => Text(
                _.duration.value.inMinutes >= 60
                    ? printDurationWithHours(_.duration.value)
                    : printDuration(_.duration.value),
                style: textStyle,
              ),
            ),
          // END VIDEO DURATION
          SizedBox(width: 15),
          if (_.bottomRight != null) ...[_.bottomRight!, SizedBox(width: 5)],

          //if (_.enabledButtons.pip) PipButton(responsive: responsive),

          if (_.enabledButtons.videoFit) VideoFitButton(responsive: responsive),
          if (_.enabledButtons.playBackSpeed)
            PlayBackSpeedButton(responsive: responsive, textStyle: textStyle),
          if (_.enabledButtons.muteAndSound)
            MuteSoundButton(responsive: responsive),

          if (_.enabledButtons.fullscreen)
            FullscreenButton(
              size: responsive.ip(_.fullscreen.value ? 5 : 7),
            )
        ],
      ),
    );
  }
}
