CREATE DATABASE hedera_paper;

USE hedera_paper;

CREATE TABLE Employee (
e_ID INT PRIMARY KEY,
e_first_name VARCHAR(30) NOT NULL,
e_last_name VARCHAR(30) NOT NULL,
e_gender VARCHAR(1), #'M' or 'F'
e_birthday DATE,
e_phone VARCHAR(12),
e_job_title VARCHAR(50),
e_salary NUMERIC(8,2),
e_hire_date DATE,
e_manager_ID INT, #Will be defined as FK on alter table
e_dept_ID INT #Will be defined as FK on alter table
);


CREATE TABLE Employee_Address (
e_ID INT, #FK
ea_city VARCHAR (30),
ea_street VARCHAR (30),
ea_street_num INT,
ea_postal_code INT,
FOREIGN KEY (e_ID) REFERENCES Employee (e_ID) ON DELETE CASCADE,
PRIMARY KEY (ea_city, ea_street, ea_street_num, e_ID)
);

CREATE TABLE Department (
d_ID INT PRIMARY KEY,
d_name VARCHAR(50),
e_manager_ID INT, #FK
FOREIGN KEY (e_manager_ID) REFERENCES Employee (e_ID) ON DELETE SET NULL
);

ALTER TABLE Employee #adding manager ID as FK to the employee table
ADD FOREIGN KEY (e_manager_ID)
REFERENCES Employee (e_ID)
ON DELETE SET NULL;

ALTER TABLE Employee #adding department ID as FK to the employee table
ADD FOREIGN KEY (e_dept_ID)
REFERENCES Department (d_ID)
ON DELETE SET NULL;

CREATE TABLE Vendor (
v_ID INT PRIMARY KEY,
v_name VARCHAR(60) NOT NULL,
v_phone VARCHAR(12) NOT NULL
);

CREATE TABLE Vendor_Address (
v_ID INT, #FK
va_city VARCHAR (30),
va_street VARCHAR (30),
va_street_num INT,
va_postal_code INT,
FOREIGN KEY (v_ID) REFERENCES Vendor (v_ID) ON DELETE SET NULL,
PRIMARY KEY (va_city, va_street, va_street_num)
);

CREATE TABLE Customer (
c_ID INT PRIMARY KEY,
c_first_name VARCHAR(30) NOT NULL,
c_last_name VARCHAR(30) NOT NULL,
c_phone VARCHAR(12) NOT NULL,
c_company_name VARCHAR(30)
);

CREATE TABLE Customer_Address (
c_ID INT, #FK
ca_city VARCHAR (30),
ca_street VARCHAR (30),
ca_street_num INT,
ca_postal_code INT,
FOREIGN KEY (c_ID) REFERENCES Customer (c_ID) ON DELETE CASCADE,
PRIMARY KEY (ca_city, ca_street, ca_street_num, c_ID)
);

CREATE TABLE Raw_Material (
rm_ID INT PRIMARY KEY,
rm_name VARCHAR(80) NOT NULL,
rm_price NUMERIC(10,2)
);

CREATE TABLE Product (
p_ID INT PRIMARY KEY,
p_name VARCHAR(80) NOT NULL,
p_price NUMERIC(10,2) 
);

CREATE TABLE Product_Condition (
p_ID INT, #FK
pc_sn VARCHAR(32),
pc_condition VARCHAR(10), # DEFECTIVE/WORKING
FOREIGN KEY (p_ID) REFERENCES Product (p_ID) ON DELETE CASCADE,
PRIMARY KEY (p_ID, pc_sn)
);

CREATE TABLE Vendor_Order ( 
vo_ID INT PRIMARY KEY,
v_ID INT, #FK
vo_date DATETIME NOT NULL,
FOREIGN KEY (v_ID) REFERENCES Vendor (v_ID) ON DELETE SET NULL
);

CREATE TABLE Vendor_Order_Details (
vo_ID INT, #FK
rm_ID INT, #FK
vod_quantity INT NOT NULL,
FOREIGN KEY (vo_ID) REFERENCES Vendor_Order (vo_ID) ON DELETE CASCADE,
FOREIGN KEY (rm_ID) REFERENCES Raw_Material (rm_ID) ON DELETE CASCADE,
PRIMARY KEY (vo_ID, rm_ID)
);

CREATE TABLE Customer_Order ( 
co_ID INT PRIMARY KEY,
c_ID INT, #FK
co_date DATETIME NOT NULL,
FOREIGN KEY (c_ID) REFERENCES Customer (c_ID) ON DELETE SET NULL
);

CREATE TABLE Customer_Order_Details (
co_ID INT, #FK
p_ID INT, #FK
cod_quantity INT NOT NULL,
FOREIGN KEY (co_ID) REFERENCES Customer_Order (co_ID) ON DELETE CASCADE,
FOREIGN KEY (p_ID) REFERENCES Product (p_ID) ON DELETE CASCADE,
PRIMARY KEY (co_ID, p_ID)
);

