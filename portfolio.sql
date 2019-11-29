--SELECT 'DORP TABLE "'||TABLE_NAME||'" CASCADE CONSTRAINTS;' FROM USER_TABLES;
--
--BEGIN
--    for c in (SELECT TABLE_NAME FROM USER_TABLES)loop
--        EXECUTE IMMEDIATE('DROP TABLE '||c.TABLE_NAME||' CASCADE CONSTRAINTS');
--    end loop;
--END;
-- ���̺� ����
DROP TABLE seats;
DROP TABLE flight_reserve;
DROP SEQUENCE reserve_seq;
drop TABLE members;
DROP TABLE flights;
DROP VIEW view_flight_reserve;
drop TABLE hotel_reserve;
drop TABLE hotels;

-- ȸ�� ���̺�
CREATE TABLE members(
id          VARCHAR2(20),
pwd         VARCHAR2(20),
fname_ko    VARCHAR2(20),
lname_ko    VARCHAR2(20),
fname_en    VARCHAR2(20),
lname_en    VARCHAR2(20),
nationality VARCHAR2(10),
birth       DATE,
gender      CHAR(1),
address     VARCHAR2(100),
email       VARCHAR2(40),
phone       VARCHAR2(20),
useyn       CHAR(1) DEFAULT 'Y',
regdate     DATE DEFAULT sysdate,
authority   CHAR(1) DEFAULT 'N',
CONSTRAINT pk_id PRIMARY KEY(id),
CONSTRAINT chk_use CHECK(useyn IN('Y','N')),
CONSTRAINT chk_authority CHECK(authority IN('Y', 'N')),
CONSTRAINT chk_gender CHECK(gender IN('M', 'W'))
);



COMMENT ON TABLE members IS 'ȸ��';
COMMENT ON COLUMN members.id IS '���̵�';
COMMENT ON COLUMN members.pwd IS '��й�ȣ';
COMMENT ON COLUMN members.fname_ko IS '��';
COMMENT ON COLUMN members.lname_ko IS '�̸�';
COMMENT ON COLUMN members.nationality IS '����';
COMMENT ON COLUMN members.address IS '�ּ�';
COMMENT ON COLUMN members.email IS '�̸���';
COMMENT ON COLUMN members.phone IS '��ȭ��ȣ';
COMMENT ON COLUMN members.useyn IS '''N'' Ż�𿩺�';
COMMENT ON COLUMN members.regdate IS '������';
COMMENT ON COLUMN members.authority IS '''Y''�����ڱ���';

INSERT INTO members(id, pwd, fname_ko, lname_ko, fname_en, lname_en, nationality, birth, gender, address, email, phone)
        VALUES('test', '1', '', '�׽�Ʈ', '', 'test', '�ѱ�', TO_DATE('19980101','YYYYMMDD'), 'M','test home', 'test@email.com', '010-7777-7777');
INSERT INTO members(id, pwd, fname_ko, lname_ko, fname_en, lname_en, nationality, birth, gender, address, email, phone, authority) 
    VALUES('admin','1', '', '������', '', 'admin', '�ѱ�', TO_DATE('20000101','YYYYMMDD'), 'M', '������ ��', 'admin@email.com', '010-0000-0000', 'Y');


-- �װ��� ���̺�
CREATE TABLE flights(
flight VARCHAR2(15),
airline VARCHAR2(30),
departure_city VARCHAR2(20),
arrival_city VARCHAR2(20),
departure_date date,
arrival_date date,
departure_time VARCHAR2(10),
arrival_time VARCHAR2(10),
CONSTRAINT pk_flight PRIMARY KEY(flight)
);


@flight_insert.sql;



-- �¼� ���̺�
CREATE TABLE seats(
seat_code   VARCHAR2(10),
seat_type   VARCHAR2(22),
seat_num    VARCHAR2(10), 
f_price     NUMBER,
reserve_yn  CHAR(1) DEFAULT 'N',
flight      VARCHAR2(15),
CONSTRAINT pk_seat_code PRIMARY KEY(seat_code),
CONSTRAINT chk_reserve_yn CHECK(reserve_yn IN('Y','N')),
CONSTRAINT fk_flight FOREIGN KEY(flight) REFERENCES flights(flight)
);


-- �װ����� 
CREATE TABLE flight_reserve(
f_reserve_code  NUMBER,
f_reserve_name  VARCHAR2(20),
f_reserve_date  DATE,
passport        VARCHAR2(30),
f_comment       VARCHAR2(300),
seat_type       VARCHAR2(22),
seat_num        VARCHAR2(10),
id              VARCHAR2(20),
flight          VARCHAR2(15),
CONSTRAINT pk_f_reserve_code PRIMARY KEY(f_reserve_code),
CONSTRAINT fk_id FOREIGN KEY(id) REFERENCES members(id),
CONSTRAINT fk_flight_reserve FOREIGN KEY(flight) REFERENCES flights(flight)
);
CREATE SEQUENCE reserve_seq START WITH 1 INCREMENT BY 1 NOCYCLE NOORDER NOCACHE;

@seat_insert.sql;



CREATE OR REPLACE VIEW view_flight_reserve
AS SELECT 
fr.*,
f.airline,f.arrival_city, f.arrival_date, f.arrival_time, f.departure_city, f.departure_date, f.departure_time,
s.f_price
FROM flight_reserve fr, flights f, seats s
WHERE s.reserve_yn='Y' AND f.flight=fr.flight AND f.flight=s.flight;

--select * from view_flight_reserve;
--
--
--
--
--SELECT * FROM (select * from flights
--		WHERE departure_city='��õ' AND arrival_city='����ī��' AND seats_type ='�Ϲݼ�'
--		AND departure_date >= to_date('20191111', 'YYYYMMDD'))
--where (departure_time='9:00' and airline='�ƽþƳ��װ�') or (airline='�ƽþƳ��װ�') or (departure_time='9:00');
--
--
--COMMIT;
--select distinct departure_city from flights where departure_city = '����';
--
--SELECT distinct arrival_city FROM flights
--where departure_city = '����';
--SELECT distinct seat_type FROM seats;
--
--SELECT DISTINCT to_char(departure_date, 'DD')as dd FROM flights
--where departure_city='��õ' and arrival_city='ȫ��'
--order by dd asc;
