-- 1. ADIM: Çalışma için kopya bir tablo oluşturma
-- Orijinal veriyi bozmamak için her zaman bir kopya ile çalışın.
CREATE TABLE layofsskopya LIKE layoffs;
INSERT INTO layofsskopya SELECT * FROM layoffs;

-- 2. ADIM: Mükerrer (Duplicate) Kayıtların Temizlenmesi
-- Tüm sütunları aynı olan satırları tespit edip sadece birini bırakıyoruz.
WITH duplicate_cte AS (
    SELECT *,
    ROW_NUMBER() OVER(
        PARTITION BY company, location, industry, total_laid_off, 
                     percentage_laid_off, `date`, stage, country, funds_raised_millions
    ) AS row_num
    FROM layofsskopya
)
DELETE FROM layofsskopya
WHERE (company, location, `date`) IN (
    SELECT company, location, `date` 
    FROM duplicate_cte 
    WHERE row_num > 1
);

-- 3. ADIM: Veri Standardizasyonu (Gereksiz Boşluklar ve Yazım Hataları)
-- Şirket isimlerindeki boşlukları temizleyelim
UPDATE layofsskopya
SET company = TRIM(company);

-- Industry (Sektör) sütunundaki tutarsızlıkları düzeltme (Örn: Crypto, CryptoCurrency)
UPDATE layofsskopya
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';

-- Ülke isimlerindeki hataları düzeltme (Örn: 'United States.' -> 'United States')
UPDATE layofsskopya
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';

-- 4. ADIM: Tarih Formatını Düzelme
-- Metin formatındaki tarihleri (3/6/2023) SQL tarih formatına (YYYY-MM-DD) çevirme
UPDATE layofsskopya
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

-- Sütun tipini metinden (text/varchar) gerçek DATE tipine çevirme
ALTER TABLE layofsskopya
MODIFY COLUMN `date` DATE;

-- 5. ADIM: Eksik (Null) Verilerle Başa Çıkma
-- Industry sütunu boş olanları, aynı şirketin diğer kayıtlarına bakarak doldurma
UPDATE layofsskopya t1
JOIN layofsskopya t2
    ON t1.company = t2.company
SET t1.industry = t2.industry
WHERE t1.industry IS NULL 
AND t2.industry IS NOT NULL;

-- 6. ADIM: Gereksiz Verileri Silme
-- Hem işten çıkarılan kişi sayısı hem de yüzdesi boş olan veriler analiz için kullanışsızdır
DELETE FROM layofsskopya
WHERE total_laid_off IS NULL
AND percentage_laid_off IS NULL;

-- SONUÇ: Temizlenmiş veriyi görüntüleme
SELECT * FROM layofsskopya;