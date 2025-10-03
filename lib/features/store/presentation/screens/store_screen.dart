// lib/features/store/presentation/screens/store_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/responsive_utils.dart';
import '../../../../shared/presentation/widgets/glass_card.dart';
import '../../../../shared/presentation/widgets/neon_button.dart';

class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _cartItems = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveUtils(context);
    
    return Container(
      decoration: BoxDecoration(
        gradient: AppColors.backgroundGradient,
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header with Credits
            Padding(
              padding: EdgeInsets.all(responsive.wp(5)),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.go('/home'),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.card.withOpacity(0.5),
                      padding: EdgeInsets.all(responsive.wp(3)),
                    ),
                  ),
                  SizedBox(width: responsive.wp(4)),
                  Expanded(
                    child: Text(
                      'Store',
                      style: TextStyle(
                        fontSize: responsive.sp(28),
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.monetization_on,
                        color: AppColors.warmOrange,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '1,250',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.warmOrange,
                        ),
                      ),
                      const SizedBox(width: 16),
                      IconButton(
                        onPressed: () => context.go('/profile'),
                        icon: const Icon(Icons.person, color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Tab Bar
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: AppColors.card.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.royalPurple, AppColors.electricBlue],
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                tabs: const [
                  Tab(text: 'Supplements'),
                  Tab(text: 'Equipment'),
                  Tab(text: 'Nutrition'),
                  Tab(text: 'Cart'),
                ],
              ),
            ),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildSupplementsTab(),
                  _buildEquipmentTab(),
                  _buildNutritionTab(),
                  _buildCartTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSupplementsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Performance Supplements',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          // Featured Product
          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [AppColors.neonGreen, AppColors.neonGreen.withOpacity(0.6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.science,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Elite Whey Protein',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Premium whey protein isolate for muscle recovery and growth. 25g protein per serving.',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '500 credits',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.warmOrange,
                      ),
                    ),
                    NeonButton(
                      text: 'Add to Cart',
                      onPressed: () => _addToCart('Elite Whey Protein', 500),
                      size: NeonButtonSize.small,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Product Grid
          GridView.count(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              _buildProductCard(
                'Creatine Monohydrate',
                'Pure creatine for strength gains',
                300,
                AppColors.electricBlue,
                Icons.fitness_center,
              ),
              _buildProductCard(
                'BCAA Complex',
                'Essential amino acids',
                250,
                AppColors.royalPurple,
                Icons.science,
              ),
              _buildProductCard(
                'Pre-Workout Boost',
                'Energy and focus formula',
                400,
                AppColors.neonGreen,
                Icons.bolt,
              ),
              _buildProductCard(
                'Recovery Matrix',
                'Post-workout recovery blend',
                350,
                AppColors.warmOrange,
                Icons.healing,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Training Equipment',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          _buildProductCard(
            'Professional Stopwatch',
            'Precision timing for tests',
            800,
            AppColors.electricBlue,
            Icons.timer,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Measuring Tape',
            'Accurate body measurements',
            200,
            AppColors.royalPurple,
            Icons.straighten,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Agility Cones Set',
            'Complete set for agility training',
            600,
            AppColors.neonGreen,
            Icons.flag,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Heart Rate Monitor',
            'Real-time heart rate tracking',
            1200,
            AppColors.warmOrange,
            Icons.monitor_heart,
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Nutrition Plans',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),

          _buildProductCard(
            'Athlete Meal Plan',
            '7-day customized nutrition plan',
            1500,
            AppColors.neonGreen,
            Icons.restaurant_menu,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Weight Gain Program',
            'High-calorie nutrition guide',
            1200,
            AppColors.warmOrange,
            Icons.trending_up,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Vegan Athlete Plan',
            'Plant-based performance nutrition',
            1300,
            AppColors.royalPurple,
            Icons.eco,
          ),
          const SizedBox(height: 16),
          _buildProductCard(
            'Recovery Nutrition',
            'Post-workout meal planning',
            1000,
            AppColors.electricBlue,
            Icons.healing,
          ),
        ],
      ),
    );
  }

  Widget _buildCartTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Shopping Cart',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              if (_cartItems.isNotEmpty)
                Text(
                  '${_cartItems.length} items',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),

          if (_cartItems.isEmpty)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 64,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add some products to get started',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            )
          else
            Column(
              children: [
                ..._cartItems.map((item) => _buildCartItem(item)),
                const SizedBox(height: 24),
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            '${_calculateTotal()} credits',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: AppColors.warmOrange,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      NeonButton(
                        text: 'Checkout',
                        onPressed: () {},
                        size: NeonButtonSize.medium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildProductCard(String name, String description, int price, Color color, IconData icon) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$price credits',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.warmOrange,
                ),
              ),
              IconButton(
                onPressed: () => _addToCart(name, price),
                icon: Icon(
                  Icons.add_shopping_cart,
                  color: color,
                  size: 20,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['name'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '${item['price']} credits',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _removeFromCart(item),
              icon: const Icon(
                Icons.remove_circle,
                color: AppColors.brightRed,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addToCart(String name, int price) {
    setState(() {
      _cartItems.add({'name': name, 'price': price});
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$name added to cart'),
        backgroundColor: AppColors.neonGreen,
      ),
    );
  }

  void _removeFromCart(Map<String, dynamic> item) {
    setState(() {
      _cartItems.remove(item);
    });
  }

  int _calculateTotal() {
    return _cartItems.fold(0, (sum, item) => sum + (item['price'] as int));
  }
}
