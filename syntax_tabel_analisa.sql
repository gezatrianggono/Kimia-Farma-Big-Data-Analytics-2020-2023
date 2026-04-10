-- Membuat tabel baru bernama 'tabel_analisa' di dalam dataset 'kimia_farma'
CREATE OR REPLACE TABLE `rakamin-kf-analytics-490915.kimia_farma.tabel_analisa` AS

-- 1. Meng-aggregasi tabel inventory sebelum join (Optimalisasi Biaya & Mencegah Fan-out)
WITH inventory_unique AS (
  SELECT 
    branch_id, 
    product_id
  FROM `rakamin-kf-analytics-490915.kimia_farma.kf_inventory`
  GROUP BY branch_id, product_id
),

-- 2. Tahap Ekstraksi & Join (Mengambil data mentah dengan aman)
raw_data AS (
  SELECT
    CAST(t.transaction_id AS STRING) AS transaction_id,
    CAST(t.date AS DATE) AS date, 
    CAST(t.branch_id AS STRING) AS branch_id,
    c.branch_name,
    c.kota,
    c.provinsi,
    c.rating AS rating_cabang,
    t.customer_name,
    CAST(t.product_id AS STRING) AS product_id,
    p.product_name,
    CAST(t.price AS FLOAT64) AS actual_price,
    CAST(t.discount_percentage AS FLOAT64) AS discount_percentage,
    CAST(t.rating AS FLOAT64) AS rating_transaksi
  FROM `rakamin-kf-analytics-490915.kimia_farma.kf_final_transaction` AS t
  LEFT JOIN `rakamin-kf-analytics-490915.kimia_farma.kf_kantor_cabang` AS c 
    ON t.branch_id = c.branch_id
  LEFT JOIN `rakamin-kf-analytics-490915.kimia_farma.kf_product` AS p 
    ON t.product_id = p.product_id
  LEFT JOIN inventory_unique AS i 
    ON t.branch_id = i.branch_id AND t.product_id = i.product_id
),

-- 3. Tahap Data Cleaning (Membersihkan teks dan menangani Null)
cleaned_data AS (
  SELECT
    transaction_id,
    date,
    branch_id,      
    INITCAP(TRIM(branch_name)) AS branch_name, 
    INITCAP(TRIM(kota)) AS kota,
    INITCAP(TRIM(provinsi)) AS provinsi,
    COALESCE(rating_cabang, 0.0) AS rating_cabang,
    INITCAP(TRIM(customer_name)) AS customer_name,
    product_id,     
    INITCAP(TRIM(product_name)) AS product_name,
    COALESCE(actual_price, 0.0) AS actual_price,
    COALESCE(discount_percentage, 0.0) AS discount_percentage,
    COALESCE(rating_transaksi, 0.0) AS rating_transaksi
  FROM raw_data
)

-- 4. Tahap Transformasi Finansial (Metrik Utama)
SELECT 
  transaction_id,
  date,
  branch_id,
  branch_name,
  kota,
  provinsi,
  rating_cabang,
  customer_name,
  product_id,
  product_name,
  actual_price,
  discount_percentage,
  
  CASE
    WHEN actual_price <= 50000 THEN 0.10
    WHEN actual_price > 50000 AND actual_price <= 100000 THEN 0.15
    WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
    WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
    WHEN actual_price > 500000 THEN 0.30
  END AS persentase_gross_laba,
  
  actual_price - (actual_price * discount_percentage) AS nett_sales,
  
  ROUND(
    (actual_price - (actual_price * discount_percentage)) * CASE
      WHEN actual_price <= 50000 THEN 0.10
      WHEN actual_price > 50000 AND actual_price <= 100000 THEN 0.15
      WHEN actual_price > 100000 AND actual_price <= 300000 THEN 0.20
      WHEN actual_price > 300000 AND actual_price <= 500000 THEN 0.25
      WHEN actual_price > 500000 THEN 0.30
    END, 
  2) AS nett_profit,
  
  rating_transaksi

FROM cleaned_data;
