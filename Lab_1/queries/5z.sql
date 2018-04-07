SELECT /*+ index(ztiposaula idx_bitmap_ano_tipo) no_index(ztiposaula idx_ztiposaula_bitmap_tipo) no_index(ztiposaula idx_bitmap_tipo_ano)*/ zucs.codigo, ztiposaula.ano_letivo, ztiposaula.periodo, tipo, SUM(turnos*horas_turno) AS horas
FROM zucs JOIN ztiposaula ON zucs.codigo = ztiposaula.codigo
WHERE tipo = 'OT' AND (ano_letivo = '2002/2003' OR ano_letivo = '2003/2004')
GROUP BY zucs.codigo, ztiposaula.ano_letivo, ztiposaula.periodo, tipo;