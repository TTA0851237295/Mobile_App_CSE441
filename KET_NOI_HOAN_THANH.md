# ✅ Kết nối Flutter - Spring Boot đã hoàn thành!

## 📦 Đã tích hợp:

### 1. **API Service** - Giao tiếp với Backend
File: `lib/services/api_service.dart`
- ✅ Tất cả endpoints (Auth, User, Check-in, Goal, Tips, Admin)
- ✅ Tự động quản lý JWT token
- ✅ Lưu token vào SharedPreferences
- ✅ Tự động gửi token trong mọi request

### 2. **Auth Provider** - Quản lý trạng thái đăng nhập
File: `lib/providers/auth_provider.dart`
- ✅ Login/Register với API thật
- ✅ Lưu thông tin user
- ✅ Quản lý loading state
- ✅ Hiển thị lỗi
- ✅ Logout

### 3. **User Model** - Cấu trúc dữ liệu
File: `lib/models/user.dart`
- ✅ Parse JSON từ API
- ✅ Check quyền admin

### 4. **Auth Screen** - Màn hình đăng nhập/đăng ký
File: `lib/screens/auth/auths_screen.dart`
- ✅ Form đăng nhập với validation
- ✅ Form đăng ký với validation
- ✅ Hiển thị loading spinner
- ✅ Hiển thị lỗi từ API
- ✅ Phân quyền tự động (Admin/User)

## 🚀 Cách chạy:

### Backend (đang chạy):
```bash
# Terminal: Run: BackendBtlMobileAppApplication
# http://localhost:8080
```

### Flutter App:
```bash
cd Mobile_App_CSE441

# Chạy trên Chrome (Web)
flutter run -d chrome

# Chạy trên Android Emulator
flutter run -d emulator-xxxx

# Chạy trên thiết bị thật
flutter run
```

## 🔐 Test đăng nhập:

### Tài khoản có sẵn trong DB:
- **Admin**: `admin` / `admin123`
- **User**: `demo` / `demo123`

### Hoặc đăng ký tài khoản mới:
1. Chuyển sang tab "Đăng ký"
2. Nhập đầy đủ: Họ tên, Email, Username, Password
3. Nhấn "Đăng ký"
4. Chuyển về "Đăng nhập" và đăng nhập

## 📱 Flow hoàn chỉnh:

```
1. User mở app → AuthScreen
2. Nhập username/password → Gọi API login
3. API trả về token + user info
4. Token tự động lưu vào SharedPreferences
5. Kiểm tra role:
   - Nếu ADMIN → AppShellAdmin (màn hình admin)
   - Nếu USER → AppShell (màn hình user)
6. Mọi request sau đó tự động có Authorization header
```

## 🔧 Cấu hình quan trọng:

### API URL (lib/config/app_config.dart):
```dart
// Hiện tại: localhost (cho Web/iOS Simulator)
static const String apiBaseUrl = 'http://localhost:8080/api';

// Đổi thành 10.0.2.2 nếu chạy Android Emulator
static const String apiBaseUrl = 'http://10.0.2.2:8080/api';

// Đổi thành IP máy nếu chạy thiết bị thật
static const String apiBaseUrl = 'http://192.168.1.100:8080/api';
```

## 📝 Sử dụng API trong code:

```dart
// Import
import 'package:provider/provider.dart';
import 'package:mobile_app_btl/providers/auth_provider.dart';

// Trong build method
final authProvider = Provider.of<AuthProvider>(context);

// Login
await authProvider.login(username, password);

// Check user
if (authProvider.currentUser != null) {
  print('User: ${authProvider.currentUser!.username}');
  print('Is Admin: ${authProvider.currentUser!.isAdmin}');
}

// Logout
await authProvider.logout();
```

## 🎯 Các API có sẵn:

Xem file `lib/services/api_service.dart` để biết tất cả methods:
- `login()` - Đăng nhập
- `register()` - Đăng ký
- `getProfile()` - Lấy thông tin user
- `changePassword()` - Đổi mật khẩu
- `getDashboardStats()` - Thống kê dashboard
- `createCheckin()` - Tạo check-in
- `getCheckins()` - Danh sách check-in
- `getEmotionStats()` - Thống kê cảm xúc
- `getGoals()` - Danh sách mục tiêu
- `createGoal()` - Tạo mục tiêu
- `updateGoalStatus()` - Cập nhật trạng thái
- `deleteGoal()` - Xóa mục tiêu
- `getTips()` - Danh sách tips
- `getAllUsers()` - Admin: Danh sách users
- `createTip()` - Admin: Tạo tip

## ✅ Checklist hoàn thành:

- ✅ Cài đặt dependencies (http, shared_preferences, provider)
- ✅ Tạo API Service với tất cả endpoints
- ✅ Tạo AuthProvider quản lý state
- ✅ Tạo User model
- ✅ Tích hợp vào Login/Register form
- ✅ Tự động lưu/load token
- ✅ Hiển thị loading và error
- ✅ Phân quyền Admin/User tự động
- ✅ Backend CORS đã cấu hình
- ✅ Test chạy thành công

## 🎉 Kết quả:

Flutter app đã kết nối hoàn chỉnh với Spring Boot backend! Bạn có thể:
1. Đăng ký tài khoản mới
2. Đăng nhập
3. Tự động phân quyền
4. Gọi tất cả API endpoints
5. Token tự động quản lý

**Enjoy coding! 🚀**
