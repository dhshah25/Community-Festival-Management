EXPLAIN ANALYZE
SELECT e."EventID", e."Title", e."EventDate", e."StartTime", e."EndTime"
FROM public."Event" e
WHERE e."FestivalID" = 1
ORDER BY e."EventDate", e."StartTime";