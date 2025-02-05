import 'package:flutter/material.dart';

class OffersAndRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Offers & Rewards'),
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.card_giftcard),
                text: 'Rewards',
              ),
              Tab(
                icon: Icon(Icons.local_offer),
                text: 'Discount\nVouchers',
              ),
              Tab(
                icon: Icon(Icons.redeem),
                text: 'Redeem\nOffers',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRewardsTab(),
            _buildDiscountVouchersTab(),
            _buildRedeemOffersTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildRewardsTab() {
    final List<Map<String, dynamic>> rewards = [
      {
        'title': 'Birthday Reward',
        'description': 'Get special rewards on your birthday!',
        'icon': Icons.cake,
        'color': Colors.pink,
      },
      {
        'title': 'Welcome Bonus',
        'description': 'New user special reward points',
        'icon': Icons.stars,
        'color': Colors.orange,
      },
      {
        'title': 'Loyalty Reward',
        'description': 'Special reward for regular customers',
        'icon': Icons.favorite,
        'color': Colors.red,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: rewards.length,
      itemBuilder: (context, index) {
        final reward = rewards[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: reward['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(reward['icon'], color: reward['color']),
            ),
            title: Text(
              reward['title'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(reward['description']),
            trailing: Icon(Icons.arrow_forward_ios, size: 16),
          ),
        );
      },
    );
  }

  Widget _buildDiscountVouchersTab() {
    final List<Map<String, dynamic>> vouchers = [
      {
        'title': 'Weekend Special',
        'discount': '20% OFF',
        'validity': 'Valid till Sunday',
        'icon': Icons.weekend,
        'color': Colors.blue,
      },
      {
        'title': 'First Purchase',
        'discount': '15% OFF',
        'validity': 'Valid for 24 hours',
        'icon': Icons.shopping_bag,
        'color': Colors.green,
      },
      {
        'title': 'Festival Offer',
        'discount': '25% OFF',
        'validity': 'Valid for this week',
        'icon': Icons.celebration,
        'color': Colors.purple,
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        final voucher = vouchers[index];
        return Card(
          elevation: 4,
          margin: EdgeInsets.only(bottom: 16),
          child: ListTile(
            leading: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: voucher['color'].withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(voucher['icon'], color: voucher['color']),
            ),
            title: Text(
              voucher['title'],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(voucher['discount'], 
                    style: TextStyle(color: voucher['color'], fontWeight: FontWeight.bold)),
                Text(voucher['validity'], style: TextStyle(fontSize: 12)),
              ],
            ),
            trailing: ElevatedButton(
              onPressed: () {},
              child: Text('Use'),
              style: ElevatedButton.styleFrom(
                backgroundColor: voucher['color'],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildRedeemOffersTab() {
    final List<Map<String, dynamic>> offers = [
      {
        'brand': 'Amazon',
        'rate': '13%',
        'logo': Icons.shopping_cart,
        'color': Colors.orange,
      },
      {
        'brand': 'Flipkart',
        'rate': '12%',
        'logo': Icons.shopping_bag,
        'color': Colors.blue,
      },
      {
        'brand': 'Myntra',
        'rate': '15%',
        'logo': Icons.shopping_basket,
        'color': Colors.pink,
      },
      {
        'brand': 'Swiggy',
        'rate': '11%',
        'logo': Icons.fastfood,
        'color': Colors.orange,
      },
      {
        'brand': 'Zomato',
        'rate': '14%',
        'logo': Icons.restaurant,
        'color': Colors.red,
      },
    ];

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1,
      ),
      itemCount: offers.length,
      itemBuilder: (context, index) {
        final offer = offers[index];
        return Card(
          elevation: 4,
          child: InkWell(
            onTap: () {},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: offer['color'].withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    offer['logo'],
                    color: offer['color'],
                    size: 40,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  offer['brand'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Redeem at ${offer['rate']}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}