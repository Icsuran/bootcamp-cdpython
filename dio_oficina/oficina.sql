-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
DROP SCHEMA IF EXISTS `mydb` ;

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`cliente`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`cliente` ;

CREATE TABLE IF NOT EXISTS `mydb`.`cliente` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `cpf` VARCHAR(11) NULL,
  `cnpj` VARCHAR(15) NULL,
  `nome` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(12) NOT NULL,
  `endereco` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `cpf_UNIQUE` (`cpf` ASC) VISIBLE,
  UNIQUE INDEX `cnpj_UNIQUE` (`cnpj` ASC) VISIBLE)
ENGINE = InnoDB;

INSERT INTO cliente (cpf, nome, telefone, endereco) VALUES ('12345678911', 'Nanah', '531231231231', 'sem endereço');


-- -----------------------------------------------------
-- Table `mydb`.`marca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`marca` ;

CREATE TABLE IF NOT EXISTS `mydb`.`marca` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

INSERT INTO marca (nome) VALUES ('Fiat');


-- -----------------------------------------------------
-- Table `mydb`.`modelo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`modelo` ;

CREATE TABLE IF NOT EXISTS `mydb`.`modelo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `tipo` ENUM('Compacto', 'Sedan', 'Perua', 'Caminhonete') NOT NULL DEFAULT 'Compacto',
  `marca_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_modelo_marca1_idx` (`marca_id` ASC) VISIBLE,
  CONSTRAINT `fk_modelo_marca1`
    FOREIGN KEY (`marca_id`)
    REFERENCES `mydb`.`marca` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO modelo (nome, tipo, marca_id) VALUES ('Uno', 'Compacto', 1);


-- -----------------------------------------------------
-- Table `mydb`.`veiculo`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`veiculo` ;

CREATE TABLE IF NOT EXISTS `mydb`.`veiculo` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `placa` VARCHAR(12) NOT NULL,
  `cor` VARCHAR(45) NOT NULL,
  `ano_modelo` INT NOT NULL,
  `ano` INT NULL,
  `chassi` VARCHAR(45) NULL,
  `modelo_id` INT NOT NULL,
  `cliente_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_veiculo_modelo1_idx` (`modelo_id` ASC) VISIBLE,
  INDEX `fk_veiculo_cliente1_idx` (`cliente_id` ASC) VISIBLE,
  CONSTRAINT `fk_veiculo_modelo1`
    FOREIGN KEY (`modelo_id`)
    REFERENCES `mydb`.`modelo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_veiculo_cliente1`
    FOREIGN KEY (`cliente_id`)
    REFERENCES `mydb`.`cliente` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO veiculo (placa, cor, ano_modelo, modelo_id, cliente_id) VALUES ('132123123123', 'PRETA', 2023, 1, 1);


-- -----------------------------------------------------
-- Table `mydb`.`especialidade`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`especialidade` ;

CREATE TABLE IF NOT EXISTS `mydb`.`especialidade` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  `salario` FLOAT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

INSERT INTO especialidade (descricao, salario) VALUES ('Motor', 1000);


-- -----------------------------------------------------
-- Table `mydb`.`mecanico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`mecanico` ;

CREATE TABLE IF NOT EXISTS `mydb`.`mecanico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `endereco` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(12) NOT NULL,
  `especialidade_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_Mecanico_Especialidade1_idx` (`especialidade_id` ASC) VISIBLE,
  CONSTRAINT `fk_Mecanico_Especialidade1`
    FOREIGN KEY (`especialidade_id`)
    REFERENCES `mydb`.`especialidade` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO mecanico (nome, endereco, telefone, especialidade_id) VALUES ('João', 'sem endereço', '123123123123', 1);


-- -----------------------------------------------------
-- Table `mydb`.`equipe`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`equipe` ;

CREATE TABLE IF NOT EXISTS `mydb`.`equipe` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_criacao` DATETIME NOT NULL,
  `data_encerramento` DATETIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

INSERT INTO equipe (data_criacao) VALUES (NOW());


-- -----------------------------------------------------
-- Table `mydb`.`equipe_mecanico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`equipe_mecanico` ;

CREATE TABLE IF NOT EXISTS `mydb`.`equipe_mecanico` (
  `equipe_id` INT NOT NULL,
  `mecanico_id` INT NOT NULL,
  PRIMARY KEY (`equipe_id`, `mecanico_id`),
  INDEX `fk_Equipe_has_Mecanico_Mecanico1_idx` (`mecanico_id` ASC) VISIBLE,
  INDEX `fk_Equipe_has_Mecanico_Equipe1_idx` (`equipe_id` ASC) VISIBLE,
  CONSTRAINT `fk_Equipe_has_Mecanico_Equipe1`
    FOREIGN KEY (`equipe_id`)
    REFERENCES `mydb`.`equipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Equipe_has_Mecanico_Mecanico1`
    FOREIGN KEY (`mecanico_id`)
    REFERENCES `mydb`.`mecanico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO equipe_mecanico (equipe_id, mecanico_id) VALUES (1,1);


