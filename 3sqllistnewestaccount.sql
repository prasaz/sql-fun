-- DDL

CREATE TABLE Firm
(
	FirmID INT PRIMARY KEY,
    Name VARCHAR(50)
);

INSERT INTO Firm (FirmID, Name)
VALUES
    (1, 'Sony Capital'),
    (2, 'DC Financial'),
  	(3, 'Marvel Investment'),
    (4, 'Warner Group')
;

CREATE TABLE AccountType
(
	AccountTypeID INT PRIMARY KEY,
	Name VARCHAR(50)
);

INSERT INTO AccountType (AccountTypeID, Name)
VALUES
	(1, 'CASH'),
    (2, 'MARGIN'),
	(3, 'TFSA'),
    (4, 'RRSP'),
    (5, 'RESP')
;

 
CREATE TABLE Account
(
  AccountID INT PRIMARY KEY,
  FirmID INT,
  CustomerName VARCHAR(50),
  AccountTypeID INT,
  StartDate DATE  
);

INSERT INTO Account (AccountID, FirmID, CustomerName, AccountTypeID, StartDate)
VALUES
  (1, 3, 'Steve Rogers', 1, '2021-10-21'),
  (2, 3, 'Tony Stark', 1, '2020-02-14'),
  (3, 3, 'Tony Stark', 2, '2020-02-14'),
  (4, 3, 'Tony Stark', 5, '2021-07-20'),
  (5, 1, 'Peter Parker', 3, '2022-03-01'),
  (6, 3, 'Bruce Banner', 2, '2021-08-10'),
  (7, 2, 'Bruce Wayne', 1, '2018-12-25'),
  (8, 2, 'Bruce Wayne', 2, '2019-01-05'),
  (9, 2, 'Bruce Wayne', 3, '2020-11-13'),
  (10, 2, 'Bruce Wayne', 4, '2021-04-04'),
  (11, 2, 'Bruce Wayne', 5, '2022-09-09')
;

-- Quetions
-- List only newest account for each firm as of Jan 1, 2022.  
-- All firms must appear, NULL date if firm has none.


-- ANS
SELECT DISTINCT fa.FirmID, fa.Name as FirmName, tmp.StartDate, tmp.rnk
FROM Firm fa LEFT JOIN (SELECT 
f.FirmID
, f.Name
, a.StartDate
, RANK() over (partition by f.FirmID Order by a.startDate desc) as rnk
FROM Firm f
INNER JOIN Account a ON f.FirmID = a.FIrmID
WHERE a.startDate < '2022-01-01') tmp
ON fa.FirmID = tmp.FirmID
WHERE tmp.rnk = 1 or tmp.rnk is null;

-- Correct 
select f.FirmID as 'Firm ID', f.Name as 'Firm Name', a.StartDate as 'Start Date'
from Firm f
left join (
  select FirmID, max(StartDate) as StartDate
  from Account
  where StartDate <= '2022-01-01'
  group by FirmID
) a
on f.FirmID = a.FirmID ;


