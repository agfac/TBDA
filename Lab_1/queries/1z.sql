SELECT zucs.codigo, zucs.designacao, zocorrencias.ano_letivo, zocorrencias.inscritos, ztiposaula.tipo, ztiposaula.turnos
FROM zucs JOIN zocorrencias ON zucs.codigo = zocorrencias.codigo left outer JOIN ztiposaula ON ztiposaula.codigo = zocorrencias.codigo and ztiposaula.ano_letivo = zocorrencias.ano_letivo
WHERE zucs.designacao = 'Bases de Dados' AND zucs.curso = 275;