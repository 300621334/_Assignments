select * from cat;
select * from weather;
desc weather;

--RPAD(string,length [,'set'])  --set is a unordered set of one or more chars. Default padding is done with spaces
--LPAD(string,length [,'set'])
select city || condition from weather;--one way to concatenate
select concat( city , condition) from weather;--other way to catenate
select concat(city || ' ',condition) from weather;--literal string after comma gives error
select rpad(city, 35, '.') , temperature from WEATHER; --right padding
select rpad(city, 20, '.*.') from weather;
select '12-DEC-2010' from weather;--even thou no col was specified from the target table but just a date string was given, it still idsplays it 
select '12-DEC-2010', lpad(city, 20) from weather;--default padding is done with spaces
select lpad('2-jan-12', 30) from weather;--instead of passing col name variable, just a string date used.



--RTRIM(string [,'set'])  --set is an unordered set of char(s)
--LTRIM(string [,'set'])
select * from MAGAZINE;
select rtrim(title,'."') from MAGAZINE;--more than one args bw single quotes. trims dot and/or double quote
select ltrim(title, '."') from magazine;

select trim(trailing '.' from title) from MAGAZINE;
select trim(leading '"' from title) from MAGAZINE;
select trim(trailing '"' from title) from MAGAZINE;
select trim(both '"' from title) from MAGAZINE;--why TRIM cannot have >1 args?
select trim(both from title) from MAGAZINE;--not specifying 'set' removes spaces by defaults
select trim(title) from magazine;--default set to be trimed is spaces. Not specifying "both" does the same as both!!!
select trim('.' from title) from magazine;--only terminal chars removed
select trim('"' from title) from magazine;


select city, upper(city), lower(city), initCap(city) from weather;


--SUBSTR(string,start [,count])
select * from ADDRESS;
select RPAD(lastname || ',' || firstname, 25, '.') as "Name", substr(phone, 5) as "Phone" from ADDRESS;--start index is NOT zero based!!!
select rpad(lastname||','||firstname,20) "Full Name", substr(phone, 9, 4) "Phone" from address;



--INSTR(string,set [,start [,occurrence ] ]) --searches & returns index-position of 2nd param in 1st param-field
select * from magazine;
select author, substr(author, instr(author, ',')+2) from Magazine;
select author from magazine where instr(author, 'O', 1, 2) > 0;--zero would have meant NOT found (i.e. either 1 'O' or no 'O')




--SOUNDEX:	used	in	a	where	clause	to	find	words	that	sound	like	other	words.
select author from magazine where soundex(author) = soundex('Banheffer');
--Can we use SOUNDEX to find duplicates with slight differences in spelling?Yes.
select * from address;
select a.lastname from address a, address b where soundex(a.lastname) = soundex(b.lastname);--not working as expected
select a.LastName, a.FirstName, a.Phone from ADDRESS a, ADDRESS b where SOUNDEX(a.LastName)=SOUNDEX(b.LastName);--not working as expected





--Numeric	Single-Row Functions --we use dummy table "dual" just to satisfy syntax.
select POWER(3,2) from dual;
select ROUND(3.14159,3) from dual;
select TRUNC(3.1457,2) from dual;
select CEIL(5.7) from dual;--round up "ceiling"
select FLOOR(3.8) from dual;--round down
select ABS(-7) from dual; --Absolute value
select MOD(10,3) from dual; --modulus = remainder

select * from math;
select name, above, below, ABOVE+BELOW as plus, ABOVE-BELOW as subtract, ABOVE*BELOW as times, ABOVE/BELOW as div from math where name='LOW DECIMAL';--don't use 'minus' as a field name coz reserved word




--NVL(value,substitute). If value is NULL, this function is equal to substitute. If value is not NULL, this function is equal to value.
select * from math;
select name, above, below, NVL(empty , 99999) from math where name='WHOLE NUMBER';--only if "EMPTY" is NULL then it's set to "99999"

