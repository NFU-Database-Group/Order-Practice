INSERT INTO `Employee` (
    `title`, `firstName`, `middleName`, `lastName`, `address`,
    `workTelExt`, `homeTelNo`, `empEmailAddress`, `socialSecurityNumber`,
    `DOB`, `position`, `sex`, `salary`, `dateStarted`
) VALUES
('Mr.', '志強', '宏仁', '王', '台北市中正區和平東路123號',
 '101', '0223456789', 'chih.wang@example.com', 'A123456789',
 '1980-01-15', '業務經理', 'M', 72000.00, '2010-06-01'),
('Ms.', '怡君', NULL, '陳', '新北市永和區中正路456巷7號',
 '203', '0222266688', 'yijun.chen@example.com', 'B987654321',
 '1988-09-23', '財務分析師', 'F', 58000.00, '2015-09-15'),
('Dr.', '偉翔', NULL, '林', '高雄市前鎮區中華五路9號',
 '305', '072289900', 'weixiang.lin@example.com', 'C112233445',
 '1975-12-05', '資深工程師', 'M', 88000.00, '2008-04-20'),
(NULL, '佳音', '思婷', '張', '台中市北屯區崇德路三段50號',
 NULL, '0422345566', 'jiayin.chang@example.com', 'D556677889',
 '1992-04-10', '人資助理', 'F', 45000.00, '2022-01-10'),
('Mrs.', '淑華', NULL, '黃', '台南市東區裕農路200號',
 '404', NULL, 'shuhua.huang@example.com', 'E998877665',
 '1983-06-18', '行政主管', 'F', 65000.00, '2013-08-01');

 INSERT INTO `Customer` (
    `customerName`, `customerStreet`, `customerCity`, `customerState`, 
    `customerZipCode`, `custTelNo`, `custFaxNo`, `DOB`, 
    `maritalStatus`, `creditRating`
) VALUES
('陳小明', '台北市信義區松仁路123號', '台北市', '台北', '110', '0912345678', '0223456789', '1990-05-10', 'Single', 4),
('李佳蓉', '新北市板橋區文化路二段456巷7號', '新北市', '新北', '220', '0987654321', NULL, '1985-12-30', 'Married', 5),
('王大衛', '高雄市苓雅區中山二路33號', '高雄市', '高雄', '802', '0922333444', '0733445566', '1978-03-15', 'Divorced', 3),
('張語嫣', '台中市西屯區市政北七路88號', '台中市', '台中', '407', '0955778899', NULL, '1995-09-25', 'Single', 2),
('林子豪', '台南市中西區永福路一段100號', '台南市', '台南', '700', '0966887766', '0622554411', '1980-07-07', 'Widowed', 1);

INSERT INTO `Product` (
    `productName`, `serialNo`, `unitPrice`, `quantityOnHand`,
    `reorderLevel`, `reorderQuantity`, `reorderLeadTime`
) VALUES
('無線滑鼠', 'MSE-2025001', 499.00, 120, 30, 50, 7),
('機械鍵盤', 'KBD-2025002', 1890.00, 75, 20, 30, 10),
('27吋螢幕', 'MON-2025003', 6290.00, 35, 10, 15, 14),
('USB-C 充電線', 'CAB-2025004', 129.00, 300, 100, 200, 3),
('外接硬碟 1TB', 'HDD-2025005', 2390.00, 50, 10, 20, 5);
