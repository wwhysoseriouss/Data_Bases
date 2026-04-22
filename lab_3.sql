-- Лабораторна робота №3
-- З дисципліни: Бази даних та інформаційні системи
-- Студент: Богдан Вячеслав (група MIT-31)
-- Тема: Складні SQL-запити (Система керування автопарком)

/* =========================================================================
   ЧАСТИНА 1: Логічні оператори (AND, OR, NOT, IN, BETWEEN, LIKE)
   ========================================================================= */

-- Запит 1. Отримати всі поїздки, які довші за 100 км ТА (AND) були завершені без запізнень
SELECT * FROM trips WHERE distance_km > 100 AND is_late = FALSE;

-- Запит 2. Знайти автомобілі, випущені у 2019 АБО (OR) 2021 році
SELECT make, model, year FROM cars WHERE year = 2019 OR year = 2021;

-- Запит 3. Отримати водіїв, чиє ім'я починається на літеру 'О' (використання LIKE)
SELECT first_name, last_name FROM drivers WHERE first_name LIKE 'О%';

-- Запит 4. Знайти поїздки, де витрата пального НЕ (NOT) ЗНАХОДИТЬСЯ В МЕЖАХ (BETWEEN) 10 та 30 літрів
SELECT trip_id, fuel_consumed_l FROM trips WHERE fuel_consumed_l NOT BETWEEN 10 AND 30;

-- Запит 5. Вибрати автомобілі, марка яких чітко входить у визначений список (IN)
SELECT * FROM cars WHERE make IN ('Toyota', 'Ford');

/* =========================================================================
   ЧАСТИНА 2: Агрегатні функції (COUNT, SUM, AVG, MIN, MAX)
   ========================================================================= */

-- Запит 6. Підрахувати загальну кількість зареєстрованих водіїв (COUNT)
SELECT COUNT(driver_id) AS total_drivers FROM drivers;

-- Запит 7. Обчислити загальну дистанцію, пройдену всім автопарком (SUM)
SELECT SUM(distance_km) AS fleet_total_distance FROM trips;

-- Запит 8. Знайти середню тривалість поїздок, згруповану за автомобілями (AVG)
SELECT car_id, AVG(duration_hours) AS avg_duration FROM trips GROUP BY car_id;

-- Запит 9. Знайти мінімальну витрату пального, зафіксовану за одну поїздку (MIN)
SELECT MIN(fuel_consumed_l) AS min_fuel_used FROM trips;

-- Запит 10. Знайти максимальну дистанцію однієї поїздки для кожного водія, де ця дистанція більша за 150 км (MAX + HAVING)
SELECT driver_id, MAX(distance_km) AS max_distance 
FROM trips 
GROUP BY driver_id 
HAVING MAX(distance_km) > 150;

/* =========================================================================
   ЧАСТИНА 3: Всі типи з'єднань (JOIN)
   ========================================================================= */

-- Запит 11. INNER JOIN: З'єднати поїздки з відповідними водіями (лише ті, що мають збіги)
SELECT t.trip_id, d.first_name, d.last_name, t.distance_km 
FROM trips t
INNER JOIN drivers d ON t.driver_id = d.driver_id;

-- Запит 12. LEFT JOIN: Вивести всі автомобілі та їхні записи про технічне обслуговування (навіть якщо ремонтів не було)
SELECT c.make, c.model, m.description 
FROM cars c
LEFT JOIN maintenance m ON c.car_id = m.car_id;

-- Запит 13. RIGHT JOIN: Вивести всі поїздки, гарантуючи приєднання даних про водіїв (де вони доступні)
SELECT d.last_name, t.trip_date, t.distance_km
FROM drivers d
RIGHT JOIN trips t ON d.driver_id = t.driver_id;

-- Запит 14. FULL OUTER JOIN: Об'єднати всі автомобілі та всі записи про технічне обслуговування (включаючи ті, що не мають збігів)
SELECT c.license_plate, m.status, m.maintenance_date
FROM cars c
FULL OUTER JOIN maintenance m ON c.car_id = m.car_id;

-- Запит 15. CROSS JOIN: Створити матрицю всіх можливих комбінацій "автомобіль-водій" (кожен з кожним)
SELECT c.make, d.last_name 
FROM cars c
CROSS JOIN drivers d;

