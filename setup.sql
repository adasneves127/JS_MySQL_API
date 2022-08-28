CREATE DATABASE IF NOT EXISTS `API_Users`;
USE `API_Users`;
CREATE TABLE IF NOT EXISTS `Users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL unique,
  `password` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp default current_timestamp,
  `updated_at` timestamp default current_timestamp on update current_timestamp,
  PRIMARY KEY (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE DATABASE IF NOT EXISTS `Ecommerce`;
USE `Ecommerce`;

CREATE TABLE Ecommerce.EMPLOYEES (
    id                 int auto_increment
        primary key,
    name               varchar(255)                        not null,
    manager            int                                 not null comment 'int',
    `DateTime Added`   timestamp default CURRENT_TIMESTAMP not null,
    `DateTime Updated` timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    LastOPRID          int                                 not null,
    `Is Active`        tinyint(1)                          not null,
    constraint EMPLOYEES_ibfk_1
        foreign key (manager) references Ecommerce.EMPLOYEES (id),
    constraint EMPLOYEES_ibfk_2
        foreign key (LastOPRID) references Ecommerce.EMPLOYEES (id)
);

create index LastOPRID
    on Ecommerce.EMPLOYEES (LastOPRID);

create index manager
    on Ecommerce.EMPLOYEES (manager);



create table IF NOT EXISTS Ecommerce.COURIERS(
    id                 int auto_increment
        primary key,
    name               varchar(255)                        not null,
    abbreviation       varchar(3)                          not null,
    phone              int                                 null,
    email              varchar(255)                        null,
    `DateTime Added`   timestamp default CURRENT_TIMESTAMP null,
    `DateTime Updated` timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    LastOPRID          int                                 null,
    `Is Active`        tinyint(1)                          not null,
    constraint COURIERS_ibfk_1
        foreign key (LastOPRID) references Ecommerce.EMPLOYEES (id)
 );

create index LastOPRID
    on Ecommerce.COURIERS (LastOPRID);


create table IF NOT EXISTS Ecommerce.`SHIPMENT ACCOUNTS` (
    ID         int auto_increment,
    courier    int         not null,
    `acct num` varchar(30) null,
    constraint `SHIPMENT ACCOUNTS_ID_uindex`
        unique (ID),
    constraint `SHIPMENT ACCOUNTS_COURIERS_null_fk`
        foreign key (courier) references Ecommerce.COURIERS (id)
 );



create table IF NOT EXISTS Ecommerce.`SHIP METHODS`
(
    id           int                                 null,
    name         varchar(255)                        not null,
    abbreviation varchar(3)                          not null,
    courier      int                                 not null,
    created_at   timestamp default CURRENT_TIMESTAMP null,
    updated_at   timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    `Last OPRID` int                                 not null,
    constraint foreign_key_name
        foreign key (`Last OPRID`) references Ecommerce.EMPLOYEES (id)
);


CREATE TABLE IF NOT EXISTS `CUSTOMERS`(
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `name` varchar(255) NOT NULL,
    `email` varchar(255) NOT NULL,
    `password` varchar(255) NOT NULL,
    `created_at` timestamp default current_timestamp,
    `updated_at` timestamp default current_timestamp on update current_timestamp,
    PRIMARY KEY (`id`)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

create table Ecommerce.COUNTRIES
(
    id           int auto_increment
        primary key,
    abbreviation char(3)                             not null,
    name         varchar(255)                        not null,
    created_at   timestamp default CURRENT_TIMESTAMP null,
    updated_at   timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    `Last OPRID` int                                 not null,
    constraint COUNTRIES_ibfk_1
        foreign key (`Last OPRID`) references Ecommerce.EMPLOYEES (id)
);

create index `Last OPRID`
    on Ecommerce.COUNTRIES (`Last OPRID`);



CREATE TABLE IF NOT EXISTS `ADDRESSES`(
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `street` varchar(255) NOT NULL,
    `city` varchar(255) NOT NULL,
    `state` varchar(255) NULL,
    `zip` varchar(255),
    `country` int(11) NOT NULL,
    `created_at` timestamp default current_timestamp,
    `updated_at` timestamp default current_timestamp on update current_timestamp,
    `AddressType` enum('Bill To', 'Ship To', 'Sold To', 'None') not null,
    `CustomerID` int not null,
    PRIMARY KEY (`id`),
    constraint foreign key (CustomerID) references CUSTOMERS(id),
    constraint foreign key (country) references COUNTRIES(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;



create table Ecommerce.PRODUCTS
(
    id           int auto_increment
        primary key,
    name         varchar(255)                        not null,
    description  text                                not null,
    price        int                                 not null,
    created_at   timestamp default CURRENT_TIMESTAMP null,
    updated_at   timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    `Last OPRID` int                                 not null,
    constraint PRODUCTS_ibfk_1
        foreign key (`Last OPRID`) references Ecommerce.EMPLOYEES (id)
);

create index `Last OPRID`
    on Ecommerce.PRODUCTS (`Last OPRID`);


create table Ecommerce.INVENTORY
(
    id           int auto_increment
        primary key,
    product_id   int                                 not null,
    quantity     int                                 not null,
    created_at   timestamp default CURRENT_TIMESTAMP null,
    updated_at   timestamp default CURRENT_TIMESTAMP null on update CURRENT_TIMESTAMP,
    `Last OPRID` int                                 not null,
    constraint INVENTORY_ibfk_1
        foreign key (product_id) references Ecommerce.PRODUCTS (id),
    constraint INVENTORY_ibfk_2
        foreign key (`Last OPRID`) references Ecommerce.EMPLOYEES (id)
);

create index `Last OPRID`
    on Ecommerce.INVENTORY (`Last OPRID`);

create index product_id
    on Ecommerce.INVENTORY (product_id);



-- This table will be made upon the initialization of the database. --
-- It is user-dependent, on how the user will store items --
/*
CREATE TABLE IF NOT EXISTS `PUTAWAY LOCATION`(
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `LOC 1` enum(`NONE`) NOT NULL,
    `LOC 2` enum(`NONE`) NOT NULL,`name` varchar(255) NOT NULL,
    `LOC 3` enum(`NONE`) NOT NULL,
    `LOC 4` enum(`NONE`) NOT NULL,
    `created_at` timestamp default current_timestamp,
    `updated_at` timestamp default current_timestamp on update current_timestamp,
    `Last OPRID` int(11) not null,
    foreign key (`id`) references INVENTORY(id)
    constraint foreign key (`Last OPRID`) references EMPLOYEES(id)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;
*/

CREATE TABLE IF NOT EXISTS `ORDER HEADER`(
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `order num` varchar(255) NOT NULL default 'NEXT',
    `purchase order num` varchar(255),
    `order_date` datetime NOT NULL,
    `order_time` datetime NOT NULL,
    `Sold To` int(11) not null,
    `Ship To` int(11) not null,
    `Bill To` int(11) not null,
    `line status` enum('Pending','Open','Cancelled', 'Closed', 'Shipped') NOT NULL default 'Pending',
    `tracking id` varchar(255) default null,
    `created_at` timestamp default current_timestamp,
    `updated_at` timestamp default current_timestamp on update current_timestamp,
    `Last OPRID` int(11) not null,
    PRIMARY KEY (`id`),
    constraint foreign key (`Last OPRID`) references EMPLOYEES(id),
    constraint foreign key (`Sold To`) references CUSTOMERS(id),
    constraint foreign key (`Ship To`) references CUSTOMERS(id),
    constraint foreign key (`Bill To`) references CUSTOMERS(id)
 ) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `ORDER LINE`
(
    `id`           int(11)                                                  NOT NULL AUTO_INCREMENT,
    `order_header` int(11)                                              NOT NULL,
    `line_num`     int(11)                                                  NOT NULL,
    `order_date`   datetime                                                 NOT NULL,
    `order_time`   datetime                                                 NOT NULL,
    `line status`  enum ('Pending','Open','Cancelled', 'Closed', 'Shipped') NOT NULL default 'Pending',
    `tracking id`  varchar(255)                                                      default null,
    `created_at`   timestamp                                                         default current_timestamp,
    `updated_at`   timestamp                                                         default current_timestamp on update current_timestamp,
    `Last OPRID`   int(11)                                                  not null,
    PRIMARY KEY (`id`),
    constraint foreign key (order_header) references `ORDER HEADER` (id),
    constraint foreign key (`Last OPRID`) references EMPLOYEES (id)
);

CREATE TABLE IF NOT EXISTS `ORDER SCHEDULE`(
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `order_line` int(11) NOT NULL,
    `schedule_num` int(11) NOT NULL,
    `order_date` datetime NOT NULL,
    `order_time` datetime NOT NULL,
    `schedule status` enum('Pending','Open','Cancelled', 'Closed', 'Shipped') NOT NULL DEFAULT 'Pending',
    `tracking id` varchar(255) default null,
    `created_at` timestamp default current_timestamp,
    `updated_at` timestamp default current_timestamp on update current_timestamp,
    `Last OPRID` int(11) not null,
    `invoice_id` int(11) not null,
    PRIMARY KEY (`id`),
    constraint foreign key (order_line) references `ORDER LINE`(id),
    constraint foreign key (`Last OPRID`) references EMPLOYEES(id)
 );



/*
List of User Types:

    1. Admin
    2. Manager
    3. Sales
    4. Warehouse
    5. Employee
    6. Purchaser
    7. Accounting

List of Privals:
    1. Create
    2. Read
    3. Edit
    4. Delete
*/

CREATE ROLE IF NOT EXISTS 'Authenticator', 'Create Order', "Edit Order", 'Cancel Order',
	'Add Item', 'Edit Item', 'Delete Item', 'Edit Inventory', 'Edit User',
    'Edit Role', 'Edit Privilege', 'Edit Product', 'Edit Category', 'Edit Supplier',
    'Edit Customer', 'Edit Employee';

CREATE TABLE IF NOT EXISTS `CUSTOM QUERIES`(
    `Name` varchar(255) NOT NULL unique,
    `Path` varchar(255) NOT NULL
)