import 'package:flutter/material.dart';
import '../../../data/models/biller_model.dart';
import '../../../data/services/biller_service.dart';
import 'biller_info_screen.dart';

class BbpsServiceScreen extends StatefulWidget {
  final String serviceName;

  const BbpsServiceScreen({super.key, required this.serviceName});

  @override
  State<BbpsServiceScreen> createState() => _BbpsServiceScreenState();
}

class _BbpsServiceScreenState extends State<BbpsServiceScreen> {
  final BillerService _billerService = BillerService();

  // ✅ Theme (same style like your other screens)
  static const Color _primary = Color(0xFF0033A0);
  static const Color _accent = Color(0xFF4B7BEC);
  static const Color _bg = Color(0xFFF5F7FB);
  static const String _appLogo = "assets/images/logo_app_icon_white.png";

  bool _loading = true;
  List<BillerModel> _billers = [];

  final TextEditingController _searchCtrl = TextEditingController();
  List<BillerModel> _filtered = [];

  @override
  void initState() {
    super.initState();
    _fetchBillers();
    _searchCtrl.addListener(_applyFilter);
  }

  @override
  void dispose() {
    _searchCtrl.removeListener(_applyFilter);
    _searchCtrl.dispose();
    super.dispose();
  }

  Future<void> _fetchBillers() async {
    try {
      final result = await _billerService.getBillers(widget.serviceName);
      if (!mounted) return;
      setState(() {
        _billers = result;
        _filtered = result;
        _loading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _billers = [];
        _filtered = [];
        _loading = false;
      });
    }
  }

  void _applyFilter() {
    final q = _searchCtrl.text.trim().toLowerCase();
    setState(() {
      if (q.isEmpty) {
        _filtered = _billers;
      } else {
        _filtered = _billers.where((b) {
          final name = (b.blrName).toLowerCase();
          final id = (b.blrId).toLowerCase();
          return name.contains(q) || id.contains(q);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, c) {
        final w = c.maxWidth;
        final bool isMobile = w < 600;
        final double pagePadding = isMobile ? 16 : (w < 1024 ? 22 : 28);
        final double maxContentWidth = w >= 1200 ? 1100 : double.infinity;

        return Scaffold(
          backgroundColor: _bg,

          // ✅ Premium gradient AppBar + logo
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            title: Text(
              widget.serviceName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            flexibleSpace: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [_primary, _accent],
                    begin: Alignment.bottomRight,
              end: Alignment.topLeft,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Center(
                  child: Image.asset(
                    _appLogo,
                    height: 34,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.image_not_supported, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          body: SafeArea(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxContentWidth),
                      child: Padding(
                        padding: EdgeInsets.all(pagePadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ Header card
                            _headerCard(count: _billers.length),

                            const SizedBox(height: 14),

                            // ✅ Search box
                            _searchBox(),

                            const SizedBox(height: 14),

                            Expanded(
                              child: _filtered.isEmpty
                                  ? _emptyState()
                                  : ListView.separated(
                                      itemCount: _filtered.length,
                                      separatorBuilder: (_, __) =>
                                          const SizedBox(height: 10),
                                      itemBuilder: (context, index) {
                                        final biller = _filtered[index];
                                        return _billerCard(biller);
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _headerCard({required int count}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFFE9EEF7)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                colors: [_primary.withOpacity(0.15), _accent.withOpacity(0.10)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: const Icon(Icons.grid_view_rounded, color: _primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Available Billers",
                  style: const TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1F2A37),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  "Select a biller to continue",
                  style: TextStyle(
                    fontSize: 12.5,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F8FE),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: const Color(0xFFE6EDF8)),
            ),
            child: Text(
              "$count",
              style: const TextStyle(
                fontWeight: FontWeight.w900,
                color: _primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBox() {
    return TextField(
      controller: _searchCtrl,
      decoration: InputDecoration(
        hintText: "Search biller name or ID",
        prefixIcon: const Icon(Icons.search_rounded),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3EAF6)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFE3EAF6)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: _primary, width: 1.2),
        ),
        suffixIcon: _searchCtrl.text.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  _searchCtrl.clear();
                  _applyFilter();
                },
                icon: const Icon(Icons.close_rounded),
              ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE9EEF7)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, size: 36, color: Colors.grey.shade600),
            const SizedBox(height: 8),
            Text(
              "No billers found",
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Try changing the search keyword",
              style: TextStyle(color: Colors.grey.shade700),
            ),
          ],
        ),
      ),
    );
  }

  Widget _billerCard(BillerModel biller) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BillerInfoScreen(billerId: biller.blrId),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
          border: Border.all(color: const Color(0xFFE9EEF7)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  colors: [_accent.withOpacity(0.18), _accent.withOpacity(0.06)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: const Icon(Icons.account_balance_rounded, color: _primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    biller.blrName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 14.5,
                      color: Color(0xFF1F2A37),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    biller.blrId,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      color: Colors.grey.shade700,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F8FE),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6EDF8)),
              ),
              child: const Icon(Icons.arrow_forward_ios_rounded,
                  size: 16, color: _primary),
            ),
          ],
        ),
      ),
    );
  }
}