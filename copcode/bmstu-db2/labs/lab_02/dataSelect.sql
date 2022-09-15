-- 1 - предикат сравнения
-- произведения объемом меньше 10 страниц
select cp.fullname as name, title, tonality, amount
from sc1.composition c join sc1.composer cp on c.composerid = cp.id 
where c.amount < 10
order by name, title, amount

-- 2 - предикат between
-- ученики от 1 до 4 класса включительно
select fullname, form
from sc1.student s 
where s.form between 1 and 4
order by form

-- 3 - предикат like
-- учителя с музыкальным образованием
select fullname, age, education
from sc1.teacher t 
where t.education like '%музыкальное%'
order by fullname 

-- 4 - предикат in с вложенным подзапросом
-- учителя, отметки на экзаменах с которыми больше 3
select fullname
from sc1.teacher t 
where t.id in (
	select teacherid 
	from sc1.exam e 
	where e.mark > 3
)
order by fullname 

-- 5 - предикат exists с вложенным подзапросом
-- учениики, получившие на экзамене 5
select fullname, speciality
from sc1.student s 
where exists (
	select 1 
	from sc1.exam e 
	where e.studentid = s.id and e.mark = 5
)
order by fullname

-- 6 - предикат сравнения с квантором
-- учителя, возраст которых больше какого-то возраста учителя женщины с фамилиецй на А
select  fullname, gender, age
from sc1.teacher t1
where t1.age > any (
	select age 
	from sc1.teacher t2 
	where t2.gender = 'female' and t2.fullname like '%А%'
)
order by fullname 

-- 7 - аггрегатные функции в выражениях столбцов
-- средний возраст учителей
select avg(age) as ActualAVG, sum(age) / count(id) as CalcAVG
from sc1.teacher t

-- 8 - скалярные подзапросы в выражениях столбцов
-- композиции в тональности до, с учетом количества написавших их авторов
select title, tonality, (
	select count(fullname) 
	from sc1.composer c2 
	where c1.composerid = c2.id
) as authorCount
from sc1.composition c1
where c1.tonality like 'C%'
order by title

-- 9 - простое выражени case 
-- определение ученика/ученицы
select fullname, 
case gender
	when 'female' then 'ученица'
	else 'ученик'
end as type
from sc1.student s 
order by fullname 

-- 10 - поисковое выражение case
-- звенья классов учеников
select fullname,
case
	when form <= 3 then 'младшеклассница'
	when form <= 6 then 'средние классы'
	else 'старшеклассница'
end as type, form
from sc1.student s 
where s.gender = 'female'
order by form, fullname 

-- 11 - создание новой временной локальной таблицы из результирующего набора данных
-- студенты, сдавшие экзамены на 4 и лучше
select s.fullname as name, e.mark as mark
into studentMarks
from sc1.exam e join sc1.student s on e.studentid = s.id
where e.mark >= 4

select * 
from studentMarks sm
order by name

drop table studentMarks

-- 12 - вложенные коррелированные подзапросы в качестве производных таблиц в предложении from
-- композиторы и количество произведений, написанное ими
select c3.fullname , count
from (sc1.composition c join (
	select composerid as id, count(*)
	from sc1.composition c1
	group by composerid 
) as c2 on c.composerid = c2.id) as cc join sc1.composer c3 on cc.composerid = c3.id  
order by count desc

-- 13 - вложенные подзапросы с уровнем вложенности 3
-- композиции ныне живущих авторов, которые игрались на экзамене
select e.id as examNo, fullname as student, title as composition, mark
from sc1.exam e join sc1.student s on e.studentid = s.id join sc1.composition c on e.compositionid = c.id
where compositionid in (
	select id
	from sc1.composition c 
	group by id
	having composerid in (
		select id 
		from sc1.composer c2 
		where lifeyear like '%-'
	)
)
order by e.id

-- 14 - консолидирующая данные с помощью предложения group by, но без having
-- ученики и количество сданных ими экзаменов
select fullname, count(mark) as examCount
from sc1.exam e join sc1.student s on e.studentid = s.id
group by fullname
order by examCount desc, fullname

