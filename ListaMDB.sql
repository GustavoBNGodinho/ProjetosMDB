create database if not exists db_projetoFuncionario;
use db_projetoFuncionario;

drop table if exists projFunc;
drop table if exists funcionario;
drop table if exists departamento;
drop table if exists projeto;



CREATE TABLE departamento
(
   idDepto SMALLINT    UNSIGNED NOT NULL AUTO_INCREMENT,
   nomeDep VARCHAR(50)          NOT NULL,
   andar   SMALLINT    UNSIGNED,
   CONSTRAINT pk_depto PRIMARY KEY(idDepto)
);

CREATE TABLE funcionario
(
   idFunc  SMALLINT    UNSIGNED NOT NULL AUTO_INCREMENT,
   nomeF   VARCHAR(50)          NOT NULL,
   emailF  VARCHAR(50),
   salario DOUBLE,
   dataAd  DATE,
   idDepto SMALLINT    UNSIGNED NOT NULL,
   idSuper SMALLINT    UNSIGNED,

   CONSTRAINT pk_func  PRIMARY KEY(idFunc),
   CONSTRAINT fk_supe  FOREIGN KEY(idSuper) REFERENCES funcionario (idFunc),
   CONSTRAINT fk_dept  FOREIGN KEY(idDepto) REFERENCES
                       departamento(idDepto) ON DELETE CASCADE
                                             ON UPDATE CASCADE
);

CREATE TABLE projeto
(
   idProj SMALLINT UNSIGNED NOT NULL AUTO_INCREMENT,
   descrP VARCHAR(50) NOT NULL,

   CONSTRAINT pk_proj PRIMARY KEY (idProj)
);


CREATE TABLE projFunc
(
    idProj  SMALLINT UNSIGNED NOT NULL,
    idFunc  SMALLINT UNSIGNED NOT NULL,
    dataI   DATE,

    CONSTRAINT pk_projfunc PRIMARY KEY(idFunc,idProj),

    CONSTRAINT fk_pproj FOREIGN KEY (idProj) REFERENCES projeto (idProj) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT fk_pfunc FOREIGN KEY (idFunc) REFERENCES funcionario (idFunc) ON DELETE CASCADE ON UPDATE CASCADE
);


INSERT INTO departamento VALUES(null,'Engenharia',1);
INSERT INTO departamento VALUES(null,'RH',3);
INSERT INTO departamento VALUES(null,'Estoque',2);

INSERT INTO funcionario VALUES (null,'Isidro','isidro@ts.com.br', 10000.0, '2023-01-01',1,null);
INSERT INTO funcionario VALUES (null,'Sezefredo','sz@ts.com.br', 5350.0, '2023-01-01',1,1);
INSERT INTO funcionario VALUES (null,'Adamastor','ad@ts.com.br', 6170.0, '2023-01-01',1,1);
INSERT INTO funcionario VALUES (null,'Deosdedite','dd@ts.com.br', 8230.0, '2023-01-01',1,1);
INSERT INTO funcionario VALUES (null,'Energarda','en@ts.com.br', 7300.0, '2023-01-01',2,2);
INSERT INTO funcionario VALUES (null,'Josicleide','josi@ts.com.br', 6500.0, '2023-01-01',2,2);
INSERT INTO funcionario VALUES (null,'Nilsonclecio','ns@ts.com.br', 5730.0,'2023-01-01',3,6);
INSERT INTO funcionario VALUES (null,'Roberval','rb@ts.com.br', 6140.0, '2023-01-01',3,6);

INSERT INTO projeto VALUES(null, 'Folha de Pagto');
INSERT INTO projeto VALUES(null, 'Sist. Escolar');
INSERT INTO projeto VALUES(null, 'Cad. Clientes');

INSERT INTO projFunc VALUES(1,1,'2023-04-01');
INSERT INTO projFunc VALUES(1,2,'2023-04-01');
INSERT INTO projFunc VALUES(2,3,'2023-04-01');
INSERT INTO projFunc VALUES(2,4,'2023-04-01');
INSERT INTO projFunc VALUES(2,5,'2023-04-01');
INSERT INTO projFunc VALUES(2,6,'2023-04-01');

-- ex01) Todos os departamentos que possuem fucnionários alocados.
select distinct nomeDep from departamento inner join funcionario on departamento.idDepto = funcionario.idDepto;

-- ou

select distinct nomeDep 
from 
    departamento 
inner join 
    funionario using(idDepto); --> apenas paras MySQL

-- ex02) Existe algum "Pedro" na empresa?

select nomeF from funcionario where nomeF = "Pedro&";

-- ex03) Mostre todos os projetos de todos os funcionários (aqueles que tem projetos e os que não tem projetos)

select nomeF, descrP 
from 
    funcionario 
left outer join 
    projFunc using(idFunc) 
inner join 
    projeto using(idProj);

-- ex04) Mostre quem ganha acima do projeto dois
select nomeF
from
    funcionario
where salario > (
    select max(salario)
    from
        projeto
    inner join
        projFunc using(idProj)
    inner join
        funcionario using(idFunc)
    where idProj = 2;
    )

-- ex05) Mostre todos os funcionários que são supervisores

select nomeF as "supervisor"
from
    funcionario as f
inner join
    funcionario as s on s.idFunc = f.idSuper

-- ex06) Quantos funcionários temos por departamento?

select nomeDep, count(idFunc) as 'quantidade'
from
    funcionario
right outer join
    departamento using(idDepto)
group by nomeDep;


-- ex07) Os projetos existentes na empresa estão vinculados a quais departamentos?

select projeto.descrP, departamento.nomeDep
from
    from
inner join 
    projFunc using(idProj)
inner join
    funcionario using(idFunc)
inner join
    departamento using (idDepto)