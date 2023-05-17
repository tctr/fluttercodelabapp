import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// At the very top of the file, you'll find the main() function
// In its current form, it only tells Flutter to run the app defined in MyApp
void main() {
  runApp(MyApp());
}

// The MyApp class extends StatelessWidget. Widgets are the elements from which you build
// every Flutter app. As you can see, even the app itself is a widget
// Note: We'll get to the explanation of StatelessWidget (versus StatefulWidget) later
// The code in MyApp sets up the whole app. It creates the :
//    - app-wide state (more on this later),
//    - names the app,
//    - defines the visual theme,
//    -and sets the "home" widget—the starting point of your app.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// Next, the MyAppState class defines the app's...well...state. This is your first foray
// into Flutter, so this codelab will keep it simple and focused. There are many powerful ways
// to manage app state in Flutter. One of the easiest to explain is ChangeNotifier, the approach
// taken by this app.

// MyAppState defines the data the app needs to function. Right now, it only contains a single
// variable with the current random word pair. You will add to this later

// The state class extends ChangeNotifier, which means that it can notify others about its own
// changes. For example, if the current word pair changes, some widgets in the app need to know

// The state is created and provided to the whole app using a ChangeNotifierProvider (see code
// above in MyApp). This allows any widget in the app to get hold of the state.

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  // The new getNext() method reassigns current with a new random WordPair. It also calls
  // notifyListeners()(a method of ChangeNotifier)that ensures that anyone watching MyAppState
  // is notified.
  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }
}

// Lastly, there's MyHomePage, the widget you've already modified

class MyHomePage extends StatelessWidget {
  @override
  // Every widget defines a build() method that's automatically called every time the widget's
  // circumstances change so that the widget is always up to date.
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // MyHomePage tracks changes to the app's current state using the watch method
    var pair = appState.current;
    // Extract Widget : doing this to extract it to a widget with the refactor menu

    return Scaffold(
      // Every build method must return a widget or (more typically) a nested tree
      // of widgets. In this case, the top-level widget is Scaffold.
      // It's a helpful widget and is found in the vast majority of real-world Flutter apps.
      body: Column(
        // Column is one of the most basic layout widgets in Flutter. It takes any number of
        // children and puts them in a column from top to bottom. By default, the column visually
        // places its children at the top. You'll soon change this so that the column is centered.
        children: [
          Text('A random AWESOME idea:'), // ← Example change.
          BigCard(pair: pair),
          // Extract Widget : doing this to extract it to a widget with the refactor menu

          // This second Text widget takes appState, and accesses the only member of that class,
          // current (which is a WordPair). WordPair provides several helpful getters, such as
          // asPascalCase or asSnakeCase. Here, we use asLowerCase but you can change this now
          // if you prefer one of the alternatives.

          ElevatedButton(
            onPressed: () {
              appState.getNext();
              // Call the getNext method from the button's callback
            },
            child: Text('Next'),
          ),
        ],
      ),
    );
  }
}

// Created a new widget by extracting the Text instruction to a widget
class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    return Card(
      // Card is created by applying Refactor with "With Widget" to Padding, then entering Card
      child: Padding(
        // used Refactor and Wrapp2Padding to put the text in more space
        padding: const EdgeInsets.all(40.0),
        child: Text(pair.asLowerCase),
      ),
    );
  }
}
