-- Step 1: Create the final export table
CREATE OR REPLACE TABLE transactions_final_export AS
SELECT
    transaction_id,
    product_id,
    product_type,
    product_detail,
    store_id,
    store_location,
    transaction_date,
    transaction_time,
    unit_price,
    total_amount,
    CASE
        WHEN product_type ILIKE '%food%' THEN 'Food'
        WHEN product_type ILIKE '%beverages%' THEN 'Beverage'
        ELSE 'Other'
    END AS product_category,
    CASE
        WHEN DATE_PART(HOUR, transaction_time) BETWEEN 6 AND 11 THEN 'Morning'
        WHEN DATE_PART(HOUR, transaction_time) BETWEEN 12 AND 16 THEN 'Afternoon'
        WHEN DATE_PART(HOUR, transaction_time) BETWEEN 17 AND 21 THEN 'Evening'
        ELSE 'Night'
    END AS time_of_day,
    CASE
        WHEN DAYOFWEEK(transaction_date) IN (1,7) THEN 'Weekend'
        ELSE 'Weekday'
    END AS day_type
FROM transactions_processed;

-- Step 2: Select and sort for Excel download
SELECT *
FROM transactions_final_export
ORDER BY transaction_date ASC, total_amount DESC;
