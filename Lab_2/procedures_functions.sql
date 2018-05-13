--------------------------------------------------------
----------------   PL/SQL FUNCTIONS   ------------------   
--------------------------------------------------------

--------------------------------------------------------
---------------- FILL_PARTIDO_MANDATOS -----------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE FILL_PARTIDO_MANDATOS
IS
mandatosArray  partido_mandatos := partido_mandatos(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
DistritoPosArray simple_integer := 1;
Mandatos varchar2(3) := '';

BEGIN

for p in (select sigla from partidos)
loop
for d in (select d.codigo, l.mandatos from distritos d, table(d.listas) l where l.partido.sigla = p.sigla)
loop

if(d.codigo <= 18)
then
DistritoPosArray := d.codigo;
elsif(d.codigo = 30)
then
DistritoPosArray := 19;
else
DistritoPosArray := 20;
end if;

begin
dbms_output.put_line(DistritoPosArray);
end;
mandatosArray(DistritoPosArray) := d.mandatos;

end loop;

UPDATE partidos
SET mandatos_distrito = mandatosArray
WHERE partidos.sigla = p.sigla;

mandatosArray := partido_mandatos(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
DistritoPosArray := 1;

end loop;
END;

--------------------------------------------------------
----------------- FILL_PARTIDO_VOTOS -------------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE FILL_PARTIDO_VOTOS
IS
votosArray  partido_votos := partido_votos(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
DistritoPosArray simple_integer := 1;
Votos varchar2(10) := '';

BEGIN

for p in (select sigla from partidos)
loop
for d in (select codigo from distritos)
loop

BEGIN
        select sum(x.votos) into Votos
        from freguesias f, table(f.votacoes) x
        where x.partido.sigla = p.sigla AND f.concelho.codigo IN
        (select codigo
        from concelhos c
        where c.distrito.codigo = d.codigo)
        group by x.partido.sigla;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        Votos := NULL;
END;

if(d.codigo <= 18)
then
DistritoPosArray := d.codigo;
elsif(d.codigo = 30)
then
DistritoPosArray := 19;
else
DistritoPosArray := 20;
end if;

if NOT (Votos IS NULL)
then
votosArray(DistritoPosArray) := TO_NUMBER(Votos);
end if;

end loop;

UPDATE partidos
SET votos_distrito = votosArray
WHERE partidos.sigla = p.sigla;

votosArray := partido_votos(null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null,null);
DistritoPosArray := 1;

end loop;
END;

--------------------------------------------------------
/*                 STATISTICS FUNCTIONS               */   
--------------------------------------------------------
--------------------------------------------------------
--------------- GET_PARTIDO_MAIS_VOTADO ----------------   
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_PARTIDO_MAIS_VOTADO(codigoDistrito distritos.codigo%TYPE)
RETURN partidos.sigla%TYPE
IS
Sigla partidos.sigla%TYPE;
BEGIN
    SELECT x.partido.sigla INTO Sigla
    FROM freguesias F, TABLE(F.votacoes) x
    WHERE F.concelho.codigo IN
    (SELECT codigo
    FROM concelhos C
    WHERE C.distrito.codigo = codigoDistrito)
    GROUP BY x.partido.sigla
    ORDER BY SUM(x.votos) DESC
    FETCH FIRST ROW ONLY;
RETURN Sigla;
END;

--------------------------------------------------------
---------------- GET_DISTRITOS_VENCEDOR ----------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_distritos_vencedor(siglapartido partidos.sigla%TYPE)
IS
sigla partidos.sigla%TYPE := '';
ret_distritos VARCHAR2(1000) := '';
BEGIN
    FOR D IN (SELECT codigo, nome FROM distritos)
    LOOP
    sigla := get_partido_mais_votado(D.codigo);

    IF sigla = siglapartido
    THEN
    ret_distritos := ret_distritos || D.nome || CHR(10);
    END IF;

    END LOOP; 
    
    dbms_output.put_line(ret_distritos);
END;

--------------------------------------------------------
---------------- GET_DISTRITOS_MAIORIA -----------------   
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_distritos_maioria(siglapartido partidos.sigla%TYPE)
IS
sigla partidos.sigla%TYPE := '';
ret_distritos VARCHAR2(1000) := '';
mandatos_proprio simple_integer := 0;
mandatos_outros simple_integer := 0;
BEGIN
    FOR D IN (SELECT codigo, nome FROM distritos)
    LOOP

    select l.mandatos into mandatos_proprio
    from distritos dist, table(dist.listas) l
    where dist.codigo = D.codigo and l.partido.sigla = siglapartido;
    
    select sum(l.mandatos) into mandatos_outros
    from distritos dist, table(dist.listas) l
    where dist.codigo = D.codigo and l.partido.sigla <> siglapartido;
    
    IF mandatos_proprio > mandatos_outros
    THEN
    ret_distritos := ret_distritos || D.nome || CHR(10);
    END IF;

    END LOOP; 
    
    dbms_output.put_line(ret_distritos);
END;

--------------------------------------------------------
--------------- GET_PARTIDO_MAIS_VOTADO ----------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_partido_mais_votado_distr(nomedistrito distritos.nome%TYPE)
IS
sigla partidos.sigla%TYPE;
BEGIN
    SELECT x.partido.sigla INTO sigla
    FROM freguesias F, TABLE(F.votacoes) x
    WHERE F.concelho.codigo IN
    (SELECT codigo
    FROM concelhos C
    WHERE C.distrito.nome = nomedistrito)
    GROUP BY x.partido.sigla
    ORDER BY SUM(x.votos) DESC
    FETCH FIRST ROW ONLY;
dbms_output.put_line(sigla);
END;

--------------------------------------------------------
----------------- GET_PARTIDO_MAIORIA ------------------
--------------------------------------------------------

CREATE OR REPLACE PROCEDURE get_partido_maioria_distr(nomedistrito distritos.nome%TYPE)
IS
nome distritos.nome%TYPE := '';
nomePartido VARCHAR2(10) := '';
mandatos_max SIMPLE_INTEGER := 0;
mandatos_outros SIMPLE_INTEGER := 0;
BEGIN

    SELECT L.partido.sigla, L.mandatos
    INTO nomePartido, mandatos_max
    FROM distritos dist, TABLE(dist.listas) L
    WHERE dist.nome = nomedistrito
    ORDER BY L.mandatos DESC
    FETCH FIRST ROW ONLY;

    SELECT SUM(L.mandatos) INTO mandatos_outros
    FROM distritos dist, TABLE(dist.listas) L
    WHERE dist.nome = nomedistrito AND L.partido.sigla <> nomePartido;

    IF mandatos_max > mandatos_outros
    THEN
    dbms_output.put_line(nomePartido);
    ELSE
    dbms_output.put_line('Nenhum partido obteve maioria absoluta no distrito de ' || nomedistrito);
    END IF;
END;

--------------------------------------------------------
--------------- GET_DISTRITO_MAIS_INSCRITOS ------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_INSCRITOS
RETURN distritos.nome%TYPE
IS
Nome distritos.nome%TYPE;
BEGIN
SELECT D.nome INTO Nome
FROM distritos D
ORDER BY D.participacoes.inscritos DESC
FETCH FIRST ROW ONLY;
RETURN Nome;
END;

--------------------------------------------------------
--------------- GET_DISTRITO_MAIS_VOTANTES -------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_VOTANTES
RETURN distritos.nome%TYPE
IS
Nome distritos.nome%TYPE;
BEGIN
SELECT D.nome INTO Nome
FROM distritos D
ORDER BY D.participacoes.votantes DESC
FETCH FIRST ROW ONLY;
RETURN Nome;
END;

--------------------------------------------------------
------------- GET_DISTRITO_MAIS_ABSTENCOES -------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_ABSTENCOES
RETURN distritos.nome%TYPE
IS
Nome distritos.nome%TYPE;
BEGIN
SELECT D.nome INTO Nome
FROM distritos D
ORDER BY D.participacoes.abstencoes DESC
FETCH FIRST ROW ONLY;
RETURN Nome;
END;

--------------------------------------------------------
--------------- GET_DISTRITO_MAIS_BRANCOS --------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_BRANCOS
RETURN distritos.nome%TYPE
IS
Nome distritos.nome%TYPE;
BEGIN
SELECT D.nome INTO Nome
FROM distritos D
ORDER BY D.participacoes.brancos DESC
FETCH FIRST ROW ONLY;
RETURN Nome;
END;

--------------------------------------------------------
---------------- GET_DISTRITO_MAIS_NULOS ---------------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIS_NULOS
RETURN distritos.nome%TYPE
IS
Nome distritos.nome%TYPE;
BEGIN
SELECT D.nome INTO Nome
FROM distritos D
ORDER BY D.participacoes.nulos DESC
FETCH FIRST ROW ONLY;
RETURN Nome;
END;

--------------------------------------------------------
----- GET_DISTRITO_MAIOR_RACIO_VOTANTES_INSCRITOS ------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTRITO_MAIOR_RACIO_VOTANTES_INSCRITOS
RETURN distritos.nome%TYPE
IS
Nome distritos.nome%TYPE;
BEGIN
SELECT D.nome INTO NOME
FROM distritos D
ORDER BY D.participacoes.votantes/D.participacoes.inscritos DESC
FETCH FIRST ROW ONLY;
RETURN Nome;
END;

--------------------------------------------------------
------- GET_DISTRITO_MAIOR_RACIO_NULOS_VOTANTES --------
--------------------------------------------------------

CREATE OR REPLACE FUNCTION GET_DISTR_MAIOR_RACIO_NUL_VOT
RETURN distritos.nome%TYPE
IS
Nome distritos.nome%TYPE;
BEGIN
SELECT D.nome INTO NOME
FROM distritos D
ORDER BY D.participacoes.nulos/D.participacoes.votantes DESC
FETCH FIRST ROW ONLY;
RETURN Nome;
END;