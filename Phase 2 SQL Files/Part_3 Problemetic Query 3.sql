EXPLAIN ANALYZE
SELECT r."RegistrationID", p."ParticipantName", r."FestivalID"
FROM public."Registration" r
JOIN public."Participant" p ON r."Email" = p."Email"
WHERE r."FestivalID" = 1
ORDER BY p."ParticipantName";
