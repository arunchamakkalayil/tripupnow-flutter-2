import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';

class MainScreen extends StatefulWidget {
  final Widget child;
  
  const MainScreen({super.key, required this.child});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    
    switch (index) {
      case 0:
        context.go('/main/home');
        break;
      case 1:
        context.go('/main/explore');
        break;
      case 2:
        context.go('/main/track');
        break;
      case 3:
        context.go('/main/planner');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).matchedLocation;
    final showAppBar = !currentRoute.contains('/profile');
    
    // Update current index based on route
    if (currentRoute.contains('/home')) _currentIndex = 0;
    else if (currentRoute.contains('/explore')) _currentIndex = 1;
    else if (currentRoute.contains('/track')) _currentIndex = 2;
    else if (currentRoute.contains('/planner')) _currentIndex = 3;

    return Scaffold(
      appBar: showAppBar ? AppBar(
        title: Row(
          children: [
            Image.network(
              'https://cdn.jsdelivr.net/gh/arunchamakkalayil/places/TripUpNow2.png',
              height: 40,
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'TripUpNow',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
        actions: [
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          GestureDetector(
            onTap: () => context.go('/main/profile'),
            child: Container(
              margin: const EdgeInsets.only(right: 16),
              child: const CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(
                  'https://cdn.jsdelivr.net/gh/arunchamakkalayil/places/avatar.png',
                ),
              ),
            ),
          ),
        ],
      ) : null,
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on_outlined),
            activeIcon: Icon(Icons.location_on),
            label: 'Track',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Planner',
          ),
        ],
      ),
    );
  }
}