import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../providers/theme_provider.dart';

class AdminDashboardBody extends StatefulWidget {
  const AdminDashboardBody({super.key});

  @override
  State<AdminDashboardBody> createState() => _AdminDashboardBodyState();
}

class _AdminDashboardBodyState extends State<AdminDashboardBody> {
  int _tabIndex = 0; // 0: Tổng quan, 1: Người dùng, 2: Tips

  // Stats data
  Map<String, dynamic> _stats = {};
  List<dynamic> _users = [];
  List<dynamic> _tips = [];
  bool _isLoading = true;
  String? _error;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      // Load stats, users and tips in parallel
      final results = await Future.wait([
        _apiService.getAdminStats(),
        _apiService.getAllUsers(),
        _apiService.getAllTipsAdmin(),
      ]);

      setState(() {
        _stats = results[0] as Map<String, dynamic>;
        _users = results[1] as List<dynamic>;
        _tips = results[2] as List<dynamic>;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = context.watch<ThemeProvider>().isDarkMode;

    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFF980FFA)),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _loadData,
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    return Container(
      color: isDarkMode ? const Color(0xFF121218) : const Color(0xFFF8F3FF),
      child: RefreshIndicator(
        onRefresh: _loadData,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
          children: [
            // ===== HEADER =====
            _Header(isDarkMode: isDarkMode),

            const SizedBox(height: 16),

            // ===== TAB FILTER =====
            _AdminTabs(
              index: _tabIndex,
              onChanged: (i) {
                setState(() {
                  _tabIndex = i;
                });
              },
              isDarkMode: isDarkMode,
            ),

            const SizedBox(height: 16),

            // ===== BODY (HIỂN THỊ TAB TƯƠNG ỨNG) =====
            if (_tabIndex == 0)
              _OverviewTab(stats: _stats, isDarkMode: isDarkMode)
            else if (_tabIndex == 1)
              _UsersTab(users: _users, onRefresh: _loadData, isDarkMode: isDarkMode)
            else
              _TipsTab(tips: _tips, onRefresh: _loadData, isDarkMode: isDarkMode),
          ],
        ),
      ),
    );
  }
}

//
// ================= HEADER =================
//

