# PHÂN TÍCH YÊU CẦU VÀ ĐẶC TẢ CHỨC NĂNG ỨNG DỤNG "TÂM AN"
## (Mindful Load) - Trợ Lý Nhận Diện Tác Nhân Gây Căng Thẳng

**Ngày tạo:** 17 tháng 12, 2025  
**Phiên bản:** 1.0.0

---

## MỤC LỤC

1. [Tổng quan dự án](#1-tổng-quan-dự-án)
2. [Bối cảnh và vấn đề](#2-bối-cảnh-và-vấn-đề)
3. [Đối tượng người dùng](#3-đối-tượng-người-dùng)
4. [Yêu cầu chức năng](#4-yêu-cầu-chức-năng)
5. [Yêu cầu phi chức năng](#5-yêu-cầu-phi-chức-năng)
6. [Ràng buộc và giả định](#6-ràng-buộc-và-giả-định)
7. [Phân tích kiến trúc hệ thống](#7-phân-tích-kiến-trúc-hệ-thống)
8. [Đặc tả chi tiết các chức năng](#8-đặc-tả-chi-tiết-các-chức-năng)
9. [Mô hình dữ liệu](#9-mô-hình-dữ-liệu)
10. [Luồng người dùng](#10-luồng-người-dùng)
11. [Công nghệ sử dụng](#11-công-nghệ-sử-dụng)

---

## 1. TỔNG QUAN DỰ ÁN

### 1.1. Giới thiệu
**"Tâm An"** là một ứng dụng "nhật ký cảm xúc" thông minh, được thiết kế để giúp người dùng **tìm ra nguồn gốc của sự căng thẳng**. Không giống như các app "thiền" (meditation) giải quyết triệu chứng, **"Tâm An" tập trung vào việc chẩn đoán nguyên nhân**.

Ứng dụng này hoạt động như một **"thám tử" sức khỏe tinh thần**. Bằng cách cho phép người dùng ghi lại cảm xúc (check-in) một cách nhanh chóng trong ngày, ứng dụng sẽ sử dụng AI để phân tích và tìm ra các mô thức (patterns):
- *"Bạn thường cảm thấy 'Căng thẳng' vào lúc 4 giờ chiều ngày thứ Hai"*
- *"Những ngày bạn ngủ ít hơn 6 tiếng, mức độ lo lắng của bạn tăng 50%"*

### 1.2. Mục tiêu
- **Check-in ma sát thấp (low-friction):** Chỉ mất **5 giây** để ghi nhận cảm xúc
- **Phân tích sâu sắc (high-insight):** Cung cấp báo cáo phân tích chi tiết vào cuối tuần
- **Tự nhận thức (self-awareness):** Giúp người dùng hiểu rõ các tác nhân gây stress
- **Hành động cụ thể:** Không chỉ là "hít thở đi", mà là "Các cuộc họp lúc 10 giờ sáng đang làm bạn kiệt sức"

### 1.3. Triết lý sản phẩm
> **"Bạn không thể 'sửa' một vấn đề nếu bạn không biết nó là gì"**

Ứng dụng này là một **công cụ nhận thức**, không phải là công cụ trị liệu. Nó không thay thế bác sĩ tâm lý, nó chỉ cung cấp dữ liệu khách quan để người dùng tự hiểu mình hơn.

---

## 2. BỐI CẢNH VÀ VẤN ĐỀ

### 2.1. Hiện trạng (Current State)
**Stress là một "kẻ giết người thầm lặng".** Mọi người đều biết nó tồn tại, nhưng lại rất mơ hồ về nó.

#### Vấn đề 1: Cảm xúc Mơ hồ
Người dùng thường chỉ có một cảm giác chung chung là "mệt mỏi", "buồn", hoặc "căng thẳng". Họ không có khả năng (hoặc thời gian) để ngồi xuống và phân tích: **"Mình căng thẳng vì điều gì?"**

#### Vấn đề 2: Thiếu Dữ liệu Khách quan
**Không có dữ liệu, không thể cải thiện.** Bạn có thể nghĩ rằng công việc là nguyên nhân, nhưng dữ liệu có thể chỉ ra rằng đó là do:
- Xung đột với một người cụ thể
- Thói quen lướt mạng xã hội trước khi ngủ
- Thiếu ngủ liên tục trong tuần

#### Vấn đề 3: Check-in Rườm rà
Các app nhật ký hiện tại đòi hỏi người dùng phải viết rất nhiều, điều này tạo ra rào cản. **Không ai muốn viết một đoạn văn dài khi họ đang mệt mỏi.**

### 2.2. Cơ hội (Opportunity)
Xây dựng một công cụ:
- ✅ **Check-in ma sát thấp:** Chỉ mất 5 giây
- ✅ **Báo cáo phân tích sâu sắc:** Vào cuối tuần
- ✅ **Tự nhận thức:** Người dùng hiểu rõ các tác nhân gây stress cho chính họ

---

## 3. ĐỐI TƯỢNG NGƯỜI DÙNG

### 3.1. Chân dung người dùng (Persona)
**"Người đi làm Cảm thấy Quá tải"**

#### Thông tin cơ bản:
- **Đối tượng:** Nhân viên văn phòng, sinh viên
- **Tình trạng:** Cảm thấy mình luôn "quay cuồng", mất cân bằng giữa công việc và cuộc sống
- **Độ tuổi:** 22-40 tuổi

#### Nhu cầu:
- 🎯 Muốn **hiểu rõ bản thân hơn**
- 🎯 Muốn tìm ra **"thủ phạm" thực sự** đang lấy đi năng lượng
- 🎯 Muốn có **hành động cụ thể** để cải thiện

#### Tâm lý:
> *"Họ không cần thêm một app 'thiền' bảo họ 'hít thở đi', họ cần một app nói cho họ biết 'Có vẻ như các cuộc họp lúc 10 giờ sáng đang làm bạn kiệt sức'"*

#### Pain Points:
- Không có thời gian viết nhật ký dài
- Không biết bắt đầu phân tích cảm xúc từ đâu
- Cần câu trả lời cụ thể, không phải lời khuyên chung chung

---

## 4. YÊU CẦU CHỨC NĂNG

### FR1: Module "Check-in Cảm xúc 5 Giây" (5-Second Check-in)

#### FR1.1: Giao diện Tối giản
**Mục tiêu:** Giảm ma sát tối đa cho quá trình check-in

**Mô tả:**
- Khi mở app (hoặc qua widget), người dùng được hỏi một câu đơn giản:
  > **"Bạn đang cảm thấy thế nào?"**
- Không có menu phức tạp, không có điều hướng rườm rà
- Truy cập trực tiếp vào màn hình check-in

**Hiện thực trong dự án:**
- File: `lib/screens/user/stress_relief_screen.dart`
- Màn hình đầu tiên hiển thị gradient card với câu hỏi
- Widget: "Xin chào! 👋" + "Hãy dành 5 giây để chia sẻ cảm xúc của bạn lúc này."

#### FR1.2: Lựa chọn Cảm xúc
**Mục tiêu:** Hiển thị các cảm xúc chính một cách trực quan

**Yêu cầu:**
- Hiển thị **5-7 biểu tượng cảm xúc** chính
- Cảm xúc bắt buộc: Vui, Hạnh phúc, Bình thường, Buồn, Lo lắng, Căng thẳng, Giận dữ

**Hiện thực trong dự án:**
- 6 cảm xúc với icon rõ ràng:
  1. 😊 **Hạnh phúc** (sentiment_very_satisfied, Amber)
  2. 😄 **Vui vẻ** (sentiment_satisfied_alt, Green)
  3. 😐 **Bình thường** (sentiment_neutral, Grey)
  4. 😟 **Lo lắng** (sentiment_dissatisfied, Purple)
  5. 😰 **Căng thẳng** (stress_management, Orange)
  6. 😠 **Giận dữ** (sentiment_very_dissatisfied, Red)
- Layout: Grid 2 cột, dễ nhấn, dễ phân biệt
- Tương tác: Một tap là chọn xong

#### FR1.3: Thêm "Tác nhân" (Tags) ⭐ **TÍNH NĂNG CỐT LÕI**
**Mục tiêu:** Thu thập ngữ cảnh một cách nhanh chóng

**Mô tả:**
Sau khi chọn cảm xúc (ví dụ: "Căng thẳng"), ứng dụng ngay lập tức hiển thị các **"tag" (nhãn)** để người dùng chọn nhanh:

**a) Đang ở đâu? (Location)**
- 🏠 Ở nhà
- 💼 Công ty
- 🏫 Trường học
- 🍽️ Nhà hàng
- 🌳 Ngoài trời
- 🚗 Trên đường
- 🛒 Mua sắm
- ✨ Khác

**b) Đang làm gì? (Activity)**
- 💼 Làm việc
- 📖 Học tập
- 🏃 Tập thể dục
- 🍽️ Ăn uống
- ⚡ Lướt mạng (Facebook, TikTok, v.v.)
- 🎬 Giải trí
- 😴 Nghỉ ngơi
- ✨ Khác

**c) Đang với ai? (Company)**
- 😴 Một mình
- 👫 Bạn bè
- 👨‍👩‍👧‍👦 Gia đình
- 👔 Đồng nghiệp
- 💑 Người yêu
- 👨‍💼 Sếp
- ✨ Khác

**Quy trình:**
```
1. User chọn cảm xúc (1 tap)
2. Navigate sang màn hình chi tiết
3. User chọn 2-3 tags (3 taps)
4. (Tùy chọn) Thêm ghi chú ngắn
5. Nhấn "Hoàn tất"
→ Toàn bộ quá trình: 5-10 giây
```

**Hiện thực trong dự án:**
- File: `lib/screens/user/Check_in.dart`
- 3 sections: Location (8 options), Activity (8 options), Company (6 options)
- UI: Card trắng với border, icons rõ ràng
- Selection: Single choice, visual feedback khi chọn

#### FR1.4: Lời nhắc Ngẫu nhiên (Random Reminders)
**Mục tiêu:** Tăng tần suất check-in để có dữ liệu phong phú

**Yêu cầu:**
- Ứng dụng gửi **thông báo ngẫu nhiên** (ví dụ: 3 lần/ngày)
- Nội dung nhắc nhở:
  > "Check-in nhanh nhé? Bạn đang cảm thấy thế nào?"
- Thời gian ngẫu nhiên để tránh dự đoán
- Cho phép tắt hoặc điều chỉnh tần suất

**Hiện trạng:** Đang phát triển (chưa implement)

**Kế hoạch:**
- Sử dụng package `flutter_local_notifications`
- Schedule 3 notifications/ngày với thời gian random
- Deep link trực tiếp vào màn hình check-in

---

### FR2: Module "Tương quan & Phân tích" (AI Correlation Engine) ⭐ **"MA THUẬT"**

#### FR2.1: Bảng điều khiển (Dashboard)
**Mục tiêu:** Hiển thị tổng quan cảm xúc

**Yêu cầu:**
- Biểu đồ phân bố cảm xúc trong tuần
  - Ví dụ: 40% Vui, 30% Căng thẳng, 20% Bình thường, 10% Khác
- Filter theo thời gian: 7 ngày, 30 ngày, Tất cả
- Hiển thị tổng số check-in
- Streak (số ngày liên tiếp check-in)

**Hiện thực trong dự án:**
- File: `lib/screens/user/dashboard_screen.dart`
- UI Components:
  - 3 Summary Cards: Tổng check-in, Cảm xúc tích cực %, Streak
  - Pie Chart: Phân bố cảm xúc (fl_chart)
  - Stacked Bar Chart: Xu hướng theo thời gian
  - Top Emotion Card: Top 3 cảm xúc phổ biến

#### FR2.2: Phân tích Tác nhân (AI Insight) ⭐ **TÍNH NĂNG "MA THUẬT"**
**Mục tiêu:** Tìm ra patterns và đưa ra nhận định cụ thể

**Mô tả:**
Vào cuối tuần (ví dụ: Chủ Nhật), AI sẽ phân tích tất cả các check-in và đưa ra các nhận định:

**Gợi ý 1 - Tương quan Hành động (Activity Correlation):**
> 🎯 **"Tâm An nhận thấy: 86% các lần bạn check-in 'Căng thẳng' đều liên quan đến tag [Họp]. Có thể đây là một tác nhân gây căng thẳng cho bạn."**

**Gợi ý 2 - Tương quan Con người (People Correlation):**
> 👥 **"Bạn có vẻ 'Vui vẻ' hơn khi check-in với [Bạn bè] (tỷ lệ 90%) so với khi ở [Công ty] (tỷ lệ 30%)."**

**Gợi ý 3 - Tương quan Thời gian (Time Correlation):**
> ⏰ **"Mức độ 'Lo lắng' của bạn có xu hướng tăng cao vào tối Chủ Nhật. Có thể bạn đang lo cho tuần mới?"**

> ⏰ **"Bạn thường cảm thấy 'Căng thẳng' vào lúc 4 giờ chiều ngày thứ Hai."**

**Gợi ý 4 - Tương quan Địa điểm (Location Correlation):**
> 📍 **"83% các lần check-in tiêu cực của bạn xảy ra tại [Công ty]. Môi trường này có thể đang ảnh hưởng đến tâm trạng của bạn."**

**Hiện thực trong dự án:**
- File: `lib/screens/user/insight.dart`
- 4 Correlation Cards với:
  - Emoji đại diện
  - Title (loại tương quan)
  - Reliability badge (% tin cậy với màu sắc)
  - Description chi tiết
  - Chip tag
- Logic phân tích (sẽ chi tiết ở phần 8)

#### FR2.3: Tích hợp Dữ liệu Sức khỏe (Tùy chọn)
**Mục tiêu:** Mở rộng phân tích với dữ liệu sinh học

**Yêu cầu:**
- Tích hợp với Google Fit / Apple Health (nếu được cấp phép)
- Thu thập:
  - Giờ ngủ (sleep hours)
  - Bước đi (steps)
  - Nhịp tim (heart rate - optional)

**Gợi ý 5 - Tương quan Sức khỏe:**
> 💤 **"Những ngày bạn ngủ ít hơn 6 tiếng, số lần check-in 'Giận dữ' của bạn tăng gấp 2 lần."**

> 🏃 **"Những ngày bạn đi bộ trên 8000 bước, tỷ lệ cảm xúc tích cực của bạn tăng 40%."**

**Hiện trạng:** Chưa implement (kế hoạch Phase 3)

---

### FR3: Module "Nhật ký Vi mô" (Micro-Journal)

#### FR3.1: Ghi chú Tùy chọn
**Mục tiêu:** Cho phép người dùng ghi chú nhanh nếu muốn

**Yêu cầu:**
- Sau khi check-in (FR1), người dùng có thể **(tùy chọn)** viết thêm 1-2 câu
- Không bắt buộc, không tạo áp lực
- Expandable textarea: Mặc định collapsed

**Hiện thực trong dự án:**
- File: `lib/screens/user/Check_in.dart`
- Section "Ghi chú (tùy chọn)"
- Mặc định: Text "Thêm ghi chú (tùy chọn)" với icon
- Nhấn để expand → TextField xuất hiện
- Placeholder: "Ghi lại suy nghĩ của bạn..."

#### FR3.2: Tra cứu Lịch sử
**Mục tiêu:** Cho phép xem lại các check-in trước đó

**Yêu cầu:**
- Xem timeline các check-in
- Filter theo ngày/tuần/tháng
- Câu hỏi: **"Ngày này tháng trước mình cảm thấy thế nào?"**
- Hiển thị đầy đủ: Cảm xúc, tags, ghi chú, timestamp

**Hiện thực trong dự án:**
- File: `lib/screens/user/journal_screen.dart`
- UI:
  - Date filter chips (horizontal scroll)
  - Stats card tóm tắt
  - Timeline list các check-in
  - Mỗi item hiển thị: Icon cảm xúc, thời gian, tags, note preview
- Interaction: Tap item → Bottom sheet với full details

---

## 5. YÊU CẦU PHI CHỨC NĂNG

### NFR1: Quyền riêng tư & Bảo mật (Privacy) ⭐ **TUYỆT ĐỐI QUAN TRỌNG**

**Lý do:** Dữ liệu cảm xúc là **cực kỳ nhạy cảm**.

#### NFR1.1: Mã hóa Dữ liệu
**Yêu cầu:**
- Tất cả dữ liệu cảm xúc phải được **mã hóa mạnh** (AES-256)
- Dữ liệu truyền qua HTTPS (TLS 1.3)
- Token/Session được mã hóa

#### NFR1.2: Xử lý On-Device (Ưu tiên cao)
**Yêu cầu:**
- Tốt nhất là xử lý phân tích **trên thiết bị** (on-device AI) nếu có thể
- Giảm thiểu việc gửi dữ liệu raw lên server
- Chỉ gửi dữ liệu đã aggregated (tổng hợp) nếu cần

**Kế hoạch:**
- Phase 1-2: Server-side AI (với encryption)
- Phase 3: Migrate sang TensorFlow Lite (on-device)

#### NFR1.3: Cam kết Không Bán Dữ liệu
**Yêu cầu:**
- **Cam kết không bao giờ bán dữ liệu cho bên thứ ba**
- Hiển thị rõ ràng trong Privacy Policy
- Không tracking cho mục đích quảng cáo

#### NFR1.4: Kiểm soát Dữ liệu
**Yêu cầu:**
- User có quyền:
  - Xem tất cả dữ liệu của mình
  - Export dữ liệu (JSON/CSV)
  - Xóa tất cả dữ liệu vĩnh viễn

---

### NFR2: Trải nghiệm Người dùng (UX) - Frictionless

#### NFR2.1: Check-in Nhanh
**Yêu cầu:**
- Quá trình check-in (FR1) phải **hoàn toàn không có ma sát**
- **Nếu nó mất hơn 10 giây, người dùng sẽ không làm**
- Target: 5-7 giây cho 1 check-in đầy đủ

**Đo lường:**
```
Thời gian check-in = Từ lúc mở app → Nhấn "Hoàn tất"
✅ Mục tiêu: < 10 giây
⭐ Lý tưởng: 5-7 giây
```

#### NFR2.2: Responsive & Smooth
**Yêu cầu:**
- Animation: 60 FPS
- Không lag khi scroll
- Instant feedback khi tap

---

### NFR3: Tính cá nhân hóa (Personalization)

#### NFR3.1: Tags Tùy chỉnh
**Yêu cầu:**
- Các "tag" (FR1.3) phải cho phép người dùng **tự thêm**
- Ví dụ:
  - Thêm tag "Họp với Sếp A"
  - Thêm tag "Dự án B"
  - Thêm tag "Phòng gym X"

**Hiện trạng:** Đang phát triển

**Kế hoạch UI:**
- Mỗi section có button "+ Thêm tùy chỉnh"
- Dialog nhập tên tag
- Lưu vào danh sách custom tags của user

#### NFR3.2: Insights Cá nhân hóa
**Yêu cầu:**
- Phân tích phải dựa trên **dữ liệu cá nhân** của từng user
- Không áp dụng insights chung cho tất cả
- Mỗi người có patterns riêng

---

## 6. RÀNG BUỘC VÀ GIẢ ĐỊNH

### 6.1. Ràng buộc (Constraints)

#### Ràng buộc 1: Phụ thuộc vào Dữ liệu
**Mô tả:**
- Chất lượng của phân tích (FR2.2) phụ thuộc **100%** vào:
  - **Tần suất** check-in từ người dùng
  - **Sự trung thực** của các check-in

**Giải pháp:**
- FR1.4: Lời nhắc ngẫu nhiên để tăng tần suất
- UX tốt (NFR2) để giảm ma sát
- Giáo dục user về giá trị của việc check-in thường xuyên

#### Ràng buộc 2: Độ Tin cậy Thống kê
**Mô tả:**
- Cần **tối thiểu 7 ngày dữ liệu** (khoảng 21 check-ins) để có insights đáng tin cậy
- Ít hơn = insights có thể không chính xác

**Giải pháp:**
- Hiển thị reliability score (%)
- Thông báo: "Cần thêm dữ liệu để phân tích chính xác hơn"

### 6.2. Gi�� định (Assumptions)

#### Giả định 1 (Lớn nhất): Người dùng Sẵn lòng Check-in
**Mô tả:**
- Giả định rằng người dùng sẵn lòng check-in cảm xúc của họ
- Đây là giả định quan trọng nhất

**Rủi ro:**
- Nếu user không check-in → Không có dữ liệu → Không có insights

**Giảm thiểu rủi ro:**
- FR1.4: Lời nhắc ngẫu nhiên
- NFR2: UX tốt, không ma sát
- Gamification: Streak, badges (future)
- Value proposition rõ ràng: "Check-in càng nhiều, insights càng chính xác"


```
lib/
├── main.dart                          # Entry point của ứng dụng
├── config/
│   ├── app_config.dart               # Cấu hình toàn cục (màu sắc, API, constants)
│   └── app_theme.dart                # Theme configuration
├── models/
│   ├── check_in.dart                 # Model dữ liệu check-in cảm xúc
│   └── user.dart                     # Model người dùng
├── providers/
│   └── auth_provider.dart            # State management cho xác thực
├── screens/
│   ├── auth/
│   │   └── auths_screen.dart        # Màn hình đăng nhập/đăng ký
│   ├── user/
│   │   ├── stress_relief_screen.dart # Màn hình chính - Check-in
│   │   ├── Check_in.dart             # Chi tiết check-in (Bước 2)
│   │   ├── CheckInSummary.dart       # Tổng kết check-in
│   │   ├── dashboard_screen.dart     # Thống kê cảm xúc
│   │   ├── insight.dart              # Phân tích AI
│   │   ├── journal_screen.dart       # Nhật ký cảm xúc
│   │   └── more_screen.dart          # Menu cài đặt và khác
│   └── admin/
│       └── admin_home.dart           # Giao diện admin (đang phát triển)
├── services/
│   └── api_service.dart              # Service gọi API backend
├── utils/
│   └── helpers.dart                  # Các hàm tiện ích
└── widgets/
    ├── app_shell.dart                # Shell chứa bottom navigation
    ├── custom_app_bar.dart           # App bar tùy chỉnh
    ├── custom_bottom_nav.dart        # Bottom navigation bar
    ├── more_menu_item.dart           # Menu item cho màn hình More
    ├── stat_card.dart                # Card thống kê
    └── tag_chip.dart                 # Chip hiển thị tag
```

### 2.2. Kiến trúc ứng dụng

```
┌─────────────────────────────────────────────────┐
│              Presentation Layer                  │
│  (Screens, Widgets, UI Components)              │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│           State Management Layer                 │
│         (Providers, State Objects)               │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│            Business Logic Layer                  │
│    (Services, Utils, Helper Functions)          │
└──────────────────┬──────────────────────────────┘
                   │
┌──────────────────▼──────────────────────────────┐
│              Data Layer                          │
│     (Models, API Services, Local Storage)       │
└─────────────────────────────────────────────────┘
```

---

## 3. PHÂN TÍCH YÊU CẦU CHỨC NĂNG

### 3.1. Sơ đồ Use Case

```
┌────────────────────────────────────────────────┐
│                 Hệ thống Tâm An                │
└────────────────────────────────────────────────┘

    Người dùng                    Chức năng
        │                             
        ├──────────► Đăng nhập
        │
        ├──────────► Đăng ký
        │
        ├──────────► Check-in cảm xúc
        │                 ├─► Chọn cảm xúc
        │                 ├─► Chọn địa điểm
        │                 ├─► Chọn hoạt động
        │                 ├─► Chọn người đi cùng
        │                 └─► Thêm ghi chú
        │
        ├──────────► Xem thống kê
        │                 ├─► Thống kê theo thời gian
        │                 ├─► Phân bố cảm xúc
        │                 └─► Biểu đồ xu hướng
        │
        ├──────────► Xem phân tích AI
        │                 ├─► Tương quan hoạt động
        │                 ├─► Tương quan con người
        │                 ├─► Tương quan thời gian
        │                 └─► Tương quan địa điểm
        │
        ├──────────► Xem nhật ký
        │
        └──────────► Cài đặt và hồ sơ
```

### 3.2. Các module chính

#### Module 1: Xác thực (Authentication)
- **File:** `lib/screens/auth/auths_screen.dart`
- **Chức năng:**
  - Đăng nhập
  - Đăng ký tài khoản mới
  - Demo account: admin/admin123, demo/demo123

#### Module 2: Check-in Cảm xúc (Emotion Check-in)
- **File:** `lib/screens/user/stress_relief_screen.dart`, `lib/screens/user/Check_in.dart`, `lib/screens/user/CheckInSummary.dart`
- **Chức năng:**
  - Chọn cảm xúc hiện tại (5 loại)
  - Ghi nhận ngữ cảnh (địa điểm, hoạt động, người đi cùng)
  - Thêm ghi chú tùy chọn
  - Xem tổng kết check-in trong ngày

#### Module 3: Thống kê (Statistics)
- **File:** `lib/screens/user/dashboard_screen.dart`
- **Chức năng:**
  - Hiển thị tổng quan cảm xúc
  - Biểu đồ phân bố cảm xúc
  - Biểu đồ cột xếp chồng theo thời gian
  - Filter theo 7 ngày, 30 ngày, tất cả

#### Module 4: Phân tích AI (AI Insights)
- **File:** `lib/screens/user/insight.dart`
- **Chức năng:**
  - Phân tích tương quan hoạt động
  - Phân tích tương quan con người
  - Phân tích tương quan thời gian
  - Phân tích tương quan địa điểm
  - Hiển thị độ tin cậy của phân tích

#### Module 5: Nhật ký (Journal)
- **File:** `lib/screens/user/journal_screen.dart`
- **Chức năng:**
  - Xem lịch sử check-in
  - Filter theo ngày
  - Xem chi tiết từng check-in

#### Module 6: Cài đặt & Khác (More/Settings)
- **File:** `lib/screens/user/more_screen.dart`
- **Chức năng:**
  - Xem thông tin người dùng
  - Cài đặt ứng dụng
  - Trợ giúp và hỗ trợ
  - Thông tin phiên bản

---

## 4. ĐẶC TẢ CHI TIẾT CÁC CHỨC NĂNG

### 4.1. Chức năng Đăng nhập/Đăng ký

#### 4.1.1. Màn hình đăng nhập (Login)
**File:** `lib/screens/auth/auths_screen.dart`

**Mô tả:**
- Người dùng nhập tên đăng nhập và mật khẩu
- Hệ thống xác thực thông tin
- Chuyển hướng đến màn hình chính nếu thành công

**Input:**
- Tên đăng nhập (String)
- Mật khẩu (String)

**Output:**
- Thành công: Chuyển đến `AppShell` (màn hình chính)
- Thất bại: Hiển thị thông báo lỗi

**UI Components:**
- Header với icon trái tim và tên ứng dụng
- Tab switch giữa Login/Register
- 2 input fields (username, password)
- Button "Đăng nhập"
- Demo account card

**Luồng xử lý:**
```
1. Người dùng nhập thông tin
2. Nhấn nút "Đăng nhập"
3. Validate thông tin (không rỗng)
4. [Tương lai] Gọi API xác thực
5. Lưu session/token
6. Chuyển đến AppShell
```

#### 4.1.2. Màn hình đăng ký (Register)
**Mô tả:**
- Người dùng tạo tài khoản mới
- Nhập thông tin cá nhân
- Xác nhận mật khẩu

**Input:**
- Tên đăng nhập (String)
- Mật khẩu (String)
- Xác nhận mật khẩu (String)

**Validation:**
- Tên đăng nhập: không rỗng, chưa tồn tại
- Mật khẩu: tối thiểu 6 ký tự
- Xác nhận mật khẩu: phải khớp với mật khẩu

---

### 4.2. Chức năng Check-in Cảm xúc

#### 4.2.1. Bước 1: Chọn cảm xúc
**File:** `lib/screens/user/stress_relief_screen.dart`

**Mô tả:**
- Màn hình chính hiển thị card gradient với lời chào
- Hiển thị số lượng check-in trong ngày (ví dụ: "3 check-in hôm nay")
- Progress bar hiển thị tiến trình (Bước 1/2)
- Grid 6 lựa chọn cảm xúc

**5 loại cảm xúc:**
1. **Hạnh phúc** - Icon: sentiment_very_satisfied, Màu: Amber
2. **Vui vẻ** - Icon: sentiment_satisfied_alt, Màu: Green
3. **Bình thường** - Icon: sentiment_neutral, Màu: Grey
4. **Lo lắng** - Icon: sentiment_dissatisfied, Màu: Purple
5. **Căng thẳng** - Icon: stress_management, Màu: Orange
6. **Giận dữ** - Icon: sentiment_very_dissatisfied, Màu: Red

**UI Components:**
- Gradient card chính
- Lời chào "Xin chào! 👋"
- Text hướng dẫn
- Badge số lượng check-in
- Progress bar với text "Bước 1/2"
- 6 feeling items trong grid 2 cột

**Interaction:**
```
1. Người dùng nhấn vào 1 trong 6 cảm xúc
2. Navigate đến CheckInDetailScreen với emotion được chọn
3. Truyền tham số: selectedEmotion (String)
```

#### 4.2.2. Bước 2: Chi tiết Check-in
**File:** `lib/screens/user/Check_in.dart`

**Mô tả:**
- Hiển thị cảm xúc đã chọn (có thể đổi)
- Cho phép người dùng chọn thêm thông tin ngữ cảnh
- Progress bar: Bước 2/2

**Các thông tin thu thập:**

**a) Cảm xúc (Emotion):**
- Hiển thị trong card màu tím nhạt
- Button "Đổi" để quay lại bước 1
- Display: "Cảm xúc: [Tên cảm xúc]"

**b) Địa điểm (Location):**
- Title: "Bạn đang ở đâu?"
- 8 lựa chọn:
  - 🏠 Ở nhà
  - 💼 Công ty
  - 🏫 Trường học
  - 🍽️ Nhà hàng
  - 🌳 Ngoài trời
  - 🚗 Trên đường
  - 🛒 Mua sắm
  - ✨ Khác

**c) Hoạt động (Activity):**
- Title: "Bạn đang làm gì?"
- 8 lựa chọn:
  - 💼 Làm việc
  - 📖 Học tập
  - 🏃 Tập thể dục
  - 🍽️ Ăn uống
  - ⚡ Lướt mạng
  - 🎬 Giải trí
  - 😴 Nghỉ ngơi
  - ✨ Khác

**d) Người đi cùng (Company):**
- Title: "Bạn đang ở cùng ai?"
- 6 lựa chọn:
  - 😴 Một mình
  - 👫 Bạn bè
  - 👨‍👩‍👧‍👦 Gia đình
  - 👔 Đồng nghiệp
  - 💑 Người yêu
  - ✨ Khác

**e) Ghi chú (Note) - Tùy chọn:**
- Mặc định: Collapsed với text "Thêm ghi chú (tùy chọn)"
- Nhấn để expand
- TextField cho phép nhập văn bản tự do

**UI Components:**
- Gradient card header
- Progress bar "Bước 2/2"
- Emotion display card (màu tím)
- 4 selection sections (Location, Activity, Company, Note)
- Button "Hoàn tất" màu đen

**Validation:**
- Emotion: Bắt buộc (đã chọn từ bước 1)
- Location: Tùy chọn
- Activity: Tùy chọn
- Company: Tùy chọn
- Note: Tùy chọn

**Luồng xử lý:**
```
1. Hiển thị emotion từ bước 1
2. Người dùng chọn các thông tin ngữ cảnh
3. (Optional) Người dùng expand note và nhập text
4. Nhấn "Hoàn tất"
5. Validate dữ liệu
6. [Tương lai] Gọi API lưu check-in
7. Navigate đến CheckInSummaryScreen
```

##### 8.3.2.3. Bước 3: Tổng kết Check-in
**File:** `lib/screens/user/CheckInSummary.dart`

**Mô tả:**
- Modal dialog hiển thị tóm tắt check-in
- Thông tin cảm xúc vừa chọn
- Lời khuyên từ AI
- Gợi ý bài tập thở

**UI Components:**

**a) Header:**
- Title: "Tổng kết hôm nay"
- Subtitle: "Bạn đã check-in X lần trong ngày hôm nay"
- Close button (X)

**b) Dominant Emotion Card:**
- Gradient background (màu tím-hồng)
- Title: "Cảm xúc vừa chọn"
- Icon cảm xúc (48x48)
- Tên cảm xúc
- Địa điểm (nếu có)

**c) Advice Card:**
- Gradient background (màu vàng)
- Title: "Lời khuyên từ Tâm An"
- Nội dung: Phân tích ngắn gọn về cảm xúc và các yếu tố liên quan
- Gợi ý: Kỹ thuật giảm stress (ví dụ: hít thở 4-7-8)

