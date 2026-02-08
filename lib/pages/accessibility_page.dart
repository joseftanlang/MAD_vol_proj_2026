import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:final_project_flutter/accessibility_provider.dart';
import 'package:provider/provider.dart';
import 'package:final_project_flutter/l10n/app_localizations.dart';

class AccessibilityPage extends StatefulWidget {
  const AccessibilityPage({super.key});

  @override
  State<AccessibilityPage> createState() => _AccessibilityPageState();
}

class _AccessibilityPageState extends State<AccessibilityPage> {
  // Widget states
  double _currentSliderValue = 1;
  bool _switchState = false;
  String lang = "English";
  final TextEditingController _searchController = TextEditingController();
  List<String> filteredOptions = [];
  // Check whether item is saved or not!!
  bool fontSaved = true;
  bool contrastSaved = true;

  static const savedSnackBar = SnackBar(
    content: Text("Item saved successfully", style: TextStyle(fontSize: 20)),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.purple,
  );
  static const nothingSavedSnackBar = SnackBar(
    content: Text("Nothing to save!!", style: TextStyle(fontSize: 20)),
    duration: Duration(seconds: 2),
    backgroundColor: Colors.purple,
  );
  // Local Firestore data: So that don't need to keep reading from database!!
  static double fontSize = 1;
  final List<String> allOptions = ['English', 'Chinese'];
  String currentLang = "";
  bool darkMode = false;

