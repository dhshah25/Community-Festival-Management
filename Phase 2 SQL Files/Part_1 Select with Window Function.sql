-- Selecting events with their rank based on the number of tickets sold
-- Select Query with Window Function
SELECT 
    e."EventID", 
    e."Title", 
    COUNT(t."TicketID") AS TicketsSold, 
    ROW_NUMBER() OVER (ORDER BY COUNT(t."TicketID") DESC) AS Rank
FROM public."Event" e
LEFT JOIN public."Ticket" t ON e."EventID" = t."EventID"
GROUP BY e."EventID", e."Title"
ORDER BY Rank;
