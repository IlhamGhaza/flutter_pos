import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'POS App'**
  String get appTitle;

  /// No description provided for @menuHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get menuHome;

  /// No description provided for @menuOrder.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get menuOrder;

  /// No description provided for @menuHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get menuHistory;

  /// No description provided for @menuSetting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get menuSetting;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @indonesian.
  ///
  /// In en, this message translates to:
  /// **'Indonesian'**
  String get indonesian;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @loginText.
  ///
  /// In en, this message translates to:
  /// **'Login to your account'**
  String get loginText;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @productEmpty.
  ///
  /// In en, this message translates to:
  /// **'Product is empty'**
  String get productEmpty;

  /// No description provided for @scanSomething.
  ///
  /// In en, this message translates to:
  /// **'Scan something!'**
  String get scanSomething;

  /// No description provided for @scanning.
  ///
  /// In en, this message translates to:
  /// **'Scanning'**
  String get scanning;

  /// No description provided for @noDisplayValue.
  ///
  /// In en, this message translates to:
  /// **'No display value.'**
  String get noDisplayValue;

  /// No description provided for @noData.
  ///
  /// In en, this message translates to:
  /// **'No data'**
  String get noData;

  /// No description provided for @failedToGeneratePDF.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate PDF'**
  String get failedToGeneratePDF;

  /// No description provided for @pdfSavedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'PDF saved successfully'**
  String get pdfSavedSuccessfully;

  /// No description provided for @generatingPDF.
  ///
  /// In en, this message translates to:
  /// **'Generating PDF...'**
  String get generatingPDF;

  /// No description provided for @noDataToExport.
  ///
  /// In en, this message translates to:
  /// **'No data to export'**
  String get noDataToExport;

  /// No description provided for @deliveryForm.
  ///
  /// In en, this message translates to:
  /// **'Delivery Form'**
  String get deliveryForm;

  /// No description provided for @recipientName.
  ///
  /// In en, this message translates to:
  /// **'Recipient Name'**
  String get recipientName;

  /// No description provided for @recipientPhone.
  ///
  /// In en, this message translates to:
  /// **'Recipient Phone'**
  String get recipientPhone;

  /// No description provided for @recipientAddress.
  ///
  /// In en, this message translates to:
  /// **'Recipient Address'**
  String get recipientAddress;

  /// No description provided for @recipientCity.
  ///
  /// In en, this message translates to:
  /// **'Recipient City'**
  String get recipientCity;

  /// No description provided for @recipientState.
  ///
  /// In en, this message translates to:
  /// **'Recipient State'**
  String get recipientState;

  /// No description provided for @recipientPostalCode.
  ///
  /// In en, this message translates to:
  /// **'Recipient Postal Code'**
  String get recipientPostalCode;

  /// No description provided for @scheduledDeliveryDatetime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Delivery Datetime'**
  String get scheduledDeliveryDatetime;

  /// No description provided for @totalWeight.
  ///
  /// In en, this message translates to:
  /// **'Total Weight'**
  String get totalWeight;

  /// No description provided for @requiresSpecialHandling.
  ///
  /// In en, this message translates to:
  /// **'Requires Special Handling'**
  String get requiresSpecialHandling;

  /// No description provided for @deliveryNotesCustomer.
  ///
  /// In en, this message translates to:
  /// **'Delivery Notes Customer'**
  String get deliveryNotesCustomer;

  /// No description provided for @weightWarning.
  ///
  /// In en, this message translates to:
  /// **'Weight must be a number'**
  String get weightWarning;

  /// No description provided for @specialHandling.
  ///
  /// In en, this message translates to:
  /// **'Special Handling'**
  String get specialHandling;

  /// No description provided for @scheduledDate.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Date'**
  String get scheduledDate;

  /// No description provided for @scheduledTime.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Time'**
  String get scheduledTime;

  /// No description provided for @deliveryNotes.
  ///
  /// In en, this message translates to:
  /// **'Delivery Notes'**
  String get deliveryNotes;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @searchAddress.
  ///
  /// In en, this message translates to:
  /// **'Search Address'**
  String get searchAddress;

  /// No description provided for @failedToLoadTaxAndServiceCharge.
  ///
  /// In en, this message translates to:
  /// **'Failed to load tax and service charge'**
  String get failedToLoadTaxAndServiceCharge;

  /// No description provided for @taxInfo.
  ///
  /// In en, this message translates to:
  /// **'Tax Info'**
  String get taxInfo;

  /// No description provided for @taxName.
  ///
  /// In en, this message translates to:
  /// **'Tax Name'**
  String get taxName;

  /// No description provided for @taxRate.
  ///
  /// In en, this message translates to:
  /// **'Tax Rate'**
  String get taxRate;

  /// No description provided for @serviceChargeInfo.
  ///
  /// In en, this message translates to:
  /// **'Service Charge Info'**
  String get serviceChargeInfo;

  /// No description provided for @serviceChargeName.
  ///
  /// In en, this message translates to:
  /// **'Service Charge Name'**
  String get serviceChargeName;

  /// No description provided for @serviceChargeRate.
  ///
  /// In en, this message translates to:
  /// **'Service Charge Rate'**
  String get serviceChargeRate;

  /// No description provided for @customerSelection.
  ///
  /// In en, this message translates to:
  /// **'Customer Selection'**
  String get customerSelection;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @selected.
  ///
  /// In en, this message translates to:
  /// **'Selected'**
  String get selected;

  /// No description provided for @addedAndSelected.
  ///
  /// In en, this message translates to:
  /// **'Added and Selected'**
  String get addedAndSelected;

  /// No description provided for @failedToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get failedToLoadData;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @postalCode.
  ///
  /// In en, this message translates to:
  /// **'Postal Code'**
  String get postalCode;

  /// No description provided for @customerType.
  ///
  /// In en, this message translates to:
  /// **'Customer Type'**
  String get customerType;

  /// No description provided for @searchCustomer.
  ///
  /// In en, this message translates to:
  /// **'Search Customer'**
  String get searchCustomer;

  /// No description provided for @selectDiscount.
  ///
  /// In en, this message translates to:
  /// **'Select Discount'**
  String get selectDiscount;

  /// No description provided for @discount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get discount;

  /// No description provided for @discountCannotBeApplied.
  ///
  /// In en, this message translates to:
  /// **'Discount cannot be applied'**
  String get discountCannotBeApplied;

  /// No description provided for @addItemsOrSelectOtherDiscount.
  ///
  /// In en, this message translates to:
  /// **'Add items or select other discount'**
  String get addItemsOrSelectOtherDiscount;

  /// No description provided for @selectCustomerFirst.
  ///
  /// In en, this message translates to:
  /// **'Select customer first'**
  String get selectCustomerFirst;

  /// No description provided for @noDiscountAvailable.
  ///
  /// In en, this message translates to:
  /// **'No discount available'**
  String get noDiscountAvailable;

  /// No description provided for @noValidOrderData.
  ///
  /// In en, this message translates to:
  /// **'No valid order data'**
  String get noValidOrderData;

  /// No description provided for @serviceCharge.
  ///
  /// In en, this message translates to:
  /// **'Service Charge'**
  String get serviceCharge;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @subtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get subtotal;

  /// No description provided for @conditionNotMet.
  ///
  /// In en, this message translates to:
  /// **'Condition Not Met'**
  String get conditionNotMet;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @paymentType.
  ///
  /// In en, this message translates to:
  /// **'Payment Type'**
  String get paymentType;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get paymentAmount;

  /// No description provided for @change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get change;

  /// No description provided for @paymentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Payment Success'**
  String get paymentSuccess;

  /// No description provided for @paymentFailed.
  ///
  /// In en, this message translates to:
  /// **'Payment Failed'**
  String get paymentFailed;

  /// No description provided for @paymentFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment failed, please try again'**
  String get paymentFailedMessage;

  /// No description provided for @minPurchase.
  ///
  /// In en, this message translates to:
  /// **'Min Purchase'**
  String get minPurchase;

  /// No description provided for @minItem.
  ///
  /// In en, this message translates to:
  /// **'Min Item'**
  String get minItem;

  /// No description provided for @discountApplied.
  ///
  /// In en, this message translates to:
  /// **'Discount Applied'**
  String get discountApplied;

  /// No description provided for @failedToLoadDiscount.
  ///
  /// In en, this message translates to:
  /// **'Failed to load discount'**
  String get failedToLoadDiscount;

  /// No description provided for @order.
  ///
  /// In en, this message translates to:
  /// **'Order'**
  String get order;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @transfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer'**
  String get transfer;

  /// No description provided for @qr.
  ///
  /// In en, this message translates to:
  /// **'QR'**
  String get qr;

  /// No description provided for @paymentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Payment success'**
  String get paymentSuccessMessage;

  /// No description provided for @orderSavedOffline.
  ///
  /// In en, this message translates to:
  /// **'Order saved offline'**
  String get orderSavedOffline;

  /// No description provided for @totalAfterDiscount.
  ///
  /// In en, this message translates to:
  /// **'Total After Discount'**
  String get totalAfterDiscount;

  /// No description provided for @printingReceipt.
  ///
  /// In en, this message translates to:
  /// **'Printing receipt...'**
  String get printingReceipt;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @receipt.
  ///
  /// In en, this message translates to:
  /// **'Receipt'**
  String get receipt;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @customerPhone.
  ///
  /// In en, this message translates to:
  /// **'Customer Phone'**
  String get customerPhone;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Payment Cash'**
  String get paymentCash;

  /// No description provided for @paymentTransfer.
  ///
  /// In en, this message translates to:
  /// **'Payment Transfer'**
  String get paymentTransfer;

  /// No description provided for @paymentQR.
  ///
  /// In en, this message translates to:
  /// **'Payment QRIS'**
  String get paymentQR;

  /// No description provided for @quickAmount.
  ///
  /// In en, this message translates to:
  /// **'Quick Amount'**
  String get quickAmount;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @pleaseInputThePrice.
  ///
  /// In en, this message translates to:
  /// **'Please input the price'**
  String get pleaseInputThePrice;

  /// No description provided for @nominalIsLessThanTheTotalPrice.
  ///
  /// In en, this message translates to:
  /// **'Nominal is less than the total price'**
  String get nominalIsLessThanTheTotalPrice;

  /// No description provided for @pay.
  ///
  /// In en, this message translates to:
  /// **'Pay'**
  String get pay;

  /// No description provided for @qrCodeCannotBeLoaded.
  ///
  /// In en, this message translates to:
  /// **'QRIS Code cannot be loaded'**
  String get qrCodeCannotBeLoaded;

  /// No description provided for @scanQrisToMakePayment.
  ///
  /// In en, this message translates to:
  /// **'Scan QRIS to make payment'**
  String get scanQrisToMakePayment;

  /// No description provided for @errorPrinting.
  ///
  /// In en, this message translates to:
  /// **'Error printing'**
  String get errorPrinting;

  /// No description provided for @printQris.
  ///
  /// In en, this message translates to:
  /// **'Print QRIS'**
  String get printQris;

  /// No description provided for @process.
  ///
  /// In en, this message translates to:
  /// **'Process'**
  String get process;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @totalQuantity.
  ///
  /// In en, this message translates to:
  /// **'Total Quantity'**
  String get totalQuantity;

  /// No description provided for @totalBill.
  ///
  /// In en, this message translates to:
  /// **'Total Bill'**
  String get totalBill;

  /// No description provided for @cashierName.
  ///
  /// In en, this message translates to:
  /// **'Cashier Name'**
  String get cashierName;

  /// No description provided for @transactionDate.
  ///
  /// In en, this message translates to:
  /// **'Transaction Date'**
  String get transactionDate;

  /// No description provided for @print.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get print;

  /// No description provided for @syncStartedForAllData.
  ///
  /// In en, this message translates to:
  /// **'Sync started for all data'**
  String get syncStartedForAllData;

  /// No description provided for @failedToStartSync.
  ///
  /// In en, this message translates to:
  /// **'Failed to start sync'**
  String get failedToStartSync;

  /// No description provided for @syncData.
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get syncData;

  /// No description provided for @syncAllData.
  ///
  /// In en, this message translates to:
  /// **'Sync All Data'**
  String get syncAllData;

  /// No description provided for @sync.
  ///
  /// In en, this message translates to:
  /// **'Sync'**
  String get sync;

  /// No description provided for @masterData.
  ///
  /// In en, this message translates to:
  /// **'Master Data'**
  String get masterData;

  /// No description provided for @products.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get products;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @syncedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Synced Successfully'**
  String get syncedSuccessfully;

  /// No description provided for @sendPendingOrders.
  ///
  /// In en, this message translates to:
  /// **'Send Pending Orders'**
  String get sendPendingOrders;

  /// No description provided for @sendPendingCustomer.
  ///
  /// In en, this message translates to:
  /// **'Send Pending Customer'**
  String get sendPendingCustomer;

  /// No description provided for @localDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'Local Data Available'**
  String get localDataAvailable;

  /// No description provided for @syncToUpdateFromServer.
  ///
  /// In en, this message translates to:
  /// **'Sync to update from server'**
  String get syncToUpdateFromServer;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync Now'**
  String get syncNow;

  /// No description provided for @closeKasir.
  ///
  /// In en, this message translates to:
  /// **'Close Kasir'**
  String get closeKasir;

  /// No description provided for @areYouSureWantToCloseKasir.
  ///
  /// In en, this message translates to:
  /// **'Are you sure want to close kasir?'**
  String get areYouSureWantToCloseKasir;

  /// No description provided for @closeKasirSuccess.
  ///
  /// In en, this message translates to:
  /// **'Close kasir success'**
  String get closeKasirSuccess;

  /// No description provided for @qrServerKey.
  ///
  /// In en, this message translates to:
  /// **'QR Server Key'**
  String get qrServerKey;

  /// No description provided for @report.
  ///
  /// In en, this message translates to:
  /// **'Report'**
  String get report;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @useLightTheme.
  ///
  /// In en, this message translates to:
  /// **'Use light theme'**
  String get useLightTheme;

  /// No description provided for @useDarkTheme.
  ///
  /// In en, this message translates to:
  /// **'Use dark theme'**
  String get useDarkTheme;

  /// No description provided for @noInvalidOrderData.
  ///
  /// In en, this message translates to:
  /// **'No invalid order data'**
  String get noInvalidOrderData;

  /// No description provided for @noProductInOrder.
  ///
  /// In en, this message translates to:
  /// **'No product in order. Please add product first.'**
  String get noProductInOrder;

  /// No description provided for @followSystemTheme.
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get followSystemTheme;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
