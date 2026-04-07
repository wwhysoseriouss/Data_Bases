-- 1. Які автомобілі є в автопарку? [cite: 247]
SELECT make, model, year, license_plate 
FROM cars;

-- 2. Скільки пробігів в середньому мають всі автомобілі автопарку? [cite: 248]
-- Використовуємо агрегатну функцію AVG
SELECT ROUND(AVG(distance_km), 2) AS average_trip_distance 
FROM trips;

-- 3. Які записи містять інформацію про технічне обслуговування автомобіля? [cite: 249]
-- Використовуємо JOIN для об'єднання таблиць
SELECT c.make, c.model, c.license_plate, m.maintenance_date, m.description, m.status
FROM maintenance m
JOIN cars c ON m.car_id = c.car_id;

-- 4. Які автомобілі мають найбільшу кількість запізнень на перевезення? [cite: 250]
-- Використовуємо JOIN, WHERE, GROUP BY, HAVING, ORDER BY та COUNT
SELECT c.make, c.model, COUNT(t.trip_id) AS late_count
FROM trips t
JOIN cars c ON t.car_id = c.car_id
WHERE t.is_late = TRUE
GROUP BY c.make, c.model
HAVING COUNT(t.trip_id) > 0
ORDER BY late_count DESC;

-- 5. Скільки автомобілів знаходиться в технічному обслуговуванні? [cite: 251]
SELECT COUNT(DISTINCT car_id) AS cars_in_maintenance
FROM maintenance
WHERE status = 'В процесі';

-- 6. Які водії використовували певні автомобілі найчастіше? [cite: 252]
SELECT d.last_name, d.first_name, c.make, c.model, COUNT(t.trip_id) AS usage_count
FROM trips t
JOIN drivers d ON t.driver_id = d.driver_id
JOIN cars c ON t.car_id = c.car_id
GROUP BY d.last_name, d.first_name, c.make, c.model
ORDER BY usage_count DESC;

-- 7. Яка середня витрата пального на один автомобіль? [cite: 253]
SELECT c.license_plate, c.make, ROUND(AVG(t.fuel_consumed_l), 2) AS avg_fuel_consumed
FROM trips t
JOIN cars c ON t.car_id = c.car_id
GROUP BY c.license_plate, c.make;

-- 8. Яка кількість годин кожен автомобіль знаходиться в русі? [cite: 254]
-- Використовуємо агрегатну функцію SUM
SELECT c.make, c.model, c.license_plate, SUM(t.duration_hours) AS total_hours_driven
FROM trips t
JOIN cars c ON t.car_id = c.car_id
GROUP BY c.make, c.model, c.license_plate;

-- 9. Які автомобілі мають найбільший пробіг? [cite: 255]
SELECT c.make, c.model, SUM(t.distance_km) AS total_distance
FROM trips t
JOIN cars c ON t.car_id = c.car_id
GROUP BY c.make, c.model
ORDER BY total_distance DESC;

-- 10. Яка кількість обслуговуваних автомобілів за певний місяць (наприклад, березень 2026)? [cite: 256]
SELECT COUNT(maintenance_id) AS maintenance_count_march
FROM maintenance
WHERE maintenance_date >= '2026-03-01' AND maintenance_date <= '2026-03-31';