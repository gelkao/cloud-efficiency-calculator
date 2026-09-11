WITH placement AS (
  SELECT id, pool, TRIM(leaf, char(13)) AS leaf
    FROM attachment
   WHERE id   NOT GLOB '*[^0-9]*' AND id   <> ''
     AND pool NOT GLOB '*[^0-9]*' AND pool <> ''
     AND TRIM(leaf, char(13)) <> ''
),
leaf_size AS (SELECT leaf,       COUNT(*) n FROM placement GROUP BY leaf),
pool_size AS (SELECT leaf, pool, COUNT(*) n FROM placement GROUP BY leaf, pool)
SELECT p.leaf, p.pool, p.id
  FROM placement p
  JOIN leaf_size ls ON ls.leaf = p.leaf
  JOIN pool_size ps ON ps.leaf = p.leaf AND ps.pool = p.pool
 ORDER BY ls.n DESC, p.leaf, ps.n DESC,
          CAST(p.pool AS INTEGER), CAST(p.id AS INTEGER);
