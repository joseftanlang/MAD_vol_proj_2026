import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class TranslatePage extends StatefulWidget {
  @override
  _TranslatePageState createState() => _TranslatePageState();
}

class _TranslatePageState extends State<TranslatePage> {
  final TextEditingController _controller = TextEditingController();
  String _translatedText = '';

  void _translateText() async {
    final translator = GoogleTranslator();
    var translation = await translator.translate(_controller.text, to: 'tl');
    setState(() {
      _translatedText = translation.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Enter text to translate',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _translateText,
              child: Text('Translate to Chinese'),
            ),
            SizedBox(height: 20),
            Text(
              'Translated Text:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(_translatedText),
          ],
        ),
      ),
    );
  }
}