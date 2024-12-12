import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class LanguageTranslation extends StatefulWidget {
  const LanguageTranslation({super.key});

  @override
  State<LanguageTranslation> createState() => _LanguageTranslationState();
}

class _LanguageTranslationState extends State<LanguageTranslation> {
  final List<String> languages = ['Malayalam', 'English', 'Hindi', 'Arabic'];
  String originalLanguage = 'From';
  String destinationLanguage = 'To';
  String output = '';
  bool isLoading = false; // Track loading state
  final TextEditingController languageController = TextEditingController();

  // Function to get the language code based on the selected language
  String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'Malayalam':
        return 'ml';
      case 'Hindi':
        return 'hi';
      case 'Arabic':
        return 'ar';
      default:
        return '';
    }
  }

  // Translation Function
  Future<void> translate(String src, String dest, String input) async {
    if (src.isEmpty || dest.isEmpty || input.isEmpty) {
      setState(() {
        output = 'Please select valid languages and enter text.';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true; // Start loading when translation begins
    });

    try {
      final translator = GoogleTranslator();
      var translation = await translator.translate(input, from: src, to: dest);
      setState(() {
        output = translation.text; // Update output with translated text
        isLoading = false; // Stop loading once translation is complete
      });
    } 
    catch (e) {
      setState(() {
        output = 'Failed to translate. Please try again.';
        isLoading = false; // Stop loading if there's an error
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Language Translator",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    hint: Text(
                      originalLanguage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.grey[800],
                    items: languages.map((String language) {
                      return DropdownMenuItem(
                        value: language,
                        child: Text(language, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        originalLanguage = value!;
                      });
                    },
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.arrow_right_alt_outlined, color: Colors.white),
                  const SizedBox(width: 20),
                  DropdownButton(
                    hint: Text(
                      destinationLanguage,
                      style: const TextStyle(color: Colors.white),
                    ),
                    dropdownColor: Colors.grey[800],
                    items: languages.map((String language) {
                      return DropdownMenuItem(
                        value: language,
                        child: Text(language, style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setState(() {
                        destinationLanguage = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: languageController,
                  cursorColor: Colors.white,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Enter text to translate',
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  
                ),
                onPressed: () {
                  String src = getLanguageCode(originalLanguage);
                  String dest = getLanguageCode(destinationLanguage);
                  translate(src, dest, languageController.text.trim());
                },
                child: isLoading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Translate'),
              ),
              const SizedBox(height: 20),
              Text(
                output,
                style: const TextStyle(color: Colors.white, fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
