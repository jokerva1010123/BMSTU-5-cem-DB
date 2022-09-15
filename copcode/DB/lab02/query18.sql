-- 18. Простая инструкция UPDATE

update fs.inodes
set name = 'temp.txt'
where name = 'tmp.txt';