**d) Suggestion Card:**
- Background trắng
- Title: "Bạn có muốn?"
- 2 lựa chọn:
  - "📊 Xem thống kê" → Navigate to StatisticsScreen
  - "🧘 Thử bài tập thở" → Navigate to breathing exercise

**e) Action Buttons:**
- Button chính: "Xong" (màu đen) → Đóng modal
- Button phụ: "Xem lịch sử" (outline) → Navigate to JournalScreen

**Logic hiển thị:**
```
1. Nhận dữ liệu từ Check_in.dart:
   - emotion (String) ✓
   - location (String?)
   - activity (String?)
   - company (String?)
   - note (String?)

2. Tạo timestamp hiện tại

3. [Tương lai] Gọi AI API để phân tích:
   - Input: emotion, location, activity, company, note
   - Output: advice text, correlation insights

4. Hiển thị UI với dữ liệu

5. Người dùng có thể:
   - Đóng modal → Quay về StressReliefScreen
   - Xem thống kê → Navigate to StatisticsScreen
   - Xem lịch sử → Navigate to JournalScreen
```

#### 8.3.3. Chức năng Thống kê

##### 8.3.3.1. Màn hình Thống kê
**File:** `lib/screens/user/dashboard_screen.dart`

**Mô tả:**
- Tổng quan trạng thái cảm xúc của người dùng
- Hiển thị biểu đồ trực quan
- Filter theo khoảng thời gian

