import 'package:flutter/material.dart';
import 'package:jewelryapp/database/database_helper.dart';
import 'package:jewelryapp/models/user_model.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  User? _user;

  late TextEditingController _nameController;
  late TextEditingController _dobController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  int? _gender;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    User? user = await DatabaseHelper.getById(1,User.fromJson,'Users');
    if (user != null) {
      setState(() {
        _user = user;
        _nameController = TextEditingController(text: user.name);
        _dobController = TextEditingController(
          text: user.dateOfBirth != null
              ? "${user.dateOfBirth!.month.toString().padLeft(2, '0')}/${user.dateOfBirth!.day.toString().padLeft(2, '0')}/${user.dateOfBirth!.year}"
              : '',
        );
        _phoneController = TextEditingController(text: user.phone ?? '');
        _emailController = TextEditingController(text: user.email);
        _gender = user.gender;
      });
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User user = _user!;
      if (user != null) {
        user.name = _nameController.text;
        user.email = _emailController.text;
        user.phone = _phoneController.text;
        user.gender = _gender;
        // Xử lý ngày sinh
        if (_dobController.text.isNotEmpty) {
          final parts = _dobController.text.split('/');
          if (parts.length == 3) {
            final month = int.tryParse(parts[0]);
            final day = int.tryParse(parts[1]);
            final year = int.tryParse(parts[2]);
            if (month != null && day != null && year != null) {
              user.dateOfBirth = DateTime(year, month, day);
            }
          }
        }
        await DatabaseHelper.update(user);
      }
      if (mounted) {
        Navigator.of(context).pop(true);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: _saveProfile,
            child: const Text(
              "Save",
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      body: _user == null
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 32,
                        backgroundImage: _user!.avatar != null &&
                                _user!.avatar!.isNotEmpty
                            ? AssetImage(_user!.avatar!)
                            : const AssetImage('assets/images/login_light.png')
                                as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _user!.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _user!.email,
                            style: const TextStyle(
                                color: Colors.black38, fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  _EditField(label: "Name", controller: _nameController),
                  _EditField(
                      label: "Date of birth", controller: _dobController),
                  _EditField(
                      label: "Phone number", controller: _phoneController),
                  _GenderDropdown(
                    value: _gender,
                    onChanged: (val) => setState(() => _gender = val),
                  ),
                  _EditField(label: "Email", controller: _emailController),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Text(
                            "Password",
                            style:
                                TextStyle(color: Colors.black38, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            // TODO: Thêm chức năng đổi mật khẩu
                          },
                          child: const Text(
                            "Change Password",
                            style: TextStyle(
                              color: Color(0xFF7B61FF),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;

  const _EditField({
    required this.label,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black38, fontSize: 16),
          ),
          TextFormField(
            controller: controller,
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(height: 1, color: Colors.black12),
        ],
      ),
    );
  }
}

class _GenderDropdown extends StatelessWidget {
  final int? value;
  final ValueChanged<int?> onChanged;

  const _GenderDropdown({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Gender",
            style: TextStyle(color: Colors.black38, fontSize: 16),
          ),
          DropdownButtonFormField<int>(
            value: value,
            onChanged: onChanged,
            items: const [
              DropdownMenuItem(value: 1, child: Text("Male")),
              DropdownMenuItem(value: 2, child: Text("Female")),
            ],
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
          const Divider(height: 1, color: Colors.black12),
        ],
      ),
    );
  }
}
