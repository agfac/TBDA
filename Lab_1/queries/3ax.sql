SELECT codigo
FROM xucs
WHERE codigo NOT IN
(SELECT DISTINCT codigo 
FROM xtiposaula
WHERE ano_letivo = '2003/2004');