**UI Components:**

**a) Header:**
- Title: "Thống kê Cảm xúc"
- Subtitle: "Tổng quan về tâm trạng của bạn"

**b) Filter Row:**
- 3 chips:
  - "7 ngày" (selected by default)
  - "30 ngày"
  - "Tất cả"
- Background: Chip được chọn có màu đen, text trắng
- Background: Chip không chọn có màu trắng, text đen

**c) Summary Cards (3 cards):**
- Card 1: Tổng check-in
  - Icon: ✓
  - Số lượng: 28
  - Label: "Check-in"
  
- Card 2: Cảm xúc tích cực
  - Icon: 😊
  - Số lượng: 18
  - Percentage: 64%
  
- Card 3: Streak hiện tại
  - Icon: 🔥
  - Số ngày: 7
  - Label: "Ngày liên tiếp"

**d) Emotion Distribution Card:**
- Title: "Phân bố Cảm xúc"
- Pie Chart với fl_chart package
- 5 segments tương ứng 5 cảm xúc
- Màu sắc:
  - Vui vẻ: #10B981 (Green)
  - Bình thường: #6366F1 (Indigo)
  - Buồn: #3B82F6 (Blue)
  - Căng thẳng: #FF6900 (Orange)
  - Giận dữ: #FB2C36 (Red)