--NVL2 ( expr1 , expr2 , expr3 ) If expr1 is not NULL, NVL2 returns expr2. If expr1 is NULL, NVL2 returns expr3.
--string should be in quotes otherwise SQL thinks it's a variable. So get err "invalid identifier" with>>> NVL2(below, aaa, bbb)
select below, EMPTY, NVL2(below, 'aaa', 'bbb'), NVL2(empty, 'aaa', 'bbb') from math where name='HIGH DECIMAL';
select NVL2(empty, '999', '111') from math;--number as string appears on LEFT of col. While integer appears on RIGHT.
select NVL2(empty, 999, 111) from math;





--Group-Value	Functions. We can nest group-value	and	single-value functions
select * from LOCATION where CONTINENT = 'EUROPE';
select trunc(avg(LATITUDE), 3), count(LATITUDE), min(LATITUDE), max(LATITUDE), sum(LATITUDE) from LOCATION where CONTINENT = 'EUROPE';
select sum(abs(LATITUDE)) from LOCATION where CONTINENT = 'EUROPE'; 



--All	group-value	func&ons	have	a	DISTINCT	versus	ALL	op&on. e.g.	COUNT([DISTINCT | ALL] value)
select count(distinct CONTINENT), count(all CONTINENT), count(CONTINENT), count(*) from LOCATION;



--GREATEST(col1, col2, col3,...)	and	LEAST	list	func&ons:	compare	the	values	of	each	of	several	columns	in	a	row. Values	can	be	characters,	numbers,	or	dates.
select * from weather;
select city,TEMPERATURE, HUMIDITY, greatest(TEMPERATURE, HUMIDITY) from weather;

--select City, SampleDate, MAX(Noon) from COMFORT; --this will give error " not a single-group group function"
--select City, SampleDate, Noon  from COMFORT where Noon = (select MAX(Noon) from COMFORT); --this will work



--The DUAL table is a special one-row, one-column table present by default in Oracle and other database installations. In Oracle, the table has a single VARCHAR2(1) column called DUMMY that has a value of 'X'. It is suitable for use in selecting a pseudo column such as SYSDATE or USER.
select * from dual;

select Current_Date from DUAL;
select SYSTIMESTAMP from DUAL;
select '03-MAR-2012' + 2.5 from DUAL;--error WHY??? --this default date format & hence implicitly converted to DATE data-type, & so we can add 2.5 days
select to_date('03-FEB-12', 'DD-MON-YY') + 2.5 from DUAL;--add 2.5 days
select to_date('03-FEB-2012') + 2.5 from DUAL;
select to_date('03-FEB-12') + 2.5 from DUAL; --ERROR; wrong conversion coz default format is YYYY. Implict conversion goes wrong without specifying format
--select ADD_MONTHS(CelebratedDate,-6) - 1 AS LastDay from HOLIDAY_USA where Holiday = 'COLUMBUS DAY'; --minus 6 mo & then minus 1 day
select TO_CHAR (SYSDATE, 'MM-DD-YYYY HH24:MI:SS') "NOW" from dual; 
select TO_CHAR (SYSDATE, 'MM-DD-YYYY HH12:MI:SS') "NOW" from dual; 
select TO_CHAR (CURRENT_DATE, 'MM-DD-YYYY HH12:MI:SS') "NOW" from dual; 
--alter session set NLS_DATE_FORMAT = "DD/MON/YYYY"; --to change default date format of 03-MAR-2012
alter session set NLS_DATE_FORMAT = "DD-MON-YYYY";
select * from magazine where ISSUEDATE = '23-MAY-1988';
select LEAST( TO_DATE('20-JAN-04'), TO_DATE('20-DEC-04')) from DUAL;--String literals are NOT converted; we must use TO_DATE.
select LEAST('20-JAN-2004', '20-DEC-2004') from DUAL;--This is default format hence implicitly converts without TO_DATE
select next_day(Current_Date + 7 , 'monday') from DUAL;--next date that falls on monday
select last_day(Current_Date) from DUAL;--produces last date of given mo
select floor(months_between(sysdate,'05-OCT-1979')/12) as "Age" from dual;--MONTHS_BETWEEN 2 dates
select to_char(ROUND(SysDate), 'MM-DD-YYYY HH24:MI:SS') from DUAL;--if afterNoon then gives 12AM of next date, else 12AM of current date
select to_char(TRUNC(SysDate), 'MM-DD-YYYY HH24:MI:SS') from DUAL;--TRUNC() Returns current day with time set to 12 A.M.
--
select TO_DATE('02/28/08','MM/DD/YY') from DUAL;
select TO_DATE(11051946,'MMDDYYYY') from DUAL;
select to_char(sysdate, '"Today is" DD "of" fmMonth "and year is" YYYY "and time is" HH:MI') from dual;
--select Holiday, CelebratedDate from HOLIDAY_USA where CelebratedDate IN ('01-JAN-04', '22-FEB-04');
--select Holiday, CelebratedDate from HOLIDAY_USA where CelebratedDate BETWEEN '01-JAN-04' and '22-FEB-04';








 
rem ******************
rem The LOCATION Table
rem ******************