class _Header extends StatelessWidget {
  final bool isDarkMode;
  const _Header({required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quản trị hệ thống',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Color(0xFF980FFA),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Xin chào, admin',
          style: TextStyle(
            fontSize: 16,
            color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF495565),
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
  final bool isDarkMode;

  const _AdminTabs({
    required this.index,
    required this.onChanged,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFECECF0),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          _TabItem(
            label: 'Tổng quan',
            active: index == 0,
            onTap: () => onChanged(0),
            isDarkMode: isDarkMode,
          ),
          _TabItem(
            label: 'Người dùng',
            active: index == 1,
            onTap: () => onChanged(1),
            isDarkMode: isDarkMode,
          ),
          _TabItem(
            label: 'Tips sức khỏe',
            active: index == 2,
            onTap: () => onChanged(2),
            isDarkMode: isDarkMode,
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
  final bool isDarkMode;

  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
    required this.isDarkMode,
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
            color: active
                ? (isDarkMode ? const Color(0xFF1E1E2E) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: isDarkMode ? Colors.white : Colors.black,
              ),
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
  final Map<String, dynamic> stats;
  final bool isDarkMode;

  const _OverviewTab({required this.stats, required this.isDarkMode});

  String _getEmotionEmoji(String? emotion) {
    switch (emotion?.toUpperCase()) {
      case 'HAPPY': return '😆';
      case 'JOY': return '😊';
      case 'NEUTRAL': return '😐';
      case 'SAD': return '🌧️';
      case 'WORRIED': return '😟';
      case 'STRESSED': return '😫';
      case 'ANGRY': return '😡';
      default: return '😐';
    }
  }

  String _getEmotionText(String? emotion) {
    switch (emotion?.toUpperCase()) {
      case 'HAPPY': return 'Hạnh phúc';
      case 'JOY': return 'Vui vẻ';
      case 'NEUTRAL': return 'Bình thường';
      case 'SAD': return 'Buồn';
      case 'WORRIED': return 'Lo lắng';
      case 'STRESSED': return 'Căng thẳng';
      case 'ANGRY': return 'Giận dữ';
      default: return 'Chưa có dữ liệu';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Debug log để kiểm tra data
    print('DEBUG _OverviewTab stats: $stats');

    final totalUsers = stats['totalUsers'] ?? 0;
    final activeUsers = stats['activeUsers'] ?? 0;
    // Lấy totalCheckins với cả 2 trường hợp key
    final totalCheckins = stats['totalCheckins'] ?? stats['totalCheckIns'] ?? 0;

    print('DEBUG _OverviewTab: totalUsers=$totalUsers, activeUsers=$activeUsers, totalCheckins=$totalCheckins');

    final avgCheckins = totalUsers > 0 ? (totalCheckins / totalUsers).toStringAsFixed(1) : '0.0';

    // Tìm cảm xúc phổ biến nhất (có thể từ emotionDistribution nếu backend trả về)
    String? mostCommonEmotion = stats['mostCommonEmotion'];

    return Column(
      children: [
        _StatCard(title: 'Tổng người dùng', value: '$totalUsers', isDarkMode: isDarkMode),
        const SizedBox(height: 12),
        _StatCard(
          title: 'Người dùng hoạt động',
          value: '$activeUsers',
          subtitle: '7 ngày qua',
          isDarkMode: isDarkMode,
        ),
        const SizedBox(height: 12),
        _StatCard(title: 'Tổng Check-ins', value: '$totalCheckins', isDarkMode: isDarkMode),
        const SizedBox(height: 12),
        _StatCard(title: 'TB Check-ins/người', value: avgCheckins, isDarkMode: isDarkMode),
        const SizedBox(height: 16),
        _EmotionCardDynamic(
          emoji: _getEmotionEmoji(mostCommonEmotion),
          emotionText: _getEmotionText(mostCommonEmotion),
          isDarkMode: isDarkMode,
        ),
      ],
    );
  }
}

class _UsersTab extends StatelessWidget {
  final List<dynamic> users;
  final VoidCallback onRefresh;
  final bool isDarkMode;

  const _UsersTab({required this.users, required this.onRefresh, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE
          Text(
            'Quản lý người dùng',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Danh sách tất cả người dùng trong hệ thống (${users.length})',
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF717182),
            ),
          ),
          const SizedBox(height: 20),

          // ⭐ CẢ BẢNG BỌC TRONG SCROLL NGANG
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 650, // ⭐ KÍCH THƯỚC CHUẨN – KO BAO GIỜ OVERFLOW
              child: Column(
                children: [
                  _tableHeader(isDarkMode),
                  ...users.map((user) => _UserRowWidget(
                    user: user,
                    onRefresh: onRefresh,
                    isDarkMode: isDarkMode,
                  )).toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // HEADER CỘT
  Widget _tableHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12)),
      ),
      child: Row(
        children: [
          _HeaderCell("Tên đăng nhập", width: 140, isDarkMode: isDarkMode),
          _HeaderCell("Vai trò", width: 120, isDarkMode: isDarkMode),
          _HeaderCell("Ngày tạo", width: 120, isDarkMode: isDarkMode),
          _HeaderCell("Trạng thái", width: 150, isDarkMode: isDarkMode),
          _HeaderCell("Hành động", width: 120, isDarkMode: isDarkMode),
        ],
      ),
    );
  }
}

class _UserRowWidget extends StatefulWidget {
  final Map<String, dynamic> user;
  final VoidCallback onRefresh;
  final bool isDarkMode;

  const _UserRowWidget({required this.user, required this.onRefresh, required this.isDarkMode});

  @override
  State<_UserRowWidget> createState() => _UserRowWidgetState();
}

class _UserRowWidgetState extends State<_UserRowWidget> {
  bool _isLoading = false;
  final ApiService _apiService = ApiService();

  String _formatDate(String? dateStr) {
    if (dateStr == null) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _toggleUserStatus() async {
    final userId = widget.user['id'];
    if (userId == null) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.toggleUserStatus(userId);
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã cập nhật trạng thái người dùng'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.user['username'] ?? '';
    final role = widget.user['role'] ?? 'USER';
    final isActive = widget.user['isActive'] ?? true;
    final createdAt = widget.user['createdAt']?.toString();
    final isUser = role != 'ADMIN';
    final isDarkMode = widget.isDarkMode;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12)),
      ),
      child: Row(
        children: [
          _DataCell(username, width: 140, isDarkMode: isDarkMode),

          // ROLE CHIP
          SizedBox(
            width: 120,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isUser
                        ? (isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFECEEF2))
                        : const Color(0xFF030213),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    role == 'ADMIN' ? 'Admin' : 'User',
                    style: TextStyle(
                      fontSize: 12,
                      color: isUser ? (isDarkMode ? Colors.white : Colors.black) : Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          _DataCell(_formatDate(createdAt), width: 120, isDarkMode: isDarkMode),

          // STATUS CHIP
          SizedBox(
            width: 150,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: isActive
                        ? (isDarkMode ? const Color(0xFF1A3D2A) : const Color(0xFFF0FDF4))
                        : (isDarkMode ? const Color(0xFF3D1A1A) : const Color(0xFFFEF2F2)),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDarkMode ? Colors.transparent : Colors.black12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isActive ? Icons.check_circle : Icons.cancel,
                        size: 14,
                        color: isActive ? Colors.green : Colors.red,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        isActive ? "Hoạt động" : "Vô hiệu",
                        style: TextStyle(
                          fontSize: 12,
                          color: isDarkMode ? Colors.white : Colors.black,
                        ),
                      ),
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
                ? _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : InkWell(
                        onTap: _toggleUserStatus,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
                            color: isActive
                                ? (isDarkMode ? const Color(0xFF3D1A1A) : const Color(0xFFFEF2F2))
                                : (isDarkMode ? const Color(0xFF1A3D2A) : const Color(0xFFF0FDF4)),
                          ),
                          child: Text(
                            isActive ? "Vô hiệu hóa" : "Kích hoạt",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: isActive ? Colors.red : Colors.green,
                            ),
                          ),
                        ),
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
  final bool isDarkMode;

  const _HeaderCell(this.text, {required this.width, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 14,
          color: isDarkMode ? Colors.white : const Color(0xFF323232),
        ),
      ),
    );
  }
}

