-- Tworzy tabelę pracownik(imie, nazwisko, wyplata, data urodzenia, stanowisko). W tabeli mogą być dodatkowe kolumny, które uznasz za niezbędne.
CREATE TABLE employee (
id INT PRIMARY KEY AUTO_INCREMENT,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
salary DECIMAL(7,2) NOT NULL,
birth_date DATE NOT NULL,
work_position VARCHAR(50) NOT NULL
);

-- Wstawia do tabeli co najmniej 6 pracowników
INSERT INTO 
	employee (first_name, last_name, salary, birth_date, work_position)
VALUES
	('Anna', 'Noakowska', 6500.50, '1997-02-21', 'Starsza księgowa'),
	('Janina', 'Dokładna', 3500.90, '1988-11-05', 'Pracownik usług czystościowych'),
	('Andrzej', 'Piorun', 7350.50, '1953-03-11', 'Elektryk'),
	('Wiesław', 'Bogacki', 15500.00, '1974-08-01', 'Dyrektor'),
	('Jan', 'Kowalski', 4830.30, '1974-08-01', 'Dozorca'),
	('Teresa', 'Wrońska', 5260.00, '1954-09-05', 'Specjalista obsługi klienta')
;

-- Pobiera wszystkich pracowników i wyświetla ich w kolejności alfabetycznej po nazwisku
SELECT * FROM employee ORDER BY last_name ASC;

-- Pobiera pracowników na wybranym stanowisku
SELECT * FROM employee WHERE work_position = 'Elektryk';

-- Pobiera pracowników, którzy mają co najmniej 30 lat
SELECT * FROM employee WHERE year(current_date()) - year(birth_date) >= 30;

-- Zwiększa wypłatę pracowników na wybranym stanowisku o 10%
CREATE TEMPORARY TABLE TempTable AS
SELECT id FROM employee WHERE work_position = 'Elektryk';
UPDATE 
	employee
SET 
	salary = salary + (salary * 0.1)
WHERE 
	id IN (SELECT id FROM TempTable)
;
DROP TEMPORARY TABLE TempTable;

-- Pobiera najmłodszego pracowników (uwzględnij przypadek, że może być kilku urodzonych tego samego dnia)
SELECT * FROM employee WHERE birth_date = (SELECT MAX(birth_date) FROM employee);

-- Usuwa tabelę pracownik
DROP TABLE IF EXISTS employee;

-- Tworzy tabelę stanowisko (nazwa stanowiska, opis, wypłata na danym stanowisku)
CREATE TABLE work_position (
id INT PRIMARY KEY AUTO_INCREMENT,
position_name VARCHAR(30) NOT NULL,
description VARCHAR(200) NOT NULL,
salary DECIMAL(7,2) NOT NULL
);

-- Tworzy tabelę adres (ulica+numer domu/mieszkania, kod pocztowy, miejscowość)
CREATE TABLE address (
id INT PRIMARY KEY AUTO_INCREMENT,
street VARCHAR(30) NOT NULL,
house_number VARCHAR(10) NOT NULL,
postal_code VARCHAR(6) NOT NULL,
city VARCHAR(30) NOT NULL
);

-- Tworzy tabelę pracownik (imię, nazwisko) + relacje do tabeli stanowisko i adres
CREATE TABLE employee (
id INT PRIMARY KEY AUTO_INCREMENT,
address_id INT NOT NULL,
work_position_id INT NOT NULL,
first_name VARCHAR(30) NOT NULL,
last_name VARCHAR(30) NOT NULL,
FOREIGN KEY (address_id) REFERENCES address (id),
FOREIGN KEY (work_position_id) REFERENCES work_position (id)
);

-- Dodaje dane testowe (w taki sposób, aby powstały pomiędzy nimi sensowne powiązania)
INSERT INTO address
	(street, house_number, postal_code, city)
VALUES
	('Ludowa', '28B', '00-666', 'Pcim'),
	('Bojowa', '2', '91-123', 'Kozia Wólka'),
	('Miła', '5c', '41-021', 'Bytom'),
	('Dziurawa', '4/4', '15-200', 'Wąchock')
;
INSERT INTO work_position
	(position_name, description, salary)
VALUES
	('Elektryk', 'Wykonuje prace montażowe i demontażowe, instalacyjne i eksploatacyjne, konserwacje i remonty, dokonuje pomiarów w firmie.', 7350.50),
	('Dyrektor', 'Zarządza przedsiębiorstwem, organizuje jego działalność, wytycza strategię rozwoju oraz reprezentuje firmę na zewnątrz.', 15500.00),
	('Starsza księgowa', 'Kompleksowa obsługa jednego lub kilku obszarów księgowych, przygotowanie raportów i sprawozdań finansowych na potrzeby zarządu firmy.', 6500.30)
;
INSERT INTO employee
	(address_id, work_position_id, first_name, last_name)
VALUES
	(1, 3, 'Anna', 'Noakowska'),
	(2, 3, 'Janina', 'Dokładna'),
	(4, 1, 'Andrzej', 'Piorun'),
	(3, 2, 'Wiesław', 'Bogacki'),
	(2, 1, 'Jan', 'Kowalski'),
	(4, 3, 'Teresa', 'Wrońska')
;

-- Pobiera pełne informacje o pracowniku (imię, nazwisko, adres, stanowisko)
SELECT
	first_name, last_name, street, house_number, postal_code, city, position_name, description, salary
FROM
	employee e
	LEFT JOIN address a ON e.address_id = a.id
	LEFT JOIN work_position wp ON e.work_position_id = wp.id
;

-- Oblicza sumę wypłat dla wszystkich pracowników w firmie
SELECT SUM(salary) FROM employee e JOIN work_position wp ON e.work_position_id = wp.id;

-- Pobiera pracowników mieszkających w lokalizacji z kodem pocztowym 90210 (albo innym, który będzie miał sens dla Twoich danych testowych)
SELECT * FROM employee e JOIN address a ON e.address_id = a.id WHERE postal_code = '15-200';
