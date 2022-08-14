-- Given a table events with the following structure:
--   create table events (
--       event_type integer not null,
--       value integer not null,
--       time timestamp not null,
--       unique(event_type, time)
--   );

-- write an SQL query that, for each event_type that has been registered more than once, returns the difference between the latest (i.e. the most recent in terms of time) and the second latest value. The table should be ordered by event_type (in ascending order).

-- For example, given the following data:
--    event_type | value      | time
--   ------------+------------+--------------------
--    2          | 5          | 2015-05-09 12:42:00
--    4          | -42        | 2015-05-09 13:19:57
--    2          | 2          | 2015-05-09 14:48:30
--    2          | 7          | 2015-05-09 12:54:39
--    3          | 16         | 2015-05-09 13:19:57
--    3          | 20         | 2015-05-09 15:01:09

-- your query should return the following rowset:
--    event_type | value
--   ------------+-----------
--    2          | -5
--    3          | 4

-- For the event_type 2, the latest value is 2 and the second latest value is 7, so the difference between them is −5.

-- The names of the columns in the rowset don't matter, but their order does.

--DDL
  create table events (
      event_type integer not null,
      value integer not null,
      time timestamp not null,
      unique(event_type, time)
  );
  
 
insert into events values (2, 5, '2015-05-09 12:42:00');
insert into events values (4, -42, '2015-05-09 13:19:57');
insert into events values (2, 2, '2015-05-09 14:48:30');
insert into events values (2, 7, '2015-05-09 12:54:39');
insert into events values (3, 16, '2015-05-09 13:19:57');
insert into events values (3,20, '2015-05-09 15:01:09');

-- DQL

with cte as
(
select a.event_type
	 ,b.value - Lag(b.value,1) OVER (
		ORDER BY a.event_type, b.time
	) diff
	,b.time
, rank() over (PARTITION BY a.event_type order by b.time) rnk
from (
select event_type, count(*) from events
group by event_type
having count(*) > 1) a 
inner join events b on a.event_type = b.event_type
order by a.event_type, b.time desc
)

SELECT event_type, diff as value FROM
(
select event_type, diff, row_number() over (partition by event_type order by time desc)
from cte order by event_type, time
) a
where a.row_number = 1