class _DataCell extends StatelessWidget {
  final String text;
  final double width;
  final bool isDarkMode;

  const _DataCell(this.text, {required this.width, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.black,
        ),
      ),
    );
  }
}




class _TipsTab extends StatefulWidget {
  final List<dynamic> tips;
  final VoidCallback onRefresh;
  final bool isDarkMode;

  const _TipsTab({required this.tips, required this.onRefresh, required this.isDarkMode});

  @override
  State<_TipsTab> createState() => _TipsTabState();
}

class _TipsTabState extends State<_TipsTab> {
  final ApiService _apiService = ApiService();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedCategory = 'GENERAL';
  bool _isCreating = false;

  final Map<String, String> _categoryMap = {
    'GENERAL': 'Chung',
    'STRESS': 'Stress',
    'HAPPINESS': 'Happiness',
    'ANXIETY': 'Anxiety',
  };

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _createTip() async {
    if (_titleController.text.isEmpty || _contentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Vui lòng nhập đầy đủ tiêu đề và nội dung'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isCreating = true);

    try {
      await _apiService.createTip(
        title: _titleController.text,
        content: _contentController.text,
        category: _selectedCategory,
      );
      _titleController.clear();
      _contentController.clear();
      setState(() => _selectedCategory = 'GENERAL');
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã thêm tip mới thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isCreating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = widget.isDarkMode;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ================== FORM TẠO TIP ==================
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Thêm Tips mới",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Tạo lời khuyên sức khỏe tinh thần cho người dùng",
                style: TextStyle(
                  fontSize: 16,
                  color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF717182),
                ),
              ),

              const SizedBox(height: 20),

              // ===== TIÊU ĐỀ =====
              Text("Tiêu đề",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  )),
              const SizedBox(height: 8),
              TextField(
                controller: _titleController,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFF3F3F5),
                  contentPadding: const EdgeInsets.all(12),
                  hintText: "VD: Kỹ thuật thư giãn cơ bắp",
                  hintStyle: TextStyle(
                    color: isDarkMode ? const Color(0xFF6B7280) : null,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== NỘI DUNG =====
              Text("Nội dung",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  )),
              const SizedBox(height: 8),
              TextField(
                controller: _contentController,
                maxLines: 3,
                style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFF3F3F5),
                  contentPadding: const EdgeInsets.all(12),
                  hintText: "Mô tả chi tiết...",
                  hintStyle: TextStyle(
                    color: isDarkMode ? const Color(0xFF6B7280) : null,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== DANH MỤC =====
              Text("Danh mục",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  )),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFF3F3F5),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    isExpanded: true,
                    value: _selectedCategory,
                    dropdownColor: isDarkMode ? const Color(0xFF2E2E3E) : Colors.white,
                    style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                    items: _categoryMap.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.key,
                        child: Text(entry.value),
                      );
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedCategory = v);
                    },
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ===== BUTTON: Thêm Tip =====
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDarkMode ? const Color(0xFF8B5CF6) : Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _isCreating ? null : _createTip,
                  child: _isCreating
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Row(
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
        Text(
          "Danh sách Tips (${widget.tips.length})",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
        const SizedBox(height: 12),

        ...widget.tips.map((tip) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _TipCardWidget(
            tip: tip,
            onRefresh: widget.onRefresh,
            isDarkMode: isDarkMode,
          ),
        )).toList(),
      ],
    );
  }
}

