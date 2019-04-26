-- drop event autoCreateFutureSprint;
CREATE EVENT autoCreateFutureSprint
ON SCHEDULE EVERY 2 WEEK
 DO
 call createFutureSprint();
