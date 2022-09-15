create table if not exists parent
(id_parent serial primary key not null,
 full_name varchar(50) not null,
 phone nchar(18) not null,
 gender nchar(3) not null,
 address varchar(100) not null
);

create table if not exists groupp
(id_group serial primary key not null,
 name varchar(50) not null,
 type varchar(20) not null
);

create table if not exists child
(id_child serial primary key not null,
 id_group int,
 foreign key (id_group) references groupp(id_group),
 full_name varchar(50) not null,
 dob date not null,
 gender nchar(3) not null
);

create table if not exists institution
(id_institution serial primary key not null,
 name varchar(50) not null,
 phone nchar(18) not null,
 address varchar(100) not null,
 max_num_of_seats int not null
);

create table if not exists contract
(id_contract serial primary key not null,
 id_institution int not null,
 id_parent int not null,
 id_child int not null,
 foreign key (id_institution) references institution(id_institution),
 foreign key (id_parent) references parent(id_parent),
 foreign key (id_child) references child(id_child),
 date_of_conclusion date not null,
 training_period interval not null,
 service_cost numeric(10,2) not null
);

create table if not exists employee
(id_employee serial primary key not null,
 id_institution int not null,
 foreign key (id_institution) references institution(id_institution),
 full_name varchar(50) not null,
 func varchar(25) not null,
 dob date not null,
 gender nchar(3) not null,
 phone nchar(18) not null,
 experience interval not null,
 education varchar(100) not null
);

create table if not exists employee_group
(id_employee int not null,
 id_group int not null,
 foreign key (id_employee) references employee(id_employee),
 foreign key (id_group) references groupp(id_group)
);

