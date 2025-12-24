import 'package:flutter/material.dart';
import 'signup.dart';
import 'map_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _selectedPanchayat;
  final List<String> _panchayats = ['Panchayat 1', 'Panchayat 2', 'Panchayat 3'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF7EF), // lighter pastel green
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green[200],
                  child: Icon(Icons.eco, size: 50, color: Colors.green[700]),
                ),
              ),
              // App Title
              const Text(
                'My Panchayat App',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 28),
              // Login Pane
              Container(
                padding: const EdgeInsets.all(22),
                width: 360,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.green.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Username
                    TextField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person, color: Colors.green[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Password
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock, color: Colors.green[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Panchayat Dropdown
                    DropdownButtonFormField<String>(
                      value: _selectedPanchayat,
                      items: _panchayats
                          .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                          .toList(),
                      onChanged: (value) => setState(() => _selectedPanchayat = value),
                      decoration: InputDecoration(
                        labelText: 'Select Panchayat',
                        prefixIcon: Icon(Icons.location_city, color: Colors.green[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.green[50],
                      ),
                    ),
                    const SizedBox(height: 18),
                    // Login Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          debugPrint('Login pressed -> username: ${_usernameController.text}, panchayat: $_selectedPanchayat');
                          // Use named route
                          Navigator.pushNamed(context, '/map');
                          // If named routes misbehave, fallback:
                          // Navigator.of(context).push(MaterialPageRoute(builder: (_) => const MapPage()));
                        },
                        child: const Text('Login', style: TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Forgot Password & Signup
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            debugPrint('Forgot Password tapped');
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Forgot password tapped')),
                            );
                          },
                          child: const Text('Forgot Password?', style: TextStyle(color: Colors.green)),
                        ),
                        TextButton(
                          onPressed: () {
                            debugPrint('Navigate to Signup');
                            Navigator.pushNamed(context, '/signup');
                            // fallback: Navigator.of(context).push(MaterialPageRoute(builder: (_) => const SignupPage()));
                          },
                          child: const Text('Sign Up', style: TextStyle(color: Colors.green)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}