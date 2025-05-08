import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../constants/app_colors.dart';
import '../../../../constants/app_defaults.dart';
import '../../../../core/components/app_back_button.dart';
import '../../../../core/components/app_settings_tile.dart';
import '../../../../core/themes/app_themes.dart';

class LanguageSettingsPage extends StatefulWidget {
  const LanguageSettingsPage({super.key});

  @override
  _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
}

class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String? _selectedLanguageCode;

  void _updateSearchQuery(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  void _changeLanguage(String languageCode) {
    Locale locale = Locale(languageCode);
    Get.updateLocale(locale);
    setState(() {
      _selectedLanguageCode = languageCode;
    });
    Navigator.pop(context); // Close the LanguageSettingsPage after selecting the language
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppBackButton(),
        title: const Text('Language Settings'),
      ),
      backgroundColor: AppColors.cardColor,
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(AppDefaults.padding),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding,
            vertical: AppDefaults.padding * 2,
          ),
          decoration: BoxDecoration(
            color: AppColors.scaffoldBackground,
            borderRadius: AppDefaults.borderRadius,
          ),
          child: Column(
            children: [
              _SearchField(
                controller: _searchController,
                onChanged: _updateSearchQuery,
              ),
              const _SuggestedLanguage(),
              _AllCountries(
                searchQuery: _searchQuery,
                onLanguageSelected: _changeLanguage,
                selectedLanguageCode: _selectedLanguageCode,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AllCountries extends StatelessWidget {
  final String searchQuery;
  final Function(String) onLanguageSelected;
  final String? selectedLanguageCode;

  const _AllCountries({
    required this.searchQuery,
    required this.onLanguageSelected,
    this.selectedLanguageCode,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> languages = [
      {'name': 'English (United States)', 'code': 'en'},
      {'name': 'Hindi', 'code': 'hi'},
      {'name': 'Marathi', 'code': 'mr'},
      {'name': 'Afrikaans', 'code': 'af'},
      {'name': 'Albanian', 'code': 'sq'},
      {'name': 'Amharic', 'code': 'am'},
      {'name': 'Arabic', 'code': 'ar'},
      {'name': 'Armenian', 'code': 'hy'},
      {'name': 'Assamese', 'code': 'as'},
      {'name': 'Aymara', 'code': 'ay'},
      {'name': 'Azerbaijani', 'code': 'az'},
      {'name': 'Bambara', 'code': 'bm'},
      {'name': 'Basque', 'code': 'eu'},
      {'name': 'Belarusian', 'code': 'be'},
      {'name': 'Bengali', 'code': 'bn'},
      {'name': 'Bhojpuri', 'code': 'bho'},
      {'name': 'Bosnian', 'code': 'bs'},
      {'name': 'Bulgarian', 'code': 'bg'},
      {'name': 'Catalan', 'code': 'ca'},
      {'name': 'Cebuano', 'code': 'ceb'},
      {'name': 'Chinese (Simplified)', 'code': 'zh-cn'},
      {'name': 'Chinese (Traditional)', 'code': 'zh-tw'},
      {'name': 'Corsican', 'code': 'co'},
      {'name': 'Croatian', 'code': 'hr'},
      {'name': 'Czech', 'code': 'cs'},
      {'name': 'Danish', 'code': 'da'},
      {'name': 'Dhivehi', 'code': 'dv'},
      {'name': 'Dogri', 'code': 'doi'},
      {'name': 'Dutch', 'code': 'nl'},
      {'name': 'Esperanto', 'code': 'eo'},
      {'name': 'Estonian', 'code': 'et'},
      {'name': 'Ewe', 'code': 'ee'},
      {'name': 'Filipino (Tagalog)', 'code': 'fil'},
      {'name': 'Finnish', 'code': 'fi'},
      {'name': 'French', 'code': 'fr'},
      {'name': 'Frisian', 'code': 'fy'},
      {'name': 'Galician', 'code': 'gl'},
      {'name': 'Georgian', 'code': 'ka'},
      {'name': 'German', 'code': 'de'},
      {'name': 'Greek', 'code': 'el'},
      {'name': 'Guarani', 'code': 'gn'},
      {'name': 'Gujarati', 'code': 'gu'},
      {'name': 'Haitian Creole', 'code': 'ht'},
      {'name': 'Hausa', 'code': 'ha'},
      {'name': 'Hawaiian', 'code': 'haw'},
      {'name': 'Hebrew', 'code': 'he'},
      {'name': 'Hmong', 'code': 'hmn'},
      {'name': 'Hungarian', 'code': 'hu'},
      {'name': 'Icelandic', 'code': 'is'},
      {'name': 'Igbo', 'code': 'ig'},
      {'name': 'Ilocano', 'code': 'ilo'},
      {'name': 'Indonesian', 'code': 'id'},
      {'name': 'Irish', 'code': 'ga'},
      {'name': 'Italian', 'code': 'it'},
      {'name': 'Japanese', 'code': 'ja'},
      {'name': 'Javanese', 'code': 'jv'},
      {'name': 'Kannada', 'code': 'kn'},
      {'name': 'Kazakh', 'code': 'kk'},
      {'name': 'Khmer', 'code': 'km'},
      {'name': 'Kinyarwanda', 'code': 'rw'},
      {'name': 'Konkani', 'code': 'gom'},
      {'name': 'Korean', 'code': 'ko'},
      {'name': 'Krio', 'code': 'kri'},
      {'name': 'Kurdish (Kurmanji)', 'code': 'ku'},
      {'name': 'Kurdish (Sorani)', 'code': 'ckb'},
      {'name': 'Kyrgyz', 'code': 'ky'},
      {'name': 'Lao', 'code': 'lo'},
      {'name': 'Latin', 'code': 'la'},
      {'name': 'Latvian', 'code': 'lv'},
      {'name': 'Lingala', 'code': 'ln'},
      {'name': 'Lithuanian', 'code': 'lt'},
      {'name': 'Luganda', 'code': 'lg'},
      {'name': 'Luxembourgish', 'code': 'lb'},
      {'name': 'Macedonian', 'code': 'mk'},
      {'name': 'Maithili', 'code': 'mai'},
      {'name': 'Malagasy', 'code': 'mg'},
      {'name': 'Malay', 'code': 'ms'},
      {'name': 'Malayalam', 'code': 'ml'},
      {'name': 'Maltese', 'code': 'mt'},
      {'name': 'Maori', 'code': 'mi'},
      {'name': 'Marathi', 'code': 'mr'},
      {'name': 'Meiteilon (Manipuri)', 'code': 'mni-mtei'},
      {'name': 'Mizo', 'code': 'lus'},
      {'name': 'Mongolian', 'code': 'mn'},
      {'name': 'Myanmar (Burmese)', 'code': 'my'},
      {'name': 'Nepali', 'code': 'ne'},
      {'name': 'Norwegian', 'code': 'no'},
      {'name': 'Nyanja (Chichewa)', 'code': 'ny'},
      {'name': 'Odia (Oriya)', 'code': 'or'},
      {'name': 'Oromo', 'code': 'om'},
      {'name': 'Pashto', 'code': 'ps'},
      {'name': 'Persian', 'code': 'fa'},
      {'name': 'Polish', 'code': 'pl'},
      {'name': 'Portuguese', 'code': 'pt'},
      {'name': 'Punjabi', 'code': 'pa'},
      {'name': 'Quechua', 'code': 'qu'},
      {'name': 'Romanian', 'code': 'ro'},
      {'name': 'Russian', 'code': 'ru'},
      {'name': 'Samoan', 'code': 'sm'},
      {'name': 'Sanskrit', 'code': 'sa'},
      {'name': 'Scots Gaelic', 'code': 'gd'},
      {'name': 'Sepedi', 'code': 'nso'},
      {'name': 'Serbian', 'code': 'sr'},
      {'name': 'Sesotho', 'code': 'st'},
      {'name': 'Shona', 'code': 'sn'},
      {'name': 'Sindhi', 'code': 'sd'},
      {'name': 'Sinhala', 'code': 'si'},
      {'name': 'Slovak', 'code': 'sk'},
      {'name': 'Slovenian', 'code': 'sl'},
      {'name': 'Somali', 'code': 'so'},
      {'name': 'Spanish', 'code': 'es'},
      {'name': 'Sundanese', 'code': 'su'},
      {'name': 'Swahili', 'code': 'sw'},
      {'name': 'Swedish', 'code': 'sv'},
      {'name': 'Tagalog (Filipino)', 'code': 'tl'},
      {'name': 'Tajik', 'code': 'tg'},
      {'name': 'Tamil', 'code': 'ta'},
      {'name': 'Tatar', 'code': 'tt'},
      {'name': 'Telugu', 'code': 'te'},
      {'name': 'Thai', 'code': 'th'},
      {'name': 'Tigrinya', 'code': 'ti'},
      {'name': 'Tsonga', 'code': 'ts'},
      {'name': 'Turkish', 'code': 'tr'},
      {'name': 'Turkmen', 'code': 'tk'},
      {'name': 'Twi (Akan)', 'code': 'ak'},
      {'name': 'Ukrainian', 'code': 'uk'},
      {'name': 'Urdu', 'code': 'ur'},
      {'name': 'Uyghur', 'code': 'ug'},
      {'name': 'Uzbek', 'code': 'uz'},
      {'name': 'Vietnamese', 'code': 'vi'},
      {'name': 'Welsh', 'code': 'cy'},
      {'name': 'Xhosa', 'code': 'xh'},
      {'name': 'Yiddish', 'code': 'yi'},
      {'name': 'Yoruba', 'code': 'yo'},
      {'name': 'Zulu', 'code': 'zu'},
    ];

    final List<Map<String, String>> filteredLanguages = languages
        .where((language) => language['name']!
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: AppDefaults.padding),
        const Text('All Languages'),
        const SizedBox(height: AppDefaults.padding),
        ...filteredLanguages.map((language) {
          return AppSettingsListTile(
            label: language['name']!,
            trailing: selectedLanguageCode == language['code']
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => onLanguageSelected(language['code']!),
          );
        }),
      ],
    );
  }
}

class _SuggestedLanguage extends StatelessWidget {
  const _SuggestedLanguage();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDefaults.padding),
        Text('Default'),
        SizedBox(height: AppDefaults.padding),
        AppSettingsListTile(
          label: 'English (United States)',
          trailing: Icon(
            Icons.check,
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        inputDecorationTheme: AppTheme.secondaryInputDecorationTheme,
      ),
      child: TextField(
        controller: controller,
        decoration: const InputDecoration(
          labelText: 'Search',
          hintText: 'Type a word',
          suffixIcon: Padding(
            padding: EdgeInsets.all(AppDefaults.padding),
            child: Icon(Icons.search),
          ),
          suffixIconConstraints: BoxConstraints(),
        ),
        onChanged: onChanged,
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// class LanguageSettingsPage extends StatefulWidget {
//   const LanguageSettingsPage({super.key});
//
//   @override
//   _LanguageSettingsPageState createState() => _LanguageSettingsPageState();
// }
//
// class _LanguageSettingsPageState extends State<LanguageSettingsPage> {
//   final List<Map<String, String>> _languages = [
//     {'name': 'English', 'code': 'en'},
//     {'name': 'Hindi', 'code': 'hi'},
//     // Add more languages with their respective language codes here
//   ];
//
//   String _selectedLanguageCode = Get.locale?.languageCode ?? 'en';
//
//   void _changeLanguage(String languageCode) {
//     setState(() {
//       _selectedLanguageCode = languageCode;
//     });
//     Locale locale = Locale(languageCode);
//     Get.updateLocale(locale);
//     Get.back(); // Close the LanguageSettingsPage after selecting the language
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Language Settings'),
//       ),
//       body: ListView.builder(
//         itemCount: _languages.length,
//         itemBuilder: (context, index) {
//           final language = _languages[index];
//           return ListTile(
//             title: Text(language['name']!),
//             trailing: _selectedLanguageCode == language['code']
//                 ? const Icon(Icons.check, color: Colors.green)
//                 : null,
//             onTap: () => _changeLanguage(language['code']!),
//           );
//         },
//       ),
//     );
//   }
// }
