import 'package:askbura/feature_box.dart';
// import 'package:askbura/openai_service.dart';
import 'package:askbura/pallete.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'askgemini.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'playht.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AiVOOVService playHTService = AiVOOVService();

  FlutterTts flutterTts = FlutterTts();
  final speechToText = SpeechToText();
  // final OpenaiService openAIService = OpenaiService();
  String lastWords = '';
  @override
  void initState() {
    super.initState();
    initSpeechToText();
    flutterTts.setLanguage("am-ET");
  }

  Future<void> initSpeechToText() async {
    await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    await speechToText.listen(onResult: onSpeechResult, localeId: 'am-ET');

    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords.isEmpty
          ? "እባኮትን ይናገሩ"
          : result.recognizedWords; // Fallback to default if empty
      print(lastWords);
    });
  }

  @override
  void dispose() {
    super.dispose();
    speechToText.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('AskBura'), leading: Icon(Icons.menu), centerTitle: true),
      body: Column(
        children: [
          Stack(
            children: [
              Center(
                child: Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.only(top: 4),
                    decoration: BoxDecoration(
                        color: Pallete.assistantCircleColor,
                        shape: BoxShape.circle)),
              ),
              Container(
                height: 123,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/burak.jpg'),

                    // Adjusts image to fit inside the circle
                  ),
                ),
              )
            ],
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.symmetric(horizontal: 40).copyWith(top: 30),
              decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(20).copyWith(topLeft: Radius.zero),
                  border: Border.all(color: Pallete.borderColor)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('Good Morning, What task can I do for you?',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontFamily: 'Cera Pro')),
              )),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(top: 10, left: 22),
            child: Text('Here are a few features',
                style: TextStyle(
                    fontFamily: 'Cera Pro',
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                FeatureBox(
                  color: Pallete.firstSuggestionBoxColor,
                  headerText: 'ChatGPT',
                  descriptionText:
                      'A smarter way to stay organized and informed with ChatGPT',
                ),
                FeatureBox(
                  color: Pallete.secondSuggestionBoxColor,
                  headerText: 'Dall-E',
                  descriptionText:
                      'Get inspired and stay creative with your personal assistand powered by Dall-E',
                ),
                FeatureBox(
                  color: Pallete.thirdSuggestionBoxColor,
                  headerText: 'Smart Voice Assistant',
                  descriptionText:
                      'Get the best of both worlds with a voice assistant powered by Dall-E and ChatGPT',
                ),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Pallete.firstSuggestionBoxColor,
          onPressed: () async {
            if (await speechToText.hasPermission &&
                speechToText.isNotListening) {
              print('i am listening');
              await startListening();
            } else if (speechToText.isListening) {
              print('i am stoping listening');

              Askgemini askgemini = Askgemini(prompt: lastWords);
              String response = await askgemini.network();

              print("Gemini Response: $response");
              await flutterTts.speak(response);
              await stopListening();
            } else {
              initSpeechToText();
            }
          },
          child: Icon(speechToText.isListening ? Icons.stop : Icons.mic,
              color: Colors.black)),
    );
  }
}
