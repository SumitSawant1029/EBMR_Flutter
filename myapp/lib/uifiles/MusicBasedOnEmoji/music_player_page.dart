import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart'; // Import the just_audio package

class MusicPlayerPage extends StatefulWidget {
  final String musicUrl;
  final String imageUrl;
  final String title;
  final String author;

  MusicPlayerPage({
    required this.musicUrl,
    required this.imageUrl,
    required this.title,
    required this.author,
  });

  @override
  _MusicPlayerPageState createState() => _MusicPlayerPageState();
}

class _MusicPlayerPageState extends State<MusicPlayerPage> {
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  Future<void> _initPlayer() async {
    try {
      await _player.setUrl(widget.musicUrl);
    } catch (e) {
      print("Error initializing player: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xFF242d5c)),
        backgroundColor: Color(0xFF51cffa),
        title: Text('Music Player'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.network(
              widget.imageUrl,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.author,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
          StreamBuilder<Duration>(
            stream: _player.positionStream,
            builder: (context, snapshot) {
              final position = snapshot.data ?? Duration.zero;
              final duration = _player.duration ?? Duration.zero;
              return Slider(
                value: position.inSeconds.toDouble(),
                min: 0.0,
                max: duration.inSeconds.toDouble(),
                onChanged: (value) {
                  _player.seek(Duration(seconds: value.toInt()));
                },
              );
            },
          ),
          IconButton(
            onPressed: () async {
              if (_player.playing) {
                await _player.pause();
              } else {
                await _player.play();
              }
              setState(() {});
            },
            icon: Icon(
              _player.playing ? Icons.pause : Icons.play_arrow,
              size: 36,
            ),
          ),
        ],
      ),
    );
  }
}
