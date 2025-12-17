# 📚 HƯỚNG DẪN: Dùng List<Widget> để chuyển trang không bị nhảy

## ❌ Vấn đề cũ (BỊ NHẢY):

```dart
// Cách làm SAI - Mỗi màn hình có Scaffold riêng
class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(...),           // ← AppBar riêng
      body: Text("Home"),
      bottomNavigationBar: BottomNav(), // ← BottomNav riêng
    );
  }
}

// Khi chuyển trang bằng Navigator.push()
Navigator.push(context, MaterialPageRoute(
  builder: (context) => ProfilePage()  // ← Tạo màn hình MỚI
));

// KẾT QUẢ: AppBar và BottomNav bị tạo lại => NHẢY GIẬT! ❌
```

---

## ✅ Giải pháp mới (KHÔNG BỊ NHẢY):

### Bước 1: Tạo AppShell với List<Widget>

```dart
class AppShell extends StatefulWidget {
  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;  // ← Index trang hiện tại

  // 🎯 DANH SÁCH TẤT CẢ CÁC TRANG
  final List<Widget> _pages = const [
    HomePage(),      // Index 0
    ProfilePage(),   // Index 1
    SettingsPage(),  // Index 2
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ AppBar CHUNG cho tất cả trang
      appBar: CustomAppBar(),

      // ✅ CHỈ BODY THAY ĐỔI
      body: IndexedStack(
        index: _currentIndex,    // ← Hiển thị trang nào?
        children: _pages,        // ← Tất cả các trang
      ),

      // ✅ BottomNav CHUNG cho tất cả trang
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;  // ← CHỈ ĐỔI SỐ INDEX
          });
        },
      ),
    );
  }
}
```

### Bước 2: Các trang con KHÔNG CÓ Scaffold

```dart
// ✅ ĐÚNG - Chỉ có nội dung, không có Scaffold
class HomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Đây là Home"),
        // ... nội dung khác
      ],
    );
  }
}

class ProfilePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Đây là Profile"),
        // ... nội dung khác
      ],
    );
  }
}
```

---

## 🔍 Cách hoạt động:

### 1. **List<Widget> là gì?**
```dart
final List<Widget> _pages = [
  HomePage(),      // Trang 0
  ProfilePage(),   // Trang 1
  SettingsPage(),  // Trang 2
];
```
- Là một **DANH SÁCH** chứa tất cả các màn hình
- Mỗi màn hình có **INDEX** riêng (0, 1, 2, ...)
- Tất cả đều được **TẠO SẴN** khi khởi động app

### 2. **IndexedStack là gì?**
```dart
IndexedStack(
  index: _currentIndex,  // Hiển thị trang số mấy?
  children: _pages,      // Danh sách tất cả các trang
)
```

**Cách hoạt động:**
```
_currentIndex = 0  →  Hiển thị HomePage
_currentIndex = 1  →  Hiển thị ProfilePage
_currentIndex = 2  →  Hiển thị SettingsPage
```

**Điểm đặc biệt:**
- `IndexedStack` **GIỮ TẤT CẢ** các trang trong bộ nhớ
- Chỉ **HIỂN THỊ** trang có index = `_currentIndex`
- Các trang khác vẫn **TỒN TẠI** nhưng **ẨN ĐI** (opacity: 0)
- **Lợi ích**: 
  - ✅ Không cần tạo lại widget
  - ✅ Giữ nguyên trạng thái (scroll position, form data, ...)
  - ✅ KHÔNG bị nhảy AppBar/BottomNav

### 3. **setState thay đổi index**
```dart
onItemSelected: (index) {
  setState(() {
    _currentIndex = index;  // CHỈ ĐỔI SỐ
  });
}
```

**Điều gì xảy ra khi nhấn BottomNav?**
1. User nhấn vào tab "Profile" (index = 1)
2. `onItemSelected(1)` được gọi
3. `setState(() => _currentIndex = 1)`
4. Flutter **TỰ ĐỘNG** rebuild widget
5. `IndexedStack` nhận index mới → Hiển thị `ProfilePage`
6. **KHÔNG** dùng Navigator.push() → **KHÔNG** bị nhảy!

---

## 📊 So sánh hai cách:

