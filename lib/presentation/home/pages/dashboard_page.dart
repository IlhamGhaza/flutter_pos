import 'package:flutter/material.dart';
import 'package:flutter_pos/core/utils/snackbar_utils.dart';
import 'package:flutter_pos/core/widgets/responsive_layout.dart';
import 'package:flutter_pos/presentation/home/pages/desktop/desktop_layout.dart';
import 'package:flutter_pos/presentation/home/widgets/nav_item.dart';
import 'package:flutter_pos/presentation/home/pages/tablet/tablet_layout.dart';
import 'package:flutter_pos/presentation/history/pages/history_page.dart';
import 'package:flutter_pos/presentation/home/pages/home_page.dart';
import 'package:flutter_pos/presentation/order/pages/order_page.dart';
import 'package:flutter_pos/presentation/setting/pages/setting_page.dart';

import '../../../core/assets/assets.gen.dart';
import '../../../core/constants/colors.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // Logout button with distinct styling
  late final Map<String, dynamic> _logoutButton;

  final List<Widget> _pages = [
    const HomePage(),
    const OrderPage(), // Only accessible on mobile
    const HistoryPage(),
    const SettingPage(),
  ];

  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _logoutButton = {
      'icon': Icons.logout_outlined,
      'activeIcon': Icons.logout,
      'label': 'Logout',
      'color': Colors.red,
      'onTap': () {
        // Handle logout
        if (mounted) {
          SnackbarUtils(
            text: 'Logout',
            backgroundColor: Colors.red,
          ).showErrorSnackBar(context);
        }
      },
    };
  }

  // Navigation items for sidebar with improved styling
  // For mobile: Home (0), Orders (1), History (2), Setting (3)
  // For tablet/desktop: Home (0), History (2), Setting (3)
  // Get the correct page index based on device type
  int _getPageIndex(int navIndex) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) return navIndex; // On mobile, indices are direct

    // On tablet/desktop, map the navigation indices to page indices
    // Navigation indices: Home (0), History (1), Settings (2)
    // Page indices: Home (0), Order (1 - not used), History (2), Settings (3)
    switch (navIndex) {
      case 0:
        return 0; // Home
      case 1:
        return 2; // History
      case 2:
        return 3; // Settings
      default:
        return 0;
    }
  }

  // Navigation items for sidebar with improved styling
  List<Map<String, dynamic>> get _navItems {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    final items = [
      {
        'icon': Icons.home_outlined,
        'activeIcon': Icons.home,
        'label': 'Home',
        'index': 0, // Always 0 for Home
        'color': AppColors.primary,
      },
    ];

    // Add Orders item only for mobile
    if (isMobile) {
      items.add({
        'icon': Icons.shopping_cart_outlined,
        'activeIcon': Icons.shopping_cart,
        'label': 'Orders',
        'index': 1, // Only exists on mobile
        'color': Colors.orange,
      });
    }

    // Add remaining items with consistent indices
    items.addAll([
      {
        'icon': Icons.history_outlined,
        'activeIcon': Icons.history,
        'label': 'History',
        'index': isMobile ? 2 : 1,
        'color': Colors.blue,
      },
      {
        'icon': Icons.settings_outlined,
        'activeIcon': Icons.settings,
        'label': 'Setting',
        'index': isMobile ? 3 : 2,
        'color': Colors.purple,
      },
    ]);

    return items;
  }

  // Sidebar theme data
  SidebarTheme _getSidebarTheme(BuildContext context) {
    return SidebarTheme(
      backgroundColor: Theme.of(context).colorScheme.surface,
      headerHeight: 80.0,
      itemHeight: 52.0,
      iconSize: 24.0,
      textStyle: const TextStyle(
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
      ),
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey[700]!,
      selectedBackgroundColor: AppColors.primary.withValues(alpha: 0.1),
      hoverColor: Colors.grey[100]!,
      borderRadius: 8.0,
      spacing: 8.0,
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
    );
  }

  void _onItemTapped(int navIndex) {
    setState(() {
      _selectedIndex = _getPageIndex(navIndex);
    });
  }

  Widget _buildMobileLayout() {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildSidebarLayout(SidebarTheme _sidebarTheme) {
    final isTablet = MediaQuery.of(context).size.width < 1100;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Container
          Container(
            width: isTablet ? 80 : 260,
            height: double.infinity,
            decoration: BoxDecoration(
              color: _sidebarTheme.backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(1, 0),
                ),
              ],
            ),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // App Logo/Header
                  SizedBox(
                    height: _sidebarTheme.headerHeight,
                    child: Center(
                      child: isTablet
                          ? Image.asset(Assets.images.logo.path, width: 50)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(Assets.images.logo.path, width: 60),
                                const SizedBox(width: 12),
                                Text(
                                  'POS App',
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: _sidebarTheme.selectedItemColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),

                  // Navigation Items
                  Padding(
                    padding: _sidebarTheme.padding,
                    child: Column(
                      children: _navItems.map((item) {
                        final isSelected = _selectedIndex == item['index'];
                        return _buildSidebarItem(
                          icon: item['icon'],
                          activeIcon: item['activeIcon'],
                          label: item['label'],
                          isSelected: isSelected,
                          isCollapsed: isTablet,
                          color:
                              item['color'] ?? _sidebarTheme.selectedItemColor,
                          onTap: () => _onItemTapped(item['index']),
                          sidebarTheme: _sidebarTheme,
                        );
                      }).toList(),
                    ),
                  ),

                  const Spacer(),

                  // Logout Button
                  Padding(
                    padding: _sidebarTheme.padding,
                    child: _buildSidebarItem(
                      icon: _logoutButton['icon'],
                      activeIcon: _logoutButton['activeIcon'],
                      label: _logoutButton['label'],
                      isSelected: false,
                      isCollapsed: isTablet,
                      color: _logoutButton['color'],
                      onTap: _logoutButton['onTap'],
                      sidebarTheme: _sidebarTheme,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Vertical Divider
          Container(
            width: 1,
            height: double.infinity,
            color: Colors.grey[200],
          ),

          // Main Content
          Expanded(
            child: _selectedIndex == 0
                ? (isTablet ? const TabletLayout() : const DesktopLayout())
                : _pages[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(30),
        ),
        color: isDark ? theme.colorScheme.surface : AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -2),
            blurRadius: 30.0,
            blurStyle: BlurStyle.outer,
            spreadRadius: 0,
            color: isDark
                ? theme.shadowColor.withOpacity(0.08)
                : AppColors.black.withValues(alpha: 0.08),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Container(
          height: 72, // Increased height for better touch targets
          padding: const EdgeInsets.only(top: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavItem(
                iconPath: Assets.icons.home.path,
                label: 'Home',
                isActive: _selectedIndex == 0,
                onTap: () => _onItemTapped(0),
              ),
              if (isMobile)
                NavItem(
                  iconPath: Assets.icons.orders.path,
                  label: 'Orders',
                  isActive: _selectedIndex == 1,
                  onTap: () => _onItemTapped(1),
                ),
              NavItem(
                iconPath: Assets.icons.payments.path,
                label: 'History',
                isActive: _selectedIndex == (isMobile ? 2 : 1),
                onTap: () => _onItemTapped(isMobile ? 2 : 1),
              ),
              NavItem(
                iconPath: Assets.icons.dashboard.path,
                label: 'Setting',
                isActive: _selectedIndex == (isMobile ? 3 : 2),
                onTap: () => _onItemTapped(isMobile ? 3 : 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isCollapsed,
    required VoidCallback onTap,
    required SidebarTheme sidebarTheme,
    IconData? activeIcon,
    Color? color,
  }) {
    final itemColor = color ?? sidebarTheme.selectedItemColor;

    return Container(
      height: sidebarTheme.itemHeight,
      margin: EdgeInsets.only(bottom: sidebarTheme.spacing),
      child: Material(
        color: isSelected
            ? sidebarTheme.selectedBackgroundColor
            : Colors.transparent,
        borderRadius: BorderRadius.circular(sidebarTheme.borderRadius),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(sidebarTheme.borderRadius),
          hoverColor: sidebarTheme.hoverColor,
          child: Padding(
            padding: sidebarTheme.padding,
            child: Row(
              children: [
                Icon(
                  isSelected ? (activeIcon ?? icon) : icon,
                  size: sidebarTheme.iconSize,
                  color:
                      isSelected ? itemColor : sidebarTheme.unselectedItemColor,
                ),
                if (!isCollapsed) ...[
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: sidebarTheme.textStyle.copyWith(
                      color: isSelected
                          ? itemColor
                          : sidebarTheme.unselectedItemColor,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final _sidebarTheme = _getSidebarTheme(context);
    return ResponsiveLayout(
      mobileScaffold: _buildMobileLayout(),
      tabletScaffold: _buildSidebarLayout(_sidebarTheme),
      desktopScaffold: _buildSidebarLayout(_sidebarTheme),
    );
  }
}

// Theme data for the sidebar
class SidebarTheme {
  const SidebarTheme({
    required this.backgroundColor,
    required this.headerHeight,
    required this.itemHeight,
    required this.iconSize,
    required this.textStyle,
    required this.selectedItemColor,
    required this.unselectedItemColor,
    required this.selectedBackgroundColor,
    required this.hoverColor,
    required this.borderRadius,
    required this.spacing,
    required this.padding,
  });

  final Color backgroundColor;
  final double borderRadius;
  final double headerHeight;
  final Color hoverColor;
  final double iconSize;
  final double itemHeight;
  final EdgeInsetsGeometry padding;
  final Color selectedBackgroundColor;
  final Color selectedItemColor;
  final double spacing;
  final TextStyle textStyle;
  final Color unselectedItemColor;
}
