EXPLAIN ANALYZE
SELECT f."FestivalID", f."Name", COUNT(t."TicketID") AS total_tickets_sold
FROM public."Festival" f
JOIN public."Event" e ON f."FestivalID" = e."FestivalID"
JOIN public."Ticket" t ON e."EventID" = t."EventID"
WHERE f."FestivalID" = 123
GROUP BY f."FestivalID", f."Name"
ORDER BY total_tickets_sold DESC;