-->> Run this command to make sure that table does not exit.

drop table LOCATION;


-->> Run the following command to create table - Location

create table LOCATION (
City       VARCHAR2(25),
Country    VARCHAR2(25),
Continent  VARCHAR2(25),
Latitude   NUMBER,
NorthSouth CHAR(1),
Longitude  NUMBER,
EastWest   CHAR(1)
);

-->> Run the following command to insert data/records into above table.

insert into LOCATION values ('ATHENS','GREECE','EUROPE',37.58,'N',23.43,'E');
insert into LOCATION values ('CHICAGO','UNITED STATES','NORTH AMERICA',41.53,'N',87.38,'W');
insert into LOCATION values ('CONAKRY','GUINEA','AFRICA',9.31,'N',13.43,'W');
insert into LOCATION values ('LIMA','PERU','SOUTH AMERICA',12.03,'S',77.03,'W');
insert into LOCATION values ('MADRAS','INDIA','INDIA',13.05,'N',80.17,'E');
insert into LOCATION values ('MANCHESTER','ENGLAND','EUROPE',53.30,'N',2.15,'W');
insert into LOCATION values ('MOSCOW','RUSSIA','EUROPE',55.45,'N',37.35,'E');
insert into LOCATION values ('PARIS','FRANCE','EUROPE',48.52,'N',2.20,'E');
insert into LOCATION values ('SHENYANG','CHINA','CHINA',41.48,'N',123.27,'E');
insert into LOCATION values ('ROME','ITALY','EUROPE',41.54,'N',12.29,'E');
insert into LOCATION values ('TOKYO','JAPAN','ASIA',35.42,'N',139.46,'E');
insert into LOCATION values ('SYDNEY','AUSTRALIA','AUSTRALIA',33.52,'S',151.13,'E');
insert into LOCATION values ('SPARTA','GREECE','EUROPE',37.05,'N',22.27,'E');
insert into LOCATION values ('MADRID','SPAIN','EUROPE',40.24,'N',3.41,'W');


-----------------------------------------------------------------------------------------

rem *****************
rem The WEATHER Table
rem *****************

-->> Run this command to make sure that table does not exit.

drop table WEATHER;

-->> Run the following command to create table - Weather

create table WEATHER (
City         VARCHAR2(11),
Temperature  NUMBER,
Humidity     NUMBER,
Condition    VARCHAR2(9)
);

-->> Run the following command to insert data/records into above table.

insert into WEATHER values ('LIMA',45,79,'RAIN');
insert into WEATHER values ('PARIS',81,62,'CLOUDY');
insert into WEATHER values ('MANCHESTER',66,98,'FOG');
insert into WEATHER values ('ATHENS',97,89,'SUNNY');
insert into WEATHER values ('CHICAGO',66,88,'RAIN');
insert into WEATHER values ('SYDNEY',69,99,'SUNNY');
insert into WEATHER values ('SPARTA',74,63,'CLOUDY');


------------------------------------------------------------------------------------------

rem *****************
rem The ADDRESS Table
rem *****************

-->> Run this command to make sure that table does not exit.

drop table ADDRESS;

-->> Run the following command to create table - Address

create table ADDRESS (
LastName   VARCHAR2(25),
FirstName  VARCHAR2(25),
Street     VARCHAR2(50),
City       VARCHAR2(25),
State      CHAR(2),
Zip        NUMBER,
Phone      VARCHAR2(12),
Ext        VARCHAR2(5)
);


-->> Run the following command to insert data/records into above table.

