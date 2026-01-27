# cineghar

A Flutter app for CineGhar.

## Sprint 5

- **Upload image to server**: Profile page supports picking an image from gallery and uploading via `PUT /api/auth/update-profile` (multipart, field `image`).
- **Display image from server**: Profile avatar loads from server using `GET /api/auth/whoami` and shows image via `hostBaseUrl` + `imageUrl`.
- **Tests**: 5+ unit tests (getProfile, uploadProfileImage, AuthApiModel, ApiEndpoints, AuthEntity) and 5+ widget tests (ProfilePage, BottomNavigationPage, WelcomePage).

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
