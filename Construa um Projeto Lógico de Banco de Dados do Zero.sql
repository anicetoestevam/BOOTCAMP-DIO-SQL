-- CRIAR BANCO DE DADOS

CREATE DATABASE Comércio;

-- UTILIZAR O BANCO DE DADOS

USE Comércio;

-- CRIANDO A TABELA FUNCIONÁRIO

CREATE TABLE Funcionário (
    idFuncionário INT AUTO_INCREMENT PRIMARY KEY,
    PrimeiroNomeFuncionário VARCHAR(45) NOT NULL,
    NomeDoMeioFuncionário CHAR(3),
    SobrenomeFuncionário VARCHAR(45) NOT NULL,
    StatusFuncionário ENUM('Disponível','Folga'),
    CPFdoFuncionário CHAR(11) NOT NULL,
    CargoFuncionário VARCHAR(45) NOT NULL,
    CONSTRAINT unique_cpf_unique UNIQUE (CPFdoFuncionário)
);

-- DESCRIÇÃO DA TABELA ACIMA
  
desc Funcionário;


-- CRIANDO A TABELA PRODUTO INICIAL

CREATE TABLE ProdutoInicial (
    idProdutoInicial INT AUTO_INCREMENT PRIMARY KEY,
    StatusProdutoInicial ENUM('Disponível','Ausente'),
    NomeProdutoInicial VARCHAR(45) NOT NULL,
    Categoria ENUM('Trigo', 'Produto Industrializado') NOT NULL,
    DescriçãoProdutoInicial VARCHAR(45)
    );

-- DESCRIÇÃO DA TABELA ACIMA

  
desc ProdutoInicial;

-- CRIANDO A TABELA PRODUTO FINAL


CREATE TABLE ProdutoFinal (
    idProdutoFinal INT AUTO_INCREMENT PRIMARY KEY,
    StatusProdutoFinal ENUM('Disponível','Ausente'),
    NomeProdutoFinal VARCHAR(45) NOT NULL,
    CategoriaProdutoFinal ENUM('Pão', 'Produto Industrializado') NOT NULL,
    DescriçãoProdutoFinal VARCHAR(45)
    );

-- DESCRIÇÃO DA TABELA ACIMA

  
desc ProdutoFinal;

-- CRIANDO A TABELA PANIFICADORA


CREATE TABLE Panificadora (
    idPanificadora INT AUTO_INCREMENT PRIMARY KEY,
    idProdutoInicial INT,
	idProdutoFinal INT,
    StatusPanificadora ENUM('Aberto', 'Fechado'),
    CNPJPanificadora CHAR(20),
    QuantidadeFuncionário INT,
    FOREIGN KEY (idProdutoIncial) REFERENCES ProdutoInicial (idProdutoInicial),
	FOREIGN KEY (idProdutoFinal) REFERENCES ProdutoFinal (idProdutoFinal),
    CONSTRAINT unique_cnpj_panificadora UNIQUE (CNPJPanificadora)
);

desc Panificadora;


-- CRIANDO A TABELA EMPRESA

CREATE TABLE Empresa (
    idEmpresa INT AUTO_INCREMENT PRIMARY KEY,
    idProdutoInicial INT,
	idProdutoFinal INT,
    CNPJEmpresa CHAR(20),
	CPFdoVendedor CHAR(11),
    QuantidadeProdutoInicial INT,
	QuantidadeProdutoFinal INT,
    FOREIGN KEY (idProdutoInicial) REFERENCES ProdutoInicial (idProdutoInicial),
	FOREIGN KEY (idProdutoFinal) REFERENCES ProdutoFinal (idProdutoFinal),
    CONSTRAINT unique_cnpj_empresa UNIQUE (CNPJEmpresa),
    CONSTRAINT unique_cpf_vendedor UNIQUE (CPFdoVendedor)
);

-- DESCRIÇÃO DA TABELA ACIMA
  
desc Empresa;


-- MOSTRANDO AS TABELAS EXISTENTES

show tables;

-- FAZENDO QUERIES

use ecommerce;

-- USANDO 2 TABELAS (FUNCIONÁRIO E EMPRESA) PARA VISUALIZAR "INSERT INTO", "WHERE", "SELECT*FROM" ...

INSERT INTO Funcionário (idFuncionário, PrimeiroNomeFuncionário,  NomeDoMeioFuncionário,  SobrenomeFuncionário,  CPFdoFuncionário)
           VALUES(001, 'MARIA', 'S', 'OLIVEIRA', 111),
			     (002, 'JOÃO', 'R', 'SILVA', 222),
                 (003, 'SEBASTIÃO', 'O', 'ARAÚJO', 333);
INSERT INTO Empresa (idEmpresa, CNPJEmpresa, CPFdoVendedor)
           VALUES(001, 085, 111),
				 (002, 086, 222),
                 (003, 087, 333);

SELECT*FROM Funcionário;

-- Recuperar todos os clientes do Sobrenome  "Oliveira"

SELECT*FROM Funcionário
WHERE SobrenomeFuncionário = 'OLIVEIRA';

SELECT*FROM Empresa;

-- Recuperar todos os fornecedores do Sobrenome "Sebastião"

SELECT*FROM Empresa
WHERE CNPJEmpresa = 085;


-- Recuperar todos os clientes com CPF começando por "11"
SELECT * FROM Funcionário WHERE CPFdoFuncionário LIKE '11%';

-- Recuperar todos os produtos da categoria "Alimentos"
SELECT * FROM ProdutoFinal WHERE CategoriaProdutoFinal = 'Pão';


-- CRIANDO EXPRESSÕES PARA GERAR ATRIBUTOS DERIVATIVOS


-- Recuperar o nome completo dos funcionários a partir de uma concatenação
SELECT CONCAT (PrimeiroNomeFuncionário, ' ', SobrenomeFuncionário) AS NomeCompletoFuncionário FROM Funcionário;

-- Calcular o preço total de um pedido multiplicando a quantidade de produtos pelo preço unitário
SELECT idProdutoInicial, QuantidadeProdutoInicial, 
       (29 * QuantidadeProdutoInicial) AS PreçoTotal
FROM ProdutoInicial
JOIN ProdutoInicial ON ProdutoInicial.idProdutoInicial = ProdutoInicial.idProdutoInicial;


-- DEFININDO ORDENAÇÕES DOS DADOS COM "ORDER BY"

-- Recuperar todos os produtos finais ordenados por nome (DESCENDENTE)
SELECT * FROM ProdutoFinal ORDER BY NomeProdutoFinal DESC;

-- Recuperar todos os funcionários ordenados por sobrenome e nome
SELECT * FROM Funcionário ORDER BY SobrenomeFuncionário, PrimeiroNomeFuncionário;

-- DEFININDO FILTROS AOS GRUPOS USANDO "HAVING STATEMENT"

-- Recuperar empresa que possui mais de 3 produtos
SELECT Empresa.idEmpresa, Empresa.QuantidadeProdutoFinal, COUNT (QuantidadeProdutoFinal.idProdutoFinal) AS TotalProdutos
FROM Empresa
INNER JOIN Empresa ON Panificadora.CNPJPanificadora = Empresa.CNPJPanificadora
INNER JOIN ProdutoFinal ON Empresa.idProdutoFinal = Empresa.idProdutoFinal
GROUP BY ProdutoFinal.idProdutoFinal, ProdutoFinal.CNPJPanificadora
HAVING TotalProdutos > 3;

