-- ==========================================================
-- Fraud Detection Project - PostgreSQL Database Queries
-- ==========================================================

-- 1. Veri Tabanı ve Tablo Oluşturma (Transactions & Fraud Labels)
CREATE TABLE IF NOT EXISTS transactions (
    transaction_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    transaction_amount NUMERIC(10, 2) NOT NULL,
    transaction_time TIMESTAMP NOT NULL,
    merchant_category VARCHAR(50),
    is_fraud INT DEFAULT 0 -- 0: Normal, 1: Dolandırıcılık
);

-- 2. Temel Veri Keşfi ve İstatistikler
-- Toplam işlem sayısı ve dolandırıcılık oranı
SELECT 
    COUNT(*) AS total_transactions,
    SUM(is_fraud) AS total_fraud_transactions,
    ROUND(SUM(is_fraud)::DECIMAL / COUNT(*) * 100, 4) AS fraud_percentage
FROM transactions;

-- 3. Riskli İşlem Kategorilerini Analiz Etme
-- Hangi kategori en çok dolandırıcılık barındırıyor?
SELECT 
    merchant_category,
    COUNT(*) AS transaction_count,
    SUM(is_fraud) AS fraud_count,
    ROUND(AVG(transaction_amount), 2) AS avg_amount
FROM transactions
GROUP BY merchant_category
ORDER BY fraud_count DESC;

-- 4. Anomali Tespiti İçin Zaman Bazlı Filtreleme (Örn: Yüksek Tutarlı İşlemler)
SELECT