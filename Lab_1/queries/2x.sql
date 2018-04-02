SELECT tipo, SUM(turnos*horas_turno) AS weekly_hours
FROM xucs JOIN xtiposaula ON xtiposaula.codigo = xucs.codigo
WHERE xucs.curso = 233 AND xtiposaula.ano_letivo = '2004/2005'
GROUP BY tipo;