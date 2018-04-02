--4x
create view horas_docentes
as
SELECT xdocentes.nr, xdocentes.nome, tipo, sum(horas*fator) as nr_horas
from xdocentes join xdsd on xdsd.nr = xdocentes.nr join xtiposaula on xtiposaula.id = xdsd.ID
where ano_letivo='2003/2004'
group by xdocentes.nr, xdocentes.nome, tipo;

create view max_horas_docentes
as
select tipo, max(nr_horas) as max_nr_horas
from horas_docentes
group by tipo;

select nr, nome, max_horas_docentes.tipo, max_nr_horas
from horas_docentes, max_horas_docentes
where horas_docentes.tipo = max_horas_docentes.tipo and horas_docentes.nr_horas = max_horas_docentes.max_nr_horas;