import 'dart:convert';
import 'package:ects/screens/sales/salesOrderDetails.dart';
import 'package:flutter/material.dart';
import 'package:ects/screens/sales/paymentVerification.dart';
import 'package:ects/constant/colorcontant.dart';
import 'package:ects/generated/assets.dart';
import '../../services/remoteservice.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderManagementPage extends StatefulWidget {
  const OrderManagementPage({super.key});

  @override
  State<OrderManagementPage> createState() => _OrderManagementPageState();
}

class _OrderManagementPageState extends State<OrderManagementPage> {
  bool _showPaidOrders = false;
  bool _isLoading = true;
  String _errorMessage = '';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<Order> _paidOrders = [];
  List<Order> _unpaidOrders = [];
  List<Order> _filteredPaidOrders = [];
  List<Order> _filteredUnpaidOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text;
      _filterOrders();
    });
  }

  void _filterOrders() {
    if (_searchQuery.isEmpty) {
      _filteredPaidOrders = _paidOrders;
      _filteredUnpaidOrders = _unpaidOrders;
    } else {
      final query = _searchQuery.toLowerCase();
      _filteredPaidOrders = _paidOrders.where((order) {
        return order.idName.toLowerCase().contains(query) ||
            order.customerName.toLowerCase().contains(query) ||
            order.date.toLowerCase().contains(query);
      }).toList();

      _filteredUnpaidOrders = _unpaidOrders.where((order) {
        return order.idName.toLowerCase().contains(query) ||
            order.customerName.toLowerCase().contains(query) ||
            order.date.toLowerCase().contains(query);
      }).toList();
    }
  }

  Future<void> _fetchOrders() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt("userId") ?? 0;
    print('Current userId: $userId');

    try {
      // Fetch unpaid orders
      final unpaidResponse = await RemoteServices.getUnpaidOrders(userId);
      if (unpaidResponse != null && unpaidResponse.contains('data')) {
        final unpaidData = json.decode(unpaidResponse);
        _unpaidOrders = _parseOrders(unpaidData['data'], false);
      }

      // Fetch paid orders
      final paidResponse = await RemoteServices.getPaidOrders(userId);
      if (paidResponse != null && paidResponse.contains('data')) {
        final paidData = json.decode(paidResponse);
        _paidOrders = _parseOrders(paidData['data'], true);
      }

      setState(() {
        _isLoading = false;
        _filterOrders(); // Initialize filtered lists
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to load orders: $e';
      });
    }
  }

  List<Order> _parseOrders(List<dynamic> data, bool isPaid) {
    return data.map<Order>((json) {
      List<Product> products = [];
      int items = 0;

      if (json['products'] is List) {
        final productList = json['products'] as List;
        products = productList.map<Product>((product) {
          return Product(
            name: product['product_name'] ?? 'Unknown Product',
            quantity: product['quantity'] ?? 0,
            price: (product['price_unit'] ?? 0).toDouble(),
          );
        }).toList();
        items = products.length;
      }

      double amount = 0;
      if (json['amount_total'] is int) {
        amount = (json['amount_total'] as int).toDouble();
      } else if (json['amount_total'] is double) {
        amount = json['amount_total'] as double;
      }

      return Order(
        numericId: json['id'], // numeric ID for backend
        idName: json['name'] ?? 'N/A', // display name for UI
        date: json['date'] ?? 'N/A',
        amount: amount,
        status: json['payment_status_desc'] ?? (isPaid ? 'paid' : 'un-paid'),
        customerName: json['customer_name'] ?? 'N/A',
        items: items,
        products: products,
        paymentUrl: json['payment_gateway_url'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            // Top Header
            Container(
              height: 267,
              width: double.infinity,
              padding: const EdgeInsets.all(21),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(Assets.iconsTopheader),
                  fit: BoxFit.fill,
                ),
              ),
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top + 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: const CircleAvatar(
                          backgroundColor: Colors.transparent,
                          foregroundImage: AssetImage(Assets.iconsBack),
                          radius: 17,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        "Order Management",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Icon(Icons.shopping_bag, color: Colors.white, size: 80),
                ],
              ),
            ),

            // Orders Card
            Positioned(
              top: 200,
              left: 20,
              right: 20,
              bottom: 20,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: whitecolor,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Search Bar
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Search by order ID, customer name, or date...",
                          border: InputBorder.none,
                          icon: Icon(Icons.search, color: Colors.grey[600]),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                            icon: Icon(Icons.clear, color: Colors.grey[600]),
                            onPressed: () {
                              _searchController.clear();
                            },
                          )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Toggle Switch
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => _showPaidOrders = false),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: _showPaidOrders ? Colors.transparent : primarycolor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Unpaid Orders",
                                style: TextStyle(
                                  color: _showPaidOrders ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _showPaidOrders = true),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                color: _showPaidOrders ? primarycolor : Colors.transparent,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                "Paid Orders",
                                style: TextStyle(
                                  color: _showPaidOrders ? Colors.white : Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (_errorMessage.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Text(
                          _errorMessage,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),

                    Expanded(
                      child: _isLoading
                          ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(primarycolor),
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              "Getting orders...",
                              style: TextStyle(fontSize: 16, ),
                            ),
                          ],
                        ),
                      )
                          : _showPaidOrders
                          ? _buildOrderList(_filteredPaidOrders, true)
                          : _buildOrderList(_filteredUnpaidOrders, false),
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

  Widget _buildOrderList(List<Order> orders, bool isPaid) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
                _searchQuery.isNotEmpty ? Icons.search_off : Icons.inventory_2,
                size: 60,
                color: Colors.grey[300]
            ),
            const SizedBox(height: 10),
            Text(
              _searchQuery.isNotEmpty
                  ? "No orders found for '$_searchQuery'"
                  : isPaid ? "No paid orders" : "No unpaid orders",
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      itemCount: orders.length,
      separatorBuilder: (context, index) => const Divider(height: 20),
      itemBuilder: (context, index) {
        final order = orders[index];
        return Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(order.idName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isPaid ? Colors.green[50] : Colors.orange[50],
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      order.status.toUpperCase(),
                      style: TextStyle(
                        color: isPaid ? Colors.green[700] : Colors.orange[700],
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text("Date: ${_formatDate(order.date)}", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Text("Customer: ${order.customerName}", style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${order.items} item${order.items > 1 ? 's' : ''}", style: const TextStyle(color: Colors.grey)),
                  Text("\TZS${order.amount.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                ],
              ),

              if (order.products.isNotEmpty) ...[
                const SizedBox(height: 10),
                ExpansionTile(
                  title: const Text("View Products", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                  children: order.products.map((product) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("${product.quantity}x ${product.name}", style: const TextStyle(fontSize: 14)),
                          Text("\TZS${product.price.toStringAsFixed(2)}", style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 10),
              if (isPaid)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      final paymentUrl = order.paymentUrl;
                      if (paymentUrl == null || paymentUrl.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Payment URL not available")),
                        );
                        return;
                      }

                      final uri = Uri.parse(paymentUrl);

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const Center(child: CircularProgressIndicator()),
                      );

                      try {
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                          Navigator.pop(context);

                          // Navigator.pushReplacement(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => const PaymentVerificationScreen(),
                          //   ),
                          // );
                        } else {
                          Navigator.pop(context);
                          throw 'Could not launch $paymentUrl';
                        }
                      } catch (e) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to open link: $e")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarycolor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      "Verify Payment",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

              if (!isPaid)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SalesOrderDetails(orderData: {
                            'id': order.numericId,      // numeric ID for backend
                            'name': order.idName,       // display name for UI
                            'date_order': order.date,
                            'amount_total': order.amount,
                            'customer_name': order.customerName,
                            'payment_status_desc': order.status,
                            'products': order.products.map((p) => {
                              'product_name': p.name,
                              'quantity': p.quantity,
                              'price_unit': p.price,
                              'subtotal': p.price * p.quantity
                            }).toList(),
                          }),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primarycolor,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Pay Now",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String dateString) {
    try {
      final dateTime = DateTime.parse(dateString);
      return "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}";
    } catch (e) {
      return dateString;
    }
  }
}

// --- MODELS ---
class Order {
  final int numericId; // backend ID
  final String idName; // display name
  final String date;
  final double amount;
  final String status;
  final String customerName;
  final int items;
  final List<Product> products;
  final String? paymentUrl;

  Order({
    required this.numericId,
    required this.idName,
    required this.date,
    required this.amount,
    required this.status,
    required this.customerName,
    required this.items,
    required this.products,
    this.paymentUrl,
  });
}

class Product {
  final String name;
  final int quantity;
  final double price;

  Product({required this.name, required this.quantity, required this.price});
}
