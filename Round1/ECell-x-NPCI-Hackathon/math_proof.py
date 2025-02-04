import pandas as pd
import numpy as np
import matplotlib.pyplot as plt

def before_reward():
    """
    Simulates customer transactions before implementing the reward system.
    Returns average monthly sales for small, medium, and big vendors.
    """
    def simulate_transactions():
        # Define customer groups
        total_customers = 1000
        medium_customers_count = 500
        big_customers_count = 600

        # All customers visit small vendors
        small_customers = set(range(1, total_customers + 1))

        # Randomly select customers for medium and big vendors with minimal overlap
        medium_customers = set(np.random.choice(list(small_customers), medium_customers_count, replace=False))
        big_customers = set(np.random.choice(list(small_customers), big_customers_count, replace=False))

        # Simulate transactions for small vendors (all customers)
        small_transactions = [{
            'Customer': customer,
            'Vendor_Type': 'Small',
            'Amount': int(np.round(np.random.uniform(60, 100)))  # Random amount between 60 and 100
        } for customer in small_customers for _ in range(np.random.randint(25, 36))]  # 25 to 35 visits per month

        # Simulate transactions for medium vendors
        medium_transactions = [{
            'Customer': customer,
            'Vendor_Type': 'Medium',
            'Amount': int(np.round(np.random.uniform(150, 250)))  # Random amount between 150 and 250
        } for customer in medium_customers for _ in range(np.random.randint(10, 16))]  # 10 to 15 visits per month

        # Simulate transactions for big vendors
        big_transactions = [{
            'Customer': customer,
            'Vendor_Type': 'Big',
            'Amount': int(np.round(np.random.uniform(800, 2200)))  # Random amount between 800 and 2200
        } for customer in big_customers for _ in range(2)]  # Fixed 2 visits per month

        # Combine all transactions into a single DataFrame
        all_transactions = small_transactions + medium_transactions + big_transactions
        df_transactions = pd.DataFrame(all_transactions)

        # Calculate total sales for each vendor type
        total_sales_small = df_transactions[df_transactions['Vendor_Type'] == 'Small']['Amount'].sum()
        total_sales_medium = df_transactions[df_transactions['Vendor_Type'] == 'Medium']['Amount'].sum()
        total_sales_big = df_transactions[df_transactions['Vendor_Type'] == 'Big']['Amount'].sum()

        return total_sales_small, total_sales_medium, total_sales_big

    # Run the simulation 1000 times
    num_simulations = 1000
    total_sales_small, total_sales_medium, total_sales_big = 0, 0, 0

    for _ in range(num_simulations):
        np.random.seed()  # Ensure a different seed for each simulation
        small, medium, big = simulate_transactions()
        total_sales_small += small
        total_sales_medium += medium
        total_sales_big += big

    # Calculate average monthly sales
    average_sales_small = total_sales_small / num_simulations
    average_sales_medium = total_sales_medium / num_simulations
    average_sales_big = total_sales_big / num_simulations
    return average_sales_small, average_sales_medium, average_sales_big


