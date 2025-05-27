CREATE TRIGGER trigger_transaction_failure
AFTER INSERT OR UPDATE OR DELETE
ON public."Volunteer"
FOR EACH STATEMENT
EXECUTE FUNCTION handle_transaction_failure();
