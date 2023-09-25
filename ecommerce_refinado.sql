-- -----------------------------------------------------
-- ecommerce refinado: onde os pedidos (orders) possuem parcelas (installments)
-- -----------------------------------------------------

DROP DATABASE IF EXISTS ecommerce_refinado;

CREATE DATABASE IF NOT EXISTS ecommerce_refinado;

USE ecommerce_refinado;

-- -----------------------------------------------------
-- Table clients
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS clients (
  idClient INT NOT NULL AUTO_INCREMENT,
  FName VARCHAR(10),
  Minit VARCHAR(3),
  LName VARCHAR(20),
  CPF CHAR(11) NOT NULL,
  Address VARCHAR(255),
  PRIMARY KEY (idClient),
  UNIQUE CPF_UNIQUE (CPF) 
);

ALTER TABLE clients AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- Table orders
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS orders (
  idOrder INT NOT NULL AUTO_INCREMENT,
  idOrderClient INT,
  orderStatus ENUM('Confirmado', 'Enviado', 'Entregue', 'Em Processamento') DEFAULT 'Em Processamento',
  orderDescription VARCHAR(255),
  sendValue FLOAT DEFAULT 10,
  orderTotal FLOAT,
  PRIMARY KEY (idOrder),
  CONSTRAINT orders_fk1 FOREIGN KEY (idOrderClient) REFERENCES clients (idClient) ON UPDATE CASCADE
);

ALTER TABLE orders AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table installments
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS installments (
  idInstallment INT NOT NULL AUTO_INCREMENT,
  payment FLOAT,
  data_installment DATE,
  idOrder INT,
  PRIMARY KEY (idInstallment),
  CONSTRAINT installments_fk1
    FOREIGN KEY (idOrder)
    REFERENCES orders (idOrder)
);

ALTER TABLE installments AUTO_INCREMENT = 1;

-- -----------------------------------------------------
-- Table product
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS product (
  idProduct INT NOT NULL AUTO_INCREMENT,
  Pname VARCHAR(45),
  classification_kids BOOL DEFAULT FALSE,
  price FLOAT,
  category ENUM('Eletrônico', 'Vestimenta', 'Brinquedos', 'Alimentos', 'Móveis') NOT NULL,
  stars FLOAT DEFAULT 0,
  size VARCHAR(10),
  PRIMARY KEY (idProduct)
);

ALTER TABLE product AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table productOrder
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS productOrder (
  idProduct INT NOT NULL,
  idOrder INT NOT NULL,
  poQuantity INT DEFAULT 1,
  poStatus ENUM('Disponível', 'Sem estoque') DEFAULT 'Disponível',
  PRIMARY KEY (idOrder, idProduct),
  CONSTRAINT productOrder_fk1 FOREIGN KEY (idOrder) REFERENCES orders (idOrder),
  CONSTRAINT productOrder_fk2 FOREIGN KEY (idProduct) REFERENCES product (idProduct)
);


-- -----------------------------------------------------
-- Table seller
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS seller (
  idSeller INT NOT NULL AUTO_INCREMENT,
  SocialName VARCHAR(255) NOT NULL,
  contact VARCHAR(10) NOT NULL,
  CNPJ CHAR(15),
  CPF CHAR(11),
  AbstName VARCHAR(255),
  location VARCHAR(45),
  PRIMARY KEY (idSeller),
  UNIQUE CPF_UNIQUE (CPF),
  UNIQUE CNPJ_UNIQUE (CNPJ) 
);

ALTER TABLE seller AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table productsStorage
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS productStorage (
  idProdStorage INT NOT NULL AUTO_INCREMENT,
  storageLocation VARCHAR(255),
  quantity INT DEFAULT 0,
  PRIMARY KEY (idProdStorage)
);

ALTER TABLE productStorage AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table storageLocation
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS storageLocation (
  idStorage INT NOT NULL,
  idProduct INT NOT NULL,
  location VARCHAR(255) NOT NULL,
  PRIMARY KEY (idStorage, idProduct),
  CONSTRAINT storageLocation_fk1
    FOREIGN KEY (idStorage)
    REFERENCES productStorage (idProdStorage),
  CONSTRAINT storageLocation_fk2
    FOREIGN KEY (idProduct)
    REFERENCES product (idProduct)
);


-- -----------------------------------------------------
-- Table supplier
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS supplier (
  idSupplier INT NOT NULL AUTO_INCREMENT,   
  SocialName VARCHAR(255) NOT NULL,
  AbstName VARCHAR(255),
  CNPJ CHAR(15) NOT NULL,
  contact VARCHAR(10) NOT NULL,
  PRIMARY KEY (idSupplier),
  UNIQUE CNPJ_UNIQUE (CNPJ) 
);

ALTER TABLE supplier AUTO_INCREMENT = 1;


-- -----------------------------------------------------
-- Table productSupplier
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS productSupplier (
  idSupplier INT NOT NULL,
  idProduct INT NOT NULL,
  quantity INT NOT NULL,
  PRIMARY KEY (idSupplier, idProduct),
  CONSTRAINT productSupplier_fk1 FOREIGN KEY (idSupplier) REFERENCES supplier (idSupplier),
  CONSTRAINT productSupplier_fk2 FOREIGN KEY (idProduct)  REFERENCES product (idProduct)
);


