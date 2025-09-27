import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/data/datasources/auth_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/midtrans_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/order_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/product_local_datasource.dart';
import 'package:flutter_pos/data/datasources/product_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/report_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/discount_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/order_local_datasource.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/data/datasources/customer_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/service_charge_remote_datasource.dart';
import 'package:flutter_pos/data/datasources/tax_remote_datasource.dart';
import 'package:flutter_pos/presentation/auth/pages/splash_screen_pages.dart';
import 'package:flutter_pos/presentation/draft_order/bloc/draft_order/draft_order_bloc.dart';
import 'package:flutter_pos/presentation/history/bloc/history/history_bloc.dart';
import 'package:flutter_pos/presentation/home/bloc/category/category_bloc.dart';
import 'package:flutter_pos/presentation/home/bloc/checkout/checkout_bloc.dart';
import 'package:flutter_pos/presentation/home/bloc/product/product_bloc.dart';
import 'package:flutter_pos/presentation/order/bloc/order/order_bloc.dart';
import 'package:flutter_pos/presentation/order/bloc/qris/qris_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/report/close_cashier/close_cashier_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/report/product_sales/product_sales_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/report/summary/summary_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/customer/customer_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_discount/sync_discount_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_tax/sync_tax_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/sync_service_charge/sync_service_charge_bloc.dart';
import 'package:flutter_pos/presentation/setting/bloc/theme/theme_bloc.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/session_manager.dart';
import 'core/utils/theme_manager.dart';
import 'core/utils/db_initializer.dart';
import 'l10n/app_localizations.dart';
import 'presentation/auth/bloc/login/login_bloc.dart';
import 'presentation/home/bloc/logout/logout_bloc.dart';
import 'presentation/setting/bloc/discount/bloc/discount_bloc.dart';
import 'presentation/setting/bloc/sync_customer/sync_customer_bloc.dart';
import 'presentation/setting/bloc/category_manage/category_manage_cubit.dart';
import 'presentation/setting/bloc/discount_manage/discount_manage_cubit.dart';
import 'presentation/setting/bloc/sync_category_upload/sync_category_upload_cubit.dart';
import 'presentation/setting/bloc/sync_discount_upload/sync_discount_upload_cubit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await initializeDatabase();
  } catch (e) {
    // Try force recreate if failed
    try {
      await initializeDatabase(forceRecreate: true);
    } catch (e) {
      // Show error to user or log, jangan infinite loop
      debugPrint('Database initialization failed: ' + e.toString());
    }
  }

  final isExpired = await SessionManager.isSessionExpired();
  if (isExpired) {
    final authLocalDatasource = AuthLocalDatasource();
    await authLocalDatasource.removeAuthData();
  } else {
    await SessionManager.updateLastActivity();
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static void setLocale(BuildContext context, Locale? newLocale) {
    final _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  AppThemeMode _currentThemeMode = AppThemeMode.system;
  Locale? _locale;

  void setLocale(Locale? locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('locale');
    setState(() {
      if (langCode == null || langCode == 'system') {
        _locale = null;
      } else {
        _locale = Locale(langCode);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    // Notify theme bloc about system theme change
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final themeBloc = context.read<ThemeBloc>();
      themeBloc.add(const ThemeEvent.systemThemeChanged());
    });
  }

  void _handleUserInteraction([_]) {
    SessionManager.updateLastActivity();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleUserInteraction,
      behavior: HitTestBehavior.opaque,
      child: _buildAppContent(context),
    );
  }

  Widget _buildAppContent(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => LogoutBloc(AuthRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductBloc(ProductRemoteDatasource())
            ..add(const ProductEvent.fetchLocal()),
        ),
        BlocProvider(create: (context) => CheckoutBloc()),
        BlocProvider(
          create: (context) => OrderBloc(
            // orderRemoteDatasource: OrderRemoteDatasource(),
            orderLocalDatasource: OrderLocalDatasource.instance,
            // discountRemoteDatasource: DiscountRemoteDatasource(),
            authLocalDatasource: AuthLocalDatasource(),
          ),
        ),
        BlocProvider(
          create: (context) => QrisBloc(MidtransRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => HistoryBloc(),
        ),
        BlocProvider(
          create: (context) => SyncOrderBloc(OrderRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CategoryBloc(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DraftOrderBloc(ProductLocalDatasource.instance),
        ),
        BlocProvider(
          create: (context) => SummaryBloc(),
        ),
        BlocProvider(
          create: (context) => ProductSalesBloc(),
        ),
        BlocProvider(
          create: (context) => CloseCashierBloc(ReportRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => DiscountBloc(DiscountRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CategoryManageCubit(),
        ),
        BlocProvider(
          create: (context) => DiscountManageCubit(),
        ),
        BlocProvider(
          create: (context) => SyncCategoryUploadCubit(),
        ),
        BlocProvider(
          create: (context) => SyncDiscountUploadCubit(),
        ),
        BlocProvider(
          create: (context) => CustomerBloc(CustomerRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncDiscountBloc(DiscountRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncTaxBloc(TaxRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) =>
              SyncServiceChargeBloc(ServiceChargeRemoteDatasource()),
        ),
        // BlocProvider(
        //   create: (context) => OrderBloc(
        //     // orderRemoteDatasource: OrderRemoteDatasource(),
        //     orderLocalDatasource: OrderLocalDatasource.instance,
        //     // discountRemoteDatasource: DiscountRemoteDatasource(),
        //     authLocalDatasource: AuthLocalDatasource(),
        //   )..add(const OrderEvent.started()),
        // ),
        BlocProvider(
          create: (context) => DiscountBloc(DiscountRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => SyncCustomerBloc(CustomerRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ThemeBloc()..add(const ThemeEvent.started()),
        ),
      ],
      child: BlocListener<ThemeBloc, ThemeState>(
        listener: (context, state) {
          state.map(
            initial: (_) {},
            loading: (_) {},
            loaded: (loadedState) {
              if (loadedState.currentTheme != _currentThemeMode) {
                setState(() {
                  _currentThemeMode = loadedState.currentTheme;
                });
              }
            },
            error: (_) {},
          );
        },
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'POS',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _currentThemeMode == AppThemeMode.system
              ? ThemeMode.system
              : (_currentThemeMode == AppThemeMode.dark
                  ? ThemeMode.dark
                  : ThemeMode.light),
          locale: _locale,
          localizationsDelegates: [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en'),
            const Locale('id'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            if (locale == null) return supportedLocales.first;
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
          onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
          home: const SplashScreenPages(),
        ),
      ),
    );
  }
}
