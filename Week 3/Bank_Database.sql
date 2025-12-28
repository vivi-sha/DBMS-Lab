create database if not exists bank;
use bank;
create table BRANCH(Branch_name varchar(20), branch_city varchar(20), Assets real, PRIMARY KEY(Branch_name));
create table BANKACCOUNT(accno int, Branch_name varchar(20), balance real, primary key(accno,Branch_name), foreign key(Branch_name) references BRANCH(Branch_name));
create table BANKCUSTOMER(customer_name varchar(20), customer_street varchar(20), customer_city varchar(20),primary key(customer_name));
create table DEPOSITER(customer_name varchar(20), accno int, primary key(customer_name,accno), foreign key(accno) references BANKACCOUNT(accno),foreign key (customer_name) references BANKCUSTOMER(customer_name));
CREATE TABLE LOAN(LOAN_number int, Branch_name varchar(20), ammount real, primary key(Branch_name), foreign key(Branch_name) references BRANCH(Branch_name));

insert into BRANCH VALUES("SBI_Chamrajpet","Bangalore",50000);
insert into BRANCH VALUES("SBI_ResidencyRoad","Bangalore",10000);
insert into BRANCH VALUES("SBI_ShivajiRoad","Bombay",20000);
insert into BRANCH VALUES("SBI_ParlimentRoad","Delhi",10000);
insert into BRANCH VALUES("SBI_Jantarmantar","Delhi",20000);

insert into BANKACCOUNT values(1,"SBI_Chamrajpet",2000);
insert into BANKACCOUNT values(2,"SBI_ResidencyRoad",5000);
insert into BANKACCOUNT values(3,"SBI_ShivajiRoad",6000);
insert into BANKACCOUNT values(4,"SBI_ParlimentRoad",9000);
insert into BANKACCOUNT values(5,"SBI_Jantarmantar",8000);
insert into BANKACCOUNT values(6,"SBI_ShivajiRoad",4000);
insert into BANKACCOUNT values(8,"SBI_ResidencyRoad",4000);
insert into BANKACCOUNT values(9,"SBI_ParlimentRoad",3000);
insert into BANKACCOUNT values(10,"SBI_ResidencyRoad",5000);
insert into BANKACCOUNT values(11,"SBI_Jantarmantar",2000);
select * from BANKCUSTOMER;

insert into BANKCUSTOMER values("Avinash","Bull_Temple_Road","Bangalore");
insert into BANKCUSTOMER values("Dinesh","Bannergatta_Road","Bangalore");
insert into BANKCUSTOMER values("Mohan","NationalCollege_Road","Bangalore");
insert into BANKCUSTOMER values("Nikil","Akbar_Road","Delhi");
insert into BANKCUSTOMER values("Ravi","Prithviraj_Road","Delhi");

insert into DEPOSITER values("Avinash",1);
insert into DEPOSITER values("Dinesh",2);
insert into DEPOSITER values("Nikil",4);
insert into DEPOSITER values("Ravi",5);
insert into DEPOSITER values("Avinash",8);
insert into DEPOSITER values("Nikil",9);
insert into DEPOSITER values("Dinesh",10);
insert into DEPOSITER values("Nikil",11);

insert into LOAN values(1,"SBI_Chamrajpet",1000);
insert into LOAN values(2,"SBI_ResidencyRoad",2000);
insert into LOAN values(3,"SBI_ShivajiRoad",3000);
insert into LOAN values(4,"SBI_ParlimentRoad",4000);
insert into LOAN values(5,"SBI_Jantarmantar",5000);

select * from BRANCH;
select * from BANKACCOUNT;
select * from BANKCUSTOMER;
select * from DEPOSITER;
SELECT * FROM LOAN;

 -- Queries to do -- 
 
 select branch_name, CONCAT(assets/100000, 'Lakhs')assets_in_lakhs	 from branch;
 
 select d.customer_name from DEPOSITER d, BANKACCOUNT b where b.branch_name="SBI_ResidencyRoad" and 
 d.accno=b.accno group by d.customer_name having count(d.accno)>=2;
 
 create view sum_of_loan as select Branch_name, SUM(balance) from BANKACCOUNT group by branch_name;
 select * from sum_of_loan;
 
 select b.customer_name,CONCAT(balance+1000, 'Rupees')UPDATED_BALANCE from BANKACCOUNT a,BANKCUSTOMER b, DEPOSITER d
 where b.customer_name=d.customer_name and a.accno=d.accno and b.customer_city="Bangalore";
