import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cineghar/core/api/api_endpoints.dart';
import 'package:cineghar/core/utils/snackbar_utils.dart';
import 'package:cineghar/features/auth/domain/entities/auth_entity.dart';
import 'package:cineghar/features/auth/domain/usecases/get_profile_usecase.dart';
import 'package:cineghar/features/auth/domain/usecases/upload_profile_image_usecase.dart';

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

  String? _fullImageUrl(String? imageUrl) {
    if (imageUrl == null || imageUrl.isEmpty) return null;
    final base = ApiEndpoints.hostBaseUrl;
    return imageUrl.startsWith('http') ? imageUrl : '$base$imageUrl';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    final profile = _profile;
    final imageUrl = _fullImageUrl(profile?.profilePicture);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 24),
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 56,
                  backgroundColor: Colors.grey.shade300,
                  backgroundImage: imageUrl != null
                      ? CachedNetworkImageProvider(imageUrl)
                      : null,
                  child: imageUrl == null
                      ? Icon(Icons.person, size: 56, color: Colors.grey.shade600)
                      : null,
                ),
                if (_uploading)
                  const Positioned(
                    right: 0,
                    bottom: 0,
                    child: SizedBox(
                      width: 32,
                      height: 32,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                else
                  Material(
                    color: Theme.of(context).colorScheme.primary,
                    shape: const CircleBorder(),
                    child: InkWell(
                      onTap: _pickAndUploadImage,
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Icon(Icons.camera_alt, color: Colors.white, size: 22),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 24),
            if (profile != null) ...[
              Text(
                profile.fullName,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(
                profile.email,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
