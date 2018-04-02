SELECT tipo, SUM(turnos*horas_turno) AS weekly_hours
FROM yucs JOIN ytiposaula ON ytiposaula.codigo = yucs.codigo
WHERE yucs.curso = 233 AND ytiposaula.ano_letivo = '2004/2005'
GROUP BY tipo;