SELECT xucs.codigo, xucs.designacao, xocorrencias.ano_letivo, xocorrencias.inscritos, xtiposaula.tipo, xtiposaula.turnos
FROM xucs JOIN xocorrencias ON xucs.codigo = xocorrencias.codigo left outer JOIN xtiposaula ON xtiposaula.codigo = xocorrencias.codigo and xtiposaula.ano_letivo = xocorrencias.ano_letivo
WHERE xucs.designacao = 'Bases de Dados' AND xucs.curso = 275;