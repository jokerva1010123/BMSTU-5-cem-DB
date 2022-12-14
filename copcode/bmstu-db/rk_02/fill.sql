INSERT INTO menu (id, name, mtype, description)
VALUES
(1, 'rus', 'breakfast', 'tasty breakfast'),
(2, 'gbr', 'breakfast', 'tasty breakfast'),
(3, 'deu', 'breakfast', 'tasty breakfast'),
(4, 'rus', 'lunch', 'tasty rus lunch'),
(5, 'deu', 'lunch', 'tasty deu lunch'),
(6, 'gbr', 'lunch', 'tasty gbr lunch'),
(7, 'rus', 'dinner', 'tasty dinner'),
(8, 'deu', 'dinner', 'tasty dinner'),
(9, 'gbr', 'dinner', 'tasty dinner'),
(10, 'aus', 'breakfast', 'tasty breakfast'),
(11, 'aus', 'dinner', 'tasty breakfast');

INSERT INTO dishes (id, name, description, rating)
VALUES
(1, 'soup #1', 'tasty soup 1 with many ingridients', 3),
(2, 'soup #2', 'tasty soup 2 with many ingridients', 7),
(3, 'soup #3', 'tasty soup 3 with many ingridients', 4),
(4, 'soup #4', 'tasty soup 4 with many ingridients', 5),
(5, 'soup #5', 'tasty soup 5 with many ingridients', 10),
(6, 'soup #6', 'tasty soup 6 with many ingridients', 1),
(7, 'soup #7', 'tasty soup 7 with many ingridients', 3),
(8, 'soup #8', 'tasty soup 8 with many ingridients', 6),
(9, 'soup #9', 'tasty soup 9 with many ingridients', 2),
(10, 'soup #10', 'tasty soup 10 with many ingridients', 4),
(11, 'soup #11', 'tasty soup 11 with many ingridients', 9);

INSERT INTO products (id, name, man_date, available_until, man_name)
VALUES
(1, 'potato', '2020-10-11', '2020-11-10', 'RusPotato'),
(2, 'tomato', '2020-10-12', '2020-12-10', 'RusTomato'),
(3, 'cucumber', '2020-10-13', '2020-12-20', 'RusCucumber'),
(4, 'salat', '2020-10-14', '2020-12-17', 'RusSalat'),
(5, 'ketchup', '2020-10-15', '2020-11-17', 'RusKetchup'),
(6, 'water', '2020-10-16', '2020-12-20', 'RusWater'),
(7, 'juice', '2020-10-17', '2020-12-21', 'RusJuice'),
(8, 'bacon', '2020-10-18', '2020-11-11', 'RusBacon'),
(9, 'sausage', '2020-10-19', '2020-12-13', 'RusSausage'),
(10, 'strawberry', '2020-10-20', '2020-11-30', 'RusStrawberry'),
(11, 'salt', '2020-10-21', '2020-11-09', 'RusSalt'),
(12, 'new', '2020-11-11', '2020-12-12', 'man');

INSERT INTO PD (did, pid)
VALUES
(1, 2),
(1, 4),
(1, 6),
(2, 1),
(2, 3),
(2, 5),
(3, 1),
(3, 2),
(3, 11),
(4, 10),
(5, 8),
(5, 9),
(5, 10),
(6, 9),
(6, 5),
(6, 6),
(7, 1),
(7, 7),
(7, 11),
(7, 5),
(7, 9),
(8, 11),
(9, 10),
(9, 1),
(9, 2),
(9, 3),
(9, 4),
(9, 5),
(9, 6),
(10, 7),
(10, 8),
(10, 9),
(10, 10),
(10, 11),
(11, 1),
(11, 3),
(11, 5),
(11, 7),
(11, 9);


INSERT INTO MD (mid, did)
VALUES
(1, 2),
(1, 3),
(1, 4),
(2, 4),
(2, 5),
(2, 6),
(2, 7),
(3, 7),
(3, 2),
(4, 2),
(4, 4),
(4, 6),
(4, 8),
(5, 1),
(6, 1),
(6, 2),
(6, 3),
(6, 4),
(6, 5),
(6, 6),
(7, 8),
(7, 9),
(7, 10),
(7, 11),
(8, 11),
(8, 10),
(9, 1),
(9, 2),
(9, 3),
(10, 1),
(10, 2),
(10, 11),
(11, 1),
(11, 5),
(11, 9);