CREATE TABLE Customer_Review (
co_ID INT,
cr_rate INT CHECK (cr_rate >= 1 AND cr_rate <= 5), #RATE BETWEEN 1-5 (1 bad, 5 great)
cr_description VARCHAR(200),
cr_date DATETIME NOT NULL,
FOREIGN KEY (co_ID) REFERENCES Customer_Order (co_ID) ON DELETE CASCADE,
PRIMARY KEY (co_ID, cr_date)
);

CREATE TABLE Warehouse (
w_ID INT PRIMARY KEY,
w_name VARCHAR(30) NOT NULL
);

CREATE TABLE Warehouse_Address (
w_ID INT, #FK
wa_city VARCHAR (30),
wa_street VARCHAR (30),
wa_street_num INT,
wa_postal_code INT,
FOREIGN KEY (w_ID) REFERENCES Warehouse (w_ID) ON DELETE SET NULL,
PRIMARY KEY (wa_city, wa_street, wa_street_num) 
);

CREATE TABLE Machine (
m_ID INT PRIMARY KEY,
w_ID INT,
m_name VARCHAR(80) NOT NULL,
m_description VARCHAR(300),
FOREIGN KEY (w_ID) REFERENCES Warehouse (w_ID) ON DELETE SET NULL
);

CREATE TABLE RM_Inventory ( #raw_material inventory
rm_ID INT,
w_ID INT,
rmi_quantity INT,
FOREIGN KEY (rm_ID) REFERENCES Raw_Material (rm_ID),
FOREIGN KEY (w_ID) REFERENCES Warehouse (w_ID),
PRIMARY KEY (rm_ID, w_ID)
);

CREATE TABLE Product_Inventory ( 
p_ID INT,
w_ID INT,
pi_quantity INT ,
FOREIGN KEY (p_ID) REFERENCES Product (p_ID),
FOREIGN KEY (w_ID) REFERENCES Warehouse (w_ID),
PRIMARY KEY (p_ID, w_ID)
);

CREATE TABLE RM_To_Product (
p_ID INT,
rm_ID INT,
FOREIGN KEY (p_ID) REFERENCES Product (p_ID),
FOREIGN KEY (rm_ID) REFERENCES Raw_Material (rm_ID),
PRIMARY KEY (p_ID, rm_ID)
);

CREATE TABLE Produced_By (
p_ID INT,
m_ID INT,
FOREIGN KEY (p_ID) REFERENCES Product (p_ID),
FOREIGN KEY (m_ID) REFERENCES Machine (m_ID),
PRIMARY KEY (p_ID, m_ID)
);

##### STARTING TO ADD VALUES #####
##### STARTING TO ADD VALUES #####
##### STARTING TO ADD VALUES #####

##### ADDING VALUES TO THE TABLES - EMPLOYEE AND DEPARTMENT ##### EMPLOYEE VALUES STARTING FROM 1 | DEPARTMENT VALUES STARTING FROM 101

INSERT INTO Employee VALUES (1, 'Dan', 'Ariel', 'M', '1987-05-12', '0505555555', 'CEO', 400000,'2005-02-10', NULL, NULL);

INSERT INTO Department VALUES (101, 'Management', 1); # Dan Ariel is now the manager of Management Department

UPDATE Employee #adding the department ID 101 to Dan Ariel
SET e_dept_ID = 101
WHERE e_ID = 1;

INSERT INTO Employee VALUES (2, 'Tomer', 'Cohen', 'M', '1968-02-10', '0504444444', 'President', 400000,'2005-01-08', NULL, 101);
INSERT INTO Employee VALUES (3, 'Avi', 'Levi', 'M', '1965-01-03', '0503333333', 'CFO', 300000,'2008-10-14', 1,101);
INSERT INTO Employee VALUES (4, 'Dafna', 'Raziel', 'F', '1972-03-11', '0502222222', 'CSO', 300000, '2020-07-01', 1, 101);

INSERT INTO Department VALUES (102, 'Sales', 4); # Dafna Raziel is now the manager of Sales Department

INSERT INTO Employee VALUES (5, 'Dikla', 'Wills', 'F', '1977-05-18', '0501111111', 'Regional Sales Manager',250000,'2020-07-01' , 4, 102);
INSERT INTO Employee VALUES (6, 'Udi', 'Nills', 'M', '1974-05-28', '0501111111', 'Account Executive', 180000, '2020-07-01' ,5, 102);
INSERT INTO Employee VALUES (7, 'Tamir', 'Harel', 'M', '1979-10-21', '0502222111', 'Head of Product', 220000,'2020-07-01' , 2, NULL);

INSERT INTO Department VALUES (103, 'Production', 7); # Tamir Harel is now the manager of Production Department

UPDATE Employee #adding the department ID 103 to Tamir Harel
SET e_dept_ID = 103
WHERE e_ID = 7;

