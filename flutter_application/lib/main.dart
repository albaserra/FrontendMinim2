import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application/blocs/user/user_bloc.dart';
import 'package:flutter_application/src/LocaleString.dart';
import 'package:flutter_application/src/creargrupo_screen.dart';


import 'package:flutter_application/src/crearticket_screen.dart';
import 'package:flutter_application/src/faqs_screen.dart';

import 'package:flutter_application/src/equipo_screen.dart';
import 'package:flutter_application/src/idioma_screen.dart';
import 'package:flutter_application/src/list_grupo_screen.dart';
import 'package:flutter_application/src/list_ticket_screen.dart';
import 'package:flutter_application/src/login_screen.dart';
import 'package:flutter_application/src/profile_screen.dart';
import 'package:flutter_application/src/register_screen.dart';
import 'package:flutter_application/src/tutorial_screen.dart';
import 'package:flutter_application/src/unirsegrupo_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:flutter_application/src/LocaleString.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application/src/controllers/language_controller.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';


Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  // Inicializa Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Configura el manejo de Dynamic Links
  handleDynamicLinks();

  runApp(MyApp(key: UniqueKey(), initialRoute: '/login_screen'));
}

void handleDynamicLinks() async {
  // Comprueba si hay un Dynamic Link pendiente al abrir la aplicación
  final PendingDynamicLinkData? data = await FirebaseDynamicLinks.instance.getInitialLink();
  final Uri? deepLink = data?.link;

  if (deepLink != null) {
    // Procesa el Dynamic Link
    processDynamicLink(deepLink);
  }

  // Escucha los Dynamic Links en segundo plano
  FirebaseDynamicLinks.instance.onLink(
    onSuccess: (PendingDynamicLinkData dynamicLinkData) async {
    final Uri deepLink = dynamicLinkData.link;

    if (deepLink != null) {
      // Procesa el Dynamic Link
      processDynamicLink(deepLink);
    }
  }, onError: (OnLinkErrorException e) async {
    // Maneja los errores si los hubiera
    print('Error al obtener el Dynamic Link: ${e.message}');
  });
}

void processDynamicLink(Uri deepLink) {
  if (deepLink.path == '/') {
    runApp(MyApp(key: UniqueKey(), initialRoute: '/login_screen'));
  } else {
    runApp(MyApp(key: UniqueKey(), initialRoute: '/login_screen'));
  }
}



class MyApp extends StatelessWidget {
  final String initialRoute;

  MyApp({required Key key, required String initialRoute})
      : initialRoute = initialRoute,
        super(key: key);
  //final LanguageController languageController;
  final LanguageController _languageController = Get.put(LanguageController());
  //const MyApp({Key? key, required this.languageController}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        
        BlocProvider<UserBloc>(
          create: (context) => UserBloc(),),

                  // Añade el proveedor del LanguageController
        Provider<LanguageController>(
          create: (_) => _languageController,

          
        ),
      ],
      child: GetMaterialApp(
        translations: LocalString(),
        locale: Locale('es', 'ES'),
          debugShowCheckedModeBanner: false,
          title: 'Price divider',
          initialRoute: initialRoute ?? '/',
          home: const LoginScreen(),
          onGenerateRoute: (RouteSettings settings) {
            switch (settings.name) {
              case '/list_grupo_screen':
                return MaterialPageRoute(
                    builder: (context) => const ListGrupoScreen());
              case '/faqs_screen':
                return MaterialPageRoute(
                    builder: (context) => FaqsScreen());
              case '/creargrupo_screen':
                return MaterialPageRoute(
                    builder: (context) => const CrearGrupoScreen());
              case '/unirsegrupo_screen':
                return MaterialPageRoute(
                    builder: (context) => const UnirseGrupoScreen());
              case '/list_ticket_screen':
                return MaterialPageRoute(
                    builder: (context) => const ListTicketScreen());
              // case '/list_producto_screen':
              //   return MaterialPageRoute(
              //       builder: (context) => const ListProductoScreen());
              


              case '/register_screen':
                return MaterialPageRoute(
                    builder: (context) => const RegisterScreen());

              case '/equipo_screen':
                return MaterialPageRoute(builder: (context) => EquipoScreen());
              case '/tutorial_screen':
                return MaterialPageRoute(builder: (context) => TutorialScreen());
              case '/profile_screen':
                return MaterialPageRoute(builder: (context) => ProfileScreen());
              case '/idioma_screen':
                return MaterialPageRoute(builder: (context) => IdiomaScreen());
              case '/login_screen':
                return MaterialPageRoute(
                    builder: (context) => const LoginScreen());
              case '/crearticket_screen':
                return MaterialPageRoute(
                    builder: (context) => const CrearTicketScreen());
              default:
                return MaterialPageRoute(
                    builder: (context) => const LoginScreen());
            }
          }),
    );
  }
}
