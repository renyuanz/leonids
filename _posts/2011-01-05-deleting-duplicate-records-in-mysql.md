---
layout: post
title: Deleting duplicate records in MySQL
date: 2011-01-05 00:29:40.000000000 +00:00
categories:
- MySQL
tags:
- duplication
- mysql
---
Sometimes you have multiple records where the same data spans across multiple columns in the table and you'd like to clean up that mess by leaving only one copy per unique set of records.

Let's consider the following recordset:
{% highlight mysql %}
mysql> select * from testdup;
+----+------+------+------+
| id | a    | b    | c    |
+----+------+------+------+
|  1 | AAA  | BBB  | CCC  |
|  2 | AAA  | BBB  | CCC  |
|  3 | AAA  | BBB  | CCC  |
|  4 | AAA  | BBB  | CCC  |
|  5 | AAA  | BBB  | CCC  |
|  6 | AAA  | BBB  | CCC  |
|  7 | AAA  | BBB  | CCC  |
|  8 | AAA  | BBB  | CCC  |
|  9 | AAA  | BBB  | CCC  |
| 10 | AAA  | BBB  | CCC  |
| 11 | AAA  | BBB  | CCC  |
| 12 | CCC  | DDD  | AAA  |
| 13 | CCC  | DDD  | AAA  |
| 14 | CCC  | DDD  | AAA  |
| 15 | CCC  | DDD  | AAA  |
| 16 | CCC  | DDD  | AAA  |
| 17 | CCC  | DDD  | AAA  |
| 18 | CCC  | DDD  | AAA  |
| 19 | CCC  | DDD  | AAA  |
| 20 | CCC  | DDD  | AAA  |
| 21 | CCC  | DDD  | AAA  |
| 22 | CCC  | DDD  | AAA  |
| 23 | AAA  | BBB  | CCC  |
+----+------+------+------+
23 rows in set (0.00 sec)
{% endhighlight %}
Now we want to clean it up to have the result as following:
{% highlight mysql %} 
|  1 | AAA  | BBB  | CCC  |
| 12 | CCC  | DDD  | AAA  |
{% endhighlight %}
This is quite simple.
Firstly we will create a table containing only the records we want to create the pristine
{% highlight mysql %}
mysql> select * from testdup_clean;
+----+------+------+------+
| id | a    | b    | c    |
+----+------+------+------+
|  1 | AAA  | BBB  | CCC  |
| 12 | CCC  | DDD  | AAA  |
+----+------+------+------+
2 rows in set (0.00 sec)
{% endhighlight %}
This is our table that contains the clean record set.
Now, if you have unique ID field in the original table you can remove the unwanted records with the following query:
{% highlight mysql %}
DELETE FROM testdup WHERE id NOT IN ( SELECT id FROM testdup_clean);
{% endhighlight %}
Otherwise, if you don't have the ID field, you can just truncate the original table and insert the records from the clean table with:
{% highlight bash %} 
mysql> TRUNCATE testdup;
Query OK, 0 rows affected (0.02 sec)
mysql> INSERT INTO testdup SELECT * from testdup_clean;
Query OK, 2 rows affected (0.00 sec)
Records: 2  Duplicates: 0  Warnings: 0
mysql> select * from testdup_clean;
+----+------+------+------+
| id | a    | b    | c    |
+----+------+------+------+
|  1 | AAA  | BBB  | CCC  |
| 12 | CCC  | DDD  | AAA  |
+----+------+------+------+
2 rows in set (0.00 sec)
{% endhighlight %}
Hope that helps somebody :-)