- Legend hiển thị % của từng cảm xúc

**e) Emotion Timeline Card:**
- Title: "Xu hướng Cảm xúc"
- Stacked Bar Chart theo ngày
- Mỗi cột = 1 ngày
- Chiều cao segment = số lượng check-in của cảm xúc đó
- Tooltip hiển thị chi tiết khi hover/tap

**f) Top Emotion Card:**
- Title: "Cảm xúc Phổ biến"
- Hiển thị top 3 cảm xúc
- Mỗi item có:
  - Icon cảm xúc
  - Tên cảm xúc
  - Progress bar
  - Percentage

**Logic:**
```
1. Lấy dữ liệu check-in từ API/Local Storage
2. Filter theo time range được chọn
3. Tính toán:
   - Tổng số check-in
   - % cảm xúc tích cực (Hạnh phúc + Vui vẻ)
   - Streak (số ngày liên tiếp có check-in)
   - Distribution của từng cảm xúc
4. Render charts với fl_chart
5. Update UI khi user thay đổi filter
```

#### 8.3.4. Chức năng Phân tích AI ⭐ "MA THUẬT"

##### 8.3.4.1. Màn hình Phân tích
**File:** `lib/screens/user/insight.dart`

**Mô tả:**
- Phân tích sâu các yếu tố ảnh hưởng đến cảm xúc
- Tìm tương quan giữa cảm xúc và ngữ cảnh
- Hiển thị độ tin cậy của phân tích

**UI Components:**

**a) Header:**
- Title: "Phân tích AI"
- Subtitle: "Tâm An đã phân tích X check-in trong 30 ngày qua"

**b) Info Note Card:**
- Background: Gradient xanh nhạt
- Icon: 💡
- Title: "Lưu ý"
- Content: Giải thích về độ tin cậy và cách diễn giải kết quả
- Sub-content: "Độ tin cậy ≥ 80% = Rất đáng tin cậy"

**c) Correlation Cards (4 loại):**

**Card 1: Tương quan Hoạt động**
- Emoji: 🎯
- Title: "Tương quan Hoạt động"
- Reliability badge:
  - Text: "X% tin cậy"
  - Color: Green (≥80%), Orange (60-79%), Red (<60%)
- Description: Phân tích mối liên hệ giữa hoạt động và cảm xúc
- Ví dụ: "86% các lần bạn check-in cảm xúc tiêu cực đều liên quan đến hoạt động [Họp]"
- Chip: "Tương quan Hoạt động"

**Card 2: Tương quan Con người**
- Emoji: 👥
- Logic tương tự
- Phân tích: Ai làm bạn vui/buồn hơn

**Card 3: Tương quan Thời gian**
- Emoji: ⏰
- Phân tích: Ngày nào, giờ nào bạn thường có cảm xúc gì

**Card 4: Tương quan Địa điểm**
- Emoji: 📍
- Phân tích: Địa điểm nào ảnh hưởng đến tâm trạng

**d) Recommendations Card:**
- Title: "Gợi ý từ Tâm An"
- Danh sách các khuyến nghị dựa trên phân tích
- Icon suggestion với action button

**Logic AI Analysis:**
```
1. Thu thập dữ liệu:
   - Tất cả check-in của user (tối thiểu 7 ngày)
   - Emotion tags
   - Context (location, activity, people, time)

2. Phân tích tương quan:
   FOR EACH context_type (location, activity, people, time):
     - Đếm số lần xuất hiện của mỗi giá trị
     - Tính % cảm xúc tích cực/tiêu cực khi có context đó
     - Tính độ tin cậy = (số sample / tổng check-in) * 100
     
3. Xác định patterns:
   - Context nào có % cảm xúc tiêu cực cao nhất?
   - Context nào có % cảm xúc tích cực cao nhất?
   - Có pattern về thời gian không? (ngày nào, giờ nào)

4. Tạo recommendations:
   IF negative_context found:
     - Suggest: Tránh hoặc thay đổi context
     - Suggest: Kỹ thuật coping
   IF positive_context found:
     - Suggest: Tăng cường context này

5. Format output với reliability score
```

**Reliability Calculation:**
```
reliability = (số lần xuất hiện context / tổng check-in) * 100

IF reliability >= 80:
  color = Green (#00A63E)
  text = "Rất tin cậy"
ELSE IF reliability >= 60:
  color = Orange (#D08700)
  text = "Tin cậy vừa phải"
ELSE:
  color = Red
  text = "Cần thêm dữ liệu"
```

#### 8.3.5. Chức năng Nhật ký Vi mô (Micro-Journal)

##### 8.3.5.1. Màn hình Nhật ký
**File:** `lib/screens/user/journal_screen.dart`

