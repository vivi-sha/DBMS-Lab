
create table Branch (branch_name varchar(30), branch_city varchar(20), assets real, primary key(branch_name));
create table BankAccount (accno int, branch_name varchar(30), balance real,
primary key (accno),
foreign key (branch_name) references Branch(branch_name));
create table BankCustomer (customer_name varchar(20), customer_street varchar(20),customer_city varchar(20),primary key(customer_name));
create table Depositer(customer_name varchar(20), accno int, 
primary key(customer_name, accno),
foreign key (customer_name) references BankCustomer(customer_name),
foreign key (accno) references BankAccount(accno));
create table LOAN (loan_number int, branch_name varchar(30), amount real,
primary key(loan_number),
foreign key (branch_name) references Branch(branch_name));
create table Borrower (customer_name varchar(20), loan_number int, 
foreign key (customer_name) references bankcustomer(customer_name),
foreign key (loan_number) references LOAN(loan_number));

insert into Branch values('SBI_Chamrajpet','Bangalore',50000);
insert into Branch values('SBI_ResidencyRoad','Bangalore',10000);
insert into Branch values('SBI_ShivajiRoad','Bombay',20000);
insert into Branch values('SBI_ParliamentRoad','Delhi',10000);
insert into Branch values('SBI_Jantarmantar','Delhi',20000);
insert into Branch values('SBI_MantriMarg','Delhi',200000);

insert into BankAccount values(1,'SBI_Chamrajpet',2000);
insert into BankAccount values(2,'SBI_ResidencyRoad',5000);
insert into BankAccount values(3,'SBI_ShivajiRoad',6000);
insert into BankAccount values(4,'SBI_ParliamentRoad',9000);
insert into BankAccount values(5,'SBI_Jantarmantar',8000);
insert into BankAccount values(6,'SBI_ShivajiRoad',4000);
insert into BankAccount values(8,'SBI_ResidencyRoad',4000);
insert into BankAccount values(9,'SBI_ParliamentRoad',3000);
insert into BankAccount values(10,'SBI_ResidencyRoad',5000);
insert into BankAccount values(11,'SBI_Jantarmantar',2000);
insert into BankAccount values(12,'SBI_MantriMarg',2000);

insert into BankCustomer values('Avinash', 'Bull_Temple_Road', 'Bangalore');
insert into BankCustomer values('Dinesh', 'Bannergatta_Road', 'Bangalore');
insert into BankCustomer values('Mohan', 'NationalCollege_Road', 'Bangalore');
insert into BankCustomer values('Nikil', 'Akbar_Road', 'Delhi');
insert into BankCustomer values('Ravi', ' Prithviraj_Road', 'Delhi');

insert into Depositer values('Avinash', 1);
insert into Depositer values('Dinesh', 2);
insert into Depositer values('Nikil', 4);
insert into Depositer values('Ravi', 5);
insert into Depositer values('Avinash', 8);
insert into Depositer values('Nikil', 9);
insert into Depositer values('Dinesh', 10);
insert into Depositer values('Nikil', 11);
insert into Depositer values('Nikil', 12);

insert into LOAN values(1,'SBI_Chamrajpet',1000);
insert into LOAN values(2,'SBI_ResidencyRoad',2000);
insert into LOAN values(3,'SBI_ShivajiRoad',3000);
insert into LOAN values(4,'SBI_ParliamentRoad',4000);
insert into LOAN values(5,'SBI_Jantarmantar',5000);

insert into Borrower values('Avinash',1);
insert into Borrower values('Dinesh',2);
insert into Borrower values('Mohan',3);
insert into Borrower values('Nikil',4);
insert into Borrower values('Ravi',5);

SELECT d.customer_name From bankaccount a,branch b, depositer d WHERE b.branch_name=a.branch_name AND
a.accno=d.accno AND b.branch_city='Delhi' GROUP BY d.customer_name 
HAVING COUNT(distinct b.branch_name)=(SELECT COUNT(branch_name)FROM branch WHERE branch_city='Delhi');

select distinct customer_name from borrower where customer_name not in (select customer_name from depositer);

Select customer_name From Borrower ,loan  Where borrower.loan_number=loan.loan_number and loan.branch_name in 
(select branch_name from depositer, bankaccount where depositer.accno = bankaccount.accno And bankaccount.branch_name in
 (Select branch_name from branch WHERE branch.branch_city='Bangalore'));
 
 Select branch_name From Branch Where assets>(Select Sum(assets) from branch Where branch_city='Bangalore');
 
 DELETE FROM bankaccount WHERE branch_name IN(SELECT branch_name FROM branch WHERE branch_city='Bombay');
 
delete from depositer where accno in
 (select accno from branch, bankaccount where branch_city = 'Bombay' and branch.branch_name = bankaccount.branch_name);

update bankaccount
set balance = balance * 1.05
