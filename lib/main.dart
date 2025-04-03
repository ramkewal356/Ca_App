import 'package:ca_app/blocs/auth/auth_bloc.dart';
import 'package:ca_app/blocs/custom_dropdown/custom_dropdown_bloc.dart';
import 'package:ca_app/blocs/customer/customer_bloc.dart';
import 'package:ca_app/blocs/dashboard/dashboard_bloc.dart';
import 'package:ca_app/blocs/document/document_bloc.dart';
import 'package:ca_app/blocs/help_and_support/help_and_support_bloc.dart';
import 'package:ca_app/blocs/image_picker/image_picker_bloc.dart';
import 'package:ca_app/blocs/logs/logs_bloc.dart';
import 'package:ca_app/blocs/multi_select_dropdown/multi_select_dropdown_bloc.dart';
import 'package:ca_app/blocs/permission/permission_bloc.dart';
import 'package:ca_app/blocs/raise_request/raise_request_bloc.dart';
import 'package:ca_app/blocs/reminder/reminder_bloc.dart';
import 'package:ca_app/blocs/service/service_bloc.dart';
import 'package:ca_app/blocs/task/task_bloc.dart';
import 'package:ca_app/blocs/team_member/team_member_bloc.dart';
import 'package:ca_app/blocs/upload_document/upload_document_bloc.dart';
// import 'package:ca_app/data/repositories/document_repository.dart';
import 'package:ca_app/routes/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await FlutterDownloader.initialize(debug: true, ignoreSsl: true);
  // FlutterDownloader.registerCallback(DocumentRepository.downloadCallback);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc()),
        BlocProvider(create: (_) => DashboardBloc()),
        BlocProvider(create: (_) => CustomDropdownBloc()),
    
        BlocProvider(create: (_) => UploadDocumentBloc()),
        BlocProvider(create: (_) => MultiSelectDropdownBloc()),
        BlocProvider(create: (_) => TeamMemberBloc()),
        BlocProvider(create: (_) => CustomerBloc()),
        BlocProvider(create: (_) => DocumentBloc()),
        BlocProvider(create: (_) => LogsBloc()),
        BlocProvider(create: (_) => ServiceBloc()),
        BlocProvider(create: (_) => DownloadDocumentBloc()),
        BlocProvider(create: (_) => AssigneCustomerBloc()),
        BlocProvider(create: (_) => TaskBloc()),
        BlocProvider(create: (_) => CreateNewTaskBloc()),
        BlocProvider(create: (_) => ActionOnTaskBloc()),
        BlocProvider(create: (_) => HelpAndSupportBloc()),
        BlocProvider(create: (_) => RaiseRequestBloc()),
        BlocProvider(create: (_) => GetDeginationBloc()),
        BlocProvider(create: (_) => ReminderBloc()),
        BlocProvider(create: (_) => CreateReminderBloc()),
        BlocProvider(create: (_) => ImagePickerBloc()),
        BlocProvider(create: (_) => GetLoginCustomerBloc()),
        BlocProvider(create: (_) => AssignServiceBloc()),
        BlocProvider(create: (_) => GetPermissionBloc()),
        BlocProvider(create: (_) => PermissionBloc())



      ],
      child: ScreenUtilInit(
          designSize: const Size(360, 690),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Flutter Demo',
              theme: ThemeData(
                colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
                useMaterial3: true,
              ),
              routerConfig: goRouter,
              // home: const MyHomePage(title: 'Flutter Demo Home Page'),
            );
          }
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
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
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