**Mô tả:**
- Hiển thị lịch sử tất cả check-in
- Filter theo ngày
- Xem chi tiết từng check-in

**UI Components:**

**a) Header:**
- Title: "Nhật ký Cảm xúc"
- Subtitle: "Lịch sử check-in của bạn"

**b) Date Filter:**
- Horizontal scrollable chips
- Chip đầu tiên: "Tất cả"
- Các chip khác: Ngày cụ thể (format: "DD/MM/YYYY")
- Selected chip có background gradient

**c) Stats Card:**
- Hiển thị thống kê ngắn gọn của filter hiện tại
- Total check-ins
- Dominant emotion
- Average mood score (nếu có)

**d) Check-in List:**
- Hiển thị dạng timeline
- Mỗi item bao gồm:
  - Thời gian: Format "HH:mm - DD Tháng MM"
  - Icon cảm xúc
  - Tên cảm xúc với màu tương ứng
  - Location tag (nếu có): "📍 [Địa điểm]"
  - Activity tag (nếu có): "⚡ [Hoạt động]"
  - People tag (nếu có): "👥 [Người]"
  - Note preview (nếu có): Hiển thị 2 dòng đầu, "... đọc thêm"
  - Border màu theo cảm xúc

**e) Empty State:**
- Icon: 📝
- Text: "Chưa có check-in nào"
- CTA: Button "Check-in ngay"

**Interaction:**
```
1. User chọn date filter
   → Filter list và update stats card

2. User tap vào check-in item
   → Hiển thị bottom sheet với full details:
      - Emotion
      - Timestamp
      - Location
      - Activity  
      - People
      - Full note
      - Actions: Edit, Delete

3. User tap "Check-in ngay"
   → Navigate to StressReliefScreen
```

#### 8.3.6. Chức năng Cài đặt & Khác

##### 8.3.6.1. Màn hình More
**File:** `lib/screens/user/more_screen.dart`

**Mô tả:**
- Trung tâm điều khiển và cài đặt
- Thông tin người dùng
- Truy cập các tính năng bổ sung

**UI Components:**

**a) Section Title:**
- Title: "Khám phá thêm"
- Subtitle: "Truy cập các tính năng và cài đặt"

**b) User Profile Card:**
- Avatar placeholder (circle với gradient)
- User icon
- Username: "demo"
- Role: "Người dùng"
- Tap để xem/edit profile

**c) Main Menu Items:**

**Nhóm 1: Dữ liệu & Nội dung**
- 📊 Báo cáo chi tiết
  - Subtitle: "Xem báo cáo tâm lý tổng hợp"
  - Arrow icon →
  
- 📖 Nhật ký
  - Subtitle: "Xem lại các check-in"
  - Arrow icon →
  
- 🎯 Mục tiêu
  - Subtitle: "Đặt mục tiêu cho bản thân"
  - Arrow icon →

**Nhóm 2: Công cụ & Hỗ trợ**
- 🧘 Bài tập thở
  - Subtitle: "Hướng dẫn kỹ thuật thở"
  - Arrow icon →
  
- 🎵 Âm thanh thiền
  - Subtitle: "Nhạc và âm thanh thư giãn"
  - Arrow icon →
  
- 💬 Trò chuyện với Tâm An
  - Subtitle: "AI chatbot hỗ trợ"
  - Arrow icon →

**d) Help Section:**
- Title: "Trợ giúp & Hỗ trợ"
- Menu items:
  - ❓ Hướng dẫn sử dụng
  - 📞 Liên hệ hỗ trợ
  - 🔒 Chính sách bảo mật
  - ⚙️ Cài đặt

**e) Footer:**
- Version info: "Phiên bản 1.0.0"
- Copyright text
- Logout button (màu đỏ)

**Widget:** `more_menu_item.dart`
- Reusable component cho menu item
- Props:
  - icon (IconData hoặc String emoji)
  - title (String)
  - subtitle (String?)
  - onTap (Function)
  - showArrow (bool, default: true)

---

## 9. MÔ HÌNH DỮ LIỆU

### 9.1. Model CheckIn

**File:** `lib/models/check_in.dart`

```dart
class CheckIn {
  String id;                // Unique identifier
  String userId;            // User ID
  String emotion;           // Tên cảm xúc
  DateTime timestamp;       // Thời gian check-in
  String? note;            // Ghi chú (optional)
  List<String>? tags;      // Tags (optional)
  String? location;        // Địa điểm (optional)
  String? activity;        // Hoạt động (optional)
  String? people;          // Người đi cùng (optional)
}
```

**Các phương thức:**
- `fromJson(Map<String, dynamic>)`: Parse từ JSON
- `toJson()`: Convert sang JSON
- `getEmotionStyle(String emotion)`: Lấy style (màu, icon) theo cảm xúc

**EmotionStyle Class:**
```dart
class EmotionStyle {
  String label;
  Color color;
  Color backgroundColor;
  Color borderColor;
}
```

**Ánh xạ cảm xúc → Style:**
| Cảm xúc | Màu chủ | Background | Border |
|---------|---------|------------|--------|
| Lo lắng | #9333EA (Purple) | #FAF5FF | #E9D5FF |
| Giận dữ | #FB2C36 (Red) | #FFF5F5 | #FFD6D6 |
| Căng thẳng | #FF6900 (Orange) | #FFFAF5 | #FFD6A7 |
| Vui vẻ/Hạnh phúc | #10B981 (Green) | #F0FDF4 | #BBF7D0 |
| Bình thường | #6366F1 (Indigo) | #F5F7FF | #DDD6FE |
| Buồn | #3B82F6 (Blue) | #F0F9FF | #BFDBFE |

### 9.2. Model User

**File:** `lib/models/user.dart` (đang phát triển)

```dart
class User {
  String id;
  String username;
  String role;              // "user" hoặc "admin"
  DateTime createdAt;
  // Thêm các fields khác khi phát triển
}
```

### 9.3. Cấu hình toàn cục

**File:** `lib/config/app_config.dart`

**Constants:**
```dart
class AppConfig {
  // API
  static const String apiBaseUrl = 'YOUR_API_URL_HERE';
  
  // Emotions
  static const List<String> emotions = [
    'Vui vẻ',
    'Bình thường', 
    'Buồn',
    'Căng thẳng',
    'Giận dữ',
  ];
  
  // Colors
  static const Color primaryColor = Color(0xFF9810FA);
  static const Color backgroundColor = Color(0xFFF5F3FF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color textPrimary = Color(0xFF030213);
  static const Color textSecondary = Color(0xFF4A5565);
  static const Color borderColor = Color(0x1A000000);
  
  // Emotion Colors Map
  static const Map<String, Color> emotionColors = {
    'Vui vẻ': Color(0xFF10B981),
    'Bình thường': Color(0xFF6366F1),
    'Buồn': Color(0xFF3B82F6),
    'Căng thẳng': Color(0xFFFF6900),
    'Giận dữ': Color(0xFFFB2C36),
  };
  
  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  
  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 14.0;
  static const double borderRadiusLarge = 20.0;
}
```

---

## 10. LUỒNG NGƯỜI DÙNG

### 10.1. Luồng chính - Happy Path

```
[Khởi động App]
     ↓
[AuthScreen: Login/Register]
     ↓ (Đăng nhập thành công)
[AppShell với Bottom Navigation]
     ↓
[Tab 1: Check-in] ← Mặc định
     ↓
[StressReliefScreen]
     ↓ (Chọn cảm xúc)
[CheckInDetailScreen]
     ↓ (Điền thông tin)
[Nhấn "Hoàn tất"]
     ↓
[CheckInSummaryScreen - Modal]
     ↓
[3 lựa chọn:]
  ├─ Xong → Quay về StressReliefScreen
  ├─ Xem thống kê → Tab 2: StatisticsScreen
  └─ Xem lịch sử → JournalScreen
```

### 10.2. Navigation Structure

```
AppShell (Bottom Navigation Bar - 4 tabs)
├─ Tab 0: Check-in (Home icon)
│   └─ StressReliefScreen
│       └─ CheckInDetailScreen
│           └─ CheckInSummaryScreen (Modal)
│
├─ Tab 1: Thống kê (Bar chart icon)
│   └─ StatisticsScreen
│
├─ Tab 2: Phân tích (Lightbulb icon)
│   └─ InsightsScreen
│
└─ Tab 3: Khác (Settings icon)
    └─ MoreScreen
        ├─ JournalScreen
        ├─ Settings
        ├─ Profile
        └─ Breathing Exercise
```

### 10.3. Luồng Check-in chi tiết

```
┌─────────────────────────────────────────────┐
│        StressReliefScreen (Bước 1/2)        │
│                                             │
│  1. Hiển thị greeting card                 │
│  2. Hiển thị số check-in trong ngày        │
│  3. Hiển thị 6 emotion options             │
│                                             │
│  User chọn emotion                         │
└──────────────────┬──────────────────────────┘
                   │ Navigate with param: emotion
                   ↓
┌─────────────────────────────────────────────┐
│       CheckInDetailScreen (Bước 2/2)        │
│                                             │
│  1. Hiển thị emotion đã chọn (có thể đổi)  ��
│  2. Section: Địa điểm (8 options)          │
│  3. Section: Hoạt động (8 options)         │
│  4. Section: Người đi cùng (6 options)     │
│  5. Section: Ghi chú (expandable)          │
│                                             │
│  User điền thông tin                       │
│  User nhấn "Hoàn tất"                      │
└──────────────────┬──────────────────────────┘
                   │ Validate & Save
                   │ Navigate with all data
                   ↓
┌─────────────────────────────────────────────┐
│        CheckInSummaryScreen (Modal)         │
│                                             │
│  1. Hiển thị tổng kết check-in hôm nay     │
│  2. Card: Cảm xúc vừa chọn                 │
│  3. Card: Lời khuyên từ AI                 │
│  4. Card: Gợi ý hành động                  │
│  5. Buttons: Xong / Xem thống kê / Xem lịch sử │
│                                             │
│  User chọn action                          │
└──────────────────┬──────────────────────────┘
                   │
       ┌───────────┼───────────┐
       ↓           ↓           ↓
    [Xong]   [Thống kê]   [Lịch sử]
       ↓           ↓           ↓
   Close    Statistics   Journal
   Modal       Screen     Screen
```

