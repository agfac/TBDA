select codigo
from xucs
where codigo not in
(select distinct codigo 
from xtiposaula
where ANO_LETIVO = '2003/2004');