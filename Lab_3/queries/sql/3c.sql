SELECT COUNT(*)
FROM
(
    SELECT designation
    FROM municipalities
    MINUS
        (SELECT distinct m.designation
        FROM facilities f
        JOIN municipalities m
        ON f.municipality = m.cod
        JOIN uses u
        ON f.id = u.id
        JOIN activities a
        ON a.ref = u.ref
        WHERE activity = 'cinema'
        )
);