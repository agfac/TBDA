DROP VIEW courses_not_sa_2003_2004;
  
CREATE VIEW courses_not_sa_2003_2004
AS
SELECT *
FROM ytiposaula 
WHERE codigo NOT IN (SELECT DISTINCT codigo
FROM ytiposaula
WHERE ano_letivo='2003/2004');

SELECT DISTINCT yucs.codigo
FROM yucs LEFT OUTER JOIN courses_not_sa_2003_2004 ON yucs.codigo=courses_not_sa_2003_2004.codigo
WHERE ano_letivo IS NOT NULL;