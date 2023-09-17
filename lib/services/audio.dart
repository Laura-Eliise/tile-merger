import 'package:audioplayers/audioplayers.dart';

Future<void> pop() async {
  final player = AudioPlayer();
  await player.setSource(AssetSource('pop.mp3'));
  await player.resume();
}
