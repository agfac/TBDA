drop view horas_docentes;
drop view max_horas_docentes;

--4z
CREATE VIEW horas_docentes
AS
SELECT zdocentes.nr, zdocentes.nome, tipo, SUM(horas*fator) AS nr_horas
FROM zdocentes JOIN zdsd ON zdsd.nr = zdocentes.nr JOIN ztiposaula ON ztiposaula.ID = zdsd.ID
WHERE ano_letivo='2003/2004'
GROUP BY zdocentes.nr, zdocentes.nome, tipo;

CREATE VIEW max_horas_docentes
AS
SELECT tipo, MAX(nr_horas) AS max_nr_horas
FROM horas_docentes
GROUP BY tipo;

SELECT nr, nome, max_horas_docentes.tipo, max_nr_horas
FROM horas_docentes join max_horas_docentes on horas_docentes.tipo = max_horas_docentes.tipo AND horas_docentes.nr_horas = max_horas_docentes.max_nr_horas;