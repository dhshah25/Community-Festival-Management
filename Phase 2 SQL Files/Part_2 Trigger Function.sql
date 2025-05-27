CREATE OR REPLACE FUNCTION handle_transaction_failure() 
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO public.error_log (error_message)
    VALUES ('Transaction failed due to: ' || SQLERRM);
    
    RAISE NOTICE 'Transaction failed! Rolling back changes. Error: %', SQLERRM;

    RETURN NULL;
END;
$$ LANGUAGE plpgsql;
