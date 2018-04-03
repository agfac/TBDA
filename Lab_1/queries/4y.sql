--4y
CREATE VIEW horas_docentes
AS
SELECT ydocentes.nr, ydocentes.nome, tipo, SUM(horas*fator) AS nr_horas
FROM ydocentes JOIN ydsd ON ydsd.nr = ydocentes.nr JOIN ytiposaula ON ytiposaula.ID = ydsd.ID
WHERE ano_letivo='2003/2004'
GROUP BY ydocentes.nr, ydocentes.nome, tipo;

CREATE VIEW max_horas_docentes
AS
SELECT tipo, MAX(nr_horas) AS max_nr_horas
FROM horas_docentes
GROUP BY tipo;

SELECT nr, nome, max_horas_docentes.tipo, max_nr_horas
FROM horas_docentes join max_horas_docentes on horas_docentes.tipo = max_horas_docentes.tipo AND horas_docentes.nr_horas = max_horas_docentes.max_nr_horas;