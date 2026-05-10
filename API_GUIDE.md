# API Integration Guide

This document explains how the X-Obese app communicates with the backend.

## Base Configuration

- **Base URL:** `http://103.168.140.134:6053`
- **Endpoints:** All endpoint paths are defined in `lib/src/apis/apis_url.dart`.

## Dio Client & Middleware

The app uses `Dio` for HTTP requests. A custom `DioClient` is implemented to handle authentication automatically.

- **Location:** `lib/src/apis/middleware/jwt_middleware.dart`

### Features:
1.  **Authorization Header:** Automatically adds `Bearer <accessToken>` to every request if available.
2.  **Cookie Header:** Adds `refreshToken` to cookies.
3.  **Automatic Token Refresh:**
    - When a `401 Unauthorized` error is received, the `onError` interceptor attempts to refresh the access token using the refresh token.
    - If successful, it retries the original request.
    - If refreshing fails (or no refresh token exists), it logs the user out and redirects to the login page.

## How to add a new API call

1.  **Define the path:** Add the new endpoint path in `lib/src/apis/apis_url.dart`.
2.  **Access the Dio instance:**
    ```dart
    final DioClient _dioClient = DioClient(baseAPI);
    // Use _dioClient.dio to make requests
    ```
3.  **Handle Responses:** Use try-catch blocks. On `DioException`, you can use the `printResponse` utility for debugging.

## Postman Collection

A Postman collection is included in the root directory: `X-Obese API.postman_collection_2_9`. Import this into Postman to test and explore the available API endpoints independently of the mobile app.

## Data Models

Most API responses are mapped to Dart models using `fromMap` or `fromJson` factory constructors. These models are typically located within the `model/` subdirectory of the relevant feature (e.g., `lib/src/screens/auth/model/`).
