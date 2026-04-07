-- Додаємо автомобілі
INSERT INTO cars (make, model, year, license_plate) VALUES
('Toyota', 'Camry', 2020, 'AA1234BB'),
('Ford', 'Transit', 2019, 'BC5678CX'),
('Mercedes-Benz', 'Sprinter', 2021, 'KA9012EE'),
('Renault', 'Kangoo', 2018, 'AI3456PP');

-- Додаємо водіїв
INSERT INTO drivers (first_name, last_name, license_number) VALUES
('Олександр', 'Коваленко', 'VOD123456'),
('Микола', 'Шевчук', 'VOD654321'),
('Дмитро', 'Бондаренко', 'VOD987654');

-- Додаємо поїздки
INSERT INTO trips (car_id, driver_id, trip_date, distance_km, duration_hours, fuel_consumed_l, is_late) VALUES
(1, 1, '2026-03-01', 150.5, 3.0, 12.5, FALSE),
(2, 2, '2026-03-05', 320.0, 5.5, 28.0, TRUE),
(1, 1, '2026-03-10', 100.0, 2.0, 8.0, FALSE),
(3, 3, '2026-03-12', 450.5, 7.0, 45.0, FALSE),
(2, 1, '2026-03-15', 50.0, 1.0, 5.0, TRUE),
(4, 2, '2026-03-20', 120.0, 2.5, 9.5, FALSE),
(1, 3, '2026-03-22', 200.0, 4.0, 16.0, FALSE),
(3, 3, '2026-04-01', 500.0, 8.0, 50.0, TRUE),
(4, 2, '2026-04-05', 80.0, 1.5, 6.5, FALSE);

-- Додаємо записи про технічне обслуговування
INSERT INTO maintenance (car_id, maintenance_date, description, status) VALUES
(1, '2026-02-15', 'Заміна масла та фільтрів', 'Завершено'),
(2, '2026-03-18', 'Ремонт гальмівної системи', 'Завершено'),
(3, '2026-04-06', 'Заміна шин', 'В процесі'),
(4, '2026-04-07', 'Діагностика двигуна', 'В процесі');