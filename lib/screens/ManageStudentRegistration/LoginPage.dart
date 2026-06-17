import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'FacultyRegistrarDashboard.dart';
import 'StudentDashboard.dart';

enum UserRole { student, facultyRegistrar, pusatAdab, lecturer, treasury }

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  String _errorMessage = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  UserRole? _selectedRole;

  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedRole == null) {
      setState(() {
        _errorMessage = 'Please select your role';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      if (username.isEmpty || password.isEmpty) {
        setState(() {
          _errorMessage = 'Username and password are required';
          _isLoading = false;
        });
        return;
      }

      // 1. Find user in Firestore by Username
      QuerySnapshot userQuery = await _firestore
          .collection('User')
          .where('Username', isEqualTo: username)
          .limit(1)
          .get();

      if (userQuery.docs.isEmpty) {
        setState(() {
          _errorMessage = 'User not found. Please check your username.';
          _isLoading = false;
        });
        return;
      }

      // 2. Get user data from Firestore
      final userDoc = userQuery.docs.first;
      final userData = userDoc.data() as Map<String, dynamic>;

      // 3. Check password (using Password field from Firestore)
      final storedPassword = userData['Password'] ?? '';
      if (password != storedPassword) {
        setState(() {
          _errorMessage = 'Incorrect password. Please try again.';
          _isLoading = false;
        });
        return;
      }

      // 4. Check role
      final userRoleString = userData['Role'] ?? '';
      final UserRole userRole = _stringToUserRole(userRoleString);

      if (userRole != _selectedRole) {
        setState(() {
          _errorMessage = 'Invalid role for this user. Please select correct role.';
          _isLoading = false;
        });
        return;
      }

      // 5. Navigate based on role
      _navigateByRole(userRole, username);

    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred: $e';
      });
      print('❌ Login error: $e');
    }
  }

  UserRole _stringToUserRole(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return UserRole.student;
      case 'faculty registrar':
      case 'faculty_registrar':
        return UserRole.facultyRegistrar;
      case 'pusatadab':
      case 'pusat_adab':
        return UserRole.pusatAdab;
      case 'lecturer':
        return UserRole.lecturer;
      case 'treasury':
        return UserRole.treasury;
      default:
        return UserRole.student;
    }
  }

  void _navigateByRole(UserRole role, String username) {
    switch (role) {
      case UserRole.student:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDashboard(username: username),
          ),
        );
        break;
      case UserRole.facultyRegistrar:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const FacultyRegistrarDashboard()),
        );
        break;
      default:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => StudentDashboard(username: username),
          ),
        );
        break;
    }
  }

  // Helper widget to keep the design DRY and clean
  Widget _buildFieldLabel(String label) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 4.0, bottom: 8.0),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  // Box shadow decoration to match the soft UI element look
  BoxDecoration _fieldBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: const Color.fromRGBO(0, 0, 0, 0.06),
          spreadRadius: 1,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5FD),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 28.0,
              vertical: 16.0,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Text(
                    'WELCOME TO',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'STUDENT ACADEMIC\nMANAGEMENT SYSTEM',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/SAMS LOGO.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: const Color(0xFF1E3A60),
                            child: const Icon(
                              Icons.school,
                              size: 60,
                              color: Colors.white,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'LOGIN',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildFieldLabel('Username:'),
                  Container(
                    decoration: _fieldBoxDecoration(),
                    child: TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter username';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFieldLabel('Role:'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: _fieldBoxDecoration(),
                    child: DropdownButtonFormField<UserRole>(
                      value: _selectedRole,
                      icon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xFF0056B3),
                        size: 30,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                      ),
                      hint: const Text(
                        'select your role',
                        style: TextStyle(color: Colors.black26, fontSize: 15),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: UserRole.student,
                          child: Text('Student'),
                        ),
                        DropdownMenuItem(
                          value: UserRole.facultyRegistrar,
                          child: Text('Faculty Registrar'),
                        ),
                        DropdownMenuItem(
                          value: UserRole.pusatAdab,
                          child: Text('Pusat Adab'),
                        ),
                        DropdownMenuItem(
                          value: UserRole.lecturer,
                          child: Text('Lecturer'),
                        ),
                        DropdownMenuItem(
                          value: UserRole.treasury,
                          child: Text('Treasury'),
                        ),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedRole = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your role';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildFieldLabel('Password:'),
                  Container(
                    decoration: _fieldBoxDecoration(),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 16,
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: const Color(0xFF5A6E7F),
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: 140,
                    height: 48,
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: const Color.fromRGBO(0, 0, 0, 0.15),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF466289),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),
                  ),
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    Text(
                      _errorMessage,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}