class _TipCardWidget extends StatefulWidget {
  final Map<String, dynamic> tip;
  final VoidCallback onRefresh;
  final bool isDarkMode;

  const _TipCardWidget({required this.tip, required this.onRefresh, required this.isDarkMode});

  @override
  State<_TipCardWidget> createState() => _TipCardWidgetState();
}

class _TipCardWidgetState extends State<_TipCardWidget> {
  final ApiService _apiService = ApiService();
  bool _isLoading = false;

  String _getCategoryDisplay(String? category) {
    switch (category?.toUpperCase()) {
      case 'STRESS': return 'stress';
      case 'HAPPINESS': return 'happiness';
      case 'ANXIETY': return 'anxiety';
      default: return 'general';
    }
  }

  Future<void> _toggleTipStatus() async {
    final tipId = widget.tip['id'];
    if (tipId == null) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.toggleTipStatus(tipId);
      widget.onRefresh();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteTip() async {
    final tipId = widget.tip['id'];
    if (tipId == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: widget.isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        title: Text('Xác nhận xóa', style: TextStyle(color: widget.isDarkMode ? Colors.white : Colors.black)),
        content: Text('Bạn có chắc chắn muốn xóa tip này?', style: TextStyle(color: widget.isDarkMode ? const Color(0xFFB0B0B0) : Colors.black)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    setState(() => _isLoading = true);

    try {
      await _apiService.deleteTip(tipId);
      widget.onRefresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Đã xóa tip thành công'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${e.toString().replaceAll('Exception: ', '')}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.tip['title'] ?? '';
    final content = widget.tip['content'] ?? '';
    final category = widget.tip['category']?.toString();
    final isActive = widget.tip['isActive'] ?? true;
    final isDarkMode = widget.isDarkMode;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Tiêu đề + tag
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isDarkMode ? const Color(0xFF2E2E3E) : const Color(0xFFF3F3F5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      _getCategoryDisplay(category),
                      style: TextStyle(
                        fontSize: 12,
                        color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF495565),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: isActive
                          ? (isDarkMode ? const Color(0xFF1A3D2A) : const Color(0xFFF0FDF4))
                          : (isDarkMode ? const Color(0xFF3D1A1A) : const Color(0xFFFEF2F2)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      isActive ? 'Hiện' : 'Ẩn',
                      style: TextStyle(
                        fontSize: 12,
                        color: isActive ? Colors.green : Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 8),

          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.black,
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Row(
                      children: [
                        InkWell(
                          onTap: _toggleTipStatus,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black26),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  isActive ? Icons.visibility_off : Icons.visibility,
                                  size: 16,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  isActive ? 'Ẩn' : 'Hiện',
                                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          onTap: _deleteTip,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.red.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.delete, size: 16, color: Colors.red),
                                SizedBox(width: 6),
                                Text('Xóa', style: TextStyle(color: Colors.red)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
            ],
          )
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
  final bool isDarkMode;

  const _StatCard({
    required this.title,
    required this.value,
    this.subtitle,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? const Color(0xFFB0B0B0) : Colors.black,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: TextStyle(
                fontSize: 12,
                color: isDarkMode ? const Color(0xFF6B7280) : const Color(0xFF495565),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _EmotionCardDynamic extends StatelessWidget {
  final String emoji;
  final String emotionText;
  final bool isDarkMode;

  const _EmotionCardDynamic({
    required this.emoji,
    required this.emotionText,
    required this.isDarkMode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF1E1E2E) : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDarkMode ? const Color(0xFF2E2E3E) : Colors.black12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Cảm xúc phổ biến nhất',
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Cảm xúc được ghi nhận nhiều nhất trong hệ thống',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: isDarkMode ? const Color(0xFFB0B0B0) : const Color(0xFF717182),
            ),
          ),
          const SizedBox(height: 16),
          Text(emoji, style: const TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            emotionText,
            style: TextStyle(
              fontSize: 20,
              color: isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
