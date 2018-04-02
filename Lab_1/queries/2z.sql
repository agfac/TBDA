SELECT tipo, SUM(turnos*horas_turno) AS weekly_hours
FROM zucs JOIN ztiposaula ON ztiposaula.codigo = zucs.codigo
WHERE zucs.curso = 233 AND ztiposaula.ano_letivo = '2004/2005'
GROUP BY tipo;