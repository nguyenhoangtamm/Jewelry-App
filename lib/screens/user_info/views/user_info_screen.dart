import 'package:flutter/material.dart';
import 'package:jewelryapp/database/database_helper.dart';
import 'package:jewelryapp/models/user_model.dart';
import 'edit_profile_screen.dart';


class UserInfoScreen extends StatefulWidget {
  const UserInfoScreen({super.key});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  late Future<User?> _userFuture;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    setState(() {
      _userFuture = DatabaseHelper.getById(1,User.fromJson,'Users'); // Thay 1 bằng id phù hợp
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              if (result == true) {
                _loadUser(); // Tải lại dữ liệu khi cập nhật thành công
              }
            },
            child: const Text(
              'Edit',
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<User?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No user found.'));
          }
          final user = snapshot.data!;
          return SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Center(
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundImage: user.avatar != null && user.avatar!.isNotEmpty
                                ? AssetImage(user.avatar!)
                                : const AssetImage('assets/images/login_light.png'),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            user.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          if (user.email.isNotEmpty)
                            Text(
                              user.email,
                              style: const TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),
                    _InfoRow(label: 'Name', value: user.name),
                    _InfoRow(
                      label: 'Date of birth',
                      value: user.dateOfBirth != null
                          ? "${user.dateOfBirth!.month.toString().padLeft(2, '0')}/${user.dateOfBirth!.day.toString().padLeft(2, '0')}/${user.dateOfBirth!.year}"
                          : '',
                    ),
                    _InfoRow(label: 'Phone number', value: user.phone ?? ''),
                    _InfoRow(
                      label: 'Gender',
                      value: user.gender == 1
                          ? 'Male'
                          : user.gender == 2
                          ? 'Female'
                          : '',
                    ),
                    _InfoRow(label: 'Email', value: user.email),
                    _PasswordRow(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F7),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const SizedBox(width: 16),
          const SizedBox(
            width: 120,
            child: Text(
              'Password',
              style: TextStyle(color: Colors.black54, fontSize: 15),
            ),
          ),
          const Expanded(
            child: Text(
              '••••••••',
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          ),
          TextButton(
            onPressed: () {
              // TODO: Thêm chức năng đổi mật khẩu
            },
            child: const Text(
              'Change Password',
              style: TextStyle(
                color: Color(0xFF7B61FF),
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}