---

## 11. CÔNG NGHỆ SỬ DỤNG

### 11.1. Frontend Framework
- **Flutter:** ^3.9.2
- **Dart SDK:** ^3.9.2

### 11.2. Packages & Dependencies

#### 11.2.1. UI & Visualization
```yaml
fl_chart: ^0.69.0           # Biểu đồ và chart
cupertino_icons: ^1.0.8     # iOS-style icons
```

#### 11.2.2. State Management
```yaml
provider: ^6.1.2            # State management solution
```

#### 11.2.3. Utilities
```yaml
intl: ^0.19.0              # Internationalization, date formatting
```

### 11.3. Dev Dependencies
```yaml
flutter_test: sdk: flutter  # Testing framework
flutter_lints: ^5.0.0       # Linting rules
```

### 11.4. Assets
```yaml
assets:
  - assets/angry.png        # Sample emotion icon
```

### 11.5. Backend (Đang phát triển)
**Kế hoạch:**
- **Framework:** Java Spring Boot (REST API)
- **Database:** PostgreSQL hoặc MySQL
- **Authentication:** JWT
- **AI/ML:** Python (Flask/FastAPI) cho phân tích
- **Deployment:** Docker, Cloud (AWS/GCP)

**API Endpoints dự kiến:**
```
POST   /api/auth/register     # Đăng ký
POST   /api/auth/login        # Đăng nhập
GET    /api/user/profile      # Lấy thông tin user

POST   /api/checkin           # Tạo check-in mới
GET    /api/checkin           # Lấy danh sách check-in
GET    /api/checkin/:id       # Lấy chi tiết check-in
PUT    /api/checkin/:id       # Cập nhật check-in
DELETE /api/checkin/:id       # Xóa check-in

GET    /api/statistics        # Lấy thống kê
GET    /api/insights          # Lấy phân tích AI
POST   /api/insights/analyze  # Yêu cầu phân tích mới
```

### 11.6. Tools & Environment
- **IDE:** Android Studio / VS Code
- **Version Control:** Git
- **Build Tool:** Gradle (Android), Xcode (iOS)
- **Package Manager:** pub (Flutter)

---

## 12. THUẬT TOÁN PHÂN TÍCH AI - CHI TIẾT TRIỂN KHAI

### 12.1. Tổng quan về AI Engine

**Mục tiêu chính:** Tìm ra các **patterns (mô thức)** và **correlations (tương quan)** giữa cảm xúc và các yếu tố ngữ cảnh.

**Input Data:**
- Check-in records: emotion, location, activity, people, timestamp, note
- (Optional) Health data: sleep hours, steps, heart rate

**Output:**
- Correlation insights với reliability score
- Recommendations dựa trên patterns
- Trend predictions

### 12.2. Algorithm: Correlation Analysis

#### 12.2.1. Data Preparation
```
FUNCTION PrepareData(user_id, time_range):
    1. Fetch all check-ins của user trong time_range
    2. Filter out invalid records (missing emotion)
    3. Normalize emotion labels (Lo lắng = Anxious = Worried)
    4. Group emotions into categories:
       - Positive: [Hạnh phúc, Vui vẻ]
       - Neutral: [Bình thường]
       - Negative: [Lo lắng, Căng thẳng, Giận dữ, Buồn]
    5. RETURN clean_data[]
```

#### 12.2.2. Activity Correlation (🎯)
```
FUNCTION AnalyzeActivityCorrelation(clean_data):
    activity_emotion_map = {}  // Key: activity, Value: {positive_count, negative_count}
    
    FOR EACH check_in IN clean_data:
        IF check_in.activity EXISTS:
            activity = check_in.activity
            emotion_type = GetEmotionType(check_in.emotion)  // positive/negative/neutral
            
            IF activity NOT IN activity_emotion_map:
                activity_emotion_map[activity] = {positive: 0, negative: 0, total: 0}
            
            activity_emotion_map[activity].total += 1
            IF emotion_type == "negative":
                activity_emotion_map[activity].negative += 1
            ELSE IF emotion_type == "positive":
                activity_emotion_map[activity].positive += 1
    
    // Tìm activity có tỷ lệ negative cao nhất
    worst_activity = NULL
    max_negative_rate = 0
    
    FOR EACH activity IN activity_emotion_map:
        IF activity_emotion_map[activity].total >= 3:  // Minimum sample size
            negative_rate = activity_emotion_map[activity].negative / activity_emotion_map[activity].total
            reliability = (activity_emotion_map[activity].total / TOTAL_CHECKINS) * 100
            
            IF negative_rate > max_negative_rate AND reliability >= 50:
                max_negative_rate = negative_rate
                worst_activity = activity
    
    IF worst_activity EXISTS:
        percentage = ROUND(max_negative_rate * 100)
        reliability = ROUND((activity_emotion_map[worst_activity].total / TOTAL_CHECKINS) * 100)
        
        RETURN {
            type: "activity_correlation",
            activity: worst_activity,
            negative_percentage: percentage,
            reliability: reliability,
            insight: "Tâm An nhận thấy: {percentage}% các lần bạn check-in cảm xúc tiêu cực đều liên quan đến tag [{worst_activity}]. Có thể đây là một tác nhân gây căng thẳng cho bạn."
        }
    
    RETURN NULL
```

#### 12.2.3. People Correlation (👥)
```
FUNCTION AnalyzePeopleCorrelation(clean_data):
    people_emotion_map = {}  // Similar structure
    
    // Logic tương tự AnalyzeActivityCorrelation
    // Nhưng tìm cả:
    // 1. People làm bạn happy nhất (highest positive rate)
    // 2. People làm bạn stressed nhất (highest negative rate)
    
    RETURN {
        happiest_with: {person, positive_rate, reliability},
        stressed_with: {person, negative_rate, reliability},
        insight: "Bạn có vẻ {emotion} hơn khi check-in với [{person}] (tỷ lệ {rate}%)..."
    }
```

#### 12.2.4. Time Correlation (⏰)
```
FUNCTION AnalyzeTimeCorrelation(clean_data):
    // Phân tích theo 2 dimensions:
    // 1. Day of week (Thứ 2, 3, 4, 5, 6, 7, CN)
    // 2. Hour of day (0-23)
    
    day_emotion_map = {}  // Key: day_of_week
    hour_emotion_map = {}  // Key: hour
    
    FOR EACH check_in IN clean_data:
        day = GetDayOfWeek(check_in.timestamp)  // 0=Monday, 6=Sunday
        hour = GetHour(check_in.timestamp)
        emotion_type = GetEmotionType(check_in.emotion)
        
        // Update day_emotion_map
        IF day NOT IN day_emotion_map:
            day_emotion_map[day] = {positive: 0, negative: 0, total: 0}
        day_emotion_map[day].total += 1
        IF emotion_type == "negative":
            day_emotion_map[day].negative += 1
        
        // Update hour_emotion_map (similar)
        ...
    
    // Tìm ngày/giờ có negative rate cao nhất
    worst_day = FindWorstDay(day_emotion_map)
    worst_hour = FindWorstHour(hour_emotion_map)
    
    RETURN {
        worst_day: {day_name: "Chủ Nhật", negative_rate: 80%, reliability: 100%},
        worst_hour: {hour: 16, negative_rate: 75%, reliability: 85%},
        insight: "Mức độ 'Lo lắng' của bạn có xu hướng tăng cao vào tối Chủ Nhật. Bạn thường cảm thấy 'Căng thẳng' vào lúc 4 giờ chiều."
    }
```

#### 12.2.5. Location Correlation (📍)
```
FUNCTION AnalyzeLocationCorrelation(clean_data):
    // Logic tương tự AnalyzeActivityCorrelation
    // Tìm location có negative rate cao nhất
    
    RETURN {
        worst_location: {location, negative_rate, reliability},
        insight: "{percentage}% các lần check-in tiêu cực của bạn xảy ra tại [{location}]..."
    }
```

### 12.3. Reliability Score Calculation

```
FUNCTION CalculateReliability(sample_count, total_count):
    // Công thức: (số lần xuất hiện / tổng check-ins) * 100
    raw_reliability = (sample_count / total_count) * 100
    
    // Điều chỉnh dựa trên sample size
    IF sample_count < 3:
        RETURN 0  // Không đủ dữ liệu
    ELSE IF sample_count < 5:
        raw_reliability *= 0.8  // Giảm 20%
    ELSE IF sample_count < 10:
        raw_reliability *= 0.9  // Giảm 10%
    
    RETURN ROUND(raw_reliability)

FUNCTION GetReliabilityColor(reliability):
    IF reliability >= 80:
        RETURN {color: GREEN, text: "Rất tin cậy", emoji: "✅"}
    ELSE IF reliability >= 60:
        RETURN {color: ORANGE, text: "Tin cậy vừa phải", emoji: "⚠️"}
    ELSE:
        RETURN {color: RED, text: "Cần thêm dữ liệu", emoji: "📊"}
```

### 12.4. Recommendation Engine

```
FUNCTION GenerateRecommendations(correlations):
    recommendations = []
    
    // Based on activity correlation
    IF correlations.activity.negative_rate > 70:
        recommendations.add({
            title: "Giảm thiểu hoạt động gây stress",
            content: "Bạn có thể thử giảm tần suất [{activity}] hoặc tìm cách làm cho nó ít căng thẳng hơn.",
            action: "Thử kỹ thuật thở 4-7-8 trước khi [{activity}]",
            icon: "🎯"
        })
    
    // Based on people correlation
    IF correlations.people.stressed_with EXISTS:
        recommendations.add({
            title: "Quản lý mối quan hệ",
            content: "Hạn chế tương tác không cần thiết với [{person}] hoặc chuẩn bị tâm lý tốt hơn trước khi gặp.",
            icon: "👥"
        })
    
    // Based on time correlation
    IF correlations.time.worst_day EXISTS:
        recommendations.add({
            title: "Chuẩn bị cho ngày khó khăn",
            content: "Vào [{day}], hãy đảm bảo bạn ngủ đủ giấc đêm trước và dành thời gian cho bản thân.",
            icon: "⏰"
        })
    
    // Based on location correlation
    IF correlations.location.worst_location EXISTS:
        recommendations.add({
            title: "Cải thiện môi trường",
            content: "Thử thay đổi không gian làm việc tại [{location}] hoặc nghỉ giải lao thường xuyên hơn.",
            icon: "📍"
        })
    
    RETURN recommendations
```