-- -----------------------------------------------------
-- Table `mydb`.`servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`servico` ;

CREATE TABLE IF NOT EXISTS `mydb`.`servico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `data_agendamento` DATETIME NOT NULL,
  `data_inicio` DATETIME NULL,
  `data_finalizacao` DATETIME NULL,
  `avaliacao` INT NULL DEFAULT 0,
  `autorizado` TINYINT NOT NULL DEFAULT 0,
  `status` ENUM('Prospecção', 'Agendamento', 'Realização', 'Finalização', 'Entrega') NULL,
  `equipe_id` INT NOT NULL,
  `veiculo_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_servico_equipe1_idx` (`equipe_id` ASC) VISIBLE,
  INDEX `fk_servico_veiculo1_idx` (`veiculo_id` ASC) VISIBLE,
  CONSTRAINT `fk_servico_equipe1`
    FOREIGN KEY (`equipe_id`)
    REFERENCES `mydb`.`equipe` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servico_veiculo1`
    FOREIGN KEY (`veiculo_id`)
    REFERENCES `mydb`.`veiculo` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

INSERT INTO servico (data_agendamento, equipe_id, veiculo_id) VALUES (NOW(), 1, 1);


-- -----------------------------------------------------
-- Table `mydb`.`peca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`peca` ;

CREATE TABLE IF NOT EXISTS `mydb`.`peca` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NULL,
  `valor` FLOAT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`servico_peca`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`servico_peca` ;

CREATE TABLE IF NOT EXISTS `mydb`.`servico_peca` (
  `servico_id` INT NOT NULL,
  `peca_id` INT NOT NULL,
  `valor_momento_contratacao` FLOAT NOT NULL DEFAULT 0,
  PRIMARY KEY (`servico_id`, `peca_id`),
  INDEX `fk_servico_peca_peca1_idx` (`peca_id` ASC) VISIBLE,
  CONSTRAINT `fk_servico_peca_servico1`
    FOREIGN KEY (`servico_id`)
    REFERENCES `mydb`.`servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_servico_peca_peca1`
    FOREIGN KEY (`peca_id`)
    REFERENCES `mydb`.`peca` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`tipo_servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`tipo_servico` ;

CREATE TABLE IF NOT EXISTS `mydb`.`tipo_servico` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NULL,
  `valor` FLOAT NULL,
  `duracao_media` TIME NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`servico_tipo_servico`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`servico_tipo_servico` ;

CREATE TABLE IF NOT EXISTS `mydb`.`servico_tipo_servico` (
  `servico_id` INT NOT NULL,
  `tipo_servico_id` INT NOT NULL,
  `valor_momento_contratacao` FLOAT NULL,
  `duracao` TIME NULL,
  PRIMARY KEY (`servico_id`, `tipo_servico_id`),
  INDEX `fk_table1_tipo_servico1_idx` (`tipo_servico_id` ASC) VISIBLE,
  CONSTRAINT `fk_table1_servico1`
    FOREIGN KEY (`servico_id`)
    REFERENCES `mydb`.`servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_table1_tipo_servico1`
    FOREIGN KEY (`tipo_servico_id`)
    REFERENCES `mydb`.`tipo_servico` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

/*
Posteriormente, realize a persistência de dados para realização de testes. Especifique ainda queries mais complexas do que apresentadas durante a explicação do desafio. Sendo assim, crie queries SQL com as cláusulas abaixo:
*/

-- Recuperações simples com SELECT Statement;
SELECT * FROM cliente;

-- Filtros com WHERE Statement;
SELECT * FROM cliente WHERE id = 1;

-- Crie expressões para gerar atributos derivados;
SELECT cliente.id, cliente.nome, count(*) FROM cliente inner join veiculo on (cliente.id = veiculo.cliente_id) inner join servico on (cliente.id = servico.veiculo_id) GROUP BY cliente.id, cliente.nome;

-- Defina ordenações dos dados com ORDER BY;
SELECT * FROM servico ORDER BY data_finalizacao DESC;

-- Condições de filtros aos grupos – HAVING Statement;
SELECT cliente.id, cliente.nome, count(*) FROM cliente inner join veiculo on (cliente.id = veiculo.cliente_id) inner join servico on (cliente.id = servico.veiculo_id) GROUP BY cliente.id, cliente.nome HAVING count(*) >= 1;

-- Crie junções entre tabelas para fornecer uma perspectiva mais complexa dos dados;
SELECT cliente.id, cliente.nome, modelo.nome FROM cliente inner join veiculo on (cliente.id = veiculo.cliente_id) inner join modelo on (veiculo.modelo_id = modelo.id) inner join servico on (cliente.id = servico.veiculo_id);
