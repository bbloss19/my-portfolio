# import necessary libraries 
# import amazon_sales.csv
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('amazon_sales.csv')
df.head()

# drop duplicate rows
df = df.drop_duplicates()
df

#drop irrelevant columns
df.drop(columns=['review_id', 'img_link', 'product_link', 'user_name', 'review_title', 'about_product', 'review_content', 'user_id'], inplace=True)
df

# Clean category column and split primary category from rest of string
df["primary_category"] = df["category"].str.split("|", expand=True)[0]
df

# Drop category column
df.drop(columns=['category'], inplace=True)
df

#Remove Indian Rupee symbol from discounted price
df["discounted_price"] = df["discounted_price"].str.strip("₹")
df

#Remove Indian Rupee symbol from actual price
df["actual_price"] = df["actual_price"].str.strip("₹")
df

#convert discount price to USD
#Exchange rate = .012
df["discounted_price"] = df["discounted_price"].str.replace(',', '').astype(float) * 0.012
df

# convert actual price to USD
# Exchange rate = 0.012
df["actual_price"] = df["actual_price"].str.replace(',', '').astype(float) * 0.012
df

# round discounted price to two decimal places
df["discounted_price"] = df["discounted_price"].round(2)
df

# round actual price to two decimal places
df["actual_price"] = df["actual_price"].round(2)
df

order = ['product_id', 'product_name', 'primary_category', 'discounted_price', 'actual_price', 'discount_percentage', 'rating', 'rating_count']
df = df[order]

# display first 50 results
df.head(50)