### 12.5. Integration với Health Data (Future)

```
FUNCTION AnalyzeSleepCorrelation(clean_data, health_data):
    sleep_emotion_map = {}  // Key: sleep_hours_range, Value: emotion_counts
    
    FOR EACH check_in IN clean_data:
        date = GetDate(check_in.timestamp)
        sleep_hours = GetSleepHours(health_data, date - 1)  // Ngủ đêm trước
        
        IF sleep_hours EXISTS:
            sleep_range = GetSleepRange(sleep_hours)  // <6h, 6-7h, 7-8h, >8h
            emotion_type = GetEmotionType(check_in.emotion)
            
            IF sleep_range NOT IN sleep_emotion_map:
                sleep_emotion_map[sleep_range] = {positive: 0, negative: 0, total: 0}
            
            sleep_emotion_map[sleep_range].total += 1
            IF emotion_type == "negative":
                sleep_emotion_map[sleep_range].negative += 1
    
    // So sánh negative rate giữa các sleep ranges
    IF sleep_emotion_map["<6h"].negative_rate > sleep_emotion_map["7-8h"].negative_rate * 1.5:
        RETURN {
            insight: "Những ngày bạn ngủ ít hơn 6 tiếng, số lần check-in 'Giận dữ' của bạn tăng gấp {ratio} lần.",
            recommendation: "Ưu tiên ngủ đủ 7-8 tiếng mỗi đêm."
        }
    
    RETURN NULL
```

### 12.6. Caching & Performance

**Để tối ưu hiệu năng:**
1. **Cache insights:** Lưu kết quả phân tích, chỉ re-calculate khi có check-in mới
2. **Incremental update:** Không analyze toàn bộ data mỗi lần, chỉ update delta
3. **Background processing:** Chạy AI analysis trong background thread
4. **Progressive insights:** Hiển thị insights sớm nhất có thể, không đợi full analysis

```
FUNCTION GetInsights(user_id):
    cached_insights = GetFromCache(user_id)
    last_checkin = GetLastCheckIn(user_id)
    
    IF cached_insights.last_updated >= last_checkin.timestamp:
        RETURN cached_insights  // Use cache
    
    // Need to update
    new_data = GetCheckInsSince(user_id, cached_insights.last_updated)
    updated_insights = IncrementalAnalysis(cached_insights, new_data)
    
    SaveToCache(user_id, updated_insights)
    RETURN updated_insights
```

---

## PHỤ LỤC

### A. Glossary (Thuật ngữ)
- **Check-in:** Hành động ghi nhận cảm xúc tại một thời điểm (chỉ mất 5-10 giây)
- **Emotion:** Trạng thái cảm xúc (7 loại: Hạnh phúc, Vui vẻ, Bình thường, Buồn, Lo lắng, Căng thẳng, Giận dữ)
- **Tags (Tác nhân):** Nhãn ngữ cảnh (Location, Activity, People) - **Tính năng cốt lõi**
- **Context:** Ngữ cảnh xung quanh check-in (địa điểm, hoạt động, người, thời gian)
- **Pattern (Mô thức):** Xu hướng lặp lại trong dữ liệu cảm xúc
- **Correlation (Tương quan):** Mối liên hệ giữa cảm xúc và các yếu tố ngữ cảnh
- **Insight:** Phân tích, nhận định từ AI - **"Ma thuật" của ứng dụng**
- **Reliability Score:** Độ tin cậy của phân tích (%), dựa trên sample size
- **Streak:** Chuỗi ngày liên tiếp có check-in
- **Low-friction:** Thiết kế không ma sát, dễ dàng sử dụng
- **High-insight:** Cung cấp phân tích sâu sắc, có giá trị cao
- **Micro-Journal:** Nhật ký vi mô, chỉ ghi chú ngắn gọn

### B. Key Metrics (Chỉ số quan trọng)

#### B.1. User Engagement Metrics
- **Check-in Frequency:** Số lần check-in/ngày (Target: 2-3 lần)
- **Check-in Duration:** Thời gian hoàn thành 1 check-in (Target: < 10 giây)
- **Streak Days:** Số ngày liên tiếp check-in (Target: > 7 ngày)
- **Tag Usage Rate:** % check-in có đầy đủ tags (Target: > 80%)

#### B.2. AI Quality Metrics
- **Correlation Accuracy:** Độ chính xác của phân tích (cần A/B testing)
- **Insight Usefulness:** % users thấy insights hữu ích (Target: > 70%)
- **Minimum Data Requirement:** Tối thiểu 21 check-ins (7 ngày × 3/ngày)

#### B.3. Product Success Metrics
- **DAU (Daily Active Users):** Số user active mỗi ngày
- **Retention Rate:** % users quay lại sau 7 ngày, 30 ngày
- **NPS (Net Promoter Score):** Mức độ recommend cho người khác

### C. Tính năng dự kiến theo Priority

#### C.1. Must-Have (Phase 1-2) ⭐⭐⭐
1. **FR1.4: Push Notification** - Lời nhắc ngẫu nhiên 3 lần/ngày
2. **Backend REST API** - Java Spring Boot với PostgreSQL
3. **JWT Authentication** - Bảo mật thực sự
4. **NFR3.1: Custom Tags** - Cho phép user tự thêm tags
5. **Offline Mode** - Lưu local, sync khi có mạng

#### C.2. Should-Have (Phase 3) ⭐⭐
6. **Real AI Analysis** - Python ML service với correlation algorithms
7. **FR2.3: Health Data Integration** - Google Fit / Apple Health
8. **Export Data** - Xuất ra PDF/CSV
9. **Breathing Exercise** - Bài tập thở có hướng dẫn (4-7-8, Box Breathing)
10. **Home Screen Widget** - Quick check-in không cần mở app

#### C.3. Nice-to-Have (Phase 4-5) ⭐
11. **AI Chatbot** - Chat với Tâm An để được tư vấn
12. **Meditation Audio** - Âm thanh thiền, nhạc thư giãn
13. **Goal Setting** - Đặt mục tiêu cải thiện tâm lý
14. **Social Features** - Chia sẻ insights (anonymously)
15. **Therapist Connect** - Kết nối với chuyên gia tâm lý

### D. Known Issues & Limitations

#### D.1. Current Limitations
1. **Backend chưa hoàn thiện:** Hiện tại dùng mock data
2. **AI analysis chưa thực:** Logic phân tích đang hard-coded, chưa có ML model
3. **Offline mode:** Chưa hỗ trợ đầy đủ (chưa có local database)
4. **Authentication:** Chưa có xác thực thực sự (dùng demo account)
5. **Push notifications:** Chưa implement
6. **Custom tags:** Chưa cho phép user tự thêm
7. **Data export:** Chưa có tính năng export

#### D.2. Technical Debt
1. **Hard-coded insights:** Cần migrate sang AI model thực
2. **No unit tests:** Cần viết tests cho critical functions
3. **No error handling:** Cần graceful error messages
4. **Performance:** Chưa optimize cho large datasets

#### D.3. UX Improvements Needed
1. **Onboarding:** Cần tutorial cho lần đầu sử dụng
2. **Empty states:** Cải thiện UI khi chưa có dữ liệu
3. **Loading states:** Thêm skeleton screens
4. **Accessibility:** Cải thiện support cho screen readers

### E. Migration Path (Lộ trình phát triển)

#### **Phase 1: MVP - UI/UX Foundation ✅ (HOÀN THÀNH)**
**Timeline:** Đã hoàn thành  
**Status:** ✅ Done

- ✅ UI/UX cho tất cả màn hình chính
- ✅ Check-in flow hoàn chỉnh (3 bước)
- ✅ Thống kê với mock data (charts, filters)
- ✅ Phân tích AI với mock data (4 correlation cards)
- ✅ Navigation structure (4 tabs)
- ✅ Custom widgets (AppBar, BottomNav, etc.)

**Deliverables:**
- Prototype có thể demo
- Design system hoàn chỉnh
- Core navigation flow

---

#### **Phase 2: Backend Integration 🚧 (ĐANG THỰC HIỆN)**
**Timeline:** 2-3 tuần  
**Priority:** ⭐⭐⭐ Must-Have

**Tasks:**
- [ ] Setup Java Spring Boot project
  - [ ] Project structure
  - [ ] Dependencies (Spring Security, JPA, etc.)
  - [ ] Application properties
  
- [ ] Database Design
  - [ ] PostgreSQL setup
  - [ ] Entity models (User, CheckIn, Tag, etc.)
  - [ ] Relationships & constraints
  - [ ] Migration scripts
  
- [ ] REST API Endpoints
  ```
  POST   /api/auth/register
  POST   /api/auth/login
  GET    /api/user/profile
  POST   /api/checkin
  GET    /api/checkin?from={date}&to={date}
  GET    /api/checkin/{id}
  PUT    /api/checkin/{id}
  DELETE /api/checkin/{id}
  GET    /api/statistics?range={7|30|all}
  GET    /api/insights
  ```
  
- [ ] Authentication & Security
  - [ ] JWT implementation
  - [ ] Password encryption (BCrypt)
  - [ ] HTTPS configuration
  - [ ] CORS setup
  
- [ ] Flutter Integration
  - [ ] API service layer
  - [ ] Error handling
  - [ ] Loading states
  - [ ] Token management
  
- [ ] Testing
  - [ ] Unit tests for API
  - [ ] Integration tests
  - [ ] Postman collection

**Deliverables:**
- Working backend API
- Database with sample data
- Flutter app connected to backend
- API documentation

---

#### **Phase 3: AI & Analytics 🤖 (KẾ HOẠCH)**
**Timeline:** 3-4 tuần  
**Priority:** ⭐⭐⭐ Must-Have

