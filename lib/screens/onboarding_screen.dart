import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'dart:ui';
import 'login_screen.dart'; // Import the LoginPage
import 'register_screen.dart'; // Import the RegisterPage
import 'dashboard_screen.dart'; // Import the GuestPage

void main() => runApp(
      const MaterialApp(
        home: OnBoardingScreen(),
        debugShowCheckedModeBanner: false, // Disable the debug banner
      ),
    );

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(); // PageController for handling page swipes
  int _currentPage = 0; // Tracks the current page
  Timer? _autoScrollTimer; // Timer for automatic page scrolling
  double _opacity = 0.5; // Initial opacity value for glowing effect
  Timer? _glowTimer; // Timer for glowing effect animation

  final List<Map<String, String>> _onBoardingData = [
    {
      'image': 'lib/images/00.webp',
      'title': ' ',
      'description': ' ',
    },
    {
      'image': 'lib/images/01.webp',
      'title': ' ',
      'description': ' ',
    },
    {
      'image': 'lib/images/02.webp',
      'title': 'NO ADS',
      'description': 'Focus on your fitness!',
    },
    {
      'image': 'lib/images/03.webp',
      'title': 'YOU vs YOU',
      'description': 'Start today!',
    },
  ];

  @override
  void initState() {
    super.initState();
    _startAutoScroll(); // Start automatic scrolling of pages
    _startGlowEffect(); // Start glowing animation
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _preloadImages(); // Preload images for smooth scrolling, called in didChangeDependencies
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel(); // Cancel auto-scroll timer when disposed
    _glowTimer?.cancel(); // Cancel glow timer when disposed
    _pageController.dispose(); // Dispose page controller
    super.dispose();
  }

  // Preload images to ensure they are available before display
  void _preloadImages() {
    for (var data in _onBoardingData) {
      precacheImage(AssetImage(data['image']!), context);
    }
  }

  void _startAutoScroll() {
    // Set auto-scroll to move pages every 3 seconds
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_currentPage < _onBoardingData.length - 1) {
        _currentPage++; // Move to next page
      } else {
        _currentPage = 0; // Loop back to first page
      }
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut, // Smooth transition animation
      );
    });
  }

  void _startGlowEffect() {
    // Alternate the opacity between 0.5 and 1.0 to create a glowing effect
    _glowTimer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        _opacity = _opacity == 0.5 ? 1.0 : 0.5;
      });
    });
  }

  // Handles manual page swipe events
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
    _autoScrollTimer?.cancel(); // Cancel auto-scroll when manually swiped
    _startAutoScroll(); // Restart auto-scroll after swipe
  }


// Navigate to login page and set user status
void _login() async {
  await _setUserStatus('loggedIn'); // Set the user status as logged in

  // Check if the widget is still mounted before navigating
  if (mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }
}

// Navigate to register page and set user status
void _register() async {
  await _setUserStatus('registered'); // Set the user status as registered

  // Check if the widget is still mounted before navigating
  if (mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}

// Navigate to guest page and set user status
void _continueAsGuest() async {
  await _setUserStatus('guest'); // Set the user status as guest

  // Check if the widget is still mounted before navigating
  if (mounted) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }
}