-- 15 - консолидирующая данные с помощью предложения group by с having
-- ученики, получившие разные оценки ща экзамены 
select fullname, avg(mark) as averageMark, min(mark) as minMark, max(mark) as maxMark
from sc1.exam e join sc1.student s on e.studentid = s.id
group by fullname
having max(mark) != min(mark)
order by fullname

-- 16 - insert вставка в таблицу одного значения
-- Моцарта в композитора
insert into sc1.composer (fullname, gender, lifeyear, nationality)
values ('Вольфганг Амадей Моцарт', 'male', '1756-1791', 'Германия')

select *
from sc1.composer c 
where c.fullname = 'Вольфганг Амадей Моцарт'

-- 17 - многострочная insert, вып. вставку в таблицу результирующего набора данных вложенного подзапроса
-- добавление в экзамены студентов старше 5 класса с учителем 378 и композицией объемом между 10 и 20 страницами с мин id
insert into sc1.exam (studentid, teacherid, compositionid, mark)
select id, 378, (
	select min(id) 
	from sc1.composition 
	where amount between 10 and 20
), 4
from sc1.student 
where form > 5

-- 18 - инструкция update 
-- увеличить в два раза объем произведений, написанных в мажоре
update sc1.composition 
set amount = amount * 2
where tonality like '%dur'

-- 19 - update со скалярным подзапросом в предложении set
-- сделать наибольшим возраст тех учителей, которые имеют высшее обраование и id < 100
update sc1.teacher
set age  = (
	select max(age) 
	from sc1.teacher
)
where id < 100 and education like 'высшее%'

-- 20 - delete
-- удалить из экзаменов двоешников с id < 10
delete from sc1.exam
where mark = 2 and studentid < 10

-- 21 - delete с вложенным коррелированным подзапросом в предложении where
-- удалить жкзамены, произведения к которым написал композитор 13
delete from sc1.exam 
where compositionid in (
	select compositionid 
	from sc1.exam e join sc1.composition c on e.compositionid = c.id
	where composerid = 13
)

-- 22 - простое обобщенное табличное выражение
with cn (form, numOfStudent) as (
	select form, count(*)
	from sc1.student s 
	group by s.form
)
select *
from cn
order by form

-- 23 - рекурсивное обобщенное табличное выражение
-- композиторы, которые работают учителями
with recursive teacherComposer (fullname, gender, lifeyear, rec) as (
	select fullname, gender, lifeyear, null
	from sc1.composer c 
	where lifeyear like '%-'
	union all
	select tc.fullname, tc.gender, tc.lifeyear, '1'
	from sc1.teacher t join teacherComposer as tc on t.fullname = tc.fullname where rec is null
)
select fullname as name, gender, lifeyear from teacherComposer as tc
order by fullname 

-- 24 - оконные функции. использование min max avg over 
select fullname, mark, avg(mark) over (partition by fullname) as averageMark
from sc1.exam e join sc1.student s on e.studentid = s.id
order by fullname

-- 25 - оконные функции для устранения дублей
update sc1.exam
set teacherid = 13, mark = 5
where studentid between 1 and 1000

update sc1.exam 
set studentid = 1
where teacherid = 13

select s.fullname as student, t.fullname as teacher, mark
from sc1.exam e join sc1.student s on e.studentid = s.id join sc1.teacher t on e.teacherid = t.id
order by student, teacher

delete from sc1.exam 
where id in (
	with tmp as (
		select id, studentid, teacherid, mark, row_number() over (partition by studentid, teacherid, mark) as n
		from sc1.exam 
	)
	select id
	from tmp
	where n > 1
)

-- кол-во сыгранных 'симфония 4' на экзаменах девочками с оценками от 4 до 5
select title, count(*)
from sc1.exam e join sc1.composition c on e.compositionid = c.id join sc1.student s on e.studentid = s.id 
where gender = 'female' and mark between 4 and 5 and title = 'Симфония №4'
group by title