  @override
  void initState() {
    super.initState();
    fontSaved = true;
    contrastSaved = true;
    filteredOptions = allOptions;
    syncWithDatabase();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void searchFiltering(String k) {
    setState(() {
      // Ensures that list won't be empty if user deletes every text in search bar
      if (k.isEmpty) {
        filteredOptions = allOptions;
      } else {
        filteredOptions = allOptions
            .where((option) => option.toLowerCase().contains(k.toLowerCase()))
            .toList();
      }
    });
  }

  void syncWithDatabase() async {
    // FirebaseAuth latest user data, used to access User's UID!!
    final user = FirebaseAuth.instance.currentUser;
    // Used a powerful firestore method: .set() which creates if field not found and updates if field is found
    if (user != null) {
      try {
        if (!AccessibilityProvider.accessibilitySynced) {
          DocumentSnapshot doc = await FirebaseFirestore.instance
              .collection('accessibility')
              .doc(user.uid)
              .get();
          Map<String, dynamic> data = {
            'fontSize': 1,
            'darkMode': false,
            'language': 'English',
          };

          // If document don't exist, create user document as default settings first!!
          if (!doc.exists) {
            // .set() is used here instead of .add() to give document an unique ID
            await FirebaseFirestore.instance
                .collection('accessibility')
                .doc(user.uid)
                .set(data);
          } else {
            data =
                doc.data()
                    as Map<
                      String,
                      dynamic
                    >; // Only if document is found use it, if not stick to default!!
          }
          setState(() {
            currentLang = data["language"];
            _switchState = data["darkMode"];
            _currentSliderValue = data["fontSize"];
          });
          lang = data["language"];
          darkMode = data["darkMode"];
          fontSize = data["fontSize"];
        } else {
          Map<String, dynamic> data = AccessibilityProvider.data;
          setState(() {
            currentLang = data["language"];
            _switchState = data["darkMode"];
            _currentSliderValue = data["fontSize"];
          });
          lang = data["language"];
          darkMode = data["darkMode"];
          fontSize = data["fontSize"];
        }
      } catch (err) {
        print("Document not made yet!!");
      }
    } else {
      print("User not logged in!!");
    }
  }

  // Used to update user accessibility settings!! Type indicates which to change
  void updateUserAccessibility(int type, dynamic changedValue) async {
    // FirebaseAuth latest user data, used to access User's UID!!
    final user = FirebaseAuth.instance.currentUser;
    // Used a powerful firestore method: .set() which creates if field not found and updates if field is found
    if (user != null) {
      switch (type) {
        case 1:
          AccessibilityProvider.data["fontSize"] = changedValue;
          await FirebaseFirestore.instance
              .collection('accessibility')
              .doc(user.uid)
              .update({
                'fontSize': changedValue,
              }); // Setoptions ensures it only updates field mentioned!!
        case 2:
        AccessibilityProvider.data["darkMode"] = changedValue;
          await FirebaseFirestore.instance
              .collection('accessibility')
              .doc(user.uid)
              .update({'darkMode': changedValue});

        case 3:
        AccessibilityProvider.data["language"] = changedValue;
          await FirebaseFirestore.instance
              .collection('accessibility')
              .doc(user.uid)
              .update({'language': changedValue});
        case 4:
          AccessibilityProvider.data["fontSize"] = changedValue[0];
          AccessibilityProvider.data["darkMode"] = changedValue[1];
          await FirebaseFirestore.instance
              .collection('accessibility')
              .doc(user.uid)
              .update({
                'fontSize': changedValue[0],
                'darkMode': changedValue[1],
              });
      }
    } else {
      print("User not logged in!!");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        // This alerts user that they have not saved something!!
        leading: IconButton(
          onPressed: () {
            if (!fontSaved || !contrastSaved) {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text(AppLocalizations.of(context)!.saveChangesDialogTitle, style: Theme.of(context).textTheme.titleMedium,),
                    content: Text(
                      AppLocalizations.of(context)!.saveChangesDialogContent, style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    actions: [
                      MaterialButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(AppLocalizations.of(context)!.cancel, style: Theme.of(context).textTheme.bodyMedium,),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          fontSaved = true;
                          contrastSaved = true;
                          Navigator.pushNamed(context, "/home");
                        },
                        child: Text(AppLocalizations.of(context)!.dontSave, style: Theme.of(context).textTheme.bodyMedium,),
                      ),
                      FilledButton(
                        onPressed: () {
                          fontSize = _currentSliderValue;
                          darkMode = _switchState;
                          if (!fontSaved || !contrastSaved) {
                            updateUserAccessibility(4, [
                              _currentSliderValue,
                              _switchState,
                            ]);
                          } else if (!contrastSaved) {
                            updateUserAccessibility(2, _switchState);
                          } else {
                            updateUserAccessibility(1, _currentSliderValue);
                          }
                          fontSaved = true;
                          contrastSaved = true;
                          Navigator.pushNamed(context, "/home");
                        },
                        child: Text(AppLocalizations.of(context)!.save, style: Theme.of(context).textTheme.bodyMedium,),
                      ),
                    ],
                  );
                },
              );
            } else {
              Navigator.pushNamed(context, "/home");
            }
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: SizedBox(
          height: 40,
          child: Image.asset(
            'assets/Singapore_poly.png',
            fit: BoxFit.contain,
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                debugPrint('Profile icon tapped');
                Navigator.pushNamed(context, '/settings');
              },
              child: const CircleAvatar(
                radius: 18,
                backgroundColor: Colors.white,
                child: Icon(Icons.person, color: Colors.blueAccent),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            spacing: 20,
            children: [
              SizedBox(height: 10),
              
              Text(
                AppLocalizations.of(context)!.accessibilityEditPreference,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              SizedBox(height: 36),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                spacing: 10,
                children: [
                  Container(
                    width: 350,
                    constraints: BoxConstraints(minHeight: 300),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // color: Colors.white70,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueGrey, width: 3),
                    ),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.fontSizeTitle,
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium!.copyWith(color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 26),
                        Text(
                          AppLocalizations.of(context)!.currentSettings,
                          style: Theme.of(
                            context,
                          ).textTheme.bodyMedium!.copyWith(color: Colors.grey),
                        ),
                        SizedBox(height: 16),
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setDialogStateAgain) {
                                    return AlertDialog(
                                      title: Text(AppLocalizations.of(context)!.editFontSize, style: Theme.of(context).textTheme.titleMedium,),
                                      content: Container(
                                        width: 300,
                                        constraints: BoxConstraints(
                                          minHeight: 100,
                                        ),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "A",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Slider(
                                                    value: _currentSliderValue,
                                                    max: 2,
                                                    min: 1,
                                                    divisions: 4,
                                                    // label: _currentSliderValue
                                                    //     .round()
                                                    //     .toString(),
                                                    onChanged: (value) {
                                                      fontSaved = false;
                                                      if (fontSize == value) {
                                                        fontSaved = true;
                                                      }
                                                      _currentSliderValue =
                                                          value;
                                                      setDialogStateAgain(
                                                        () {},
                                                      );
                                                    },
                                                  ),
                                                ),
                                                Text(
                                                  "A",
                                                  style: TextStyle(
                                                    fontSize: 64,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Container(
                                                  width: 106,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                0,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                0,
                                                              ),
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.blueGrey,
                                                      width: 4,
                                                    ),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      fontSaved = false;
                                                      if (_currentSliderValue <
                                                          1.25) {
                                                        _currentSliderValue =
                                                            1.25;
                                                      }
                                                      _currentSliderValue -=
                                                          0.25;
                                                      if (fontSize ==
                                                          _currentSliderValue) {
                                                        fontSaved = true;
                                                      }
                                                      setDialogStateAgain(
                                                        () {},
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .remove_circle_outline_sharp,
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: 106,
                                                  height: 50,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                0,
                                                              ),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                0,
                                                              ),
                                                          topRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                          bottomRight:
                                                              Radius.circular(
                                                                10,
                                                              ),
                                                        ),
                                                    border: Border.all(
                                                      color: Colors.blueGrey,
                                                      width: 4,
                                                    ),
                                                  ),
                                                  child: IconButton(
                                                    onPressed: () {
                                                      fontSaved = false;
                                                      if (_currentSliderValue >
                                                          1.75) {
                                                        _currentSliderValue =
                                                            1.75;
                                                      }
                                                      _currentSliderValue +=
                                                          0.25;
                                                      if (fontSize ==
                                                          _currentSliderValue) {
                                                        fontSaved = true;
                                                      }
                                                      setDialogStateAgain(
                                                        () {},
                                                      );
                                                    },
                                                    icon: Icon(
                                                      Icons
                                                          .add_circle_outline_sharp,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: 10),

                                            SizedBox(height: 16),
                                            Text(
                                              AppLocalizations.of(context)!.exampleBody,
                                              style: TextStyle(
                                                fontSize:
                                                    _currentSliderValue * 16,
                                              ),
                                            ),
                                            SizedBox(height: 6),
                                            (fontSaved)
                                                ? Text(
                                                    AppLocalizations.of(context)!.noUnsavedChanges,
                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      color: Colors.grey
                                                    ),
                                                  )
                                                : Text(
                                                    AppLocalizations.of(context)!.pressSaveChanges,
                                                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                                      color: Colors.grey
                                                    ),
                                                  ),
                                          ],
                                        ),
                                      ),

                                      actions: [
                                        MaterialButton(
                                          onPressed: () {
                                            _searchController.clear();
                                            filteredOptions = allOptions;
                                            lang = currentLang;
                                            Navigator.pop(context);
                                          },
                                          child: Text(AppLocalizations.of(context)!.cancel, style: Theme.of(context).textTheme.bodyMedium,),
                                        ),
                                        // Save button only works if user selected a different selection!!
                                        FilledButton(
                                          onPressed:
                                              (fontSize != _currentSliderValue)
                                              ? () {
                                                  Provider.of<
                                                        AccessibilityProvider
                                                      >(context, listen: false)
                                                      .changeFontSize(
                                                        _currentSliderValue,
                                                      );
                                                  updateUserAccessibility(
                                                    1,
                                                    _currentSliderValue,
                                                  );
                                                  fontSize =
                                                      _currentSliderValue;
                                                  ScaffoldMessenger.of(
                                                    context,
                                                  ).showSnackBar(savedSnackBar);
                                                  fontSaved = true;
                                                  Navigator.pop(context);
                                                }
                                              : null,
                                          child: Text(AppLocalizations.of(context)!.save, style: Theme.of(context).textTheme.bodyMedium,),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Container(
                            width: 260,
                            padding: EdgeInsets.all(6),
                            constraints: BoxConstraints(minHeight: 60),
                            decoration: BoxDecoration(
                              // color: Colors.white70,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.purple,
                                width: 3,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.previewTitle,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.headlineMedium,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.previewSubtitle,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  AppLocalizations.of(context)!.previewBodyText,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(height: 6),
                                Text(
                                  AppLocalizations.of(context)!.tapBoxToChange,
                                  style: Theme.of(context).textTheme.bodyMedium!
                                      .copyWith(color: Colors.blueGrey),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 350,
                    constraints: BoxConstraints(minHeight: 100),
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.blueGrey, width: 3),
                    ),
                    child: Column(
                      spacing: 16,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.appContrast,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 5,
                          children: [
                            Icon(Icons.light_mode_sharp),
                            Switch(
                              value: _switchState,
                              onChanged: (value) {
                                contrastSaved = false;
                                if (value == darkMode) {
                                  contrastSaved = true;
                                }
                                setState(() {
                                  _switchState = value;
                                });
                                (value)
                                    ? Provider.of<AccessibilityProvider>(
                                        context,
                                        listen: false,
                                      ).changeContrast(ThemeMode.dark)
                                    : Provider.of<AccessibilityProvider>(
                                        context,
                                        listen: false,
                                      ).changeContrast(ThemeMode.light);
                              },
                            ),
                            Icon(Icons.dark_mode_sharp),
                          ],
                        ),
                        FilledButton(
                          onPressed: () {
                            if (darkMode != _switchState) {
                              updateUserAccessibility(2, _switchState);
                              (_switchState)
                                  ? Provider.of<AccessibilityProvider>(
                                      context,
                                      listen: false,
                                    ).changeContrast(ThemeMode.dark)
                                  : Provider.of<AccessibilityProvider>(
                                      context,
                                      listen: false,
                                    ).changeContrast(ThemeMode.light);
                              darkMode = _switchState;
                              setState(() {
                                contrastSaved = true;
                              });
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(savedSnackBar);
                            } else {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(nothingSavedSnackBar);
                            }
                          },
                          child: Text(AppLocalizations.of(context)!.save, style: Theme.of(context).textTheme.bodyMedium,),
                        ),
                        (contrastSaved)
                            ? Text(
                                AppLocalizations.of(context)!.noUnsavedChanges,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey
                                ),
                              )
                            : Text(
                                AppLocalizations.of(context)!.pressSaveChanges,
                                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                  color: Colors.grey
                                ),
                              ),
                      ],
                    ),
                  ),
                ],
              ),

              Container(
                width: 350,
                constraints: BoxConstraints(minHeight: 100),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.blueGrey, width: 3),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.preferredLanguage,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 5),
                    Text(
                      AppLocalizations.of(context)!.currentLanguage((currentLang == "English")
                        ? AppLocalizations.of(context)!.english
                        : AppLocalizations.of(context)!.chinese),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 10),
                    FilledButton(
                      onPressed: () {
                        // Ensures search bar is cleared when enter!!
                        _searchController.clear();
                        filteredOptions = allOptions;
                        showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                              builder: (context, setDialogState) {
                                return AlertDialog(
                                  title: Text(AppLocalizations.of(context)!.selectLanguage, style: Theme.of(context).textTheme.titleMedium,),
                                  content: SizedBox(
                                    width: double.maxFinite,
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: _searchController,
                                          decoration: InputDecoration(
                                            hintText: AppLocalizations.of(context)!.searchLanguage,
                                            hintStyle: Theme.of(context).textTheme.bodyMedium,
                                            prefixIcon: const Icon(
                                              Icons.search_sharp,
                                            ),
                                            suffixIcon:
                                                (_searchController
                                                    .text
                                                    .isNotEmpty)
                                                ? IconButton(
                                                    onPressed: () {
                                                      filteredOptions = allOptions;
                                                      setDialogState(() {});
                                                      _searchController.clear();
                                                    },
                                                    icon: const Icon(
                                                      Icons.close_sharp,
                                                    ),
                                                  )
                                                : null,
                                            border: const OutlineInputBorder(),
                                          ),
                                          onChanged: (value) {
                                            searchFiltering(value);
                                            setDialogState(() {});
                                          },
                                        ),
                                        const SizedBox(height: 10),
                                        SizedBox(
                                          height: 250,
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: filteredOptions.length,
                                            itemBuilder: (context, index) {
                                              return ListTile(
                                                title: Text(
                                                  (filteredOptions[index] == "English" ? "English" : "中文") ,
                                                ),
                                                trailing:
                                                    (filteredOptions[index] ==
                                                        lang)
                                                    ? Icon(Icons.star)
                                                    : null,
                                                enabled:
                                                    filteredOptions[index] !=
                                                    lang,
                                                selected:
                                                    filteredOptions[index] ==
                                                    lang,
                                                onTap: () {
                                                  setState(() {
                                                    lang =
                                                        filteredOptions[index];
                                                  });
                                                  setDialogState(() {});
                                                },
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  actions: [
                                    MaterialButton(
                                      onPressed: () {
                                        _searchController.clear();
                                        filteredOptions = allOptions;
                                        lang = currentLang;
                                        Navigator.pop(context);
                                      },
                                      child: Text(AppLocalizations.of(context)!.cancel, style: Theme.of(context).textTheme.bodyMedium,),
                                    ),
                                    // Save button only works if user selected a different selection!!
                                    FilledButton(
                                      onPressed: (currentLang != lang)
                                          ? () {
                                              updateUserAccessibility(3, lang);
                                              (currentLang != "English") ? Provider.of<AccessibilityProvider>(context,listen: false,).changeLanguage(Locale('en')): Provider.of<AccessibilityProvider>(context,listen: false,).changeLanguage(Locale('zh'));
                                              setState(() {
                                                currentLang = lang;
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(savedSnackBar);
                                            }
                                          : null,
                                      child: Text(AppLocalizations.of(context)!.save, style: Theme.of(context).textTheme.bodyMedium,),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: Text(AppLocalizations.of(context)!.changeLanguageButton, style: Theme.of(context).textTheme.bodyMedium,),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
