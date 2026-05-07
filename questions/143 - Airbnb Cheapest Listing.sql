-- ======================================================================
-- 143 - Airbnb Cheapest Listing
-- ======================================================================
-- Difficulty : Hard
-- Category   : Analytics
-- Companies  : Airbnb
-- Access     : Premium
-- URL        : https://www.namastesql.com/coding-problems/143-airbnb-cheapest-listing
-- ======================================================================

/*
Company X is analyzing Airbnb listings to help travelers find the most affordable yet well-equipped accommodations in various neighborhoods. Many users prefer to stay in entire homes or apartments instead of shared spaces and require essential amenities like TV and Internet for work or entertainment.

 

Your task is to find the cheapest Airbnb listing in each neighborhood that meets the following criteria:

 

.The property type must be either "Entire home" or "Apartment".
.The property must include both "TV" and "Internet" in its list of amenities.
.Among all qualifying properties in a neighborhood, return the one with the lowest nightly cost.
.If multiple properties have the same lowest cost, return the one with more number of amenities.
.The results(neighborhood, property_id, cost_per_night) should be sorted by neighborhood for better readability.

 
Table: airbnb_listings
+---------------+----------+
| COLUMN_NAME   | DATA_TYPE|
+---------------+----------+
| property_id   | int      |
| neighborhood  | VARCHAR  | 
| cost_per_night| int      | 
| room_type     | VARCHAR  | 
| amenities     | TEXT     | 
+---------------+----------+
*/


-- Write your SQL solution below:

```sql
SELECT 
    neighborhood,
    property_id,
    cost_per_night
FROM (
    SELECT 
        neighborhood,
        property_id,
        cost_per_night,
        room_type,
        amenities,
        -- Count amenities by splitting on comma
        (LENGTH(amenities) - LENGTH(REPLACE(amenities, ',', '')) + 1) AS amenity_count,
        -- Rank by cost (ascending) then by amenity count (descending) within each neighborhood
        ROW_NUMBER() OVER (
            PARTITION BY neighborhood 
            ORDER BY cost_per_night ASC, amenity_count DESC
        ) AS rn
    FROM airbnb_listings
    WHERE 
        -- Filter for entire homes or apartments
        room_type IN ('Entire home', 'Apartment')
        -- Check if amenities contain both TV and Internet (case-insensitive)
        AND UPPER(amenities) LIKE '%TV%'
        AND UPPER(amenities) LIKE '%INTERNET%'
) ranked
WHERE rn = 1
ORDER BY neighborhood;
```
