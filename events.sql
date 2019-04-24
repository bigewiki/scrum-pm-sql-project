-- -- example event
--

-- CREATE EVENT expire_events
-- ON SCHEDULE EVERY 5 MINUTE
--  DO
--  DELETE FROM events_sessions
--  WHERE stime < CURRENT_TIMESTAMP - INTERVAL 1 DAY;
