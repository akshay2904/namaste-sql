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

-- ============================================================
-- APPROACH 1: OPTIMIZED
-- (window functions, CTEs, efficient joins, minimal scans)
-- ============================================================

WITH filtered AS (
    -- Filter properties meeting room_type and amenities criteria
    SELECT
        property_id,
        neighborhood,
        cost_per_night,
        -- Count amenities by splitting on comma
        array_length(string_to_array(amenities, ','), 1) AS amenity_count
    FROM airbnb_listings
    WHERE room_type IN ('Entire home', 'Apartment')
      AND amenities ILIKE '%TV%'
      AND amenities ILIKE '%Internet%'
),
ranked AS (
    SELECT
        property_id,
        neighborhood,
        cost_per_night,
        amenity_count,
        -- Rank by lowest cost first, then by more amenities as tiebreaker
        RANK() OVER (
            PARTITION BY neighborhood
            ORDER BY cost_per_night ASC, amenity_count DESC
        ) AS rnk
    FROM filtered
)
SELECT
    neighborhood,
    property_id,
    cost_per_night
FROM ranked
WHERE rnk = 1
ORDER BY neighborhood;

-- ============================================================
-- APPROACH 2: BRUTE FORCE
-- (subqueries, basic GROUP BY/HAVING, no window functions)
-- ============================================================

SELECT
    f.neighborhood,
    f.property_id,
    f.cost_per_night
FROM (
    -- Filter qualifying properties and count amenities
    SELECT
        property_id,
        neighborhood,
        cost_per_night,
        array_length(string_to_array(amenities, ','), 1) AS amenity_count
    FROM airbnb_listings
    WHERE room_type IN ('Entire home', 'Apartment')
      AND amenities ILIKE '%TV%'
      AND amenities ILIKE '%Internet%'
) f
WHERE f.cost_per_night = (
    -- Find the minimum cost per night for this neighborhood
    SELECT MIN(f2.cost_per_night)
    FROM airbnb_listings f2
    WHERE f2.room_type IN ('Entire home', 'Apartment')
      AND f2.amenities ILIKE '%TV%'
      AND f2.amenities ILIKE '%Internet%'
      AND f2.neighborhood = f.neighborhood
)
-- Among ties on cost, keep the one with the most amenities
AND f.amenity_count = (
    SELECT MAX(array_length(string_to_array(f3.amenities, ','), 1))
    FROM airbnb_listings f3
    WHERE f3.room_type IN ('Entire home', 'Apartment')
      AND f3.amenities ILIKE '%TV%'
      AND f3.amenities ILIKE '%Internet%'
      AND f3.neighborhood = f.neighborhood
      AND f3.cost_per_night = f.cost_per_night
)
ORDER BY f.neighborhood;
