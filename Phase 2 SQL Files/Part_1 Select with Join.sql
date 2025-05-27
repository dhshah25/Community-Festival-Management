-- Select Query with Join
SELECT p."PerformanceID", e."Title" AS Event, a."Name" AS Artist, p."PerformanceTime"
FROM public."Performance" p
JOIN public."Event" e ON p."EventID" = e."EventID"
JOIN public."Artist" a ON p."ArtistID" = a."ArtistID";
