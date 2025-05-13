CREATE DATABASE IF NOT EXISTS order_practice_db;

USE order_practice_db;

-- Create tables as defined in tables.sql

CREATE TABLE `Employee` (
    `employeeNo` INT NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(20) DEFAULT NULL,
    `firstName` VARCHAR(50) NOT NULL,
    `middleName` VARCHAR(50) DEFAULT NULL,
    `lastName` VARCHAR(50) NOT NULL,
    `address` VARCHAR(255) DEFAULT NULL,
    `workTelExt` VARCHAR(10) DEFAULT NULL,
    `homeTelNo` VARCHAR(20) DEFAULT NULL,
    `empEmailAddress` VARCHAR(255) NOT NULL,
    `socialSecurityNumber` VARCHAR(20) NOT NULL,
    `DOB` DATE DEFAULT NULL,
    `position` VARCHAR(100) DEFAULT NULL,
    `sex` CHAR(1) DEFAULT NULL,
    `salary` DECIMAL(15, 2) DEFAULT NULL,
    `dateStarted` DATE NOT NULL,
    PRIMARY KEY (`employeeNo`),
    UNIQUE KEY `uk_employee_ssn` (`socialSecurityNumber`)
);

CREATE TABLE `Customer` (
    `customerNo` INT NOT NULL AUTO_INCREMENT,
    `customerName` VARCHAR(100) NOT NULL,
    `customerStreet` VARCHAR(255) DEFAULT NULL,
    `customerCity` VARCHAR(50) DEFAULT NULL,
    `customerState` VARCHAR(50) DEFAULT NULL,
    `customerZipCode` VARCHAR(20) DEFAULT NULL,
    `custTelNo` VARCHAR(20) NOT NULL,
    `custFaxNo` VARCHAR(20) DEFAULT NULL,
    `DOB` DATE DEFAULT NULL,
    `maritalStatus` ENUM('Single', 'Married', 'Divorced', 'Widowed') DEFAULT 'Single',
    `creditRating` SMALLINT UNSIGNED DEFAULT NULL,
    PRIMARY KEY (`customerNo`),
    UNIQUE KEY `uk_customer_tel` (`custTelNo`),
    UNIQUE KEY `uk_customer_fax` (`custFaxNo`)
);

CREATE TABLE `PaymentMethod` (
    `pMethodNo` INT NOT NULL AUTO_INCREMENT,
    `paymentMethod` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`pMethodNo`)
);

CREATE TABLE `Product` (
    `productNo` INT NOT NULL AUTO_INCREMENT,
    `productName` VARCHAR(100) NOT NULL,
    `serialNo` VARCHAR(50) NOT NULL,
    `unitPrice` DECIMAL(10, 2) NOT NULL,
    `quantityOnHand` INT NOT NULL DEFAULT 0,
    `reorderLevel` INT NOT NULL DEFAULT 0,
    `reorderQuantity` INT NOT NULL DEFAULT 0,
    `reorderLeadTime` INT NOT NULL DEFAULT 0,
    PRIMARY KEY (`productNo`),
    UNIQUE KEY `uk_product_serial` (`serialNo`)
);

CREATE TABLE `ShipmentMethod` (
    `sMethodNo` INT NOT NULL AUTO_INCREMENT,
    `shipmentMethod` VARCHAR(50) NOT NULL,
    PRIMARY KEY (`sMethodNo`)
);

CREATE TABLE `Order` (
    `orderNo` INT NOT NULL AUTO_INCREMENT,
    `orderDate` DATE NOT NULL,
    `billingStreet` VARCHAR(255) DEFAULT NULL,
    `billingCity` VARCHAR(50) DEFAULT NULL,
    `billingState` VARCHAR(50) DEFAULT NULL,
    `billingZipCode` VARCHAR(20) DEFAULT NULL,
    `promisedDate` DATE DEFAULT NULL,
    `status` VARCHAR(20) NOT NULL,
    `customerNo` INT NOT NULL,
    `employeeNo` INT NOT NULL,
    PRIMARY KEY (`orderNo`),
    KEY `idx_order_customer` (`customerNo`),
    KEY `idx_order_employee` (`employeeNo`),
    CONSTRAINT `fk_order_customer` FOREIGN KEY (`customerNo`) REFERENCES `Customer` (`customerNo`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_order_employee` FOREIGN KEY (`employeeNo`) REFERENCES `Employee` (`employeeNo`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `OrderDetail` (
    `orderNo` INT NOT NULL,
    `productNo` INT NOT NULL,
    `quantityOrdered` INT NOT NULL,
    PRIMARY KEY (`orderNo`, `productNo`),
    INDEX `idx_orderdetail_product` (`productNo`),
    CONSTRAINT `fk_orderdetail_order` FOREIGN KEY (`orderNo`) REFERENCES `Order` (`orderNo`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_orderdetail_product` FOREIGN KEY (`productNo`) REFERENCES `Product` (`productNo`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `Shipment` (
    `shipmentNo` INT NOT NULL AUTO_INCREMENT,
    `quantity` INT NOT NULL,
    `shipmentDate` DATE NOT NULL,
    `completeStatus` VARCHAR(20) NOT NULL,
    `orderNo` INT NOT NULL,
    `productNo` INT NOT NULL,
    `employeeNo` INT NOT NULL,
    `sMethodNo` INT NOT NULL,
    PRIMARY KEY (`shipmentNo`),
    INDEX `idx_shipment_orderdetail` (`orderNo`, `productNo`),
    INDEX `idx_shipment_employee` (`employeeNo`),
    INDEX `idx_shipment_smethod` (`sMethodNo`),
    CONSTRAINT `fk_shipment_orderdetail` FOREIGN KEY (`orderNo`, `productNo`) REFERENCES `OrderDetail` (`orderNo`, `productNo`) ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT `fk_shipment_employee` FOREIGN KEY (`employeeNo`) REFERENCES `Employee` (`employeeNo`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_shipment_smethod` FOREIGN KEY (`sMethodNo`) REFERENCES `ShipmentMethod` (`sMethodNo`) ON DELETE RESTRICT ON UPDATE CASCADE
);

CREATE TABLE `Invoice` (
    `invoiceNo` INT NOT NULL AUTO_INCREMENT,
    `dateRaised` DATE NOT NULL,
    `datePaid` DATE DEFAULT NULL,
    `creditCardNo` VARCHAR(50) DEFAULT NULL,
    `holdersName` VARCHAR(100) DEFAULT NULL,
    `expiryDate` DATE DEFAULT NULL,
    `orderNo` INT NOT NULL,
    `pMethodNo` INT NOT NULL,
    PRIMARY KEY (`invoiceNo`),
    INDEX `idx_invoice_order` (`orderNo`),
    INDEX `idx_invoice_pmethod` (`pMethodNo`),
    CONSTRAINT `fk_invoice_order` FOREIGN KEY (`orderNo`) REFERENCES `Order` (`orderNo`) ON DELETE RESTRICT ON UPDATE CASCADE,
    CONSTRAINT `fk_invoice_pmethod` FOREIGN KEY (`pMethodNo`) REFERENCES `PaymentMethod` (`pMethodNo`) ON DELETE RESTRICT ON UPDATE CASCADE
);