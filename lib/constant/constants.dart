import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

enum LogMode { debug, live }

enum ActionState { create, update, created, updated }

enum MessageStatus { success, warning, errors }

enum MessageType { text, image, audio, video, file, location }

enum OrderStatus { all, news, completed, reject }

const somethingWentWrong = "Something went wrong.";
const serverFailed = "Server Failur";
const internetConnectFailed = "Failed to connect to the network";

const errorMessage = "Something went wrong";
const errorInternetMessage = "Failed to connect to the network";
const currencySybol = "\$";
String gLanguage = "km";
String gLanguageCode = "KH";
const String rangExp =
    r"[\u1780-\u17FFa-zA-Z0-9\s!@#\$%^&*()_+\-=\[\]{};':\,./<>?]+|[#*0-9]\uFE0F?\u20E3|[\xA9\xAE\u203C\u2049\u2]"; // disable only emoji from keyboard

final navigatorKey = GlobalKey<NavigatorState>();
final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
const phnomPehnLat = 11.562108;
const phnomPehnLong = 104.888535;

// Khmer Unicode range
final khmerRegex = RegExp(r'[\u1780-\u17FF]+');

//khmer font family
var khmerFontFamily = GoogleFonts.siemreap().fontFamily;
//emglish font family
var englishFontFamily = GoogleFonts.dmSans().fontFamily;

enum RecordingQuality {
  low, // 64kbps, 44.1kHz
  mid, // 128kbps, 44.1kHz
  high, // 256kbps, 48kHz
}

Map<RecordingQuality, CodecSettings> codecSettings = {
  RecordingQuality.low: CodecSettings(bitrate: 64000, sampleRate: 44100),
  RecordingQuality.mid: CodecSettings(bitrate: 128000, sampleRate: 44100),
  RecordingQuality.high: CodecSettings(bitrate: 256000, sampleRate: 48000),
};

class CodecSettings {
  final int bitrate;
  final int sampleRate;
  CodecSettings({required this.bitrate, required this.sampleRate});
}