-- -----------------------------------------------------
-- Table productSeller
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS productSeller (
  idSeller INT NOT NULL,
  idProduct INT NOT NULL,
  prodQuantity INT DEFAULT 1,
  PRIMARY KEY (idSeller, idProduct), 
  CONSTRAINT productSeller_fk1 FOREIGN KEY (idSeller) REFERENCES seller (idSeller),
  CONSTRAINT productSeller_fk2 FOREIGN KEY (idProduct) REFERENCES product (idProduct)
);


-- -----------------------------------------------------
-- Table payments
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS payments (
  idpayment INT AUTO_INCREMENT,
  typePayment ENUM('Boleto', 'Cartão', 'Dois Cartões'),
  limitAvailable FLOAT,
  dataValid DATE,
  clients_idClient INT NOT NULL,
  PRIMARY KEY (idpayment, clients_idClient),
  CONSTRAINT payment_fk1
    FOREIGN KEY (clients_idClient)
    REFERENCES clients (idClient)
);



insert into clients (FName, Minit, Lname, CPF, Address) values
('Maria', 'M', 'Silva', 12346789, 'rua silva de prata 29, Carangola - Cidade das flores'),
('Matheus','0','Pimentel', 987654321, 'rua alemeda 289, Centro - Cidade das flores'),
('Ricardo','F', 'Silva', 45678913, 'avenida alemeda vinha 1009, Centro - Cidade das flores'),
('Julia','s', 'Franca', 789123456, 'rua lareijras 861, Centro - Cidade das flores'),
('Roberta','G', 'Assis', 98745631, 'avenidade koller 19, Centro - Cidade das flores'),
('Isabela','M','Cruz', 654789123, 'rua alemeda das flores 28, Centro - Cidade das flores');


insert into product (Pname, classification_kids, category, stars, size) values
('Fone de ouvido',false, 'Eletrônico',4,null),
('Barbie Elsa',true, 'Brinquedos',3,null),
('Body Carters',true, 'Vestimenta', 5 ,null),
('Microfone Vedo - Youtuber',False, 'Eletrônico', 0 ,null),
('Sofá retrátil',False, 'Movéis', 3, '3x57x80'),
('Farinha de arroz',False, 'Alimentos', 2, null),
('Fire Stick Amazon',False,'Eletrônico', 3,null);


insert into orders (idOrderClient, orderStatus, orderDescription, sendValue, orderTotal) values
(1,default,'compra via aplicativo',null,100),
(2,default, 'compra via aplicativo',50,200), 
(3,'Confirmado',null,null, 300),
(4,default, 'compra via web site',150,400); 



INSERT INTO installments (payment, data_installment, idOrder) VALUES
(10,  '2024-01-01', 1),
(20,  '2024-01-01', 1),
(30,  '2024-01-01', 2),
(10,  '2024-01-01', 2),
(20,  '2024-01-01', 3),
(10,  '2024-01-01', 4);



insert into productOrder (idProduct, idOrder, poQuantity, poStatus) values
(1,1,2,default),
(2,1,1,default),
(3,2,1,default);


insert into productStorage (storageLocation,quantity) values
('Rio de Janeiro',1000),
('Rio de Janeiro',500),
('São Paulo',10),
('São Paulo',100),
('São Paulo',10),
('Brasília',60);


insert into storageLocation (idProduct, idStorage, location) values
(1,2,'RJ'),
(2,6,'GO');

insert into supplier (SocialName, CNPJ, contact) values
('Almeida e filhos', '123456789123456','21985474'),
('Eletrénicos Silva', '854519649143457', '21985484'),
('Eletrdnicos Valma', '934567893934695', '21975474');


insert into productSupplier (idSupplier, idProduct, quantity) values
(1,1,500),
(1,2,400),
(2,4,633),
(3,3,5),
(2,5,10);


INSERT into seller (SocialName, AbstName, CNPJ, CPF, location, contact) values
('Tech eletronics', null, '123456789456321', null, 'Rio de Janeiro', '219946287'),
('Botique Durgas',null,null, '123456783', 'Rio de Janeiro', '219567895'),
('Kids World',null,'456789123654485',null, 'São Paulo', '1198657484');


insert into productSeller (idSeller, idProduct, prodQuantity) values
(1,6,80),
(2,7,10);

-- -----------------------------------------------------
-- Queries
-- -----------------------------------------------------
select * from productSeller;
select count(*) from clients;
select * from clients c, orders o where c.idClient = idOrderClient; 
select Fname,Lname, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select concat(Fname,' ',Lname) as Client, idOrder, orderStatus from clients c, orders o where c.idClient = idOrderClient;
select * from clients c, orders o where c.idClient = idOrderClient group by idOrder;
select clients.idClient, Fname, count(*) as Number_of_orders from clients inner join orders ON clients.idClient = orders.idOrderClient inner join productOrder on productOrder.idOrder = orders.idOrder GROUP BY idClient;
SELECT * FROM clients WHERE FName = 'Maria' order by idClient;
SELECT clients.FName, count(*) FROM clients inner join orders on (clients.idClient = orders.idOrderClient) group by clients.idClient HAVING count(*) >= 1;
-- -----------------------------------------------------
-- Queries Refinadas
-- -----------------------------------------------------
-- Parcelas de cada pedido
select clients.idClient, orders.idOrderClient, installments.payment, installments.data_installment from clients inner join orders on (orders.idOrderClient = clients.idClient) inner join installments on (installments.idOrder = orders.idOrder);