**Tasks:**
- [ ] Python ML Service Setup
  - [ ] Flask/FastAPI project
  - [ ] Connect to PostgreSQL
  - [ ] API endpoints for analysis
  
- [ ] Correlation Analysis Implementation
  - [ ] Activity correlation algorithm (FR2.2.1)
  - [ ] People correlation algorithm (FR2.2.2)
  - [ ] Time correlation algorithm (FR2.2.3)
  - [ ] Location correlation algorithm (FR2.2.4)
  - [ ] Reliability score calculation
  
- [ ] Recommendation Engine
  - [ ] Rule-based recommendations
  - [ ] Personalized suggestions
  - [ ] Action items generation
  
- [ ] Health Data Integration (FR2.3)
  - [ ] Google Fit API
  - [ ] Apple Health API
  - [ ] Sleep correlation analysis
  - [ ] Activity correlation with steps
  
- [ ] Optimize Performance
  - [ ] Caching insights
  - [ ] Incremental updates
  - [ ] Background processing
  
- [ ] Testing & Validation
  - [ ] Test với real user data
  - [ ] A/B testing framework
  - [ ] Measure insight accuracy

**Deliverables:**
- Real AI insights (not mock data)
- Health data integration working
- Performance optimized
- Validation report

---

#### **Phase 4: Essential Features 🔔 (KẾ HOẠCH)**
**Timeline:** 2-3 tuần  
**Priority:** ⭐⭐ Should-Have

**Tasks:**
- [ ] Push Notifications (FR1.4)
  - [ ] flutter_local_notifications setup
  - [ ] Random scheduling (3 times/day)
  - [ ] Deep linking to check-in screen
  - [ ] User preferences (enable/disable, frequency)
  
- [ ] Custom Tags (NFR3.1)
  - [ ] UI for adding custom tags
  - [ ] Backend support
  - [ ] Tag management (edit, delete)
  
- [ ] Offline Mode
  - [ ] Local database (Hive/SQLite)
  - [ ] Sync mechanism
  - [ ] Conflict resolution
  
- [ ] Data Export
  - [ ] Export to PDF
  - [ ] Export to CSV
  - [ ] Email/Share functionality
  
- [ ] Home Screen Widget
  - [ ] Android widget (Kotlin)
  - [ ] iOS widget (Swift)
  - [ ] Quick check-in action

**Deliverables:**
- Notifications working
- Custom tags feature
- Offline support complete
- Export functionality

---

#### **Phase 5: Advanced Features & Scale 🚀 (TƯƠNG LAI)**
**Timeline:** 4-6 tuần  
**Priority:** ⭐ Nice-to-Have

**Tasks:**
- [ ] Breathing Exercises
  - [ ] 4-7-8 technique with animation
  - [ ] Box breathing
  - [ ] Guided audio
  
- [ ] AI Chatbot
  - [ ] NLP integration
  - [ ] Context-aware responses
  - [ ] Integration with insights
  
- [ ] Meditation Audio Library
  - [ ] Audio streaming
  - [ ] Playlists
  - [ ] Favorites
  
- [ ] Social Features (Optional)
  - [ ] Anonymous sharing
  - [ ] Community insights
  - [ ] Support groups
  
- [ ] Professional Connect
  - [ ] Therapist directory
  - [ ] Appointment booking
  - [ ] Share insights with therapist

**Deliverables:**
- Complete feature set
- Production-ready app
- Marketing materials

---

#### **Phase 6: Optimization & Growth 📈 (TƯƠNG LAI)**
**Timeline:** Ongoing  
**Priority:** Continuous improvement

**Tasks:**
- [ ] Performance Optimization
  - [ ] Reduce app size
  - [ ] Optimize images
  - [ ] Lazy loading
  - [ ] Memory profiling
  
- [ ] Cloud Deployment
  - [ ] AWS/GCP setup
  - [ ] Load balancing
  - [ ] Auto-scaling
  - [ ] Monitoring (Sentry, Firebase Analytics)
  
- [ ] A/B Testing
  - [ ] Feature flags
  - [ ] Experiment framework
  - [ ] Analytics dashboard
  
- [ ] Localization
  - [ ] English translation
  - [ ] Other languages
  
- [ ] App Store Optimization
  - [ ] Keywords research
  - [ ] Screenshots
  - [ ] App description
  
- [ ] Marketing & Growth
  - [ ] Landing page
  - [ ] Social media
  - [ ] Content marketing
  - [ ] Partnerships

**Deliverables:**
- Scalable infrastructure
- Multi-language support
- Growing user base

---

## KẾT LUẬN

### Tổng kết

Tài liệu này mô tả chi tiết yêu cầu và đặc tả chức năng của ứng dụng **"Tâm An" (Mindful Load) - Trợ lý Nhận diện Tác nhân Gây Căng thẳng**. 

**Tầm nhìn cốt lõi:**
> "Tâm An" không phải là một app thiền bảo bạn "hít thở đi". Đây là một "thám tử" sức khỏe tinh thần, giúp bạn tìm ra **nguồn gốc thực sự** của căng thẳng thông qua dữ liệu khách quan.

### Triết lý thiết kế

**1. Low-Friction Check-in (5 giây) ⚡**
- Không rào cản, không rườm rà
- Tap 4-5 lần là xong
- Không áp lực phải viết dài

**2. High-Insight Analysis 🧠**
- AI tìm patterns mà bạn không nhận ra
- Insights cụ thể, có thể hành động
- Ví dụ: "86% các lần bạn căng thẳng đều liên quan đến [Họp]"

**3. Data-Driven Self-Awareness 📊**
- Không có dữ liệu, không thể cải thiện
- Dữ liệu khách quan > Cảm giác chung chung
- "Measure what matters"

### Điểm mạnh của giải pháp

✅ **Giải quyết đúng vấn đề:** Tìm nguyên nhân, không chỉ trị liệu triệu chứng  
✅ **UX xuất sắc:** Check-in nhanh, không ma sát  
✅ **AI thông minh:** Phân tích correlation thực tế, không phải lời khuyên chung chung  
✅ **Privacy-first:** Dữ liệu cảm xúc được bảo vệ tối đa  
✅ **Scalable architecture:** Dễ mở rộng, thêm tính năng  

### Những thách thức

⚠️ **User adoption:** Cần người dùng check-in thường xuyên  
→ *Giải pháp:* Push notifications, gamification (streaks), UX tốt

⚠️ **Data quality:** Phân tích phụ thuộc vào tính trung thực  
→ *Giải pháp:* Giáo dục user, tạo trust, không judgmental

⚠️ **AI accuracy:** Correlations có thể sai nếu sample size nhỏ  
→ *Giải pháp:* Reliability score, minimum data requirement, disclaimer

⚠️ **Cold start problem:** User mới chưa có insights  
→ *Giải pháp:* Onboarding tốt, explain value, show examples

### Roadmap Summary

| Phase | Timeline | Status | Key Deliverables |
|-------|----------|--------|------------------|
| **Phase 1: MVP** | ✅ Done | Complete | UI/UX, Check-in flow, Mock insights |
| **Phase 2: Backend** | 2-3 weeks | 🚧 Next | Java API, Database, Authentication |
| **Phase 3: AI** | 3-4 weeks | 📋 Planned | Real correlation analysis, Health data |
| **Phase 4: Features** | 2-3 weeks | 📋 Planned | Notifications, Custom tags, Export |
| **Phase 5: Advanced** | 4-6 weeks | 💡 Future | Chatbot, Breathing, Social |
| **Phase 6: Scale** | Ongoing | 💡 Future | Optimization, Growth, Marketing |

### Next Immediate Steps (Phase 2)

**Week 1-2: Backend Foundation**
1. [ ] Setup Java Spring Boot project structure
2. [ ] Design & create PostgreSQL database schema
3. [ ] Implement User & CheckIn entities
4. [ ] Create basic CRUD APIs

**Week 2-3: Integration**
5. [ ] Implement JWT authentication
6. [ ] Create Flutter API service layer
7. [ ] Connect app to backend
8. [ ] End-to-end testing

### Success Criteria

**Technical:**
- ✅ Backend API với < 200ms response time
- ✅ App không crash, error rate < 1%
- ✅ Hỗ trợ 10,000+ users concurrent

**Product:**
- 🎯 User check-in trung bình 2-3 lần/ngày
- 🎯 Retention rate 30 ngày > 40%
- 🎯 70% users thấy insights hữu ích
- 🎯 NPS score > 50

**Business:**
- 📈 100 active users trong tháng đầu
- 📈 1,000 active users trong 6 tháng
- 📈 4.5+ rating trên app stores

### Lời kết

**"Tâm An"** được xây dựng với niềm tin rằng:
- Mọi người xứng đáng hiểu rõ bản thân
- Dữ liệu có thể giúp chúng ta sống tốt hơn
- Technology có thể làm mental health accessible hơn

Ứng dụng này không chỉ là một công cụ, mà là một người bạn đồng hành giúp bạn "decode" cảm xúc của chính mình.

> *"The unexamined life is not worth living." - Socrates*

Với **Tâm An**, việc "examine" cuộc sống của bạn giờ đây chỉ mất **5 giây mỗi ngày**.

---

**Tài liệu được soạn bởi:** Team Tâm An  
**Ngày tạo:** 17 tháng 12, 2025  
**Phiên bản:** 1.0.0  
**Ngày cập nhật cuối:** 17 tháng 12, 2025  

**Liên hệ:**
- Email: [contact@taman.app]
- GitHub: [github.com/taman-app]
- Website: [taman.app] (coming soon)

---

## CHANGELOG

### Version 1.0.0 (17/12/2025)
- ✅ Initial document creation
- ✅ Complete requirements analysis
- ✅ Detailed functional specifications
- ✅ AI algorithm documentation
- ✅ Development roadmap
- ✅ Technical architecture

### Future Updates
- [ ] Add API documentation (Swagger)
- [ ] Add database schema diagrams
- [ ] Add user testing results
- [ ] Add performance benchmarks
- [ ] Add security audit report

---

**© 2025 Tâm An - Mindful Load. All rights reserved.**

