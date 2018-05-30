create or replace PACKAGE BODY WEB_XML AS
PROCEDURE list_facilities IS 
    v_sqlselect varchar2(4000);
    v_queryctx DBMS_XMLQuery.ctxType;
    v_clob_par clob;
    v_offset number default 1;
    v_chunk_size number := 10000;
BEGIN 
    v_sqlselect := 'SELECT d.cod, d.designation, reg.designation as region, reg.nut1, CURSOR(
                                                                                        SELECT m.cod, m.designation, r.designation as region, r.nut1, CURSOR(
                                                                                                                                                            SELECT a.activity, CURSOR(SELECT f1.name, f1.capacity, f1.address
                                                                                                                                                                                        FROM facilities f1
                                                                                                                                                                                        JOIN uses u1
                                                                                                                                                                                        ON f1.id = u1.id
                                                                                                                                                                                        WHERE a.ref = u1.ref and f1.municipality = m.cod
                                                                                                                                                                                    ) as facilities
                                                                                                                                                            FROM activities a
                                                                                                                                                            JOIN uses u
                                                                                                                                                            ON u.ref = a.ref
                                                                                                                                                            JOIN facilities f
                                                                                                                                                            ON f.id = u.id 
                                                                                                                                                            WHERE f.municipality = m.cod
                                                                                                                                                            ORDER BY a.activity
                                                                                                                                                            ) as activities
                                                                                        FROM municipalities m
                                                                                        JOIN regions r
                                                                                        ON m.region = r.cod
                                                                                        WHERE m.district = d.cod
                                                                                        ) as municipalities
                    FROM districts d
                    LEFT JOIN regions reg
                    ON d.region = reg.cod
                    ORDER BY d.cod';

    v_queryctx := DBMS_XMLQuery.newContext(v_sqlselect);

    DBMS_XMLQuery.setEncodingTag(v_queryctx, 'ISO-8859-1');
    
    DBMS_XMLQUERY.setStylesheetHeader(v_queryctx, 'xml2json.xsl');

    DBMS_XMLQuery.setRowSetTag(v_queryctx, UPPER('FACILITIES'));

    DBMS_XMLQuery.setRowTag(v_queryctx, UPPER('DISTRICT')); 

    v_clob_par := DBMS_XMLQuery.getXML(v_queryctx); 

    DBMS_XMLQuery.closeContext(v_queryctx); 
    
    loop
   
      exit when v_offset > dbms_lob.getlength(v_clob_par);
      
      htp.p( dbms_lob.substr( v_clob_par, v_chunk_size, v_offset ) );
      
      htp.para;
      
      v_offset := v_offset +  v_chunk_size;
   
    end loop;
            
    EXCEPTION
        WHEN OTHERS THEN
            htp.p(SQLERRM); 
            
END list_facilities;

PROCEDURE list_facilities_xml IS 
    v_sqlselect varchar2(4000);
    v_queryctx DBMS_XMLQuery.ctxType;
    v_clob_par clob;
    v_offset number default 1;
    v_chunk_size number := 10000;
BEGIN 
    v_sqlselect := 'SELECT xmlelement("DISTRICTS",
                             xmlagg(xmlelement("DISTRICT",
                                                        xmlelement("COD", d.cod),
                                                        xmlelement("DESIGNATION", d.designation),
                                                        (SELECT xmlagg(xmlelement("MUNICIPALITIES", 
                                                                        xmlelement("MUNICIPALITY",
                                                                        xmlelement("COD", m.cod),
                                                                        xmlelement("DESIGNATION", m.designation)
                                                                                    )
                                                                                    )
                                                                        )
                                                        FROM municipalities m
                                                        WHERE d.cod = m.district
                                                        )
                                                )
                                )
                                )
                    FROM districts d';

    v_queryctx := DBMS_XMLQuery.newContext(v_sqlselect);

    DBMS_XMLQuery.setEncodingTag(v_queryctx, 'ISO-8859-1');
    
    DBMS_XMLQUERY.setStylesheetHeader(v_queryctx, 'xml2json.xsl');

    DBMS_XMLQuery.setRowSetTag(v_queryctx, UPPER('FACILITIES'));

    DBMS_XMLQuery.setRowTag(v_queryctx, UPPER('DISTRICT')); 

    v_clob_par := DBMS_XMLQuery.getXML(v_queryctx); 

    DBMS_XMLQuery.closeContext(v_queryctx); 
    
    loop
   
      exit when v_offset > dbms_lob.getlength(v_clob_par);
      
        dbms_output.put_line(v_clob_par);

      htp.p( dbms_lob.substr( v_clob_par, v_chunk_size, v_offset ) );
      
      htp.para;
      
      v_offset := v_offset +  v_chunk_size;
   
    end loop;
            
    EXCEPTION
        WHEN OTHERS THEN
            htp.p(SQLERRM); 
            
END list_facilities_xml;
END WEB_XML;