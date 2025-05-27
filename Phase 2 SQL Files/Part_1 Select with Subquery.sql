-- Selecting the festivals that have more than 5 tickets sold
-- Select Query with a subquery
SELECT f."FestivalID", f."Name"
FROM public."Festival" f
WHERE f."FestivalID" IN (
    SELECT e."FestivalID"
    FROM public."Event" e
    JOIN public."Ticket" t ON e."EventID" = t."EventID"
    GROUP BY e."FestivalID"
    HAVING COUNT(t."TicketID") > 5
);
