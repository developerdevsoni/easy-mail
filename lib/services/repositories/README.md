# API Repository Structure

This directory contains the organized API repository structure for the Easy Mail app. The repositories are split by service domain to improve code organization and maintainability.

## Repository Structure

### Base Repository
- **`base_repository.dart`** - Contains common helper methods used by all repositories
  - `getHeaders()` - Creates HTTP headers with authentication
  - `handleRequest()` - Handles HTTP requests with error handling and logging

### Service-Specific Repositories

#### 1. Auth Repository (`auth_repository.dart`)
Handles all authentication and user-related API calls:
- User registration and login
- Google authentication
- Profile management
- User data operations

#### 2. Email Repository (`email_repository.dart`)
Handles all email-related API calls:
- Sending emails
- Sending emails with templates
- Email history and statistics

#### 3. Global Template Repository (`global_template_repository.dart`)
Handles global template operations:
- Fetching global templates
- Popular templates
- Template categories
- Template creation and usage tracking

#### 4. Personal Template Repository (`personal_template_repository.dart`)
Handles user-specific template operations:
- Personal template CRUD operations
- Favorite templates
- Template management

#### 5. Template Management Repository (`template_management_repository.dart`)
Handles general template management:
- Template CRUD operations
- Template updates and deletions

### Main Repository (`main_repository.dart`)
Coordinates all service repositories and provides a unified interface for all API operations. This is the primary entry point for API calls.

### Legacy API Repository (`../api_repository.dart`)
Maintains backward compatibility by delegating all calls to the MainRepository. This ensures existing code continues to work without changes.

## Usage

### For New Code
Use the MainRepository for all API operations:

```dart
// Authentication
final result = await MainRepository.login(
  email: 'user@example.com',
  password: 'password'
);

// Email operations
final emailResult = await MainRepository.sendEmail(
  to: 'recipient@example.com',
  subject: 'Test Email',
  body: 'Hello World'
);

// Template operations
final templates = await MainRepository.getGlobalTemplates();
```

### For Existing Code
Existing code can continue using `ApiRepository` without any changes:

```dart
// This will work exactly as before
final result = await ApiRepository.login(
  email: 'user@example.com',
  password: 'password'
);
```

## Benefits

1. **Better Organization**: APIs are grouped by service domain
2. **Easier Maintenance**: Each repository focuses on a specific area
3. **Code Reuse**: Common functionality is shared through the base repository
4. **Backward Compatibility**: Existing code continues to work
5. **Scalability**: Easy to add new service repositories
6. **Testing**: Each repository can be tested independently

## Adding New APIs

To add new APIs:

1. **For existing service**: Add the method to the appropriate repository
2. **For new service**: Create a new repository file and add it to MainRepository
3. **Update MainRepository**: Add the new method to MainRepository
4. **Update ApiRepository**: Add the method to ApiRepository for backward compatibility

Example:
```dart
// In auth_repository.dart
static Future<Map<String, dynamic>> newAuthMethod() async {
  // Implementation
}

// In main_repository.dart
static Future<Map<String, dynamic>> newAuthMethod() async {
  return AuthRepository.newAuthMethod();
}

// In api_repository.dart
static Future<Map<String, dynamic>> newAuthMethod() async {
  return MainRepository.newAuthMethod();
}
``` 