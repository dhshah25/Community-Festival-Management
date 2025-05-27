CREATE INDEX idx_ticket_event ON public."Ticket" ("EventID");
CREATE INDEX idx_event_festival ON public."Event" ("FestivalID");
CREATE INDEX idx_ticket_event_covering ON public."Ticket" ("EventID") INCLUDE ("TicketID");

