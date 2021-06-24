import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:scrapabill/services/navigation_service.dart';
import 'package:scrapabill/state_manager/state.dart';
import 'package:scrapabill/state_manager/store.dart';
import 'package:scrapabill/views/styles/k_colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        builder: (context, items) {
          return MaterialApp(
            title: 'Scrapabill',
            debugShowCheckedModeBanner: false,
            navigatorKey: NavigationService.navigatorKey,
            theme: ThemeData(
              appBarTheme: Theme.of(context)
                  .appBarTheme
                  .copyWith(brightness: Brightness.light),
              pageTransitionsTheme: PageTransitionsTheme(builders: {
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              }),
              primaryColor: KColor.primaryColor,
              accentColor: KColor.primaryColor,
            ),
            home: MyHomePage(title: 'Flutter Demo Home Page'),
          );
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
