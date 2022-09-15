copy sc1.composer (fullname, gender, lifeyear, nationality) from '/tmp/composer.csv'
	with delimiter ',';
	
copy sc1.composition (title, tonality, amount, composerid) from '/tmp/composition.csv'
	with delimiter ',';
	
copy sc1.student (fullname, gender, form, speciality) from '/tmp/student.csv'
	with delimiter ',';
	
copy sc1.teacher (fullname, gender, age, education) from '/tmp/teacher.csv'
	with delimiter ',';
	
copy sc1.exam (studentid, teacherid, compositionid, mark, date) from '/tmp/exam.csv'
	with delimiter ',';