insert into ADDRESS values ('BAILEY', 'WILLIAM', null,null,null,null,'213-555-0223',null);
insert into ADDRESS values ('ADAMS', 'JACK', null,null,null,null,'415-555-7530',null);
insert into ADDRESS values ('SEP', 'FELICIA', null,null,null,null,'214-555-8383',null);
insert into ADDRESS values ('DE MEDICI', 'LEFTY', null,null,null,null,'312-555-1166',null);
insert into ADDRESS values ('DEMIURGE', 'FRANK', null,null,null,null,'707-555-8900',null);
insert into ADDRESS values ('CASEY', 'WILLIS', null,null,null,null,'312-555-1414',null);
insert into ADDRESS values ('ZACK', 'JACK', null,null,null,null,'415-555-6842',null);
insert into ADDRESS values ('YARROW', 'MARY',null,null,null,949414302,'415-555-2178',null);
insert into ADDRESS values ('WERSCHKY', 'ARNY', null,null,null,null,'415-555-7387',null);
insert into ADDRESS values ('BRANT', 'GLEN', null,null,null,null,'415-555-7512',null);
insert into ADDRESS values ('EDGAR', 'THEODORE', null,null,null,null,'415-555-6252',null);
insert into ADDRESS values ('HARDIN', 'HUGGY', null,null,null,null,'617-555-0125',null);
insert into ADDRESS values ('HILD', 'PHIL', null,null,null,null,'603-555-2242',null);
insert into ADDRESS values ('LOEBEL', 'FRANK', null,null,null,null,'202-555-1414',null);
insert into ADDRESS values ('MOORE', 'MARY', null,null,null,601262460,'718-555-1638',null);
insert into ADDRESS values ('SZEP', 'FELICIA', null,null,null,null,'214-555-8383',null);
insert into ADDRESS values ('ZIMMERMAN', 'FRED', null,null,null,null,'503-555-7491',null);

------------------------------------------------------------------------------------------------


rem ******************
rem The MAGAZINE Table
rem ******************

-->> Run this command to make sure that table does not exit.

drop table magazine;

-->> Run the following command to create table - Magazine

create table magazine (
Name       VARCHAR2(16),
Title      VARCHAR2(37),
Author     VARCHAR2(25),
IssueDate  DATE,
Page       NUMBER
);

-->> Run the following command to insert data/records into above table.

insert into MAGAZINE values ('BERTRAND MONTHLY','THE BARBERS WHO SHAVE THEMSELVES.','BONHOEFFER, DIETRICH', TO_DATE('23-MAY-1988','DD-MON-YYYY'),70);
insert into MAGAZINE values ('LIVE FREE OR DIE','"HUNTING THOREAU IN NEW HAMPSHIRE"','CHESTERTON, G.K.', TO_DATE('26-AUG-1981','DD-MON-YYYY'),320);
insert into MAGAZINE values ('PSYCHOLOGICA','THE ETHNIC NEIGHBORHOOD','RUTH, GEORGE HERMAN',TO_DATE('18-SEP-1919','DD-MON-YYYY'),246);
insert into MAGAZINE values ('FADED ISSUES','RELATIONAL DESIGN AND ENTHALPY','WHITEHEAD, ALFRED',TO_DATE('20-JUN-1926','DD-MON-YYYY'),279);
insert into MAGAZINE values ('ENTROPY WIT','"INTERCONTINENTAL RELATIONS."','CROOKES, WILLIAM', TO_DATE('20-SEP-1950','DD-MON-YYYY'),20);

--------------------------------------------------------------------------------------------


rem **************
rem The MATH Table
rem **************

-->> Run this command to make sure that table does not exit.

drop table MATH;

-->> Run the following command to create table - Math


create table MATH (
Name          VARCHAR2(12),
Above         NUMBER,
Below         NUMBER,
Empty         NUMBER
);


-->> Run the following command to insert data/records into above table.

insert into MATH values ('WHOLE NUMBER',11,-22,null);
insert into MATH values ('LOW DECIMAL',33.33,-44.44,null);
insert into MATH values ('MID DECIMAL',55.5,-55.5,null);
insert into MATH values ('HIGH DECIMAL',66.666,-77.777,null);

---------------------------------------------------------------------------------------------




