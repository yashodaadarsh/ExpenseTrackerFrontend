
import 'package:expense_tracker/features/home/presentation/bloc/home_bloc.dart';
import 'package:expense_tracker/features/home/presentation/ui/home.dart';
import 'package:flutter/material.dart';


import '../../../../core/models/user_dto.dart';
import '../../../../service_locator.dart';
import '../../../login/presentation/ui/LoginPage.dart';
import '../../data/source/user_service.dart';

class ProfilePage extends StatefulWidget {

  final UserDto currentUser;

  const ProfilePage({super.key, required this.currentUser});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();

  // State to toggle editing
  bool _isEditing = false;
  bool _isLoading = false;

  // Controllers
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _limitController;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(text: widget.currentUser.firstName);
    _lastNameController = TextEditingController(text: widget.currentUser.lastName);
    _phoneController = TextEditingController(text: widget.currentUser.phoneNumber.toString());
    _emailController = TextEditingController(text: widget.currentUser.email);
    _limitController = TextEditingController(text: widget.currentUser.limit.toString());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text("My Profile", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          // The Edit/Save Action Button
          IconButton(
            onPressed: _isLoading ? null : _toggleEditMode,
            icon: Icon(_isEditing ? Icons.check : Icons.edit),
            tooltip: _isEditing ? "Save Changes" : "Edit Profile",
          ),
          if (_isEditing)
            IconButton(
              onPressed: _isLoading ? null : _cancelEdit,
              icon: const Icon(Icons.close),
              tooltip: "Cancel",
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.deepPurple))
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 1. Profile Picture Section
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.deepPurple.withOpacity(0.1),
                      backgroundImage: widget.currentUser.profilePic != null &&
                          widget.currentUser.profilePic!.isNotEmpty
                          ? NetworkImage(widget.currentUser.profilePic!)
                          : null,
                      child: widget.currentUser.profilePic == null
                          ? const Icon(Icons.person, size: 60, color: Colors.deepPurple)
                          : null,
                    ),
                    if (_isEditing)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          radius: 18,
                          child: IconButton(
                            icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                            onPressed: () {
                              // TODO: Implement Image Picker Logic
                            },
                          ),
                        ),
                      )
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. Personal Details Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Personal Info",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple
                        )
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Expanded(child: _buildTextField("First Name", _firstNameController, Icons.person_outline)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildTextField("Last Name", _lastNameController, Icons.person_outline)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildTextField("Email", _emailController, Icons.email_outlined,
                        inputType: TextInputType.emailAddress,
                        editable: false,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField("Phone Number", _phoneController, Icons.phone_outlined,
                        inputType: TextInputType.number),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // 3. Settings / Limits Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Account Settings",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple
                        )
                    ),
                    const SizedBox(height: 20),
                    _buildTextField("Monthly Expense Limit", _limitController, Icons.account_balance_wallet_outlined,
                        inputType: TextInputType.number),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      IconData icon, {
        TextInputType inputType = TextInputType.text,
        bool editable = true, // 👈 new flag
      }) {
    final bool isEnabled = _isEditing && editable;

    return TextFormField(
      controller: controller,
      enabled: isEnabled,
      keyboardType: inputType,
      validator: editable
          ? (value) => value!.isEmpty ? "Required" : null
          : null, // no validation for read-only field
      style: TextStyle(
        color: isEnabled ? Colors.black : Colors.grey[700],
        fontWeight: isEnabled ? FontWeight.normal : FontWeight.w500,
      ),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.deepPurple),
        filled: true,
        fillColor: isEnabled
            ? Colors.purple.withOpacity(0.05)
            : Colors.transparent,
        border: isEnabled
            ? OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        )
            : InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      ),
    );
  }

  // --- Logic Methods ---

  void _toggleEditMode() {
    if (_isEditing) {
      // User clicked "Check" (Save)
      _saveProfile();
    } else {
      // User clicked "Edit"
      setState(() {
        _isEditing = true;
      });
    }
  }

  void _cancelEdit() {
    // Revert changes by re-initializing controllers from original data
    _initializeControllers();
    setState(() {
      _isEditing = false;
    });
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    HomePageBloc homeBloc = s1<HomePageBloc>();

    // 1. Create updated DTO
    final updatedUser = UserDto(
      userId: widget.currentUser.userId, // ID cannot be changed usually
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      email: _emailController.text,
      phoneNumber: int.tryParse(_phoneController.text) ?? 0,
      limit: int.tryParse(_limitController.text) ?? 0,
      profilePic: widget.currentUser.profilePic, // Keep existing or handle new image logic
    );

    // 2. Call API
    final success = await _userService.updateUser(updatedUser);

    setState(() => _isLoading = false);

    if (success) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated successfully!"), backgroundColor: Colors.green),
        );
        setState(() {
          _isEditing = false;
        });
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Session Expired Please Login Again"), backgroundColor: Colors.red),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
              (route) => false, // removes ALL routes
        );
      }
    }
  }
}