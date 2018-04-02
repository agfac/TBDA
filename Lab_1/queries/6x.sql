--6x
SELECT curso, COUNT(curso) AS num_tipos_aula_curso
FROM (SELECT curso,tipo
FROM xucs JOIN xtiposaula ON xucs.codigo=xtiposaula.codigo
GROUP BY curso, tipo)
GROUP BY curso
HAVING COUNT(curso) = (SELECT COUNT (DISTINCT tipo) AS num_tipos_aula
FROM xtiposaula);