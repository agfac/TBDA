--4x
drop view horas_docentes;
drop view max_horas_docentes;

CREATE VIEW horas_docentes
AS
SELECT xdocentes.nr, xdocentes.nome, tipo, SUM(horas*fator) AS nr_horas
FROM xdocentes JOIN xdsd ON xdsd.nr = xdocentes.nr JOIN xtiposaula ON xtiposaula.ID = xdsd.ID
WHERE ano_letivo='2003/2004'
GROUP BY xdocentes.nr, xdocentes.nome, tipo;

CREATE VIEW max_horas_docentes
AS
SELECT tipo, MAX(nr_horas) AS max_nr_horas
FROM horas_docentes
GROUP BY tipo;

SELECT nr, nome, max_horas_docentes.tipo, max_nr_horas
FROM horas_docentes join max_horas_docentes on horas_docentes.tipo = max_horas_docentes.tipo and horas_docentes.nr_horas = max_horas_docentes.max_nr_horas;