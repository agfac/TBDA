--------------------------------------------------------
--------------------   DROP TABLES  --------------------   
--------------------------------------------------------

DROP TABLE freguesias CASCADE CONSTRAINTS;

DROP TABLE concelhos CASCADE CONSTRAINTS;

DROP TABLE distritos CASCADE CONSTRAINTS;

DROP TABLE partidos CASCADE CONSTRAINTS;

--------------------------------------------------------
--------------------   DROP TYPES  ---------------------   
--------------------------------------------------------

DROP TYPE freguesia_t;

DROP TYPE concelho_t;

DROP TYPE distrito_t;

DROP TYPE partidos;

DROP TYPE freguesia_t;

DROP TYPE zona_t;

DROP TYPE votacoes_tab_t;

DROP TYPE votacao_t;

DROP TYPE participacao_t;

DROP TYPE listas_tab_t;

DROP TYPE lista_t;

DROP TYPE partido_t;

--------------------------------------------------------
-------------------   CREATE TYPES  --------------------   
--------------------------------------------------------

CREATE OR REPLACE TYPE partido_mandatos AS VARRAY(20) OF NUMBER(3);

CREATE OR REPLACE TYPE partido_votos AS VARRAY(20) OF NUMBER(10);

CREATE OR REPLACE TYPE partido_t AS OBJECT(
    sigla VARCHAR2(10),
    designacao VARCHAR2(100),
    mandatos_distrito partido_mandatos,
    votos_distrito partido_votos
);

CREATE OR REPLACE TYPE lista_t AS OBJECT(
    partido REF partido_t,
    mandatos NUMBER(3)
);

CREATE OR REPLACE TYPE listas_tab_t AS TABLE OF lista_t;

CREATE OR REPLACE TYPE participacao_t AS OBJECT(
    inscritos NUMBER(10),
    votantes NUMBER(10),
    abstencoes NUMBER(10),
    brancos NUMBER(10),
    nulos NUMBER(10)
);

CREATE OR REPLACE TYPE votacao_t AS OBJECT(
    partido REF partido_t,
    votos NUMBER(10)
);

CREATE OR REPLACE TYPE votacoes_tab_t AS TABLE OF votacao_t;

CREATE OR REPLACE TYPE zona_t AS OBJECT(
    codigo NUMBER(6),
    nome VARCHAR2(50),
    map member function get_codigo return number,
    member function get_nome return varchar2
) not final;

CREATE OR REPLACE TYPE BODY zona_t AS
    map member function get_codigo return number is
        begin 
        return codigo;
        end get_codigo;
    member function get_nome return varchar2 is
        begin 
        return nome;
        end get_nome;
end;

CREATE OR REPLACE TYPE distrito_t under zona_t(
    regiao VARCHAR2(1),
    participacoes participacao_t,
    listas listas_tab_t,
    overriding member function get_nome return varchar2
);

CREATE OR REPLACE TYPE BODY distrito_t AS
    overriding member function get_nome return varchar2 is
        begin 
        return 'Distrito: ' || nome;
        end get_nome;
end;

CREATE OR REPLACE TYPE concelho_t under zona_t(
    distrito REF distrito_t,
    overriding member function get_nome return varchar2
);

CREATE OR REPLACE TYPE BODY concelho_t AS
    overriding member function get_nome return varchar2 is
        begin 
        return 'Concelho: ' || nome;
        end get_nome;
end;

CREATE OR REPLACE TYPE freguesia_t under zona_t(
    concelho REF concelho_t,
    votacoes votacoes_tab_t,
    overriding member function get_nome return varchar2
);

CREATE OR REPLACE TYPE BODY freguesia_t AS
    overriding member function get_nome return varchar2 is
        begin 
        return 'Freguesia: ' || nome;
        end get_nome;
end;

--------------------------------------------------------
------------------   CREATE TABLES   -------------------   
--------------------------------------------------------

CREATE TABLE partidos OF partido_t;

CREATE TABLE distritos OF distrito_t 
    NESTED TABLE listas STORE AS listas_tab;
    
CREATE TABLE concelhos OF concelho_t;

CREATE TABLE freguesias OF freguesia_t 
    NESTED TABLE votacoes STORE AS votacoes_tab;
    
--------------------------------------------------------
----------------   PL/SQL FUNCTIONS   ------------------   
--------------------------------------------------------

PROCEDURE FILL_PARTIDO_MANDATOS
IS
DECLARE
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