import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pos/core/extensions/build_context_ext.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/data/datasources/auth_local_datasource.dart';
import 'package:flutter_pos/presentation/auth/pages/login_page.dart';
import 'package:flutter_pos/presentation/home/pages/dashboard_page.dart';
import 'package:flutter_pos/presentation/setting/bloc/report/close_cashier/close_cashier_bloc.dart';
import 'package:flutter_pos/presentation/setting/pages/manage_printer_page.dart';
import 'package:flutter_pos/presentation/setting/pages/report/report_page.dart';
import 'package:flutter_pos/presentation/setting/pages/save_server_key_page.dart';
import 'package:flutter_pos/presentation/setting/pages/sync_data_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/components/menu_button.dart';
import '../../../core/components/spaces.dart';
import '../../../core/utils/connectivity_utils.dart';
import '../../../l10n/app_localizations.dart';
import '../../home/bloc/logout/logout_bloc.dart';
import '../bloc/sync_order/sync_order_bloc.dart';
import '../widgets/theme_selector.dart';
import '../widgets/language_selector.dart';
// import 'manage_product_page.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  bool isOnline = true;
  @override
  void initState() {
    _checkConnectivity();
    super.initState();
  }

  Future<void> _checkConnectivity() async {
    final connected = await ConnectivityUtils.isConnected();
    setState(() {
      isOnline = connected;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 360;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.push(const DashboardPage());
            },
          ),
          title: Text(
            AppLocalizations.of(context)!.menuSetting,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen ? 6 : 8,
                vertical: 2,
              ),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: isOnline ? Colors.green : Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isOnline ? Icons.wifi : Icons.wifi_off,
                    color: Colors.white,
                    size: isSmallScreen ? 12 : 14,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    isOnline ? 'Online' : 'Offline',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmallScreen ? 10 : 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    // Flexible(
                    //   child: MenuButton(
                    //     iconPath: Assets.images.manageProduct.path,
                    //     label: 'Setting Product',
                    //     onPressed: () =>
                    //         context.push(const ManageProductPage()),
                    //     isImage: true,
                    //   ),
                    // ),
                    // const SpaceWidth(15.0),
                    Flexible(
                      child: MenuButton(
                        iconPath: Assets.images.managePrinter.path,
                        label: 'Setting Printer',
                        onPressed: () {
                          context.push(const ManagePrinterPage());
                        },
                        isImage: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceHeight(20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Flexible(
                      child: MenuButton(
                        iconPath: Assets.images.manageQr.path,
                        label: AppLocalizations.of(context)!.qrServerKey,
                        onPressed: () =>
                            context.push(const SaveServerKeyPage()),
                        isImage: true,
                      ),
                    ),
                    const SpaceWidth(15.0),
                    Flexible(
                      child: MenuButton(
                        iconPath: Assets.images.sync.path,
                        label: AppLocalizations.of(context)!.syncData,
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SyncDataPage()));
                        },
                        isImage: true,
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceHeight(20.0),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Flexible(
                      child: MenuButton(
                        iconPath: Assets.images.report.path,
                        label: AppLocalizations.of(context)!.report,
                        onPressed: () => context.push(const ReportPage()),
                        isImage: true,
                      ),
                    ),
                    const SpaceWidth(15.0),
                    Flexible(
                      child: BlocListener<SyncOrderBloc, SyncOrderState>(
                        listener: (context, state) {
                          state.maybeMap(
                            orElse: () {},
                            successCloseChasier: (_) {
                              context.read<CloseCashierBloc>().add(
                                    const CloseCashierEvent.closeCashier(),
                                  );

                              context.pushReplacement(const LoginPage());
                              SnackbarUtils(
                                text: AppLocalizations.of(context)!.closeKasirSuccess,
                                backgroundColor: Colors.green,
                              ).showSuccessSnackBar(context);
                            },
                          );
                        },
                        child: MenuButton(
                          iconPath: Assets.images.close.path,
                          label: AppLocalizations.of(context)!.closeKasir,
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text(AppLocalizations.of(context)!.closeKasir),
                                    content: Text(
                                        AppLocalizations.of(context)!.areYouSureWantToCloseKasir),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.cancel),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          context.read<SyncOrderBloc>().add(
                                                const SyncOrderEvent
                                                    .sendOrderForCloseChasier(),
                                              );
                                          Navigator.pop(context);
                                        },
                                        child: Text(AppLocalizations.of(context)!.yes),
                                      ),
                                    ],
                                  );
                                });
                          },
                          isImage: true,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SpaceHeight(10.0),
              // Theme Selector
              const ThemeSelector(),
              // const SpaceHeight(10),
              const LanguageSelector(),
              const SpaceHeight(10),
              BlocConsumer<LogoutBloc, LogoutState>(
                listener: (context, state) {
                  state.maybeWhen(
                    success: () {
                      AuthLocalDatasource().removeAuthData();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    error: (message) {
                      AuthLocalDatasource().removeAuthData();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                      SnackbarUtils(
                        text: message,
                        backgroundColor: Colors.red,
                      ).showErrorSnackBar(context);
                    },
                    orElse: () {},
                  );
                },
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(AppLocalizations.of(context)!.logout),
                          content: Text(AppLocalizations.of(context)!.confirm),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(AppLocalizations.of(context)!.cancel),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context
                                    .read<LogoutBloc>()
                                    .add(const LogoutEvent.logout());
                              },
                              child: Text(AppLocalizations.of(context)!.logout),
                            ),
                          ],
                        ),
                      );
                    },
                    child: state.maybeWhen(
                      loading: () => const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      ),
                      orElse: () => Text(AppLocalizations.of(context)!.logout),
                    ),
                  );
                },
              ),
              const Divider(),
            ],
          ),
        ));
  }
}
