SELECT codigo
FROM yucs
WHERE codigo NOT IN
(SELECT DISTINCT codigo 
FROM ytiposaula
WHERE ano_letivo = '2003/2004');