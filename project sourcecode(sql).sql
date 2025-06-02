CREATE database bankingfraudtransaction;

use  bankingfraudtransaction;

select * from rawdata;  # foundation table 


CREATE TABLE Users (
    AccountID VARCHAR(20) PRIMARY KEY,
    CustomerAge INT,
    CustomerOccupation VARCHAR(255),
    AccountBalance DECIMAL(10,2)
);
select * from users;


CREATE TABLE transaction (
    transactionid VARCHAR(50),
    Customerage INT,
    Transactionamount FLOAT,
    Deviceid VARCHAR(50),
    Transactiontype VARCHAR(30),
    TransactionDuration int
);
select * from transaction;


CREATE TABLE DeviceInfo (
    DeviceID varchar(20) PRIMARY KEY,
    AccountID VARCHAR(20),
    IPAddress VARCHAR(15),
    MerchantID VARCHAR(20),
    FOREIGN KEY (AccountID) REFERENCES Users(AccountID)
);

select * from deviceinfo;


create table attempts (
	AccountId varchar(20) ,
    LoginAttempts int 
    );

select * from attempts;


# top 5 High-Value Transactions
select accountid , max(transactionamount) as highest_amount
from rawdata
group by accountid
order by highest_amount desc
limit 5;


# multiple login attempts
select accountid , loginattempts 
from rawdata 
where loginattempts > 20;


# Highest Transaction Locations
select location , max(transactionamount) as amount 
from rawdata
group by location 
order by amount desc
limit 5 ; 

# channels used
select channel , count(*) as no_of_transaction
from rawdata 
group by channel 
order by no_of_transaction desc;


#highest amount with their channel
select channel ,accountid, transactionamount
from rawdata 
order by  transactionamount desc
limit 5;

# Transactions from Multiple IPs for Same Account
SELECT AccountID, COUNT(DISTINCT IP_Address) AS ip_count
FROM rawdata
GROUP BY AccountID
HAVING ip_count > 3
order by ip_count desc
limit 10;


# highest acccountbalance by each occupation.
select  customeroccupation, max(accountbalance) as max
from rawdata 
where customeroccupation IN ('retired' , 'doctor','student', 'engineer')
group by customeroccupation
order by max desc;


# total transaction amount
select round(sum(transactionamount),0) as total_amount
from rawdata;

# total no. of account ids.
select count(distinct(accountid)) as total_accountid
from rawdata;


# sum of debit and credit amount .
SELECT 
    transactiontype, 
    ROUND(SUM(transactionamount)) AS amount
FROM 
    transaction
GROUP BY 
    transactiontype

UNION ALL

SELECT 
    'Total' AS transactiontype, 
    ROUND(SUM(transactionamount)) AS amount
FROM 
    transaction
WHERE 
    transactiontype IN ('Debit', 'Credit');
    
    
# number of transaction

select count(distinct transactionid)
from rawdata ;