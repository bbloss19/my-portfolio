# import necessary libraries and dataset
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('Airbnb_ny.csv')
df.head()

# Drop columns "host_name"
df = df.drop(columns=['host_name'])

# Change date format from mm-dd-YYYY to YYYY-mm-dd
df['datetime'] = pd.to_datetime(df['last_review'],format='%Y-%m-%d')
df['date_formatted'] = df['datetime'].dt.strftime('%Y%m%d')

# change name of neighborhood group column to 'Borough'
df = df.rename(columns={'neighbourhood_group':'Borough'})

# Drop columns 'datetime' and 'date_formatted'
df = df.drop(columns=['datetime', 'date_formatted'])

# remove outliers and unrealistic values
df = df.drop(df[df['price'] >= 1000].index)
df = df.drop(df[df['minimum_nights'] > 365].index)
df = df.drop(df[df['calculated_host_listings_count'] > 50].index)
df = df.drop(df[df['reviews_per_month'] >25].index)

# create scatterplot showing average price per night by borough
# Calculate the average price for each borough
avg_price_by_borough = df.groupby('Borough')['price'].mean()

# Create the bar plot showing average price per night for each borough
plt.bar(avg_price_by_borough.index, avg_price_by_borough.values)
plt.xlabel("Borough")
plt.ylabel("Average Price per Night")
plt.title("Average Airbnb Price by Borough")
plt.xticks(rotation=45, ha='right')  # Rotate x-axis labels for better readability
plt.tight_layout()  # Adjust layout to prevent labels from overlapping
plt.show()

# create scatterplot showing the effect avg reviews per month has on price per night
plt.scatter(df['reviews_per_month'], df['price'], c='red', s=10)
plt.grid(True)
plt.xlabel('reviews per month')
plt.ylabel('price per Night')
plt.title('The Effect of AVG Reviews per Month on Price ')
plt.show()

# Create pie chart displaying percentage of each room type in the dataset
def autopct_format(values):
       def my_format(pct):
           total = sum(values)
           val = int(round(pct*total/100.0))
           return '{p:.2f}%\n({v:d})'.format(p=pct,v=val)
       return my_format

plt.pie(room_type_counts, labels=room_type_counts.index, autopct=autopct_format(room_type_counts), startangle=90)
plt.title('Room Type Distribution')
plt.legend(room_type_counts.index, title='Room Type', loc='best', bbox_to_anchor=(1, 0, 0.5, 1))
plt.show()
