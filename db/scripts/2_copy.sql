COPY stg.food FROM '/data/stagedata.csv' DELIMITER ',' CSV HEADER;

COPY dbo.food FROM '/data/historicaldata.csv' DELIMITER ',' CSV HEADER;