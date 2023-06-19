--Cleaning json for categories
--update stg.food set categories = regexp_replace(categories, '\[|\]','', 'g');
--update dbo.food set categories = regexp_replace(categories, '\[|\]','', 'g');
--update stg.food set categories = regexp_replace(categories, '''','"', 'g');


INSERT INTO dbo.food
    (
        index 
        ,id 
        ,alias 
        ,name
        ,image_url 
        ,is_closed 
        ,url 
        ,review_count  
        ,categories
        ,rating 
        ,transactions 
        ,phone 
        ,display_phone 
        ,distance
        ,latitude 
        ,longitude 
        ,address1 
        ,address2 
        ,address3 
        ,city 
        ,zip_code 
        ,country 
        ,state 
        ,display_address 
        ,price 
        ,DateAdded 
    )
SELECT
        new.index 
        ,new.id 
        ,new.alias 
        ,new.name
        ,new.image_url 
        ,new.is_closed 
        ,new.url 
        ,new.review_count  
        ,new.categories
        ,new.rating 
        ,new.transactions 
        ,new.phone 
        ,new.display_phone 
        ,new.distance
        ,new.latitude 
        ,new.longitude 
        ,new.address1 
        ,new.address2 
        ,new.address3 
        ,new.city 
        ,new.zip_code 
        ,new.country 
        ,new.state 
        ,new.display_address 
        ,new.price 
        ,new.DateAdded 
FROM dbo.food hist
RIGHT JOIN stg.food new
    ON hist.alias = new.alias
    WHERE hist.alias IS NULL;

