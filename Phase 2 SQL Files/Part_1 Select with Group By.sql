-- Selecting the total number of tickets sold per event
-- Select Query with Group By
SELECT t."EventID", e."Title", COUNT(t."TicketID") AS TicketsSold
FROM public."Ticket" t
JOIN public."Event" e ON t."EventID" = e."EventID"
GROUP BY t."EventID", e."Title";
