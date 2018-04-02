SELECT yucs.codigo, yucs.designacao, yocorrencias.ano_letivo, yocorrencias.inscritos, ytiposaula.tipo, ytiposaula.turnos
FROM yucs JOIN yocorrencias ON yucs.codigo = yocorrencias.codigo left outer JOIN ytiposaula ON ytiposaula.codigo = yocorrencias.codigo and ytiposaula.ano_letivo = yocorrencias.ano_letivo
WHERE yucs.designacao = 'Bases de Dados' AND yucs.curso = 275;