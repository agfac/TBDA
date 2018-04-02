DROP VIEW courses_not_sa_2003_2004;
  
CREATE VIEW courses_not_sa_2003_2004
AS
SELECT *
FROM xtiposaula 
WHERE codigo NOT IN (SELECT DISTINCT codigo
FROM xtiposaula
WHERE ano_letivo='2003/2004');

SELECT DISTINCT xucs.codigo
FROM xucs LEFT OUTER JOIN courses_not_sa_2003_2004 ON xucs.codigo=courses_not_sa_2003_2004.codigo
WHERE ano_letivo IS NOT NULL;