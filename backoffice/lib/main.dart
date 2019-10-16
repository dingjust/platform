import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:redux/redux.dart';
import 'package:services/services.dart';
import 'package:widgets/widgets.dart';
import 'package:core/core.dart';
import 'package:path_provider/path_provider.dart';

import 'src/my/home.dart';
import 'src/notification/home.dart';

void main() {
  debugInstrumentationEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final store = Store<AppState>(
    appReducer,

    /// 初始化数据
    initialState: AppState(
      user: User.empty(),
      theme: ThemeData(primarySwatch: Colors.blue),
      locale: Locale('zh', 'CN'),
    ),
  );

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// 通过 StoreProvider 应用 store
    return StoreProvider(
      store: store,
      child: StoreBuilder<AppState>(builder: (context, store) {
        return MaterialApp(
          title: '定制加 - 云Hybris平台',

          /// 多语言实现代理
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            AppLocalizationsDelegate.delegate,
          ],
          locale: store.state.locale,
          supportedLocales: [store.state.locale],
          theme: store.state.theme,
          home: SplashPage(),
          routes: <String, WidgetBuilder>{
            // 路由
            '/home': (BuildContext context) => HomePage()
          },
        );
      }),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Widget> _modules;

  void _handleNavigation(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    _modules = <Widget>[
      NotificationHomePage(
        repository: MessageRepositoryImpl(
          fileStorage: MessageFileStorage(
            "message",
            getApplicationDocumentsDirectory,
          ),
          webClient: MessageWebClient(),
        ),
      ),
      MyHomePage(),
    ];

    return Scaffold(
      body: _modules[_currentIndex],
      bottomNavigationBar: AppLocalizations(
        child: BottomNavigation(
          currentIndex: _currentIndex,
          onChanged: _handleNavigation,
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  BottomNavigation({Key key, this.currentIndex: 0, this.onChanged}) : super(key: key);

  final int currentIndex;
  final ValueChanged<int> onChanged;

  final List<BottomNavigationBarItem> items = [
    BottomNavigationBarItem(
      icon: const Icon(Icons.message),
      title: const Text('消息'),
    ),
    BottomNavigationBarItem(
      icon: const Icon(Icons.account_box),
      title: const Text('我的'),
    )
  ];

  void _handleTap(int index) {
    onChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: items,
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      onTap: _handleTap,
    );
  }
}

class AppLocalizations extends StatefulWidget {
  final Widget child;

  AppLocalizations({Key key, this.child}) : super(key: key);

  @override
  State<AppLocalizations> createState() => _AppLocalizationsState();
}

class _AppLocalizationsState extends State<AppLocalizations> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder<AppState>(builder: (context, store) {
      /// 通过 StoreBuilder 和 Localizations 实现实时多语言切换
      return Localizations.override(
        context: context,
        locale: store.state.locale,
        child: widget.child,
      );
    });
  }
}
