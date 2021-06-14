-- Keep a log of any SQL queries you execute as you solve the mystery.

-- theft time: July 28, 2020
-- place: Chamberlin Street.

select count(name) from people; --200
select count(description) from crime_scene_reports; --300
select count(street) from crime_scene_reports; --301

select description from crime_scene_reports WHERE street = "Chamberlin Street"
and year = 2020 and month = 7 and day = 28;
-- Theft of the CS50 duck took place at 10:15am at the Chamberlin Street courthouse.
-- Interviews were conducted today with three witnesses who were present at the time — each
-- of their interview transcripts mentions the courthouse.

select name, count(transcript) from interviews WHERE year = 2020 and month = 7 and day = 28; --6
select name, transcript from interviews WHERE year = 2020 and month = 7 and day = 28;
-- Ruth | Sometime within ten minutes of the theft, I saw the thief get into a car
-- 10:15am - 10:25am
-- in the courthouse parking lot and drive away.
-- If you have security footage from the courthouse parking lot, you might want to look for cars
-- that left the parking lot in that time frame.

-- Eugene | I don't know the thief's name, but it was someone I recognized. Earlier this morning,
-- before I arrived at the courthouse, I was walking by the ATM on Fifer Street and saw the thief there withdrawing some money.

-- Raymond | As the thief was leaving the courthouse, they called someone who talked to them for less than a minute.
-- In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow.
-- The thief then asked the person on the other end of the phone to purchase the flight ticket.

select count(activity) from courthouse_security_logs where year = 2020 and month = 7 and day = 28;--74
select DISTINCT(activity) from courthouse_security_logs where year = 2020 and month = 7 and day = 28;--entrance and exit
select license_plate, minute from courthouse_security_logs where year = 2020 and month = 7 and day = 28
and hour = 10 and minute >= 15 and minute <=25 and activity = "exit";
-- 5P2BI95 | 16
-- 94KL13X | 18
-- 6P58WS2 | 18
-- 4328GD8 | 19
-- G412CB7 | 20
-- L93JTIZ | 21
-- 322W7JE | 23
-- 0NTHK55 | 23

select distinct(transaction_type) from atm_transactions;
-- transaction_type; deposit; withdraw
select distinct(atm_location) from atm_transactions;
select account_number from atm_transactions where transaction_type = "withdraw" and atm_location = "Fifer Street"
and year = 2020 and month = 7 and day = 28;
-- account_number
-- 28500762
-- 28296815
-- 76054385
-- 49610011
-- 16153065
-- 25506511
-- 81061156
-- 26013199

select duration from phone_calls where year = 2020 and month = 7 and day = 28;
-- 441, 101 , 235 , 75... :: seem like durations are in second unit
select caller, receiver, duration from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60;
-- (130) 555-0289 | (996) 555-8899 | 51
-- (499) 555-9472 | (892) 555-8872 | 36
-- (367) 555-5533 | (375) 555-8161 | 45 X
-- (609) 555-5876 | (389) 555-5198 | 60
-- (499) 555-9472 | (717) 555-1342 | 50
-- (286) 555-6063 | (676) 555-6554 | 43
-- (770) 555-1861 | (725) 555-3243 | 49 X
-- (031) 555-6622 | (910) 555-3251 | 38
-- (826) 555-1652 | (066) 555-9701 | 55
-- (338) 555-6650 | (704) 555-2131 | 54

select name, id from people where
license_plate in
(select license_plate from courthouse_security_logs where year = 2020 and month = 7 and day = 28
and hour = 10 and minute >= 15 and minute <=25 and activity = "exit")
and phone_number in
(select caller from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60);
-- name | id
-- Roger | 398010
-- Russell | 514354 x
-- Evelyn | 560886
-- Ernest | 686048 x

select name, account_number, person_id, phone_number, passport_number from
people JOIN bank_accounts ON id = person_id
where license_plate in
    (select license_plate from courthouse_security_logs where year = 2020 and month = 7 and day = 28
    and hour = 10 and minute >= 15 and minute <=25 and activity = "exit")
    and phone_number in
    (select caller from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60)
and account_number in
    (select account_number from atm_transactions where transaction_type = "withdraw" and atm_location = "Fifer Street"
    and year = 2020 and month = 7 and day = 28);
-- name | account_number | person_id | phone_number | passport_number
-- Ernest | 49610011 | 686048 | (367) 555-5533 | 5773159633
-- Russell | 26013199 | 514354 | (770) 555-1861 | 3592750733


select id, city from airports where city = "Fiftyville";
-- id | city
-- 8 | Fiftyville
select id, hour, minute, destination_airport_id from flights where origin_airport_id =
(select id from airports where city = "Fiftyville")
and year = 2020 and month = 7 and day = 29 ORDER BY hour, minute;
-- id | hour | minute | destination_airport_id
-- 36 | 8 | 20 | 4
-- 43 | 9 | 30 | 1
-- 23 | 12 | 15 | 11
-- 53 | 15 | 20 | 9
-- 18 | 16 | 0 | 6

select id, destination_airport_id from flights where origin_airport_id = (select id from airports where city = "Fiftyville")
and year = 2020 and month = 7 and day = 29 ORDER BY hour, minute LIMIT 1;
-- id | destination_airport_id
-- 36 | 4

select city from airports where id =
(select destination_airport_id from flights where origin_airport_id = (select id from airports where city = "Fiftyville")
and year = 2020 and month = 7 and day = 29 ORDER BY hour, minute LIMIT 1);
-- London

select name from people where passport_number in
(
    select passport_number from passengers where flight_id =
    (select id from flights where origin_airport_id = (select id from airports where city = "Fiftyville")
    and year = 2020 and month = 7 and day = 29 ORDER BY hour, minute LIMIT 1)
    and passport_number in
    (
    select passport_number from
    people JOIN bank_accounts ON id = person_id
    where license_plate in
        (select license_plate from courthouse_security_logs where year = 2020 and month = 7 and day = 28
        and hour = 10 and minute >= 15 and minute <=25 and activity = "exit")
        and phone_number in
        (select caller from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60)
    and account_number in
        (select account_number from atm_transactions where transaction_type = "withdraw" and atm_location = "Fifer Street"
        and year = 2020 and month = 7 and day = 28)
    )
);
-- passport_number
-- 5773159633
-- Ernest

-- (367) 555-5533 | (375) 555-8161 | 45 X

select name from people where phone_number =
(   select receiver from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60
    and caller =
    (   select caller from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60
        INTERSECT
        select phone_number from people where passport_number in
        (
            select passport_number from passengers where flight_id =
            (select id from flights where origin_airport_id = (select id from airports where city = "Fiftyville")
            and year = 2020 and month = 7 and day = 29 ORDER BY hour, minute LIMIT 1)
            and passport_number in
            (
            select passport_number from
            people JOIN bank_accounts ON id = person_id
            where license_plate in
                (select license_plate from courthouse_security_logs where year = 2020 and month = 7 and day = 28
                and hour = 10 and minute >= 15 and minute <=25 and activity = "exit")
                and phone_number in
                (select caller from phone_calls where year = 2020 and month = 7 and day = 28 and duration <= 60)
            and account_number in
                (select account_number from atm_transactions where transaction_type = "withdraw" and atm_location = "Fifer Street"
                and year = 2020 and month = 7 and day = 28)
            )
        )
    )
);
-- receiver
-- (375) 555-8161
-- name
-- Berthold