-- Запит 16. SELF JOIN: Знайти автомобілі, випущені в один і той самий рік (з'єднання таблиці самої з собою)
SELECT c1.make AS car1, c2.make AS car2, c1.year
FROM cars c1
JOIN cars c2 ON c1.year = c2.year AND c1.car_id != c2.car_id;

/* =========================================================================
   ЧАСТИНА 4: Складні підзапити (Subqueries: WHERE, IN, EXISTS)
   ========================================================================= */

-- Запит 17. Підзапит у WHERE: Знайти поїздки, які довші за середню дистанцію всіх поїздок
SELECT trip_id, distance_km 
FROM trips 
WHERE distance_km > (SELECT AVG(distance_km) FROM trips);

-- Запит 18. Підзапит з IN: Знайти водіїв, які хоча б раз керували автомобілем марки 'Toyota'
SELECT first_name, last_name FROM drivers 
WHERE driver_id IN (
    SELECT driver_id FROM trips WHERE car_id IN (
        SELECT car_id FROM cars WHERE make = 'Toyota'
    )
);

-- Запит 19. Підзапит з NOT IN: Знайти автомобілі, які жодного разу не були на технічному обслуговуванні
SELECT make, model, license_plate FROM cars 
WHERE car_id NOT IN (SELECT car_id FROM maintenance);

-- Запит 20. Підзапит з EXISTS: Знайти водіїв, які мають хоча б одну поїздку із запізненням
SELECT first_name, last_name FROM drivers d
WHERE EXISTS (
    SELECT 1 FROM trips t WHERE t.driver_id = d.driver_id AND t.is_late = TRUE
);

-- Запит 21. Підзапит з NOT EXISTS: Знайти автомобілі, для яких не зафіксовано жодної поїздки
SELECT make, license_plate FROM cars c
WHERE NOT EXISTS (
    SELECT 1 FROM trips t WHERE t.car_id = c.car_id
);

-- Запит 22. Глибоко вкладений підзапит (складний рівень): Знайти водіїв, які керували авто, що зараз знаходяться 'В процесі' ремонту
SELECT first_name, last_name FROM drivers 
WHERE driver_id IN (
    SELECT driver_id FROM trips WHERE car_id IN (
        SELECT car_id FROM maintenance WHERE status = 'В процесі'
    )
);

-- Запит 23. Підзапит у блоці SELECT: Вивести деталі автомобілів разом із загальною кількістю їхніх поїздок (зв'язаний підзапит)
SELECT make, model, 
    (SELECT COUNT(*) FROM trips t WHERE t.car_id = c.car_id) AS total_trips_made
FROM cars c;

/* =========================================================================
   ЧАСТИНА 5: Операції над множинами (UNION, INTERSECT, EXCEPT)
   ========================================================================= */

-- Запит 24. UNION: Об'єднати ID авто, які мали поїздки, ТА ID авто, які були на ремонті (без дублікатів)
SELECT car_id FROM trips
UNION
SELECT car_id FROM maintenance;

-- Запит 25. INTERSECT (Перетин): Знайти авто, які мають ЯК зафіксовані поїздки, ТАК І записи про ремонти
SELECT car_id FROM trips
INTERSECT
SELECT car_id FROM maintenance;

-- Запит 26. EXCEPT (Різниця): Знайти авто, які мають зафіксовані поїздки, АЛЕ ЖОДНОГО РАЗУ не були на ремонті
SELECT car_id FROM trips
EXCEPT
SELECT car_id FROM maintenance;

/* =========================================================================
   ЧАСТИНА 6: Common Table Expressions (CTE - Узагальнені табличні вирази)
   ========================================================================= */

-- Запит 27. Просте CTE: Обчислити середню дистанцію та вибрати поїздки, що її перевищують
WITH AvgDistance AS (
    SELECT AVG(distance_km) AS avg_dist FROM trips
)
SELECT trip_id, distance_km FROM trips, AvgDistance WHERE distance_km > avg_dist;

-- Запит 28. CTE для агрегації даних: Порахувати загальну витрату пального на кожного водія
WITH DriverFuel AS (
    SELECT driver_id, SUM(fuel_consumed_l) AS total_fuel FROM trips GROUP BY driver_id
)
SELECT d.last_name, df.total_fuel FROM drivers d
JOIN DriverFuel df ON d.driver_id = df.driver_id;

-- Запит 29. Кілька CTE: Знайти водіїв, які керували автомобілями, що мали хоча б один ремонт
WITH CarMaintenanceCount AS (
    SELECT car_id, COUNT(*) AS maint_count FROM maintenance GROUP BY car_id
),
HighMaintCars AS (
    SELECT car_id FROM CarMaintenanceCount WHERE maint_count >= 1
)
SELECT DISTINCT d.last_name 
FROM drivers d
JOIN trips t ON d.driver_id = t.driver_id
JOIN HighMaintCars hmc ON t.car_id = hmc.car_id;

-- Запит 30. CTE для підготовки даних (сумарна дистанція по авто)
WITH TripData AS (
    SELECT car_id, distance_km FROM trips
)
SELECT car_id, SUM(distance_km) AS total_distance FROM TripData GROUP BY car_id;

-- Запит 31. CTE для ідентифікації "проблемних" поїздок (із запізненням та великою витратою пального)
WITH ProblematicTrips AS (
    SELECT * FROM trips WHERE is_late = TRUE AND fuel_consumed_l > 20
)
SELECT p.trip_id, c.make FROM ProblematicTrips p JOIN cars c ON p.car_id = c.car_id;

-- Запит 32. CTE для визначення "активного автопарку" (автомобілі з поїздками після певної дати)
WITH ActiveFleet AS (
    SELECT DISTINCT car_id FROM trips WHERE trip_date >= '2026-01-01'
)
SELECT c.make, c.license_plate FROM cars c JOIN ActiveFleet af ON c.car_id = af.car_id;

-- Запит 33. CTE для форматування звіту (генерація повного імені водія для подальшої агрегації)
WITH DriverReport AS (
    SELECT d.first_name || ' ' || d.last_name AS full_name, t.distance_km
    FROM drivers d JOIN trips t ON d.driver_id = t.driver_id
)
SELECT full_name, SUM(distance_km) AS total_distance_by_driver FROM DriverReport GROUP BY full_name;

/* =========================================================================
   ЧАСТИНА 7: Віконні функції (Window Functions)
   ========================================================================= */

-- Запит 34. ROW_NUMBER(): Призначити унікальний порядковий номер поїздкам кожного водія у хронологічному порядку
SELECT trip_id, driver_id, trip_date,
       ROW_NUMBER() OVER(PARTITION BY driver_id ORDER BY trip_date) as trip_sequence
FROM trips;

-- Запит 35. RANK(): Скласти рейтинг водіїв на основі загальної пройденої ними дистанції
WITH DriverTotals AS (
    SELECT driver_id, SUM(distance_km) as total_dist FROM trips GROUP BY driver_id
)
SELECT driver_id, total_dist,
       RANK() OVER(ORDER BY total_dist DESC) as distance_rank
FROM DriverTotals;

-- Запит 36. DENSE_RANK(): Скласти рейтинг автомобілів за віком (роком випуску, без пропусків у ранжируванні)
SELECT make, model, year,
       DENSE_RANK() OVER(ORDER BY year DESC) as age_rank
FROM cars;

-- Запит 37. LAG(): Порівняти дистанцію поточної поїздки з дистанцією попередньої поїздки для того ж автомобіля
SELECT trip_id, car_id, trip_date, distance_km,
       LAG(distance_km) OVER(PARTITION BY car_id ORDER BY trip_date) as prev_trip_dist
FROM trips;

-- Запит 38. LEAD(): Побачити дату наступної поїздки (якщо є) для конкретного водія
SELECT trip_id, driver_id, trip_date,
       LEAD(trip_date) OVER(PARTITION BY driver_id ORDER BY trip_date) as next_trip_date
FROM trips;

-- Запит 39. SUM() OVER(): Обчислити наростаючий підсумок пройденої дистанції (сума накопиченням) для кожного автомобіля
SELECT trip_id, car_id, trip_date, distance_km,
       SUM(distance_km) OVER(PARTITION BY car_id ORDER BY trip_date) as running_total_distance
FROM trips;

-- Запит 40. AVG() OVER(): Порівняти витрату пального в конкретній поїздці із загальним середнім показником цього ж автомобіля
SELECT trip_id, car_id, fuel_consumed_l,
       ROUND(AVG(fuel_consumed_l) OVER(PARTITION BY car_id), 2) as overall_avg_fuel_for_car
FROM trips;

-- Кінець файлу лабораторної роботи №3
