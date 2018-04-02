--6y
SELECT curso, COUNT(curso) AS num_tipos_aula_curso
FROM (SELECT curso,tipo
FROM yucs JOIN ytiposaula ON yucs.codigo=ytiposaula.codigo
GROUP BY curso, tipo)
GROUP BY curso
HAVING COUNT(curso) = (SELECT COUNT (DISTINCT tipo) AS num_tipos_aula
FROM ytiposaula);