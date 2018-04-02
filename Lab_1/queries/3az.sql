SELECT codigo
FROM zucs
WHERE codigo NOT IN
(SELECT DISTINCT codigo 
FROM ztiposaula
WHERE ano_letivo = '2003/2004');