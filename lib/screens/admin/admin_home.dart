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
    return const Text(
      'Trang Người dùng (bạn đã có sẵn)',
      style: TextStyle(color: Color(0xFF495565)),
    );
  }
}

class _TipsTab extends StatelessWidget {
  const _TipsTab();

  @override
  Widget build(BuildContext context) {
    return const Text(
      'Trang Tips sức khỏe',
      style: TextStyle(color: Color(0xFF495565)),
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
