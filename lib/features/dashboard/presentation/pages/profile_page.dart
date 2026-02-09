import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cineghar/core/api/api_client.dart';
import 'package:cineghar/core/api/api_endpoints.dart';
import 'package:cineghar/core/utils/snackbar_utils.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/logout_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/upload_profile_image_usecase.dart';
import 'package:cineghar/features/auth/presentation/providers/auth_providers.dart';
import 'package:cineghar/app/routes/app_routes.dart';
import 'package:cineghar/features/auth/presentation/pages/login_page.dart';
import 'package:cineghar/features/orders/presentation/pages/order_history_page.dart';
import 'package:cineghar/app/theme/app_colors.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  AuthEntity? _profile;
  bool _loading = true;
  bool _uploading = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _loading = true);
    final getProfile = ref.read(getProfileUsecaseProvider);
    final result = await getProfile();
    result.fold(
      (failure) {
        if (mounted) {
          SnackbarUtils.showError(context, failure.message);
          setState(() => _loading = false);
        }
      },
      (entity) {
        if (mounted) {
          setState(() {
            _profile = entity;
            _loading = false;
          });
        }
      },
    );
    if (mounted && _loading) setState(() => _loading = false);
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );
    if (xFile == null || !mounted) return;
    setState(() => _uploading = true);
    final uploadUseCase = ref.read(uploadProfileImageUsecaseProvider);
    final result = await uploadUseCase(xFile);
    result.fold(
      (failure) {
        if (mounted) {
          SnackbarUtils.showError(context, failure.message);
          setState(() => _uploading = false);
        }
      },
      (entity) {
        if (mounted) {
          setState(() {
            _profile = entity;
            _uploading = false;
          });
          SnackbarUtils.showSuccess(context, 'Profile image updated');
        }
      },
    );
  }

  Future<void> _editField(String label, String currentValue, bool isEmail) async {
    final controller = TextEditingController(text: currentValue);
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          'Edit $label',
          style: const TextStyle(fontWeight: FontWeight.w700, color: AppColors.textPrimary),
        ),
        content: TextField(
          controller: controller,
          keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.name,
          textCapitalization: isEmail ? TextCapitalization.none : TextCapitalization.words,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save'),
          ),
        ],
      ),
    );
    if (result == null || result.isEmpty || result == currentValue || !mounted) return;

    try {
      final apiClient = ref.read(apiClientProvider);
      final body = isEmail ? {'email': result} : {'fullName': result};
      await apiClient.put(ApiEndpoints.updateProfile, data: body);
      await _loadProfile();
      if (mounted) SnackbarUtils.showSuccess(context, '$label updated successfully');
    } catch (e) {
      if (mounted) {
        final msg = e is DioException
            ? (e.response?.data?['message'] ?? e.message)
            : e.toString();
        SnackbarUtils.showError(context, msg?.toString() ?? 'Update failed');
      }
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout', 
          style: TextStyle(
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        content: const Text(
          'Are you sure you want to log out of CineGhar?',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text(
                    'Cancel', 
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    'Logout',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    
    // Use AuthViewmodel to handle logout (clears state, Hive, SecureStorage, and SharedPrefs)
    await ref.read(authViewModelProvider.notifier).logout();
    
    if (mounted) {
      // Navigate to login and clear navigation stack
      AppRoutes.pushAndRemoveUntil(context, const LoginPage());
    }
  }

  String? _fullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final base = ApiEndpoints.hostBaseUrl;
    return imageUrl.startsWith('http') ? imageUrl : '$base$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final bool isTablet = size.shortestSide > 600;
    final double horizontalPadding = isTablet ? 40.0 : 20.0;

    if (_loading) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Profile',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
            ),
            Positioned.fill(
              child: Container(color: Colors.black.withOpacity(0.4)),
            ),
            const Center(child: CircularProgressIndicator(color: Colors.white)),
          ],
        ),
      );
    }

    final profile = _profile;
    final imageUrl = _fullImageUrl(profile?.profilePicture);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset('assets/images/background.png', fit: BoxFit.cover),
          ),
          // Dark Overlay
          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.4)),
          ),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                const SizedBox(height: 20),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                      ),
                      boxShadow: AppColors.cardShadow,
                    ),
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding, 0, horizontalPadding, 40,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 12),
                          // Drag handle
                          Container(
                            width: 40,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(height: 32),

                          // -- Profile Picture --
                          Center(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.2),
                                        blurRadius: 24,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    radius: 56,
                                    backgroundColor: AppColors.surfaceVariant,
                                    backgroundImage: imageUrl != null
                                        ? CachedNetworkImageProvider(imageUrl)
                                        : null,
                                    child: imageUrl == null
                                        ? Icon(
                                            Icons.person,
                                            size: 56,
                                            color: Colors.grey.shade400,
                                          )
                                        : null,
                                  ),
                                ),
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: _uploading
                                      ? Container(
                                          width: 36,
                                          height: 36,
                                          decoration: const BoxDecoration(
                                            color: AppColors.primary,
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Padding(
                                            padding: EdgeInsets.all(8),
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : Material(
                                          color: AppColors.primary,
                                          shape: const CircleBorder(),
                                          elevation: 2,
                                          child: InkWell(
                                            onTap: _pickAndUploadImage,
                                            customBorder: const CircleBorder(),
                                            child: const Padding(
                                              padding: EdgeInsets.all(9),
                                              child: Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 28),

                          // -- Editable Name & Email --
                          _buildEditableRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Full Name',
                            value: profile?.fullName ?? '—',
                            onEdit: () => _editField(
                              'Full Name', profile?.fullName ?? '', false,
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildEditableRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: profile?.email ?? '—',
                            onEdit: () => _editField(
                              'Email', profile?.email ?? '', true,
                            ),
                          ),
                          const SizedBox(height: 32),

                          // Divider
                          Divider(color: Colors.grey.shade100, thickness: 1),
                          const SizedBox(height: 24),

                          // -- Bookings --
                          _buildSectionLabel('Bookings'),
                          const SizedBox(height: 12),
                          _buildMenuCard(
                            icon: Icons.confirmation_number_outlined,
                            title: 'My Tickets',
                            subtitle: 'View your past bookings and tickets',
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const OrderHistoryPage(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),

                          // -- Favourites --
                          _buildSectionLabel('Favourites'),
                          const SizedBox(height: 12),
                          _buildMenuCard(
                            icon: Icons.favorite_border_rounded,
                            title: 'My Favorite Movies',
                            subtitle: 'View your saved favorite movies',
                            onTap: () => SnackbarUtils.showError(
                              context, 'Favorites page coming soon!',
                            ),
                          ),
                          const SizedBox(height: 40),

                          // -- Logout Section --
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: AppColors.surface,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.grey.shade100),
                              boxShadow: AppColors.softShadow,
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Ready to leave?',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'You can always log back in later',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _logout,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primary,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 0,
                                    ),
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.logout_rounded, size: 20),
                                        SizedBox(width: 10),
                                        Text(
                                          'Logout from CineGhar',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            letterSpacing: 0.5,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
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
        ],
      ),
    );
  }

  Widget _buildEditableRow({
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 18),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildMenuCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: AppColors.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.primary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 13, color: AppColors.textSecondary),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