INSERT INTO Employee VALUES (8, 'David', 'Cohen', 'M', '1990-01-13', '0504444111', 'Production Worker', 120000,'2020-07-01'  , 7, 103);
INSERT INTO Employee VALUES (9, 'Arik', 'Dahn', 'M', '1992-04-18', '0503333111', 'Production Worker', 120000,'2020-07-01'  , 7, 103);
INSERT INTO Employee VALUES (10, 'Daniela', 'Cohen', 'F', '1994-07-23', '0503355511', 'Production Worker', 120000,'2020-07-01', 7, 103);
INSERT INTO Employee VALUES (11, 'Adi', 'Biton', 'F', '1991-02-02', '0503354511', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (12, 'Dana', 'Kellerman', 'F', '1994-03-20', '0503255511', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (13, 'Dudi', 'Shmuelly', 'M', '1990-07-25', '0503365511', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (14, 'Adam', 'Asket', 'M', '1989-07-22', '0503355571', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (15, 'Idan', 'Muller', 'M', '1993-02-28', '0503355611', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (16, 'Steven', 'Sher', 'M', '1991-04-25', '0503357711', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (17, 'Avi', 'Samuel', 'M', '1992-09-12', '05033685511', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (18, 'Danny', 'Kalderon', 'M', '1991-01-05', '0503345511', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (19, 'Shira', 'Bentov', 'F', '1990-08-02', '0503334211', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (20, 'Elor', 'Shamash', 'M', '1992-12-04', '0503379311', 'Production Worker', 120000, '2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (21, 'Adva', 'Aviry', 'F', '1995-05-08', '0503331451', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (22, 'Lior', 'Boniel', 'F', '1996-02-14', '0503355590', 'Production Worker', 120000,'2020-07-01' , 7, 103);
INSERT INTO Employee VALUES (23, 'Ran', 'Attias', 'M', '1989-01-27', '0503355524', 'Production Worker', 120000, '2020-07-01', 7, 103);


##### ADDING VALUES TO THE TABLES - EMPLOYEE ADDRESS #####

INSERT INTO Employee_Address VALUES (1, 'Tel-Aviv', 'Rothshild', 5, 512305);
INSERT INTO Employee_Address VALUES (2, 'Tel-Aviv', 'Iben-Gabirol', 15, 590213);
INSERT INTO Employee_Address VALUES (3, 'Haifa', 'Lotus', 2, 859120);
INSERT INTO Employee_Address VALUES (4, 'Hedra', 'Caspi', 14, 852145);
INSERT INTO Employee_Address VALUES (5, 'Haifa', 'Yonathan', 33, 358605);
INSERT INTO Employee_Address VALUES (6, 'Hedera', 'Ha-Nahalhim', 14, 659405);
INSERT INTO Employee_Address VALUES (7, 'Haifa', 'Oscar-Cohen', 21, 345665);
INSERT INTO Employee_Address VALUES (8, 'Hedera', 'HaPalmah', 7, 346777);
INSERT INTO Employee_Address VALUES (9, 'Hedera', 'Menara', 1, 245334);
INSERT INTO Employee_Address VALUES (10, 'Hedera', 'Hasif', 9, 412392);
INSERT INTO Employee_Address VALUES (11, 'Hedera', 'Bialik', 13, 412318);
INSERT INTO Employee_Address VALUES (12, 'Hedera', 'Lev Haim', 58, 412314);
INSERT INTO Employee_Address VALUES (13, 'Hedera', 'Allenby', 37, 412327);
INSERT INTO Employee_Address VALUES (14, 'Hedera', 'Ben Yeuda', 21, 425305);
INSERT INTO Employee_Address VALUES (15, 'Hedera', 'HaArba', 1, 412335);
INSERT INTO Employee_Address VALUES (16, 'Hedera', 'HaMasger', 20, 444305);
INSERT INTO Employee_Address VALUES (17, 'Hedera', 'Dizengoff', 15, 413305);
INSERT INTO Employee_Address VALUES (18, 'Hedera', 'Kaplan', 67, 412305);
INSERT INTO Employee_Address VALUES (19, 'Hedera', 'Yefet', 32, 412705);
INSERT INTO Employee_Address VALUES (20, 'Hedera', 'Aza', 54, 412355);
INSERT INTO Employee_Address VALUES (21, 'Hedera', 'Sderot', 6, 412315);
INSERT INTO Employee_Address VALUES (22, 'Hedera', 'King George', 4, 445305);
INSERT INTO Employee_Address VALUES (23, 'Hedera', 'Hasif', 12, 412315);

##### ADDING VALUES TO THE TABLES - VENDOR AND VENDOR ADDRESS ##### VENDOR VALUES STARTING FROM 90,001

INSERT INTO Vendor VALUES (90001, 'Eliyahu &  Itzhick IsraWood Ltd', '043000050');
INSERT INTO Vendor VALUES (90002, 'Office4You Ltd', '042009090');
INSERT INTO Vendor VALUES (90003, 'The Cohens Transportation', '035005050');

INSERT INTO Vendor_Address VALUES (90001, 'Haifa', 'Etrog', 1, 590145);
INSERT INTO Vendor_Address VALUES (90002, 'Hedra', 'HaZayet', 14, 590892);
INSERT INTO Vendor_Address VALUES (90003, 'Tel Aviv', 'Helel-Yafe', 25, 480123);

##### ADDING VALUES TO THE TABLES - CUSTOMER AND CUSTOMER ADDRESS ##### CUSTOMER VALUES STARTING FROM 200,001

INSERT INTO Customer VALUES (200001, 'Israel', 'Shaul', '0508902033', NULL);
INSERT INTO Customer VALUES (200002, 'Israel', 'Israeli', '0522422033', 'Agosherim Ltd');
INSERT INTO Customer VALUES (200003, 'Ido', 'Wolf', '0542304331', 'Kravitz');
INSERT INTO Customer VALUES (200004, 'Tom', 'Elskin', '0508454513', 'Daphim 4 You');
INSERT INTO Customer VALUES (200005, 'Hadar', 'Yilel', '0528903342', NULL);
INSERT INTO Customer VALUES (200006, 'Dudi', 'Levi', '0532479123', 'Happy birthday Cards');
INSERT INTO Customer VALUES (200007, 'Jack', 'Daniels', '0532474233', 'Daphim & Events Ltd');
INSERT INTO Customer VALUES (200008, 'Avner', 'Alphasi', '053247463', 'Wish You Well');
INSERT INTO Customer VALUES (200009, 'Dikla', 'Shavit', '0532475533', 'A4 is Us');
INSERT INTO Customer VALUES (200010, 'Ruti', 'Segev', '0532682233', 'News for the people');

INSERT INTO Customer_Address VALUES (200001, 'Gan Shmuel', 'Shaltiel', 4, 450245);
INSERT INTO Customer_Address VALUES (200002, 'Ein HaHoresh', 'Davidson', 23, 701314);
INSERT INTO Customer_Address VALUES (200003, 'Haifa', 'Yehuda HaMacabi', 10, 304245);
INSERT INTO Customer_Address VALUES (200004, 'Sde Yitzachk', 'Abrahmson', 12, 304501);
INSERT INTO Customer_Address VALUES (200005, 'Hedera', 'Yosef Mualem', 54, 303904);
INSERT INTO Customer_Address VALUES (200006, 'Hedera', 'HaShalom', 17, 225775);
INSERT INTO Customer_Address VALUES (200007, 'Hedera', 'Tesheri', 12, 246912);
INSERT INTO Customer_Address VALUES (200008, 'Haifa', 'Bnei Tovim', 25, 235863);
INSERT INTO Customer_Address VALUES (200009, 'Kfar Saba', 'Balfur', 3, 227345);
INSERT INTO Customer_Address VALUES (200010, 'Kfar Saba', 'HaMagen', 10, 246813);

##### ADDING VALUES TO THE TABLES - RAW MATERIAL AND PRODUCT ##### RM VALUES STARTING FROM 120,001 | PRODUCT VALUES STARTING FROM 150,001

INSERT INTO Raw_Material VALUES (120001, 'Wood Pulp', 0.399);
INSERT INTO Raw_Material VALUES (120002, 'Virgin Pulp', 0.125);
INSERT INTO Raw_Material VALUES (120003, 'Starch', 0.59);
INSERT INTO Raw_Material VALUES (120004, 'Color Mineral', 0.39);
INSERT INTO Raw_Material VALUES (120005, 'Waste Paper', 0.99);
INSERT INTO Raw_Material VALUES (120006, 'Resin', 0.40);

INSERT INTO Product VALUES (150001, 'Printing Paper', 12.999);
INSERT INTO Product VALUES (150002, 'Coated Paper', 7.999);
INSERT INTO Product VALUES (150003, 'Tissue Paper', 8.999);
INSERT INTO Product VALUES (150004, 'Cardboard', 8.999);
INSERT INTO Product VALUES (150005, 'Paperboard', 6.999);
INSERT INTO Product VALUES (150006, 'Carton', 4.999);
INSERT INTO Product VALUES (150007, 'Fineart Paper', 25.999);
INSERT INTO Product VALUES (150008, 'Pilot Pen 0.4', 5);
INSERT INTO Product VALUES (150009, 'Stabilo Boss Highligher - Yellow', 4.5);

##### ADDING VALUES TO THE TABLE - PRODUCT CONDITION #####

INSERT INTO Product_Condition VALUES (150001, 'SN505505', 'WORKING');
INSERT INTO Product_Condition VALUES (150001, 'SN505506', 'DEFECTIVE');
INSERT INTO Product_Condition VALUES (150001, 'SN505507', 'WORKING');
INSERT INTO Product_Condition VALUES (150001, 'SN505508', 'WORKING');
INSERT INTO Product_Condition VALUES (150001, 'SN505509', 'DEFECTIVE');
INSERT INTO Product_Condition VALUES (150001, 'SN505510', 'WORKING');
INSERT INTO Product_Condition VALUES (150001, 'SN505511', 'WORKING');

INSERT INTO Product_Condition VALUES (150002, 'SN40404', 'WORKING');
INSERT INTO Product_Condition VALUES (150002, 'SN40405', 'WORKING');
INSERT INTO Product_Condition VALUES (150002, 'SN40406', 'WORKING');
INSERT INTO Product_Condition VALUES (150002, 'SN40407', 'DEFECTIVE');
INSERT INTO Product_Condition VALUES (150002, 'SN40408', 'DEFECTIVE');

INSERT INTO Product_Condition VALUES (150003, 'SN31115', 'WORKING');
INSERT INTO Product_Condition VALUES (150003, 'SN31116', 'DEFECTIVE');
INSERT INTO Product_Condition VALUES (150003, 'SN31117', 'DEFECTIVE');
INSERT INTO Product_Condition VALUES (150003, 'SN31118', 'WORKING');

INSERT INTO Product_Condition VALUES (150004, 'SN41118', 'WORKING');
INSERT INTO Product_Condition VALUES (150004, 'SN41119', 'WORKING');
INSERT INTO Product_Condition VALUES (150004, 'SN41120', 'WORKING');

INSERT INTO Product_Condition VALUES (150005, 'SN41125', 'WORKING');
INSERT INTO Product_Condition VALUES (150005, 'SN41126', 'WORKING');
INSERT INTO Product_Condition VALUES (150005, 'SN41127', 'WORKING');

INSERT INTO Product_Condition VALUES (150006, 'SN55234', 'WORKING');
INSERT INTO Product_Condition VALUES (150006, 'SN55235', 'DEFECTIVE');
INSERT INTO Product_Condition VALUES (150006, 'SN55236', 'WORKING');
INSERT INTO Product_Condition VALUES (150006, 'SN55237', 'DEFECTIVE');

INSERT INTO Product_Condition VALUES (150007, 'SN41234', 'WORKING');
INSERT INTO Product_Condition VALUES (150007, 'SN41235', 'WORKING');

INSERT INTO Product_Condition VALUES (150008, 'SN45551', 'WORKING');
INSERT INTO Product_Condition VALUES (150008, 'SN45552', 'WORKING');
INSERT INTO Product_Condition VALUES (150008, 'SN45553', 'WORKING');

INSERT INTO Product_Condition VALUES (150009, 'SN75551', 'WORKING');
INSERT INTO Product_Condition VALUES (150009, 'SN75552', 'DEFECTIVE');
INSERT INTO Product_Condition VALUES (150009, 'SN75553', 'WORKING');

##### ADDING VALUES TO THE TABLES - VENDOR ORDER AND VENDOR ORDER DETAILS ##### VALUES STARTING FROM 800,001

INSERT INTO Vendor_Order VALUES (800001, 90001, '2020-07-18 08:30:14');
INSERT INTO Vendor_Order VALUES (800002, 90002, '2020-05-18 10:42:05');
INSERT INTO Vendor_Order VALUES (800003, 90003, '2020-05-19 11:58:44');
INSERT INTO Vendor_Order VALUES (800004, 90002, '2020-05-20 15:24:20');
INSERT INTO Vendor_Order VALUES (800005, 90001, '2020-05-20 09:14:33');

INSERT INTO Vendor_Order_Details VALUES (800001, 120001, 200);
INSERT INTO Vendor_Order_Details VALUES (800001, 120002, 410);
INSERT INTO Vendor_Order_Details VALUES (800001, 120003, 950);
INSERT INTO Vendor_Order_Details VALUES (800001, 120004, 180);
INSERT INTO Vendor_Order_Details VALUES (800001, 120005, 340);
INSERT INTO Vendor_Order_Details VALUES (800001, 120006, 120);

INSERT INTO Vendor_Order_Details VALUES (800002, 120001, 130);
INSERT INTO Vendor_Order_Details VALUES (800002, 120002, 130);
INSERT INTO Vendor_Order_Details VALUES (800002, 120003, 190);

INSERT INTO Vendor_Order_Details VALUES (800003, 120004, 125);
INSERT INTO Vendor_Order_Details VALUES (800003, 120005, 135);
INSERT INTO Vendor_Order_Details VALUES (800003, 120006, 120);

INSERT INTO Vendor_Order_Details VALUES (800004, 120001, 300);
INSERT INTO Vendor_Order_Details VALUES (800004, 120003, 285);
INSERT INTO Vendor_Order_Details VALUES (800004, 120005, 140);
INSERT INTO Vendor_Order_Details VALUES (800004, 120006, 255);

INSERT INTO Vendor_Order_Details VALUES (800005, 120002, 170);
INSERT INTO Vendor_Order_Details VALUES (800005, 120004, 325);

##### ADDING VALUES TO THE TABLES - CUSTOMER ORDER AND CUSTOMER ORDER DETAILS ##### VALUES STARTING FROM 1,000,001s

INSERT INTO Customer_Order VALUES (1000001, 200001, '2020-07-19 12:35:28');
INSERT INTO Customer_Order VALUES (1000002, 200002, '2020-07-19 14:53:14');
INSERT INTO Customer_Order VALUES (1000003, 200003, '2020-07-19 09:12:40');
INSERT INTO Customer_Order VALUES (1000004, 200004, '2020-07-20 08:32:33');
INSERT INTO Customer_Order VALUES (1000005, 200005, '2020-07-20 09:50:10');
INSERT INTO Customer_Order VALUES (1000006, 200006, '2020-07-21 15:20:00');
INSERT INTO Customer_Order VALUES (1000007, 200007, '2020-07-23 08:44:32');
INSERT INTO Customer_Order VALUES (1000008, 200008, '2020-07-25 17:55:24');
INSERT INTO Customer_Order VALUES (1000009, 200009, '2020-08-01-12:23:11');
INSERT INTO Customer_Order VALUES (1000010, 200010, '2020-08-04 10:33:55');


INSERT INTO Customer_Order_Details VALUES (1000001, 150009, 50);

INSERT INTO Customer_Order_Details VALUES (1000002, 150001, 4100);
INSERT INTO Customer_Order_Details VALUES (1000002, 150002, 1200);
INSERT INTO Customer_Order_Details VALUES (1000002, 150003, 1350);
INSERT INTO Customer_Order_Details VALUES (1000002, 150004, 8200);
INSERT INTO Customer_Order_Details VALUES (1000002, 150008, 2500);

INSERT INTO Customer_Order_Details VALUES (1000003, 150004, 1350);
INSERT INTO Customer_Order_Details VALUES (1000003, 150005, 2500);
INSERT INTO Customer_Order_Details VALUES (1000003, 150007, 3800);
INSERT INTO Customer_Order_Details VALUES (1000003, 150008, 1100);

INSERT INTO Customer_Order_Details VALUES (1000004, 150001, 2450);
INSERT INTO Customer_Order_Details VALUES (1000004, 150002, 1800);
INSERT INTO Customer_Order_Details VALUES (1000004, 150005, 700);

INSERT INTO Customer_Order_Details VALUES (1000005, 150008, 30);
INSERT INTO Customer_Order_Details VALUES (1000005, 150009, 50);

INSERT INTO Customer_Order_Details VALUES (1000006, 150004, 6100);
INSERT INTO Customer_Order_Details VALUES (1000006, 150007, 4500);
INSERT INTO Customer_Order_Details VALUES (1000006, 150008, 2000);
INSERT INTO Customer_Order_Details VALUES (1000006, 150009, 5150);

INSERT INTO Customer_Order_Details VALUES (1000007, 150001, 2450);
INSERT INTO Customer_Order_Details VALUES (1000007, 150002, 1800);
INSERT INTO Customer_Order_Details VALUES (1000007, 150005, 700);

INSERT INTO Customer_Order_Details VALUES (1000008, 150001, 4100);
INSERT INTO Customer_Order_Details VALUES (1000008, 150002, 1200);
INSERT INTO Customer_Order_Details VALUES (1000008, 150003, 1350);
INSERT INTO Customer_Order_Details VALUES (1000008, 150004, 8200);
INSERT INTO Customer_Order_Details VALUES (1000008, 150008, 2500);

INSERT INTO Customer_Order_Details VALUES (1000009, 150004, 6100);
INSERT INTO Customer_Order_Details VALUES (1000009, 150007, 4500);
INSERT INTO Customer_Order_Details VALUES (1000009, 150008, 2000);
INSERT INTO Customer_Order_Details VALUES (1000009, 150009, 5150);

INSERT INTO Customer_Order_Details VALUES (1000010, 150004, 6100);
INSERT INTO Customer_Order_Details VALUES (1000010, 150007, 4500);
INSERT INTO Customer_Order_Details VALUES (1000010, 150008, 2000);
INSERT INTO Customer_Order_Details VALUES (1000010, 150009, 5150);

##### ADDING VALUES TO THE TABLES - Customer Review #####

INSERT INTO Customer_Review VALUES (1000001, 5, 'Great service! thank you', '2020-07-24 12:39:28');
INSERT INTO Customer_Review VALUES (1000002, 4, 'Good', '2020-07-21 15:23:44');
INSERT INTO Customer_Review VALUES (1000003, 5, 'Excellent, as always', '2020-07-22 09:18:55');
INSERT INTO Customer_Review VALUES (1000004, 5, 'You guys are awesome', '2020-07-22 20:04:15');
INSERT INTO Customer_Review VALUES (1000005, 5, 'Happy with the service you provide', '2020-07-24 17:50:23');
INSERT INTO Customer_Review VALUES (1000006, 3, NULL, '2020-07-25 15:14:33');
INSERT INTO Customer_Review VALUES (1000007, 5, NULL, '2020-07-28 10:25:15');
INSERT INTO Customer_Review VALUES (1000008, 5, NULL, '2020-07-29 16:51:25');
INSERT INTO Customer_Review VALUES (1000009, 5, NULL, '2020-08-01 18:34:45');
INSERT INTO Customer_Review VALUES (1000010, 5, NULL, '2020-08-05 12:11:52');


##### ADDING VALUES TO THE TABLES - WAREHOUSE AND WAREHOUSE ADDRESS ##### WH VALUES STARTING FROM 30,001

INSERT INTO Warehouse VALUES (30001, 'Hedera Paper Ltd');
INSERT INTO Warehouse VALUES (30002, 'Hedera Paper Visitor Center');
INSERT INTO Warehouse VALUES (30003, 'Hedera Recycle Factory');

INSERT INTO Warehouse_Address VALUES (30001, 'Hedera', 'Yosef Maizer', 1, 909020);
INSERT INTO Warehouse_Address VALUES (30002, 'Hedera', 'Fridlander', 14, 919420);
INSERT INTO Warehouse_Address VALUES (30003, 'Hedera', 'Yosef Maizer', 4, 909028);

##### ADDING VALUES TO THE TABLES - MACHINE ##### MACHINE VALUES STARTING FROM 31,001

INSERT INTO Machine VALUES (31001, 30001, 'Kraft Paper Making 1092mm', 'Converts raw material: waster paper, recycled paper into craft paper');
INSERT INTO Machine VALUES (31002, 30001, 'High Speed 100TPD Jumbo Roll 3200mm', 'Make high quality A4 copy paper');
INSERT INTO Machine VALUES (31003, 30003, 'Double Blade Sheet Cutter A80', 'Cutting width of: 1092mm, 1575mm, 2000mm');
INSERT INTO Machine VALUES (31004, 30002, 'Toilet Paper Jumbo Roll Making 1092mm', 'Converts virgin pulp, waste paper into top quality toilet paper');
INSERT INTO Machine VALUES (31005, 30003, '20TPD Waste Paper Recycling Machine 2100mm', 'Make high quality photocopy paper, notebook paper');

##### ADDING VALUES TO THE TABLES - RM Inventory AND Product Inventory ##### 

INSERT INTO RM_Inventory VALUES (120001, 30001, 5850); #WH1
INSERT INTO RM_Inventory VALUES (120002, 30001, 7551);
INSERT INTO RM_Inventory VALUES (120003, 30001, 3485);
INSERT INTO RM_Inventory VALUES (120004, 30001, 7405);
INSERT INTO RM_Inventory VALUES (120005, 30001, 2500);
INSERT INTO RM_Inventory VALUES (120006, 30001, 9710);

INSERT INTO RM_Inventory VALUES (120001, 30002, 340); #WH2
INSERT INTO RM_Inventory VALUES (120002, 30002, 131);
INSERT INTO RM_Inventory VALUES (120003, 30002, 125);
INSERT INTO RM_Inventory VALUES (120004, 30002, 305);
INSERT INTO RM_Inventory VALUES (120005, 30002, 127);
INSERT INTO RM_Inventory VALUES (120006, 30002, 60);

INSERT INTO RM_Inventory VALUES (120001, 30003, 1404); #WH3
INSERT INTO RM_Inventory VALUES (120002, 30003, 987);
INSERT INTO RM_Inventory VALUES (120003, 30003, 765);
INSERT INTO RM_Inventory VALUES (120004, 30003, 495);
INSERT INTO RM_Inventory VALUES (120005, 30003, 1640);
INSERT INTO RM_Inventory VALUES (120006, 30003, 589);

INSERT INTO Product_Inventory VALUES (150001, 30001, 31); #WH1
INSERT INTO Product_Inventory VALUES (150002, 30001, 24);
INSERT INTO Product_Inventory VALUES (150003, 30001, 13);
INSERT INTO Product_Inventory VALUES (150004, 30001, 12);
INSERT INTO Product_Inventory VALUES (150005, 30001, 36);
INSERT INTO Product_Inventory VALUES (150006, 30001, 34);
INSERT INTO Product_Inventory VALUES (150007, 30001, 12); 
INSERT INTO Product_Inventory VALUES (150008, 30001, 17);
INSERT INTO Product_Inventory VALUES (150009, 30001, 38);

INSERT INTO Product_Inventory VALUES (150001, 30002, 10); #WH2
INSERT INTO Product_Inventory VALUES (150002, 30002, 23);
INSERT INTO Product_Inventory VALUES (150003, 30002, 12);
INSERT INTO Product_Inventory VALUES (150004, 30002, 34);
INSERT INTO Product_Inventory VALUES (150005, 30002, 56);
INSERT INTO Product_Inventory VALUES (150006, 30002, 12);
INSERT INTO Product_Inventory VALUES (150007, 30002, 30);

INSERT INTO Product_Inventory VALUES (150001, 30003, 10); #WH3
INSERT INTO Product_Inventory VALUES (150002, 30003, 6);
INSERT INTO Product_Inventory VALUES (150003, 30003, 3);
INSERT INTO Product_Inventory VALUES (150004, 30003, 5);
INSERT INTO Product_Inventory VALUES (150005, 30003, 2);
INSERT INTO Product_Inventory VALUES (150006, 30003, 5);
INSERT INTO Product_Inventory VALUES (150007, 30003, 8);
INSERT INTO Product_Inventory VALUES (150008, 30003, 3);
INSERT INTO Product_Inventory VALUES (150009, 30003, 4);

##### TO PRODUCE EACH PRODUCT YOU NEED THE BELOW RM #####

INSERT INTO RM_To_Product VALUES (150001, 120001); 
INSERT INTO RM_To_Product VALUES (150001, 120002);
INSERT INTO RM_To_Product VALUES (150001, 120003);
INSERT INTO RM_To_Product VALUES (150001, 120006);

INSERT INTO RM_To_Product VALUES (150002, 120001);
INSERT INTO RM_To_Product VALUES (150002, 120003);
INSERT INTO RM_To_Product VALUES (150002, 120005);
INSERT INTO RM_To_Product VALUES (150002, 120006);

INSERT INTO RM_To_Product VALUES (150003, 120001);
INSERT INTO RM_To_Product VALUES (150003, 120003);
INSERT INTO RM_To_Product VALUES (150003, 120006);

INSERT INTO RM_To_Product VALUES (150004, 120002);
INSERT INTO RM_To_Product VALUES (150004, 120003);
INSERT INTO RM_To_Product VALUES (150004, 120004);
INSERT INTO RM_To_Product VALUES (150004, 120006);

INSERT INTO RM_To_Product VALUES (150005, 120001);
INSERT INTO RM_To_Product VALUES (150005, 120006);

INSERT INTO RM_To_Product VALUES (150006, 120001);
INSERT INTO RM_To_Product VALUES (150006, 120003);
INSERT INTO RM_To_Product VALUES (150006, 120005);

INSERT INTO RM_To_Product VALUES (150007, 120001);
INSERT INTO RM_To_Product VALUES (150007, 120002);
INSERT INTO RM_To_Product VALUES (150007, 120003);
INSERT INTO RM_To_Product VALUES (150007, 120004);
INSERT INTO RM_To_Product VALUES (150007, 120006);

##### INSERTING VALUES INTO PRODUCT PRODUCED BY MACHINE #####

INSERT INTO Produced_By VALUES (150001, 31001);
INSERT INTO Produced_By VALUES (150003, 31001);

INSERT INTO Produced_By VALUES (150002, 31001);

INSERT INTO Produced_By VALUES (150003, 31004);

INSERT INTO Produced_By VALUES (150004, 31001);
INSERT INTO Produced_By VALUES (150004, 31002);

INSERT INTO Produced_By VALUES (150005, 31005);

INSERT INTO Produced_By VALUES (150006, 31005);

INSERT INTO Produced_By VALUES (150007, 31001);

##### FINISHED ADDING VALUES TO THE TABLES #####
##### FINISHED ADDING VALUES TO THE TABLES #####
##### FINISHED ADDING VALUES TO THE TABLES #####

### KPI 1 - Number of order and their total sum from the third quarter - Target over 100K ###

USE hedera_paper;

SELECT COUNT(DISTINCT co.co_ID) AS total_orders, SUM(cod.cod_quantity * p.p_price) AS total_revenue
FROM customer_order AS co
JOIN customer_order_details AS cod ON cod.co_ID = co.co_ID
JOIN product AS p ON p.p_ID = cod.p_ID
WHERE co.co_date BETWEEN '2020-07-01 00:00:00' AND '2020-10-01 00:00:00';

### KPI 2 - Customer rating of over 4/5 in Q3 ###

SELECT AVG(customer_review.cr_rate) AS q3_rating
FROM customer_review
WHERE cr_date BETWEEN '2020-07-01 00:00:00' AND '2020-10-01 00:00:00';

### KPI 3 - Average defect lower than 3% ###

SELECT CONCAT(COUNT(pc.pc_sn)/
(SELECT SUM(pi.pi_quantity) FROM product_inventory AS pi)*100, '%') AS defect_rate
FROM product_condition AS pc
WHERE pc.pc_condition = 'DEFECTIVE';

### KPI 4 - NUMBER OF NEW HIRES OF Q3 ###
SELECT COUNT(e.e_ID) AS q3_new_hires
FROM Employee AS e
WHERE e_hire_date BETWEEN '2020-07-01 00:00:00' AND '2020-10-01 00:00:00';

### GETTING SOME DETAILS OF THOSE EMPLOYEES ###

SELECT e.e_ID, e.e_first_name, e.e_last_name, e.e_hire_date
FROM Employee AS e
WHERE e_hire_date BETWEEN '2020-07-01 00:00:00' AND '2020-10-01 00:00:00';

### KPI 5 - CALCULATING THE TOTAL PROFIT OF THE 3RD QUARTER ###

SELECT c.total_income - a.salary_expenses - b.total_rm_expenses AS total_q3_profit

FROM ( 
	SELECT SUM(e.e_salary)/4 AS salary_expenses #Q3 salary
	FROM Employee AS e
) a

JOIN (
	SELECT SUM(vod.vod_quantity * rm.rm_price) AS total_rm_expenses
	FROM Vendor_Order_Details AS vod
	JOIN Raw_Material AS rm ON rm.rm_ID = vod.rm_ID
    JOIN Vendor_Order AS vo ON vo.vo_ID = vod.vo_ID
    WHERE vo.vo_date BETWEEN '2020-07-01 00:00:00' AND '2020-10-01 00:00:00'
) b

JOIN (
	SELECT SUM(cod.cod_quantity * p.p_price) AS total_income
	FROM Customer_Order_Details AS cod
	JOIN Product AS p ON p.p_ID = cod.p_ID
    JOIN Customer_Order AS co ON co.co_ID = cod.co_ID
    WHERE co.co_date BETWEEN '2020-07-01 00:00:00' AND '2020-10-01 00:00:00'
) c;

CREATE INDEX first_name_last_name_index USING BTREE
ON Employee (e_first_name, e_last_name);

CREATE INDEX birthday_index USING BTREE
ON Employee (e_birthday);

SHOW INDEX FROM Department;

SELECT e_ID ,e_first_name, e_last_name, e_birthday
FROM employee
ORDER BY e_birthday ASC;

show table status from employee;
