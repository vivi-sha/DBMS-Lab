create database if not exists supplier;
use supplier;

create table Supplier(SID int,SNAME varchar(20),CITY varchar(20),primary key(SID));
create table Parts(PID int, PNAME varchar(20),color varchar(20),primary key(PID));
create table Catalog(SID int, PID int, cost int, primary key(SID,PID), foreign key(SID) references Supplier(SID), foreign key (PID) references Parts(PID));

 insert into Supplier (SID,SNAME,CITY) values
 (10001,"Acme Widget","bangalore"),
 (10002,"Johns","Kolkata"),
 (10003,"Vimal","Mumbai"),
 (10004,"Reliance","Delhi");
 insert into Parts(PID,PNAME,color) values
 (20001,"Book","Red"),
 (20002,"Pen","Red"),
 (20003,"Pencil","Green"),
 (20004,"Mobile","Green"),
 (20005,"Charger","Black");
 insert into Catalog(SID,PID,cost) values
 (10001,20001,10),
 (10001,20002,10),
 (10001,20003,30),
 (10001,20004,10),
 (10001,20005,10),
 (10002,20001,10),
 (10002,20002,20),
 (10003,20003,30),
 (10004,20003,40);
 

 -- Find the pnames of parts for which there is some supplier. --
select PNAME from Parts where PID in (select PID from Catalog);

--  Find the snames of suppliers who supply every part. --
select distinct s.SNAME from Supplier s join catalog c1 on s.SID=c1.SID where (select count(distinct PID) from catalog c2 where c2.SID=c1.SID)= (select count(*) from Parts);

-- Find the snames of suppliers who supply every red part. --
SELECT s.SNAME
FROM Supplier s
JOIN Catalog c ON s.SID = c.SID
JOIN Parts p ON c.PID = p.PID
WHERE p.color = 'Red'
GROUP BY s.SID, s.SNAME  -- Group by both ID and Name
HAVING COUNT(DISTINCT p.PID) = (
    -- This subquery gets the TOTAL number of red parts
    SELECT COUNT(p2.PID)
    FROM Parts p2
    WHERE p2.color = 'Red'
);
-- Find the pnames of parts supplied by Acme Widget Suppliers and by no one else. --
select p.PNAME from parts p where not exists (select * from catalog c join supplier s on s.SID=c.SID where p.PID=c.PID and s.SNAME!="Acme Widget");

-- Find the sids of suppliers who charge more for some part than the average cost of that part (averaged over all the suppliers who supply that part).
select c.SID from Catalog c where c.cost>(select AVG(cost) from catalog c2 where c.PID=c2.PID);

-- For each part, find the sname of the supplier who charges the most for that part. --
select c1.pid, s.SNAME from supplier s, catalog c1 where c1.cost=(select MAX(c2.cost) from catalog c2 where c1.PID=c2.PID) and s.SID=c1.SID; 
