import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:gstsync/features/party/domain/models/party.dart';
import 'package:gstsync/features/party/presentation/bloc/party_bloc.dart';
import 'package:gstsync/features/party/presentation/pages/party_details_page.dart';
import 'package:gstsync/features/invoice/domain/models/invoice.dart';
import 'package:gstsync/features/invoice/presentation/bloc/invoice_bloc.dart';
import 'package:gstsync/features/invoice/presentation/pages/edit_invoice_page.dart';
import 'package:gstsync/features/item/domain/models/item.dart';
import 'package:gstsync/features/item/presentation/bloc/item_bloc.dart';
import 'package:gstsync/features/store/presentation/providers/store_provider.dart';
import 'package:intl/intl.dart';

class GlobalSearchPage extends StatefulWidget {
  const GlobalSearchPage({super.key});

  @override
  State<GlobalSearchPage> createState() => _GlobalSearchPageState();
}

class _GlobalSearchPageState extends State<GlobalSearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  late TabController _tabController;
  
  String _searchQuery = '';
  List<Party> _matchedParties = [];
  List<Invoice> _matchedInvoices = [];
  List<Item> _matchedItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    // Auto-focus search field when page opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _performSearch(String query) {
    if (query.isEmpty) {
      setState(() {
        _searchQuery = '';
        _matchedParties = [];
        _matchedInvoices = [];
        _matchedItems = [];
      });
      return;
    }

    final lowerQuery = query.toLowerCase();
    
    // Search parties
    final partyState = context.read<PartyBloc>().state;
    if (partyState is PartiesLoaded) {
      _matchedParties = partyState.parties.where((party) {
        return party.name.toLowerCase().contains(lowerQuery) ||
            (party.gstin?.toLowerCase().contains(lowerQuery) ?? false) ||
            (party.phone?.toLowerCase().contains(lowerQuery) ?? false) ||
            (party.email?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    // Search invoices
    final invoiceState = context.read<InvoiceBloc>().state;
    if (invoiceState is InvoicesLoaded) {
      _matchedInvoices = invoiceState.invoices.where((invoice) {
        return invoice.invoiceNumber.toLowerCase().contains(lowerQuery) ||
            invoice.displayTitle.toLowerCase().contains(lowerQuery) ||
            (invoice.notes?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    // Search items
    final itemState = context.read<ItemBloc>().state;
    if (itemState is ItemsLoaded) {
      _matchedItems = itemState.items.where((item) {
        return item.name.toLowerCase().contains(lowerQuery) ||
            (item.hsn?.toLowerCase().contains(lowerQuery) ?? false);
      }).toList();
    }

    setState(() {
      _searchQuery = query;
    });
  }

  int get _totalResults =>
      _matchedParties.length + _matchedInvoices.length + _matchedItems.length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Container(
          height: 44,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onChanged: _performSearch,
            decoration: InputDecoration(
              hintText: 'Search parties, invoices, items...',
              hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
              prefixIcon: Icon(Icons.search, color: Colors.grey[500], size: 22),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[500], size: 20),
                      onPressed: () {
                        _searchController.clear();
                        _performSearch('');
                      },
                    )
                  : null,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
            style: const TextStyle(fontSize: 15),
          ),
        ),
        bottom: _searchQuery.isNotEmpty
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor: Colors.grey[600],
                    indicatorColor: Theme.of(context).primaryColor,
                    tabs: [
                      Tab(text: 'Parties (${_matchedParties.length})'),
                      Tab(text: 'Invoices (${_matchedInvoices.length})'),
                      Tab(text: 'Items (${_matchedItems.length})'),
                    ],
                  ),
                ),
              )
            : null,
      ),
      body: _searchQuery.isEmpty
          ? _buildEmptySearchState()
          : _totalResults == 0
              ? _buildNoResultsState()
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildPartiesTab(),
                    _buildInvoicesTab(),
                    _buildItemsTab(),
                  ],
                ),
    );
  }

  Widget _buildEmptySearchState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search,
              size: 48,
              color: Colors.blue[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Search Everything',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Text(
              'Search across parties, invoices, and items all at once',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 8,
            children: [
              _buildSuggestionChip('Party name'),
              _buildSuggestionChip('Invoice #'),
              _buildSuggestionChip('GSTIN'),
              _buildSuggestionChip('HSN code'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionChip(String label) {
    return ActionChip(
      label: Text(label, style: const TextStyle(fontSize: 13)),
      backgroundColor: Colors.grey[200],
      onPressed: () {
        _searchController.text = label;
        _performSearch(label);
      },
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off,
              size: 48,
              color: Colors.orange[300],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No results found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try searching with different keywords',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartiesTab() {
    if (_matchedParties.isEmpty) {
      return _buildEmptyTabState('No parties match your search');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _matchedParties.length,
      itemBuilder: (context, index) {
        final party = _matchedParties[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: party.type == PartyType.buyer
                  ? Colors.blue[100]
                  : Colors.green[100],
              child: Icon(
                party.type == PartyType.buyer ? Icons.person : Icons.business,
                color: party.type == PartyType.buyer ? Colors.blue : Colors.green,
              ),
            ),
            title: _highlightMatch(party.name, _searchQuery),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (party.gstin != null && party.gstin!.isNotEmpty)
                  _highlightMatch('GSTIN: ${party.gstin}', _searchQuery),
                if (party.phone != null && party.phone!.isNotEmpty)
                  Text('📞 ${party.phone}', style: TextStyle(color: Colors.grey[600])),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: party.type == PartyType.buyer
                    ? Colors.blue[50]
                    : Colors.green[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                party.type == PartyType.buyer ? 'Customer' : 'Supplier',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: party.type == PartyType.buyer
                      ? Colors.blue[700]
                      : Colors.green[700],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PartyDetailsPage(party: party),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildInvoicesTab() {
    if (_matchedInvoices.isEmpty) {
      return _buildEmptyTabState('No invoices match your search');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _matchedInvoices.length,
      itemBuilder: (context, index) {
        final invoice = _matchedInvoices[index];
        final isPositive = invoice.financialImpact > 0;

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: isPositive ? Colors.green[100] : Colors.red[100],
              child: Icon(
                Icons.receipt_long,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
            title: _highlightMatch(invoice.displayTitle, _searchQuery),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('dd MMM yyyy').format(invoice.invoiceDate),
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  '₹${invoice.totalAmount.abs().toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isPositive ? Colors.green[700] : Colors.red[700],
                  ),
                ),
              ],
            ),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isPositive ? Colors.green[50] : Colors.red[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isPositive ? 'INCOME' : 'EXPENSE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isPositive ? Colors.green[700] : Colors.red[700],
                ),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditInvoicePage(invoice: invoice),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildItemsTab() {
    if (_matchedItems.isEmpty) {
      return _buildEmptyTabState('No items match your search');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _matchedItems.length,
      itemBuilder: (context, index) {
        final item = _matchedItems[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: CircleAvatar(
              backgroundColor: Colors.purple[100],
              child: Icon(
                Icons.inventory_2,
                color: Colors.purple[700],
              ),
            ),
            title: _highlightMatch(item.name, _searchQuery),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.hsn != null && item.hsn!.isNotEmpty)
                  _highlightMatch('HSN: ${item.hsn}', _searchQuery),
                Text(
                  '₹${item.unitPrice.toStringAsFixed(2)} • ${item.taxRate}% GST',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right, color: Colors.grey),
            onTap: () {
              // Show item details in a snackbar for now
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Item: ${item.name}')),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildEmptyTabState(String message) {
    return Center(
      child: Text(
        message,
        style: TextStyle(color: Colors.grey[500]),
      ),
    );
  }

  Widget _highlightMatch(String text, String query) {
    if (query.isEmpty) return Text(text);

    final lowerText = text.toLowerCase();
    final lowerQuery = query.toLowerCase();
    final startIndex = lowerText.indexOf(lowerQuery);

    if (startIndex == -1) return Text(text);

    final endIndex = startIndex + query.length;
    final beforeMatch = text.substring(0, startIndex);
    final match = text.substring(startIndex, endIndex);
    final afterMatch = text.substring(endIndex);

    return RichText(
      text: TextSpan(
        style: const TextStyle(color: Colors.black87),
        children: [
          TextSpan(text: beforeMatch),
          TextSpan(
            text: match,
            style: TextStyle(
              backgroundColor: Colors.yellow[200],
              fontWeight: FontWeight.w600,
            ),
          ),
          TextSpan(text: afterMatch),
        ],
      ),
    );
  }
}
