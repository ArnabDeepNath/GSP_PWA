import 'package:flutter/material.dart';
import 'package:gstsync/features/party/domain/models/party.dart';

/// Party Search and Filter Widget
class PartySearchFilter extends StatefulWidget {
  final List<Party> parties;
  final Function(List<Party>) onFilterChanged;
  final PartyType? initialTypeFilter;

  const PartySearchFilter({
    super.key,
    required this.parties,
    required this.onFilterChanged,
    this.initialTypeFilter,
  });

  @override
  State<PartySearchFilter> createState() => _PartySearchFilterState();
}

class _PartySearchFilterState extends State<PartySearchFilter> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  PartySortOption _sortOption = PartySortOption.nameAsc;
  PartyType? _typeFilter;

  @override
  void initState() {
    super.initState();
    _typeFilter = widget.initialTypeFilter;
    _applyFilters();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    List<Party> filtered = widget.parties;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      final query = _searchQuery.toLowerCase();
      filtered = filtered.where((party) {
        return party.name.toLowerCase().contains(query) ||
            (party.gstin?.toLowerCase().contains(query) ?? false) ||
            (party.phone?.toLowerCase().contains(query) ?? false) ||
            (party.email?.toLowerCase().contains(query) ?? false);
      }).toList();
    }

    // Apply type filter
    if (_typeFilter != null) {
      filtered = filtered.where((p) => p.type == _typeFilter).toList();
    }

    // Apply sorting
    switch (_sortOption) {
      case PartySortOption.nameAsc:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case PartySortOption.nameDesc:
        filtered.sort((a, b) => b.name.compareTo(a.name));
        break;
      case PartySortOption.recentFirst:
        filtered.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case PartySortOption.oldestFirst:
        filtered.sort((a, b) => a.createdAt.compareTo(b.createdAt));
        break;
    }

    widget.onFilterChanged(filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Search Bar
        Container(
          margin: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            onChanged: (value) {
              setState(() => _searchQuery = value);
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: 'Search parties...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500]),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = '');
                        _applyFilters();
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            ),
          ),
        ),

        // Filter Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              // Type Filter Chips
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', _typeFilter == null, () {
                        setState(() => _typeFilter = null);
                        _applyFilters();
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Customers', _typeFilter == PartyType.buyer, () {
                        setState(() => _typeFilter = PartyType.buyer);
                        _applyFilters();
                      }),
                      const SizedBox(width: 8),
                      _buildFilterChip('Suppliers', _typeFilter == PartyType.seller, () {
                        setState(() => _typeFilter = PartyType.seller);
                        _applyFilters();
                      }),
                    ],
                  ),
                ),
              ),

              // Sort Dropdown
              PopupMenuButton<PartySortOption>(
                icon: Icon(Icons.sort, color: Colors.grey[700]),
                tooltip: 'Sort',
                onSelected: (option) {
                  setState(() => _sortOption = option);
                  _applyFilters();
                },
                itemBuilder: (context) => [
                  _buildSortMenuItem(PartySortOption.nameAsc, 'Name (A-Z)', Icons.sort_by_alpha),
                  _buildSortMenuItem(PartySortOption.nameDesc, 'Name (Z-A)', Icons.sort_by_alpha),
                  _buildSortMenuItem(PartySortOption.recentFirst, 'Newest First', Icons.schedule),
                  _buildSortMenuItem(PartySortOption.oldestFirst, 'Oldest First', Icons.history),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildFilterChip(String label, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Theme.of(context).primaryColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<PartySortOption> _buildSortMenuItem(
    PartySortOption option,
    String label,
    IconData icon,
  ) {
    final isSelected = _sortOption == option;
    return PopupMenuItem(
      value: option,
      child: Row(
        children: [
          Icon(icon, size: 18, color: isSelected ? Theme.of(context).primaryColor : Colors.grey[600]),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey[800],
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Icon(Icons.check, size: 16, color: Theme.of(context).primaryColor),
            ),
        ],
      ),
    );
  }
}

enum PartySortOption {
  nameAsc,
  nameDesc,
  recentFirst,
  oldestFirst,
}
