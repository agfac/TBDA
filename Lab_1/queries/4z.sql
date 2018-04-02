--4z
create view horas_docentes
as
SELECT zdocentes.nr, zdocentes.nome, tipo, sum(horas*fator) as nr_horas
from zdocentes join zdsd on zdsd.nr = zdocentes.nr join ztiposaula on ztiposaula.id = zdsd.ID
where ano_letivo='2003/2004'
group by zdocentes.nr, zdocentes.nome, tipo;

create view max_horas_docentes
as
select tipo, max(nr_horas) as max_nr_horas
from horas_docentes
group by tipo;

select nr, nome, max_horas_docentes.tipo, max_nr_horas
from horas_docentes, max_horas_docentes
where horas_docentes.tipo = max_horas_docentes.tipo and horas_docentes.nr_horas = max_horas_docentes.max_nr_horas;