// Method to set user status in SharedPreferences
Future<void> _setUserStatus(String status) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('userStatus', status); // Save the status
}

  // Colors used for the animated text
  static const colorizeColors = [
    Color.fromARGB(255, 246, 248, 255),
    Color.fromARGB(255, 255, 102, 0),
    Color.fromARGB(255, 255, 124, 1),
    Color.fromARGB(255, 245, 12, 12),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr, // Set text direction for UI
      child: Scaffold(
        body: Stack(
          children: [
            // Full-screen background image
            PageView.builder(
              controller: _pageController,
              itemCount: _onBoardingData.length,
              onPageChanged: _onPageChanged,
              itemBuilder: (context, index) {
                final data = _onBoardingData[index];
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      data['image']!,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10.0, top: 110.0, right: 10.0, bottom: 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedTextKit(
                              animatedTexts: [
                                ColorizeAnimatedText(
                                  data['title']!,
                                  textStyle: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  colors: colorizeColors,
                                ),
                              ],
                              isRepeatingAnimation: false, // Stop repeating animation
                            ),
                            const SizedBox(height: 1),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: AnimatedTextKit(
                                animatedTexts: [
                                  ColorizeAnimatedText(
                                    data['description']!,
                                    textAlign: TextAlign.center,
                                    textStyle: const TextStyle(fontSize: 16, wordSpacing: -1),
                                    colors: colorizeColors,
                                    speed: const Duration(milliseconds: 50),
                                  ),
                                ],
                                isRepeatingAnimation: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            // Blur and translucent container
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                  child: Stack(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color.fromARGB(255, 255, 72, 0).withOpacity(0.6), // 100% opacity
                              const Color.fromARGB(255, 0, 0, 0).withOpacity(0.0), // 0% opacity
                            ],
                          ),
                          border: const Border(
                            top: BorderSide(
                              color: Color.fromARGB(235, 255, 60, 0),
                              width: 1.0,
                            ),
                            left: BorderSide(
                              color: Color.fromARGB(235, 255, 60, 0),
                              width: 1.0,
                            ),
                            right: BorderSide(
                              color: Color.fromARGB(235, 255, 60, 0),
                              width: 1.0,
                            ),
                          ),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                          ),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SmoothPageIndicator(
                              controller: _pageController,
                              count: _onBoardingData.length,
                              effect: const ExpandingDotsEffect(
                                expansionFactor: 3,
                                spacing: 8,
                                radius: 16,
                                dotWidth: 16,
                                dotHeight: 8,
                                dotColor: Color.fromARGB(255, 241, 181, 166),
                                activeDotColor: Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                            const SizedBox(height: 20),
                                    ElevatedButton(
                                      onPressed: _login,
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        minimumSize: const Size(double.infinity, 50),
                                        backgroundColor: const Color.fromARGB(255, 255, 66, 8),  // Button background color
                                        foregroundColor: Colors.white, // Button text (and icon) color
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.login), // Icon for login button
                                          SizedBox(width: 10),
                                          Text('Login'),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: _register,
                                      style: ElevatedButton.styleFrom(
                                        elevation: 5,
                                        minimumSize: const Size(double.infinity, 50),
                                        backgroundColor: const Color.fromARGB(255, 255, 66, 8), // Button background color
                                        foregroundColor: Colors.white, // Button text (and icon) color
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.person_add), // Icon for register button
                                          SizedBox(width: 10),
                                          Text('Register'),
                                        ],
                                      ),
                                    ),

                            const SizedBox(height: 12),
                                          const Padding(
                                            padding: EdgeInsets.only(left: 16, right: 16),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: Color.fromARGB(255, 255, 102, 0),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                                                  child: Text(
                                                    "Or",
                                                    style: TextStyle(
                                                      color: Colors.white,  // Set color to white
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Divider(
                                                    thickness: 2,
                                                    color: Color.fromARGB(255, 255, 102, 0)
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
              
                            const SizedBox(height: 12), 
                            ElevatedButton( 
                              onPressed: _continueAsGuest, 
                              style: ElevatedButton.styleFrom( 
                                minimumSize: const Size(double.infinity, 50), 
                                backgroundColor: const Color.fromARGB(255, 139, 110, 96),
                                foregroundColor: Colors.white, // Button text (and icon) color 
                                textStyle: const TextStyle( 
                                  color: Color.fromARGB(255, 255, 254, 254), 
                                  fontSize: 16, 
                                  fontWeight: FontWeight.normal, 
                                ), 
                              ), 
                              child: const Text('Continue as Guest'), 
                            ), 
                            const SizedBox(height: 40), 
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



/*
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                await _setUserStatus('loggedIn');
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Login'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _setUserStatus('guest');
                Navigator.pushReplacementNamed(context, '/dashboard');
              },
              child: const Text('Continue as Guest'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _setUserStatus('registered');
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
  */



