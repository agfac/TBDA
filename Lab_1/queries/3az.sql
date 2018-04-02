select codigo
from zucs
where codigo not in
(select distinct codigo 
from ztiposaula
where ANO_LETIVO = '2003/2004');