| Tiêu chí | Navigator.push() (CŨ) | List<Widget> + IndexedStack (MỚI) |
|----------|----------------------|-----------------------------------|
| AppBar | Mỗi trang có AppBar riêng → BỊ NHẢY ❌ | AppBar CHUNG → Không nhảy ✅ |
| BottomNav | Mỗi trang có BottomNav riêng → BỊ NHẢY ❌ | BottomNav CHUNG → Không nhảy ✅ |
| Tạo widget | Tạo MỚI mỗi lần chuyển trang | Tạo SẴN 1 lần duy nhất |
| Trạng thái | MẤT trạng thái (scroll, form, ...) | GIỮ NGUYÊN trạng thái ✅ |
| Hiệu suất | Chậm hơn (tạo lại nhiều) | Nhanh hơn (chỉ đổi visibility) |
| Animation | Có animation push/pop | KHÔNG có animation (trơn tru hơn) |

---

## 🎯 Ứng dụng trong project của bạn:

### File: `lib/widgets/app_shell.dart`

```dart
class _AppShellState extends State<AppShell> {
  int _currentIndex = 0;

  // 🎯 4 TRANG CHÍNH CỦA APP
  final List<Widget> _pages = const [
    StressReliefScreen(),  // Index 0 - Check-in cảm xúc
    StatisticsScreen(),    // Index 1 - Thống kê
    InsightsScreen(),      // Index 2 - Phân tích
    MoreScreen(),          // Index 3 - Khác
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),  // ✅ AppBar CHUNG

      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() {
            _currentIndex = index;  // ✅ Chỉ đổi số
          });
        },
      ),
    );
  }
}
```

### Khi user nhấn BottomNav:

```
User nhấn "Check-in"  →  _currentIndex = 0  →  Hiển thị StressReliefScreen
User nhấn "Thống kê"  →  _currentIndex = 1  →  Hiển thị StatisticsScreen
User nhấn "Phân tích" →  _currentIndex = 2  →  Hiển thị InsightsScreen
User nhấn "Khác"      →  _currentIndex = 3  →  Hiển thị MoreScreen
```

**KẾT QUẢ:**
- ✅ AppBar "Tâm An - Trợ lý nhận diện căng thẳng" **KHÔNG NHẢY**
- ✅ BottomNav **KHÔNG NHẢY**
- ✅ Chuyển trang mượt mà
- ✅ Giữ nguyên trạng thái của mỗi trang

---

## 🚀 Lợi ích:

1. **UX tốt hơn**: Không bị giật lag khi chuyển trang
2. **Hiệu suất cao hơn**: Không tạo lại widget nhiều lần
3. **Giữ trạng thái**: Scroll position, form input, ... không bị mất
4. **Code sạch hơn**: AppBar và BottomNav chỉ định nghĩa 1 lần
5. **Dễ maintain**: Thêm/bớt trang chỉ cần sửa List<Widget>

---

## 💡 Lưu ý:

### Khi nào dùng List<Widget>?
✅ **NÊN DÙNG** khi:
- App có BottomNav/TabBar cố định
- Các trang cùng cấp (không có parent-child)
- Muốn giữ trạng thái của các trang

### Khi nào dùng Navigator.push()?
✅ **NÊN DÙNG** khi:
- Mở màn hình chi tiết (Product Detail, Profile Detail, ...)
- Màn hình tạm thời (Dialog, Modal, ...)
- Cần animation chuyển trang
- Cần history/back button

### Ví dụ kết hợp:

```dart
// Trang chính: Dùng List<Widget>
AppShell → [HomePage, ProfilePage, SettingsPage]

// Từ HomePage, mở chi tiết: Dùng Navigator.push()
HomePage → Navigator.push(ProductDetailPage)

// Từ ProfilePage, chỉnh sửa: Dùng Navigator.push()
ProfilePage → Navigator.push(EditProfilePage)
```

---

## 🎓 Tổng kết:

**List<Widget>** giúp bạn:
1. Tạo danh sách các trang
2. Dùng IndexedStack để chuyển đổi
3. Giữ nguyên AppBar và BottomNav
4. Không bị nhảy giật khi chuyển trang

**Công thức:**
```
List<Widget> + IndexedStack + setState(index) = Chuyển trang mượt mà! 🚀
```

Hy vọng bây giờ bạn đã hiểu rõ! 😊

