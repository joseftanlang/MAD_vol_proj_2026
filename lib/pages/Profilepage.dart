import 'dart:ui';
import 'package:flutter/material.dart';
// import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:glassmorphism/glassmorphism.dart';
import '../components/AppBar.dart';
import '../components/BottomNav.dart';
import 'QRpage.dart';
import 'SignIn.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // User details controllers
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late TextEditingController bornController;
  late TextEditingController bloodTypeController;
  late TextEditingController addressController;
  late TextEditingController emailController;
  late TextEditingController nationalityController;

  // Backup for canceling edits
  late Map<String, String> _backupData;

  bool isEditing = false;

  // Animation controller for smooth transitions
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with default data
    nameController = TextEditingController(text: "John Doe");
    usernameController = TextEditingController(text: "john_doe");
    passwordController = TextEditingController(text: "password123");
    bornController = TextEditingController(text: "1990-01-01");
    bloodTypeController = TextEditingController(text: "O+");
    addressController = TextEditingController(text: "123 Main St");
    emailController = TextEditingController(text: "john@example.com");
    nationalityController = TextEditingController(text: "American");

    // Backup data for cancel
    _backupData = {
      "name": nameController.text,
      "username": usernameController.text,
      "password": passwordController.text,
      "born": bornController.text,
      "bloodType": bloodTypeController.text,
      "address": addressController.text,
      "email": emailController.text,
      "nationality": nationalityController.text,
    };

    // Setup animation controller
    _animationController = AnimationController(
      duration: Duration(milliseconds: 400),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    passwordController.dispose();
    bornController.dispose();
    bloodTypeController.dispose();
    addressController.dispose();
    emailController.dispose();
    nationalityController.dispose();

    _animationController.dispose();
    super.dispose();
  }

  void toggleEdit() {
    if (isEditing) {
      // Confirm save with dialog
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Save changes?"),
          content: Text("Do you want to save your profile changes?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Cancel editing
                cancelEdits();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                saveEdits();
              },
              child: Text("Save"),
            ),
          ],
        ),
      );
    } else {
      // Enter edit mode with animation
      setState(() {
        isEditing = true;
        _animationController.forward();
        // Save current data for potential cancel
        _backupData = {
          "name": nameController.text,
          "username": usernameController.text,
          "password": passwordController.text,
          "born": bornController.text,
          "bloodType": bloodTypeController.text,
          "address": addressController.text,
          "email": emailController.text,
          "nationality": nationalityController.text,
        };
      });
    }
  }

  void saveEdits() {
    setState(() {
      isEditing = false;
      _animationController.reverse();
    });
  }

  void cancelEdits() {
    setState(() {
      // Restore previous data
      nameController.text = _backupData["name"]!;
      usernameController.text = _backupData["username"]!;
      passwordController.text = _backupData["password"]!;
      bornController.text = _backupData["born"]!;
      bloodTypeController.text = _backupData["bloodType"]!;
      addressController.text = _backupData["address"]!;
      emailController.text = _backupData["email"]!;
      nationalityController.text = _backupData["nationality"]!;
      // Exit edit mode
      isEditing = false;
      _animationController.reverse();
    });
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      {bool obscureText = false, String? hint}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: GlassmorphicContainer(
        border: label == "Password" ? 0 : 1,
        width: double.infinity,
        height: 80,
        borderRadius: 20,
        blur: 20,
        linearGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderGradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.4),
            Colors.white.withOpacity(0.1),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: isEditing,
                  obscureText: obscureText,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          "John Doe",
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "Level 5 Volunteer",
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: CustomAppBar(scaffoldKey: _scaffoldKey),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        scaffoldKey: _scaffoldKey,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QRPage(userId: 'user-123'),
              ),
            );
          }
        },
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF1D2671), Color(0xFFC33764)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Profile Picture (add update later)
                CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/profile_placeholder.png'),
                ),
                const SizedBox(height: 20),
                // Header
                _buildHeader(),
                const SizedBox(height: 20),
                // Edit/save toggle button
                ElevatedButton.icon(
                  onPressed: toggleEdit,
                  icon: Icon(isEditing ? Icons.check : Icons.edit),
                  label: Text(isEditing ? "Save" : "Edit"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // Profile fields with animated fade-in
                _buildAnimatedField("Name", nameController),
                _buildAnimatedField("Username", usernameController),
                _buildAnimatedField("Password", passwordController, obscureText: true),
                _buildAnimatedField("Born (Date)", bornController, hint: "YYYY-MM-DD"),
                _buildAnimatedField("Blood Type", bloodTypeController),
                _buildAnimatedField("Address", addressController),
                _buildAnimatedField("Email", emailController),
                _buildAnimatedField("Nationality", nationalityController),
                const SizedBox(height: 40),
                // Sign out & delete buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.red,
                        side: BorderSide(color: Colors.red),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Delete Account'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SignInPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[800],
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      child: Text('Sign Out'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedField(String label, TextEditingController controller, {bool obscureText = false, String? hint}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: _buildProfileField(label, controller, obscureText: obscureText, hint: hint),
    );
  }
}