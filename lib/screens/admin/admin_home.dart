import 'package:flutter/material.dart';

class AdminDashboardBody extends StatefulWidget {
  const AdminDashboardBody({super.key});

  @override
  State<AdminDashboardBody> createState() => _AdminDashboardBodyState();
}

class _AdminDashboardBodyState extends State<AdminDashboardBody> {
  int _tabIndex = 0; // 0: Tổng quan, 1: Người dùng, 2: Tips

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ===== HEADER =====
          const _Header(),

          const SizedBox(height: 16),

          // ===== TAB FILTER =====
          _AdminTabs(
            index: _tabIndex,
            onChanged: (i) {
              setState(() {
                _tabIndex = i;
              });
            },
          ),

          const SizedBox(height: 16),

          // ===== BODY (CHỈ PHẦN NÀY ĐỔI) =====
          IndexedStack(
            index: _tabIndex,
            children: const [
              _OverviewTab(),
              _UsersTab(),
              _TipsTab(),
            ],
          ),
        ],
      ),
    );
  }
}

//
// ================= HEADER =================
//

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Quản trị hệ thống',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF980FFA),
          ),
        ),
        SizedBox(height: 4),
        Text(
          'Xin chào, admin',
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF495565),
          ),
        ),
      ],
    );
  }
}

//
// ================= TABS =================
//

class _AdminTabs extends StatelessWidget {
  final int index;
  final ValueChanged<int> onChanged;

  const _AdminTabs({
    required this.index,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFECECF0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Tổng quan',
            active: index == 0,
            onTap: () => onChanged(0),
          ),
          _TabItem(
            label: 'Người dùng',
            active: index == 1,
            onTap: () => onChanged(1),
          ),
          _TabItem(
            label: 'Tips sức khỏe',
            active: index == 2,
            onTap: () => onChanged(2),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: active ? null : onTap,
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ),
      ),
    );
  }
}

//
// ================= TAB CONTENT =================
//

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _StatCard(title: 'Tổng người dùng', value: '2'),
        SizedBox(height: 12),
        _StatCard(
          title: 'Người dùng hoạt động',
          value: '1',
          subtitle: '7 ngày qua',
        ),
        SizedBox(height: 12),
        _StatCard(title: 'Tổng Check-ins', value: '28'),
        SizedBox(height: 12),
        _StatCard(title: 'TB Check-ins/người', value: '14'),
        SizedBox(height: 16),
        _EmotionCard(),
      ],
    );
  }
}

class _UsersTab extends StatelessWidget {
  const _UsersTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 8),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TITLE
            const Text(
              'Quản lý người dùng',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 4),
            const Text(
              'Danh sách tất cả người dùng trong hệ thống',
              style: TextStyle(fontSize: 14, color: Color(0xFF717182)),
            ),
            const SizedBox(height: 20),

            // ⭐ CẢ BẢNG BỌC TRONG SCROLL NGANG
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                width: 650, // ⭐ KÍCH THƯỚC CHUẨN – KO BAO GIỜ OVERFLOW
                child: Column(
                  children: [
                    _tableHeader(),
                    _userRow(
                      username: "admin",
                      role: "Admin",
                      date: "17/12/2025",
                      active: true,
                      isUser: false,
                    ),
                    _userRow(
                      username: "demo",
                      role: "User",
                      date: "17/12/2025",
                      active: true,
                      isUser: true,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // HEADER CỘT
  Widget _tableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: const [
          _HeaderCell("Tên đăng nhập", width: 140),
          _HeaderCell("Vai trò", width: 120),
          _HeaderCell("Ngày tạo", width: 120),
          _HeaderCell("Trạng thái", width: 150),
          _HeaderCell("Hành động", width: 120),
        ],
      ),
    );
  }

  // USER ROW
  Widget _userRow({
    required String username,
    required String role,
    required String date,
    required bool active,
    required bool isUser,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black12)),
      ),
      child: Row(
        children: [
          _DataCell(username, width: 140),

          // ROLE CHIP
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUser ? const Color(0xFFECEEF2) : const Color(0xFF030213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    role,
                    style: TextStyle(
                      fontSize: 12,
                      color: isUser ? Colors.black : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _DataCell(date, width: 120),

          // STATUS CHIP
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0FDF4),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.black12),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.check_circle, size: 14, color: Colors.green),
                      SizedBox(width: 6),
                      Text("Hoạt động", style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ACTION
          SizedBox(
            width: 120,
            child: isUser
                ? Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black12),
                    ),
                    child: const Text("Vô hiệu hóa", textAlign: TextAlign.center),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}

