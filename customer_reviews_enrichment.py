import pandas as pd
import pyodbc
import nltk
from nltk.sentiment.vader import SentimentIntensityAnalyzer


#to fetch data from a SQL database
def fetch_data_from_sql():
    # the connection string
    conn_str = (
        "Driver={SQL Server};"  # Specify the driver for SQL Server
        "Server=DESKTOP-MV0G00C;"  # Specify your SQL Server instance
        "Database=MarketingAnalytics;"  # Specify the database name
        "Trusted_Connection=yes;"  # Use Windows Authentication for the connection
    )

    conn = pyodbc.connect(conn_str)
    
    query = "SELECT ReviewID, CustomerID, ProductID, ReviewDate, Rating, ReviewText FROM dbo.customer_reviews"
    
    df = pd.read_sql(query, conn)
    
    conn.close()
    
    return df

customer_reviews_df = fetch_data_from_sql()

sia = SentimentIntensityAnalyzer()

def calculate_sentiment(review):
    sentiment = sia.polarity_scores(review)
    return sentiment['compound']

def categorize_sentiment(score, rating):
    if score > 0.05:  # Positive sentiment score
        if rating >= 4:
            return 'Positive'  # High rating and positive sentiment
        elif rating == 3:
            return 'Mixed Positive'  # Neutral rating but positive sentiment
        else:
            return 'Mixed Negative'  # Low rating but positive sentiment
    elif score < -0.05:  # Negative sentiment score
        if rating <= 2:
            return 'Negative'  # Low rating and negative sentiment
        elif rating == 3:
            return 'Mixed Negative'  # Neutral rating but negative sentiment
        else:
            return 'Mixed Positive'  # High rating but negative sentiment
    else:  # Neutral sentiment score
        if rating >= 4:
            return 'Positive'  # High rating with neutral sentiment
        elif rating <= 2:
            return 'Negative'  # Low rating with neutral sentiment
        else:
            return 'Neutral'  # Neutral rating and neutral sentiment


def sentiment_bucket(score):
    if score >= 0.5:
        return '0.5 to 1.0'  # Strongly positive sentiment
    elif 0.0 <= score < 0.5:
        return '0.0 to 0.49'  # Mildly positive sentiment
    elif -0.5 <= score < 0.0:
        return '-0.49 to 0.0'  # Mildly negative sentiment
    else:
        return '-1.0 to -0.5'  # Strongly negative sentiment

customer_reviews_df['SentimentScore'] = customer_reviews_df['ReviewText'].apply(calculate_sentiment)

customer_reviews_df['SentimentCategory'] = customer_reviews_df.apply(
    lambda row: categorize_sentiment(row['SentimentScore'], row['Rating']), axis=1)

customer_reviews_df['SentimentBucket'] = customer_reviews_df['SentimentScore'].apply(sentiment_bucket)

print(customer_reviews_df.head())

customer_reviews_df.to_csv('fact_customer_reviews_with_sentiment.csv', index=False)
