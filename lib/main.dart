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
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

// the entire contents of MyHomePage is extracted into a new widget, GeneratorPage. The only part of the old
// MyHomePage widget that didn't get extracted is Scaffold.

// then MyHomePage is modified extending a StatefulWidget instead of a StatelessWidget
// A StatefulWidget is a type of widget that has State
// Using StatefulWidget, we can avoid having all our variables stored in MyAppState
class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
  // The underscore (_) at the start of _MyHomePageState makes that class private
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0; // initialized to 0

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
        break;
      case 1:
        page = Placeholder();
        break;
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    return Scaffold(
      // The new MyHomePage contains a Row with two children. The first widget is SafeArea, and the second
      // is an Expanded widget.
      body: Row(
        children: [
          // The SafeArea ensures that its child is not obscured by a hardware notch or a status bar.
          // In this app, the widget wraps around NavigationRail
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(40.0),
              child: NavigationRail(
                extended: false,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                ],
                // A selected index of zero selects the first destination, a selected index of one selects the
                //second destination, and so on
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  //print('selected: $value');
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
          ),
          // Expanded widgets are extremely useful in rows and columns—they let you express layouts where some
          // children take only as much space as they need (NavigationRail, in this case) and other widgets should
          // take as much of the remaining room as possible (Expanded, in this case).
          Expanded(
            child: Container(
              color: Theme.of(context).colorScheme.primaryContainer,
              child: page,
            ),
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    // MyHomePage tracks changes to the app's current state using the watch method
    var pair = appState.current;
    // Extract Widget : doing this to extract it to a widget with the refactor menu

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      // Every build method must return a widget or (more typically) a nested tree
      // of widgets. In this case, the top-level widget is Scaffold.
      // It's a helpful widget and is found in the vast majority of real-world Flutter apps.
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // Column is one of the most basic layout widgets in Flutter. It takes any number of
        // children and puts them in a column from top to bottom. By default, the column visually
        // places its children at the top. You'll soon change this so that the column is centered.
        children: [
          //Text('A random AWESOME idea:'), // ← Example change.
          BigCard(pair: pair),
          // Extract Widget : doing this to extract it to a widget with the refactor menu

          // This second Text widget takes appState, and accesses the only member of that class,
          // current (which is a WordPair). WordPair provides several helpful getters, such as
          // asPascalCase or asSnakeCase. Here, we use asLowerCase but you can change this now
          // if you prefer one of the alternatives.

          SizedBox(height: 10),

          // We have used refactor "wrap with Row" to include a new button next to the "Next" button
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
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

  // add a like button and save the corresponding word pairs
  var favorites = <WordPair>[];
  // the property is initialized with an empty list [] and can only contain Wordpair type using generics (template)
  // a Set could be used instead.They are defined by {}

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
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
    final theme = Theme.of(context); // add to get color themes
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );
    // theme.textTheme, gives access to the app's font theme.
    // displayMedium property is a large style meant for display text
    // Dart, the programming language in which you're writing this app, is null-safe, so it
    // won't let you call methods of objects that are potentially null. In this case, though,
    // you can use the ! operator ("bang operator") to assure Dart you know what you're doing

    return Card(
      // Card is created by applying Refactor with "With Widget" to Padding, then entering Card
      color: theme.colorScheme.primary,
      child: Padding(
          // used Refactor and Wrapp2Padding to put the text in more space
          padding: const EdgeInsets.all(40.0),
          child: Text(
            pair.asLowerCase,
            style: style,
            semanticsLabel: "${pair.first} ${pair.second}",
          )),
    );
  }
}
