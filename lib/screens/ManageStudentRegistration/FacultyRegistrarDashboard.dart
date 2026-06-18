import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'LoginPage.dart';
import 'FacultyOpenRegistrationPage.dart';

class FacultyRegistrarDashboard extends StatefulWidget {
  final String? username;
  final String? fullName;
  final String? email;

  const FacultyRegistrarDashboard({
    super.key,
    this.username,
    this.fullName,
    this.email,
  });

  @override
  State<FacultyRegistrarDashboard> createState() =>
      _FacultyRegistrarDashboardState();
}

class _FacultyRegistrarDashboardState extends State<FacultyRegistrarDashboard> {
  String _displayName = 'Faculty Registrar';
  bool _isLoading = true;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // ✅ Load user data from Firebase
  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);

    try {
      // Try to get current authenticated user
      final User? currentUser = _auth.currentUser;
      
      print('🔍 Current user email: ${currentUser?.email}');
      
      if (currentUser != null && currentUser.email != null) {
        // Search by email
        final snapshot = await _firestore
            .collection('User')
            .where('Email', isEqualTo: currentUser.email)
            .limit(1)
            .get();

        if (snapshot.docs.isNotEmpty) {
          final data = snapshot.docs.first.data() as Map<String, dynamic>;
          _displayName = data['FullName'] ?? 
                        data['Name'] ?? 
                        data['StudentName'] ??
                        widget.fullName ??
                        widget.username ??
                        'Faculty Registrar';
          print('✅ Name from Firebase: $_displayName');
        } else {
          // Use provided data if available
          _displayName = widget.fullName ?? 
                        widget.username ?? 
                        'Faculty Registrar';
          print('⚠️ Using widget data: $_displayName');
        }
      } else if (widget.fullName != null) {
        _displayName = widget.fullName!;
        print('✅ Using widget fullName: $_displayName');
      } else if (widget.username != null) {
        _displayName = widget.username!;
        print('✅ Using widget username: $_displayName');
      } else {
        _displayName = 'Faculty Registrar';
        print('⚠️ Using default: Faculty Registrar');
      }
      
    } catch (e) {
      print('❌ Error loading faculty data: $e');
      _displayName = widget.fullName ?? 
                    widget.username ?? 
                    'Faculty Registrar';
    }

    setState(() => _isLoading = false);
  }

  // ✅ Handle logout
  Future<void> _handleLogout() async {
    try {
      await _auth.signOut();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator while fetching data
    if (_isLoading) {
      return Scaffold(
        backgroundColor: const Color(0xffe6f4fe),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                color: Color(0xff1573db),
              ),
              SizedBox(height: 16),
              Text(
                'Loading...',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xffe6f4fe),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ✅ Top Bar: User Name (FROM LOGIN) + Logout Button
              Align(
                alignment: Alignment.topRight,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _displayName, // ✅ SHOWS LOGGED-IN USER NAME
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey[900],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.blue[600],
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    // Logout Button
                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Color(0xFF466289),
                        size: 22,
                      ),
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                      onPressed: _handleLogout,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // System Title Text
              Text(
                'STUDENT ACADEMIC\nMANAGEMENT SYSTEM',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                  color: Colors.black.withOpacity(0.85),
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 40),

              // Circular Logo Container
              Container(
                width: 220,
                height: 220,
                decoration: const BoxDecoration(
                  color: Color(0xff0d335d),
                  shape: BoxShape.circle,
                ),
                child: ClipOval(
                  child: Image.asset(
                    'assets/SAMS LOGO.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xff0d335d),
                        child: const Icon(
                          Icons.school,
                          size: 60,
                          color: Colors.lightBlueAccent,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 60),

              // Open Registration Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => FacultyOpenRegistrationPage(
                          username: widget.username,
                          fullName: _displayName,
                          email: widget.email,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1573db),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  child: const Text(
                    'OPEN REGISTRATION',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}