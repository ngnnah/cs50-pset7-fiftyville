# cs50-pset7-fiftyville

## Most thrilling learning exercise. SQL can seriously solve crimes!

The CS50 Duck has been stolen! The town of Fiftyville has called upon you to solve the mystery of the stolen duck. Authorities believe that the thief stole the duck and then, shortly afterwards, took a flight out of town with the help of an accomplice. The Fiftyville authorities have taken some of the town’s records from around the time of the theft and prepared a SQLite database for you, fiftyville.db, which contains tables of data from around the town. 

You need to solve the crime, and fill out the following info in answers.txt (SPOILER ALERT: I filled my correct answers):
- The THIEF is: 
- The thief ESCAPED TO: 
- The ACCOMPLICE is: 

### CHECK OUT queries I have used and my logics which helps identify the culprit, in log.sql
### One of the many queries looks something like this:
![image](https://user-images.githubusercontent.com/58123635/121844984-c9fd5580-ccb2-11eb-9a96-fd422bf1cfb8.png)

## SQL query looks difficult to the eyes, but actually are quite easy and intuitive to write.

### Some of my own notes, while watching *my favorite* Week7 lecture [video](https://cs50.harvard.edu/x/2021/weeks/7/)


CSV  (static unchanging data) = flat-file database (spreadsheet): convenient; but querying is inefficient , especially when db get large

COME the Relational databases: program that manage data (via tables)

Processing CSV files:

from csv import reader
![image](https://user-images.githubusercontent.com/58123635/121845426-6aec1080-ccb3-11eb-84fd-318e5880914a.png)

SQLite: each database is just a binary file (filled with 0101010110...)


![image](https://user-images.githubusercontent.com/58123635/121845538-966efb00-ccb3-11eb-9ea3-382b23240901.png)


FUNCTIONS: AVG, COUNT, DISTINCT, LOWER, MAX, MIN, UPPER

CONDITIONS: WHERE, LIKE, ORDER BY, LIMIT, GROUP BY

EXAMPLES:

- SELECT title FROM shows WHERE title LIKE "%Office$"'; NOTE: (%: zero or more characters)
- SELECT DISTINCTS(UPPER(title)) FROM shows ORDER BY UPPER(title);
- SELECT UPPER(title), COUNT(title) FROM shows GROUP BY UPPER(title) ORDER BY COUNT(title) DESC/ASC;
- SELECT UPPER(TRIM(title)), COUNT(title) FROM shows GROUP BY UPPER(TRIM((title)) ORDER BY COUNT(title) DESC/ASC LIMIT 10;
- INSERT INTO shows (Timestamp, title, genres) VALUES("now", "The Muppet Show", "Comedy, Musical");


NOTE:
- PRIMARY KEY: a column in a table that uniquely identifies every row (shows col)
-- V.S. Unique key: Primary key will not accept NULL values whereas Unique key can accept one NULL value. (a unique column might have rows with NULL values). A table can have only primary key (column), and multiple unique keys (columns).

- FOREIGN KEY: refer to a column with primary key.

INDEX: helps achieve Logarithmic search time (using a B-tree: wide, and short i.e. A Stocky Tree): 

e.g. CREATE INDEX name ON table (column,...);

JOIN: helps extract info from multiple tables. The tutorial [video](https://cs50.harvard.edu/x/2021/shorts/sql/) explains JOIN usage pretty well.

Watchout for SQL Injection ATTACK: dont use Python f-string inside db.execute commands. For example:

- db.execute(f"... {username} {password}") >> ignore password check = BAD :(
- Use placeholder (?) db.execute(" username = ? AND password = ?", username, password) >> this is good & safe :)

And final note: With large database, and many clients making requests at the same time, race condition can happen, a nice term for this is: *failed whale* (e.g. Kim Kadashian's Egg photo network congestion)!

The solution: many databases provide atomicity (binary action: complete/not complete) & isolation (actions are executed, as if, sequentially) via TRANSACTION.
