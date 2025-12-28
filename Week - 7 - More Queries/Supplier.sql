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

-- Extra Queries -- 

-- Find the most expensive part overall and the supplier who supplies it. --
SELECT P.PNAME, S.SNAME, C.cost FROM Catalog C JOIN Supplier S ON C.SID = S.SID JOIN Parts P ON C.PID = P.PID
WHERE C.cost = (SELECT MAX(cost) FROM Catalog);

-- Find suppliers who do NOT supply any red parts.
SELECT SNAME FROM Supplier WHERE SID NOT IN ( SELECT C.SID FROM Catalog C JOIN Parts P ON C.PID = P.PID WHERE P.color = 'Red');

-- Show each supplier and total value of all parts they supply. -- 
SELECT S.SNAME, SUM(C.cost) AS Total_Value FROM Supplier S JOIN Catalog C ON S.SID = C.SID GROUP BY S.SID, S.SNAME;

-- Find suppliers who supply at least 2 parts cheaper than ₹20. -- 
SELECT S.SNAME FROM Supplier S JOIN Catalog C ON S.SID = C.SID WHERE C.cost < 20 GROUP BY S.SID, S.SNAME HAVING COUNT(C.PID) >= 2;

-- List suppliers who offer the cheapest cost for each part. --
SELECT P.PNAME, S.SNAME, C.cost FROM Catalog C JOIN Supplier S ON C.SID = S.SID JOIN Parts P ON C.PID = P.PID
WHERE C.cost = (SELECT MIN(C2.cost) FROM Catalog C2 WHERE C2.PID = C.PID);

 -- Create a view showing suppliers and the total number of parts they supply.
CREATE VIEW SupplierPartCounts AS
SELECT S.SNAME, COUNT(C.PID) AS Total_Parts_Supplied
FROM Supplier S
JOIN Catalog C ON S.SID = C.SID
GROUP BY S.SID, S.SNAME;

select * from SupplierPartCounts;

-- Create a view of the most expensive supplier for each part.
CREATE VIEW MostExpensiveSuppliers AS
SELECT P.PNAME, S.SNAME, C.cost
FROM Catalog C
JOIN Supplier S ON C.SID = S.SID
JOIN Parts P ON C.PID = P.PID
WHERE C.cost = (
    SELECT MAX(C2.cost) 
    FROM Catalog C2 
    WHERE C2.PID = C.PID
);

select * from MostExpensiveSuppliers;

-- Create a Trigger to prevent inserting a Catalog cost below 1.
DELIMITER //

CREATE TRIGGER PreventInvalidCost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    IF NEW.cost < 1 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: Cost cannot be less than 1';
    END IF;
END; //

DELIMITER ;

-- Create a trigger to set to default cost if not provided.
DELIMITER //

CREATE TRIGGER SetDefaultCost
BEFORE INSERT ON Catalog
FOR EACH ROW
BEGIN
    -- Check if the cost is missing (NULL)
    IF NEW.cost IS NULL THEN
        SET NEW.cost = 10; -- Replace 10 with your desired default price
    END IF;
END; //

DELIMITER ;
