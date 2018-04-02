select codigo
from yucs
where codigo not in
(select distinct codigo 
from ytiposaula
where ANO_LETIVO = '2003/2004');