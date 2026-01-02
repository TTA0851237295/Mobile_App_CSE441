# 📱 TAM AN APP - API DOCUMENTATION

## 📋 Mục lục
1. [Chuẩn bị](#1-chuẩn-bị)
2. [Tài khoản test](#2-tài-khoản-test)
3. [API Authentication](#3-api-authentication)
4. [API User](#4-api-user)
5. [API Check-in](#5-api-check-in)
6. [API Goals](#6-api-goals)
7. [API Admin](#7-api-admin)
8. [API Tips (Admin only)](#8-api-tips-admin-only)

---

## 1. Chuẩn bị

### Base URL
```
http://localhost:8080
```

### Khởi động Spring Boot
```bash
.\mvnw.cmd spring-boot:run
```

### Headers cho các API cần xác thực
```
Authorization: Bearer {token}
Content-Type: application/json
```

---

## 2. Tài khoản test

| Role | Username | Password |
|------|----------|----------|
| Admin | `admin` | `Admin123!` |
| User | `tuananh` | `TuanAnh@123` |
| User | `ngocbao` | `NgocBao@123` |

---

## 3. API Authentication

### 3.1. Đăng ký User mới

**POST** `/api/auth/register`

**Body:**
```json
{
  "username": "newuser",
  "displayName": "New User",
  "password": "NewPass@123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "user": {
      "id": 3,
      "username": "newuser",
      "displayName": "New User",
      "role": "USER"
    }
  }
}
```

---

### 3.2. Đăng nhập (Login)

**POST** `/api/auth/login`

**Body:**
```json
{
  "username": "tuananh",
  "password": "TuanAnh@123"
}
```

**Response (200):**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "token": "eyJhbGciOiJIUzI1NiJ9...",
    "user": {
      "id": 1,
      "username": "tuananh",
      "displayName": "Tuấn Anh",
      "role": "USER",
      "isActive": true,
      "themeMode": "LIGHT"
    }
  }
}
```

---

### 3.3. Đăng nhập Admin

**POST** `/api/auth/login`

**Body:**
```json
{
  "username": "admin",
  "password": "Admin123!"
}
```

---

## 4. API User

### 4.1. Lấy thông tin user hiện tại

**GET** `/api/users/me`

**Headers:** `Authorization: Bearer {token}`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "id": 1,
    "username": "tuananh",
    "displayName": "Tuấn Anh",
    "role": "USER",
    "isActive": true,
    "themeMode": "LIGHT",
    "createdAt": "2025-12-01T08:00:00"
  }
}
```

---

### 4.2. Lấy dashboard (thống kê 7 ngày gần nhất)

**GET** `/api/users/dashboard?days=7`

**Headers:** `Authorization: Bearer {token}`

**Query Parameters:**
- `days`: Số ngày thống kê (7, 14, 30)

**Response (200):**
```json
{
  "success": true,
  "data": {
    "totalCheckIns": 25,
    "streak": 5,
    "checkInsThisWeek": 7,
    "averageEmotion": "HAPPY",
    "emotionTrends": [...],
    "emotionDistribution": {
      "HAPPY": 15,
      "NEUTRAL": 5,
      "STRESSED": 3
    },
    "recentEntries": [...]
  }
}
```

---

### 4.3. Đổi theme mode

**PUT** `/api/users/theme`

**Headers:** `Authorization: Bearer {token}`

**Body:**
```json
{
  "themeMode": "DARK"
}
```

**Values:** `LIGHT` hoặc `DARK`

---

### 4.4. Đổi tên hiển thị

**PUT** `/api/users/display-name`

**Headers:** `Authorization: Bearer {token}`

**Body:**
```json
{
  "displayName": "Tên mới"
}
```

---

### 4.5. Đổi mật khẩu

**POST** `/api/users/change-password`

**Headers:** `Authorization: Bearer {token}`

**Body:**
```json
{
  "currentPassword": "TuanAnh@123",
  "newPassword": "NewPass@456",
  "confirmPassword": "NewPass@456"
}
```

---

## 5. API Check-in

### 5.1. Tạo checkin mới

**POST** `/api/checkins`

**Headers:** `Authorization: Bearer {token}`

**Body:**
```json
{
  "emotion": "HAPPY",
  "locationTag": "HOME",
  "activityTag": "RELAX",
  "peopleTag": "FAMILY",
  "note": "Tối nay cảm thấy vui vẻ"
}
```

**Enums hợp lệ:**

| Emotion | Mô tả |
|---------|-------|
| `HAPPY` | 😆 Hạnh phúc |
| `JOY` | 😊 Vui vẻ |
| `NEUTRAL` | 😐 Bình thường |
| `SAD` | 🌧️ Buồn |
| `WORRIED` | 😟 Lo lắng |
| `STRESSED` | ⚡ Căng thẳng |
| `ANGRY` | 😡 Giận dữ |

| Location | Mô tả |
|----------|-------|
| `WORK` | Công ty |
| `HOME` | Nhà |
| `COMMUTE` | Di chuyển |
| `OUTDOOR` | Ngoài trời |
| `OTHER` | Khác |

| Activity | Mô tả |
|----------|-------|
| `MEETING` | Họp |
| `CODING` | Code |
| `STUDY` | Học |
| `SOCIAL_MEDIA` | Lướt mạng |
| `EATING` | Ăn |
| `WORKOUT` | Tập |
| `RELAX` | Thư giãn |
| `OTHER` | Khác |

| People | Mô tả |
|--------|-------|
| `ALONE` | Một mình |
| `COWORKERS` | Đồng nghiệp |
| `BOSS` | Sếp |
| `FAMILY` | Gia đình |
| `FRIENDS` | Bạn bè |
| `PARTNER` | Người yêu |
| `OTHER` | Khác |

---

### 5.2. Xem lịch sử check-ins

**GET** `/api/checkins?page=0&size=20`

**Headers:** `Authorization: Bearer {token}`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 10,
        "emotion": "HAPPY",
        "locationTag": "HOME",
        "activityTag": "RELAX",
        "peopleTag": "FAMILY",
        "note": "Tối nay cảm thấy vui vẻ...",
        "createdAt": "2025-12-29T20:30:00"
      }
    ],
    "totalElements": 25,
    "totalPages": 3,
    "currentPage": 0
  }
}
```

---

### 5.3. Xóa checkin

**DELETE** `/api/checkins/{id}`

**Headers:** `Authorization: Bearer {token}`

**Example:** `DELETE /api/checkins/10`

---

## 6. API Goals

### 6.1. Tạo goal mới

**POST** `/api/goals`

**Headers:** `Authorization: Bearer {token}`

**Body:**
```json
{
  "title": "Checkin hàng ngày",
  "description": "Checkin cảm xúc mỗi ngày trong 30 ngày",
  "startDate": "2025-12-29",
  "endDate": "2026-01-28",
  "targetType": "COUNT",
  "targetValue": null,
  "targetCount": 30
}
```

**Target Types:**
- `EMOTION` - Theo dõi cảm xúc cụ thể
- `ACTIVITY` - Theo dõi hoạt động
- `LOCATION` - Theo dõi địa điểm
- `COUNT` - Đếm số lần checkin

---

### 6.2. Lấy danh sách goals

**GET** `/api/goals?page=0&size=20`

**Headers:** `Authorization: Bearer {token}`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "content": [
      {
        "id": 5,
        "title": "Checkin hàng ngày",
        "description": "Checkin cảm xúc mỗi ngày trong 30 ngày",
        "startDate": "2025-12-29",
        "endDate": "2026-01-28",
        "targetType": "COUNT",
        "targetCount": 30,
        "status": "ACTIVE",
        "progressValue": 15
      }
    ],
    "totalElements": 5,
    "totalPages": 1
  }
}
```

---

### 6.3. Đánh dấu hoàn thành / Cập nhật goal

**PATCH** `/api/goals/{id}`

**Headers:** `Authorization: Bearer {token}`

**Body:**
```json
{
  "status": "COMPLETED"
}
```

**Status values:** `ACTIVE`, `COMPLETED`, `CANCELLED`

---

## 7. API Admin

> ⚠️ **Yêu cầu token Admin**

### 7.1. Thống kê tổng quan hệ thống

**GET** `/api/admin/stats`

**Headers:** `Authorization: Bearer {admin_token}`

**Response (200):**
```json
{
  "success": true,
  "data": {
    "totalUsers": 10,
    "activeUsers": 8,
    "inactiveUsers": 2,
    "totalCheckins": 250,
    "totalGoals": 45,
    "activeGoals": 30,
    "completedGoals": 10,
    "cancelledGoals": 5,
    "totalTips": 20
  }
}
```

---

### 7.2. Xem danh sách tất cả users

**GET** `/api/admin/users`

**Headers:** `Authorization: Bearer {admin_token}`

**Response (200):**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "username": "tuananh",
      "displayName": "Tuấn Anh",
      "role": "USER",
      "isActive": true,
      "themeMode": "LIGHT",
      "createdAt": "2025-12-01T08:00:00"
    }
  ]
}
```

---

### 7.3. Kích hoạt/Vô hiệu hóa user

**PATCH** `/api/admin/users/{userId}/toggle`

**Headers:** `Authorization: Bearer {admin_token}`

**Example:** `PATCH /api/admin/users/2/toggle`

**Response (200):**
```json
{
  "success": true,
  "message": "User status updated",
  "data": {
    "id": 2,
    "username": "ngocbao",
    "isActive": false
  }
}
```

💡 Gọi lại để toggle ngược lại

---

## 8. API Tips (Admin only)

### 8.1. Xem tất cả tips (kể cả inactive)

**GET** `/api/tips/all`

**Headers:** `Authorization: Bearer {admin_token}`

---

### 8.2. Thêm tip mới

**POST** `/api/tips`

**Headers:** `Authorization: Bearer {admin_token}`

**Body:**
```json
{
  "title": "Tập thiền 10 phút mỗi ngày",
  "content": "Ngồi thoải mái, nhắm mắt, tập trung vào hơi thở...",
  "category": "ANXIETY"
}
```

---

### 8.3. Xóa tip

**DELETE** `/api/tips/{tipId}`

**Headers:** `Authorization: Bearer {admin_token}`

**Example:** `DELETE /api/tips/21`

---

### 8.4. Bật/Tắt hiển thị tip

**PATCH** `/api/tips/{tipId}/toggle`

**Headers:** `Authorization: Bearer {admin_token}`

**Example:** `PATCH /api/tips/1/toggle`

**Response (200):**
```json
{
  "success": true,
  "message": "Tip status updated",
  "data": {
    "id": 1,
    "title": "Kỹ thuật hít thở 4-7-8",
    "isActive": false
  }
}
```

---

### 8.5. Lấy tất cả checkins để phân tích (Insights)

**GET** `/api/checkins?page=0&size=100`

**Headers:** `Authorization: Bearer {token}`

💡 Flutter sẽ xử lý phân tích AI từ dữ liệu này:
- 👥 People Correlation
- 🎯 Activities Impact
- ⏰ Time Patterns
- 📍 Location Influence

---

## 📝 Error Responses

### 400 Bad Request
```json
{
  "success": false,
  "message": "Validation error message"
}
```

### 401 Unauthorized
```json
{
  "success": false,
  "message": "Invalid credentials"
}
```

### 403 Forbidden
```json
{
  "success": false,
  "message": "Access denied"
}
```

### 404 Not Found
```json
{
  "success": false,
  "message": "Resource not found"
}
```