// ====== COMPONENTS ======
class _HeaderCell extends StatelessWidget {
  final String text;
  final double width;

  const _HeaderCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: Color(0xFF323232),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final double width;

  const _DataCell(this.text, {required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: const TextStyle(fontSize: 14),
      ),
    );
  }
}




class _TipsTab extends StatelessWidget {
  const _TipsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ================== FORM TẠO TIP ==================
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.black12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Thêm Tips mới",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Tạo lời khuyên sức khỏe tinh thần cho người dùng",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF717182),
                  ),
                ),

                const SizedBox(height: 20),

                // ===== TIÊU ĐỀ =====
                const Text("Tiêu đề",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _input("VD: Kỹ thuật thư giãn cơ bắp"),

                const SizedBox(height: 20),

                // ===== NỘI DUNG =====
                const Text("Nội dung",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _input("Mô tả chi tiết...", maxLines: 3),

                const SizedBox(height: 20),

                // ===== DANH MỤC =====
                const Text("Danh mục",
                    style:
                        TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                _dropdown(),

                const SizedBox(height: 20),

                // ===== BUTTON: Thêm Tip =====
                Align(
                  alignment: Alignment.centerLeft,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding:
                          const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {},
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.add, color: Colors.white, size: 28),
                        SizedBox(width: 6),
                        Text("Thêm Tip",
                            style: TextStyle(color: Colors.white, fontSize: 15)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ================== DANH SÁCH TIPS ==================
          const Text(
            "Danh sách Tips (2)",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),

          _tipCard(
            title: "Kỹ thuật thở 4-7-8",
            tag: "stress",
            content:
                "Hít vào qua mũi trong 4 giây, giữ hơi trong 7 giây, thở ra qua miệng trong 8 giây. "
                "Lặp lại 4 lần để giảm căng thẳng ngay lập tức.",
          ),

          const SizedBox(height: 12),

          _tipCard(
            title: "Viết nhật ký cảm ơn",
            tag: "happiness",
            content:
                "Mỗi tối trước khi ngủ, hãy viết ra 3 điều bạn cảm thấy biết ơn. Điều này giúp bạn cảm thấy hạnh phúc và tích cực hơn.",
          ),
        ],
      ),
    );
  }

  // ==================== INPUT FIELD ====================
  Widget _input(String hint, {int maxLines = 1}) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFFF3F3F5),
        contentPadding: const EdgeInsets.all(12),
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  // ==================== DROPDOWN ====================
  Widget _dropdown() {
  return Container(
    width: double.infinity, // ⬅ làm FULL WIDTH
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: const Color(0xFFF3F3F5),
      borderRadius: BorderRadius.circular(10),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        isExpanded: true, // ⬅ đảm bảo dropdown chiếm hết chiều rộng
        value: "Chung",
        items: const [
          DropdownMenuItem(value: "Chung", child: Text("Chung")),
          DropdownMenuItem(value: "stress", child: Text("Stress")),
          DropdownMenuItem(value: "happiness", child: Text("Happiness")),
          DropdownMenuItem(value: "anxiety", child: Text("Anxiety")),
        ],
        onChanged: (v) {},
      ),
    ),
  );
}


  // ================= TIP CARD =================
  Widget _tipCard({
    required String title,
    required String tag,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề + tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w600)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(tag,
                    style:
                        const TextStyle(fontSize: 12, color: Color(0xFF495565))),
              )
            ],
          ),

          const SizedBox(height: 8),

          Text(
            content,
            style: const TextStyle(fontSize: 14),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _actionButton("Ẩn", Icons.visibility_off),
              const SizedBox(width: 12),
              _actionButton("Xóa", Icons.delete),
            ],
          )
        ],
      ),
    );
  }

  // ================= ACTION BUTTON =================
  Widget _actionButton(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black26),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label),
        ],
      ),
    );
  }
}



//
// ================= CARDS (GIỮ NGUYÊN) =================
//

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 14)),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF495565),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmotionCard extends StatelessWidget {
  const _EmotionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text('Cảm xúc phổ biến nhất', style: TextStyle(fontSize: 16)),
          SizedBox(height: 8),
          Text(
            'Cảm xúc được ghi nhận nhiều nhất trong hệ thống',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Color(0xFF717182)),
          ),
          SizedBox(height: 16),
          Text('😫', style: TextStyle(fontSize: 36)),
          SizedBox(height: 8),
          Text('Căng thẳng', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