def after_reward():
    """
    Simulates customer transactions after implementing the reward system.
    Returns average monthly sales for small, medium, and big vendors, and average coins remaining.
    """
    def generate_transactions(customer_set, low_range, high_range, low_percent, freq_range, vendor_type):
        """
        Generates transactions for a given customer set and vendor type.
        Applies reward system logic (coins deposited/withdrawn).
        """
        customers = []
        vendor_types = []
        amounts = []
        coins_deposited = []
        coins_withdrawn = []

        for customer in customer_set:
            frequency = np.random.randint(freq_range[0], freq_range[1] + 1)  # Random visit frequency
            for _ in range(frequency):
                if np.random.rand() <= low_percent:
                    amount = np.random.uniform(low_range[0], low_range[1])  # Low spending range
                else:
                    amount = np.random.uniform(high_range[0], high_range[1])  # High spending range
                amount = int(round(amount))
                deposited = 0.1 * amount if amount > 100 else 0  # Coins deposited for spending > 100
                withdrawn = 0.1 * amount if amount > 200 else 0  # Coins withdrawn for spending > 200
                customers.append(customer)
                vendor_types.append(vendor_type)
                amounts.append(amount)
                coins_deposited.append(deposited)
                coins_withdrawn.append(withdrawn)

        return pd.DataFrame({
            'Customer': customers,
            'Vendor_Type': vendor_type,
            'Amount': amounts,
            'Coins_Deposited': coins_deposited,
            'Coins_Withdrawn': coins_withdrawn
        })

    def simulate_transactions():
        # Define customer groups
        small_customers = set(range(1, 1001))  # All customers visit small vendors
        medium_customers = set(np.random.choice(list(small_customers), 600, replace=False))  # Randomly select medium vendor customers

        # Generate transactions for small and medium vendors
        small_df = generate_transactions(small_customers, (40, 70), (100, 130), 0.2, (24, 29), 'Small')
        medium_df = generate_transactions(medium_customers, (140, 160), (200, 240), 0.4, (12, 18), 'Medium')

        # Combine transactions and calculate cumulative coins
        transactions_df = pd.concat([small_df, medium_df])
        transactions_df['Cumulative_Coins'] = transactions_df.groupby('Customer')['Coins_Deposited'].cumsum() - transactions_df.groupby('Customer')['Coins_Withdrawn'].cumsum()

        total_sales_small = small_df['Amount'].sum()
        total_sales_medium = medium_df['Amount'].sum()

        # Big vendor spending calculations
        customer_coins = transactions_df.groupby('Customer')['Cumulative_Coins'].last().reset_index()
        selected_customers = np.random.choice(customer_coins['Customer'], 700, replace=False)  # Randomly select 700 customers for big vendors

        # Threshold-Driven Spending Behavior: Customers are motivated to increase their spending when thresholds are implemented.
        def assign_spending_category():
            rand = np.random.rand()
            if rand <= 0.40:
                return np.random.uniform(1000, 1300)  # Low spending category
            elif rand <= 0.60:
                return np.random.uniform(1300, 1800)  # Medium spending category
            else:
                return np.random.uniform(2000, 2200)  # High spending category

        def calculate_spending(coins, category):
            if category < 2000:
                return min(coins / 0.10, category)  # Spending needed to redeem coins for low/medium categories
            else:
                return min(coins / 0.15, category)  # Spending needed to redeem coins for high category

        customer_coins['Spending_Category'] = customer_coins['Customer'].apply(lambda x: assign_spending_category())
        customer_coins['Spending_Needed'] = customer_coins.apply(lambda x: calculate_spending(x['Cumulative_Coins'], x['Spending_Category']), axis=1)

        selected_customer_spending = customer_coins[customer_coins['Customer'].isin(selected_customers)]
        total_amount_spent = selected_customer_spending['Spending_Needed'].sum() * 2  # Big vendor spending

        return total_sales_small, total_sales_medium, total_amount_spent, selected_customer_spending['Cumulative_Coins'].mean()

    # Run the simulation 1000 times
    num_simulations = 1000
    total_sales_small, total_sales_medium, total_sales_big = 0, 0, 0
    average_coins_remaining = 0

    for _ in range(num_simulations):
        np.random.seed()  # Varying seed for each simulation
        small, medium, big, avg_coins = simulate_transactions()
        total_sales_small += small
        total_sales_medium += medium
        total_sales_big += big
        average_coins_remaining += avg_coins

    # Calculate average monthly sales and coins remaining
    average_sales_small = total_sales_small / num_simulations
    average_sales_medium = total_sales_medium / num_simulations
    average_sales_big = total_sales_big / num_simulations
    average_coins_remaining /= num_simulations

    return average_sales_small, average_sales_medium, average_sales_big


# Run simulations and get results
b_small_sales, b_medium_sales, b_big_sales = before_reward()
a_small_sales, a_medium_sales, a_big_sales = after_reward()

# Print results
print(f"Average Monthly Sales for Small Vendors before reward: {b_small_sales}")
print(f"Average Monthly Sales for Medium Vendors before reward: {b_medium_sales}")
print(f"Average Monthly Sales for Big Vendors before reward: {b_big_sales}")
print(f"Average Monthly Sales for Small Vendors after reward: {a_small_sales}")
print(f"Average Monthly Sales for Medium Vendors after reward: {a_medium_sales}")
print(f"Average Monthly Sales for Big Vendors after reward: {a_big_sales}")

# Plot results
labels = ['Small Vendors', 'Medium Vendors', 'Big Vendors']
before_sales = [b_small_sales, b_medium_sales, b_big_sales]
after_sales = [a_small_sales, a_medium_sales, a_big_sales]

x = np.arange(len(labels))  # Label locations
width = 0.35  # Bar width

# Create bar charts
fig, ax = plt.subplots()
rects1 = ax.bar(x - width/2, before_sales, width, label='Before Reward')
rects2 = ax.bar(x + width/2, after_sales, width, label='After Reward')

# Add labels, title, and legend
ax.set_ylabel('Sales')
ax.set_title('Sales by Vendor Type Before and After Implementing Reward System')
ax.set_xticks(x)
ax.set_xticklabels(labels)
ax.legend()

# Add value labels on top of bars
def autolabel(rects):
    for rect in rects:
        height = rect.get_height()
        ax.annotate('{}'.format(height),
                    xy=(rect.get_x() + rect.get_width() / 2, height),
                    xytext=(0, 3),  # 3 points vertical offset
                    textcoords="offset points",
                    ha='center', va='bottom')

autolabel(rects1)
autolabel(rects2)

fig.tight_layout()
plt.show()