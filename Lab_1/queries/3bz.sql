DROP VIEW courses_not_sa_2003_2004;
  
CREATE VIEW courses_not_sa_2003_2004
AS
SELECT *
FROM ztiposaula 
WHERE codigo NOT IN (SELECT DISTINCT codigo
FROM ztiposaula
WHERE ano_letivo='2003/2004');

SELECT DISTINCT zucs.codigo
FROM zucs LEFT OUTER JOIN courses_not_sa_2003_2004 ON zucs.codigo=courses_not_sa_2003_2004.codigo
WHERE ano_letivo IS NOT NULL;