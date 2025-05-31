import 'package:flutter/material.dart';
import 'my_sign_up.dart'; // Keep your existing import
import 'drawer.dart'; // Keep your existing import
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the icon package

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Define green color palette
    const Color primaryGreen = Color(0xFF4CAF50); // A standard green
    const Color secondaryGreen = Color(0xFF81C784); // A lighter green

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Authentification App', // Title can remain in English or French
      theme: ThemeData(
        // Updated primary and accent colors to green
        primaryColor: primaryGreen,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryGreen,
          primary: primaryGreen,
          secondary: secondaryGreen,
          // You might want to define other colors like error, surface, etc.
          // based on your green palette if needed for consistency.
        ),

        // Updated input decoration theme for green focus border
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primaryGreen, width: 2), // Green focus border
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15), // Kept padding
        ),

        // Updated elevated button theme for green background (for primary button)
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryGreen, // Green button background
            foregroundColor: Colors.white, // White text
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12),
            textStyle: const TextStyle( // Define text style here for consistency
               fontSize: 16, // Slightly larger font for button
               fontWeight: FontWeight.bold,
               letterSpacing: 0.8,
            ),
          ),
        ),
        // Added TextButton theme for green text color
         textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: primaryGreen, // Green text for buttons
             padding: EdgeInsets.zero,
             minimumSize: Size(10, 10),
             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
             textStyle: const TextStyle(
              fontSize: 13, // Kept original size for these texts
             ),
          ),
        ),
        // You might add other theme properties like textTheme, etc.
      ),
      home: const AuthScreen(),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Méthode pour naviguer vers la page d'inscription
  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MySignUp()),
    );
  }

  // Placeholder methods for social login
  void _signInWithGoogle() {
    print('Connexion avec Google tapée'); // French log
    // Implement Google Sign-In logic here
  }

  void _signInWithGitHub() {
    print('Connexion avec GitHub tapée'); // French log
    // Implement GitHub Sign-In logic here
  }


  @override
  Widget build(BuildContext context) {
    // Use theme colors defined in MyApp
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      // Ajout d'un AppBar transparent pour permettre l'accès au drawer
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Ensure leading icon is visible against the background
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white), // Keep white for contrast
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      extendBodyBehindAppBar: true, // Extend body behind the transparent app bar
      drawer: const Menu(), // Your drawer

      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          // Updated gradient colors to green shades
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF81C784), // Lighter green (secondaryGreen)
              Color(0xFF4CAF50), // Standard green (primaryGreen)
            ],
          ),
        ),
        child: SafeArea(
          // Center the content block and limit its width
          child: Center(
            child: ConstrainedBox(
               constraints: const BoxConstraints(maxWidth: 400), // Max width for the content block
               child: SingleChildScrollView( // Keep scrollability
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20), // Padding around the content
                child: Column( // Main Column for layout
                  mainAxisAlignment: MainAxisAlignment.center, // Center column content vertically if space allows
                  crossAxisAlignment: CrossAxisAlignment.stretch, // Stretch elements horizontally
                  children: [
                    // Removed the icon section

                    const SizedBox(height: 80), // Space from the top (adjust as needed)

                    // Title and Subtitle Section (Centered) - Translated
                    Text(
                      'Bienvenue !', // Translated
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Connectez-vous à votre compte', // Translated
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),

                    const SizedBox(height: 40), // Space between text and form card

                    // Authentication Card (Kept structure)
                    Container(
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start, // Align text left inside card
                        children: [
                          // Champ email - Translated
                          TextField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                              labelText: 'Email', // Label is often kept as is or translated
                              prefixIcon: Icon(Icons.email_outlined),
                              hintText: 'exemple@email.com',
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Champ mot de passe - Translated
                          TextField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            decoration: InputDecoration(
                              labelText: 'Mot de passe', // Translated
                              prefixIcon: const Icon(Icons.lock_outline),
                              hintText: '••••••••',
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  color: Colors.grey[600],
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          // Options supplémentaires - Translated
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: Checkbox(
                                      value: _rememberMe,
                                      onChanged: (value) {
                                        setState(() {
                                          _rememberMe = value ?? false;
                                        });
                                      },
                                      activeColor: primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                  ),
                                  const Text(
                                    'Se souvenir de moi', // Translated
                                    style: TextStyle(fontSize: 13),
                                  ),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  // Navigation vers l'écran de récupération de mot de passe
                                },
                                child: const Text('Mot de passe oublié ?'), // Translated
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),

                          // Bouton de connexion - Translated
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                // Logique d'authentification
                                print('Tentative de connexion avec : ${_emailController.text}'); // French log
                                // Add your actual login logic here (e.g., using Firebase Auth)
                              },
                              child: const Text('SE CONNECTER'), // Translated
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Option d'inscription - Translated
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pas encore de compte ? ', // Translated
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                              TextButton(
                                onPressed: _navigateToSignUp,
                                child: const Text('S\'inscrire'), // Translated
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30), // Space after the main card

                    // OR separator - Translated
                    Row(
                      children: [
                        const Expanded(child: Divider(color: Colors.white54)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            'OU', // Translated
                            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
                          ),
                        ),
                        const Expanded(child: Divider(color: Colors.white54)),
                      ],
                    ),

                    const SizedBox(height: 20), // Space after OR

                    // Social Sign-In Buttons - Translated text, Icons confirmed
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Google Sign-In Button
                        ElevatedButton.icon(
                          onPressed: _signInWithGoogle,
                          // FaIcon is correctly used here for the icon
                          icon: const FaIcon(FontAwesomeIcons.google, color: Colors.redAccent), // Google color
                          label: const Text('Se connecter avec Google'), // Translated
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White background
                            foregroundColor: Colors.black87, // Dark text color
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(color: Colors.grey[300]!), // Optional border
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            elevation: 2, // Add some elevation
                          ),
                        ),
                        const SizedBox(height: 15), // Space between social buttons

                        // GitHub Sign-In Button
                         ElevatedButton.icon(
                          onPressed: _signInWithGitHub,
                           // FaIcon is correctly used here for the icon
                          icon: const FaIcon(FontAwesomeIcons.github, color: Colors.black87), // GitHub color
                          label: const Text('Se connecter avec GitHub'), // Translated
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white, // White background
                            foregroundColor: Colors.black87, // Dark text color
                             shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                               side: BorderSide(color: Colors.grey[300]!), // Optional border
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                             elevation: 2, // Add some elevation
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30), // Space at the very bottom
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}