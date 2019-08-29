CREATE DATABASE `stock_db` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_bin */;

CREATE TABLE `user`
(
    `id`           int(10) unsigned                                              NOT NULL AUTO_INCREMENT,
    `user_id`      varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL,
    `user_name`    varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci  NOT NULL,
    `pwd`          varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `created_time` timestamp(3)                                                  NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_time` timestamp(3)                                                  NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`id`),
    UNIQUE KEY `user_user_id_index` (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

CREATE TABLE `account`
(
    `id`           int(10) unsigned                                             NOT NULL AUTO_INCREMENT,
    `user_id`      varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `balance`      decimal(16, 2)                                               NOT NULL DEFAULT 0,
    `created_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

CREATE TABLE `stock`
(
    `id`           int(10) unsigned                                             NOT NULL AUTO_INCREMENT,
    `stock_id`     varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `stock_name`   varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `open_price`   decimal(16, 2)                                               NOT NULL DEFAULT 0,
    `close_price`  decimal(16, 2)                                               NOT NULL DEFAULT 0,
    `trade_date`   timestamp(0)                                                 NOT NULL,
    `created_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`id`),
    UNIQUE KEY `stock_stock_id_index` (`stock_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

CREATE TABLE `user_stock`
(
    `id`           int(10) unsigned                                             NOT NULL AUTO_INCREMENT,
    `user_id`      varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `stock_id`     varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `hold_price`   decimal(16, 2)                                               NOT NULL DEFAULT 0,
    `stock_number` int(10) unsigned                                             NOT NULL,
    `created_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    FOREIGN KEY (`stock_id`) REFERENCES `stock` (`stock_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

CREATE TABLE `quotation`
(
    `id`           int(10) unsigned                                             NOT NULL AUTO_INCREMENT,
    `stock_id`     varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `stock_price`  decimal(16, 2)                                               NOT NULL DEFAULT 0,
    `created_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`stock_id`) REFERENCES `stock` (`stock_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;

CREATE TABLE `order`
(
    `id`           int(10) unsigned                                             NOT NULL AUTO_INCREMENT,
    `stock_id`     varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `user_id`      varchar(16) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
    `order_type`   int(4) unsigned COMMENT '0 卖，1 买'                            NOT NULL,
    `order_number` int(10) unsigned                                             NOT NULL,
    `deal_number`  int(10) unsigned                                             NOT NULL DEFAULT 0,
    `order_price`  decimal(16, 2)                                               NOT NULL,
    `order_status` int(4) unsigned                                                       DEFAULT 0 COMMENT '0 初始化 1 部分成交 2 成交 3 部分撤销 4 撤销',
    `created_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `updated_time` timestamp(3)                                                 NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    PRIMARY KEY (`id`),
    FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`),
    FOREIGN KEY (`stock_id`) REFERENCES `stock` (`stock_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_bin;


INSERT INTO stock (stock_id, stock_name, open_price, close_price, trade_date) VALUE ('601880', '大连港', 3.50, 3.55, '2019-07-30');
INSERT INTO stock (stock_id, stock_name, open_price, close_price, trade_date) VALUE ('000016', '深康佳A', 12.90, 12.80, '2019-07-30');
INSERT INTO stock (stock_id, stock_name, open_price, close_price, trade_date) VALUE ('601138', '工业富联', 15.33, 15.59, '2019-07-30');
INSERT INTO stock (stock_id, stock_name, open_price, close_price, trade_date) VALUE ('300731', '科创新源', 30.20, 31.38, '2019-07-30');

INSERT INTO quotation (stock_id, stock_price) VALUE ('601880', 3.55);
INSERT INTO quotation (stock_id, stock_price) VALUE ('000016', 12.80);
INSERT INTO quotation (stock_id, stock_price) VALUE ('601138', 15.59);
INSERT INTO quotation (stock_id, stock_price) VALUE ('300731', 31.38);

INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-001', 'robot-001', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-002', 'robot-002', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-003', 'robot-003', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-004', 'robot-004', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-005', 'robot-005', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-006', 'robot-006', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-007', 'robot-007', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-008', 'robot-008', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-009', 'robot-009', '111111');
INSERT INTO user (user_id, user_name, pwd) VALUE ('robot-010', 'robot-010', '111111');

INSERT INTO account (user_id, balance) VALUE ('robot-001', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-002', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-003', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-004', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-005', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-006', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-007', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-008', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-009', 100000.00);
INSERT INTO account (user_id, balance) VALUE ('robot-010', 100000.00);

INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-001', '601880', 3.55, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-002', '000016', 12.55, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-003', '601138', 13.55, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-004', '300731', 30.51, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-005', '601880', 3.55, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-006', '601880', 3.55, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-007', '000016', 12.55, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-008', '601138', 13.55, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-009', '300731', 30.51, 1000000);
INSERT INTO user_stock (user_id, stock_id, hold_price, stock_number) VALUE ('robot-010', '601880', 3.55, 1000000);