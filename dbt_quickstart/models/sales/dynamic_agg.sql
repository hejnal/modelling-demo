{{
  config(
    materialized = "view"
  )
}}

{%- set columns = adapter.get_columns_in_relation(source("prod_raw", "sales_data")) -%}

WITH daily_orders AS (
SELECT
  DATE(orderdate) AS order_date, 
  PRODUCTLINE AS product_line,
  {% for c in columns %}
    {% if c.is_float() %}
        ROUND(SUM({{ c.column }}), 1) AS {{ c.column }}_value,
    {% endif %}
  {% endfor %}
FROM
  {{ source("prod_raw", "sales_data") }}
WHERE
  STATUS = "Shipped"
{{ dbt_utils.group_by(2) }} )
SELECT order_date, product_line, sales_value, 
ROUND(SUM(sales_value) OVER (ORDER BY DATE(order_date) ROWS BETWEEN 7 PRECEDING AND CURRENT ROW  ), 1) AS rolling_average
FROM daily_orders
ORDER BY 1 DESC
