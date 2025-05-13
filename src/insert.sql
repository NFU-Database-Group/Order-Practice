-- 先暫時關閉外鍵檢查，避免順序問題
SET
    FOREIGN_KEY_CHECKS = 0;

-- Employee（階段0）
INSERT INTO
    `Employee` (
        `title`,
        `firstName`,
        `middleName`,
        `lastName`,
        `address`,
        `workTelExt`,
        `homeTelNo`,
        `empEmailAddress`,
        `socialSecurityNumber`,
        `DOB`,
        `position`,
        `sex`,
        `salary`,
        `dateStarted`
    )
VALUES
    (
        'Mr.',
        'Frank',
        NULL,
        'Huang',
        '123 Zhonghua Rd, Taipei',
        '103',
        '02-3456-7890',
        'frank.huang@example.com',
        'D123456789',
        '1979-05-10',
        'Sales',
        'M',
        60000.00,
        '2019-10-01'
    ),
    (
        'Ms.',
        'Grace',
        'L.',
        'Liu',
        '45 Mingcheng St, Taichung',
        '104',
        '04-2345-6789',
        'grace.liu@example.com',
        'E987654321',
        '1987-03-22',
        'Marketing',
        'F',
        62000.00,
        '2020-02-15'
    ),
    (
        'Dr.',
        'Henry',
        NULL,
        'Tsai',
        '78 Renai Rd, Kaohsiung',
        '105',
        '07-3456-7890',
        'henry.tsai@example.com',
        'F192837465',
        '1980-11-02',
        'Researcher',
        'M',
        80000.00,
        '2018-07-20'
    ),
    (
        'Mrs.',
        'Ivy',
        NULL,
        'Lo',
        '150 Minsheng E Rd, Tainan',
        '106',
        '06-2345-6789',
        'ivy.lo@example.com',
        'G564738291',
        '1992-07-17',
        'Support',
        'F',
        58000.00,
        '2021-01-05'
    ),
    (
        'Mr.',
        'Jack',
        'T.',
        'Wu',
        '200 Zhongshan N Rd, Taipei',
        '107',
        '02-4567-8901',
        'jack.wu@example.com',
        'H102938475',
        '1991-09-09',
        'Operations',
        'M',
        65000.00,
        '2022-11-11'
    );

-- PaymentMethod（階段1）
INSERT INTO
    `PaymentMethod` (`pMethodNo`, `paymentMethod`)
VALUES
    (1, 'Cash'),
    (2, 'Credit Card'),
    (3, 'Bank Transfer'),
    (4, 'Mobile Payment'),
    (5, 'Cheque');

-- ShipmentMethod（階段1）
INSERT INTO
    `ShipmentMethod` (`sMethodNo`, `shipmentMethod`)
VALUES
    (1, 'Courier'),
    (2, 'Store Pickup'),
    (3, 'Postal Service'),
    (4, 'Express'),
    (5, 'Drone Delivery');

-- Customer（階段1）
INSERT INTO
    `Customer` (
        `customerName`,
        `customerStreet`,
        `customerCity`,
        `customerState`,
        `customerZipCode`,
        `custTelNo`,
        `custFaxNo`,
        `DOB`,
        `maritalStatus`,
        `creditRating`
    )
VALUES
    (
        'Alice Chang',
        '1 Zhongshan Rd',
        'Taipei',
        'Taiwan',
        '100',
        '02-1234-5678',
        '02-8765-4321',
        '1990-02-14',
        'Single',
        750
    ),
    (
        'Bob Lee',
        '22 Fuxing N Rd',
        'Taipei',
        'Taiwan',
        '104',
        '02-2345-6789',
        '02-9876-5432',
        '1982-06-30',
        'Married',
        680
    ),
    (
        'Carol Wang',
        '100 Roosevelt Rd',
        'Taichung',
        'Taiwan',
        '403',
        '04-1234-5678',
        '04-8765-4321',
        '1975-12-05',
        'Divorced',
        720
    ),
    (
        'David Chen',
        '50 Keelung Rd',
        'Kaohsiung',
        'Taiwan',
        '802',
        '07-1234-5678',
        '07-8765-4321',
        '1988-08-20',
        'Married',
        690
    ),
    (
        'Eva Lin',
        '8 Heping E Rd',
        'Tainan',
        'Taiwan',
        '700',
        '06-1234-5678',
        '06-8765-4321',
        '1995-11-11',
        'Single',
        710
    );

-- Product（階段1）
INSERT INTO
    `Product` (
        `productName`,
        `serialNo`,
        `unitPrice`,
        `quantityOnHand`,
        `reorderLevel`,
        `reorderQuantity`,
        `reorderLeadTime`
    )
VALUES
    ('Widget A', 'SN-A001', 10.50, 100, 20, 50, 7),
    ('Widget B', 'SN-B002', 15.75, 200, 30, 60, 7),
    ('Gadget X', 'SN-X003', 22.00, 150, 25, 70, 10),
    ('Gadget Y', 'SN-Y004', 18.25, 120, 20, 40, 5),
    ('Thingamajig', 'SN-T005', 5.00, 300, 50, 100, 14);

-- Order（階段2）
INSERT INTO
    `Order` (
        `orderDate`,
        `billingStreet`,
        `billingCity`,
        `billingState`,
        `billingZipCode`,
        `promisedDate`,
        `status`,
        `customerNo`,
        `employeeNo`
    )
VALUES
    (
        '2025-05-01',
        '1 Zhongshan Rd',
        'Taipei',
        'Taiwan',
        '100',
        '2025-05-05',
        'Pending',
        1,
        1
    ),
    (
        '2025-05-02',
        '22 Fuxing N Rd',
        'Taipei',
        'Taiwan',
        '104',
        '2025-05-06',
        'Processing',
        2,
        2
    ),
    (
        '2025-05-03',
        '100 Roosevelt Rd',
        'Taichung',
        'Taiwan',
        '403',
        '2025-05-08',
        'Shipped',
        3,
        3
    ),
    (
        '2025-05-04',
        '50 Keelung Rd',
        'Kaohsiung',
        'Taiwan',
        '802',
        '2025-05-10',
        'Completed',
        4,
        4
    ),
    (
        '2025-05-05',
        '8 Heping E Rd',
        'Tainan',
        'Taiwan',
        '700',
        '2025-05-12',
        'Cancelled',
        5,
        5
    );

-- OrderDetail（階段3）
INSERT INTO
    `OrderDetail` (`orderNo`, `productNo`, `quantityOrdered`)
VALUES
    (1, 1, 5),
    (2, 2, 3),
    (3, 3, 2),
    (4, 4, 4),
    (5, 5, 1);

-- Shipment（階段4）
INSERT INTO
    `Shipment` (
        `quantity`,
        `shipmentDate`,
        `completeStatus`,
        `orderNo`,
        `productNo`,
        `employeeNo`,
        `sMethodNo`
    )
VALUES
    (5, '2025-05-06', 'Complete', 1, 1, 1, 1),
    (3, '2025-05-07', 'Complete', 2, 2, 2, 2),
    (2, '2025-05-09', 'Complete', 3, 3, 3, 3),
    (4, '2025-05-11', 'Pending', 4, 4, 4, 4),
    (1, '2025-05-13', 'Pending', 5, 5, 5, 5);

-- 10. Invoice（階段5）
INSERT INTO
    `Invoice` (
        `dateRaised`,
        `datePaid`,
        `creditCardNo`,
        `holdersName`,
        `expiryDate`,
        `orderNo`,
        `pMethodNo`
    )
VALUES
    (
        '2025-05-02',
        '2025-05-04',
        NULL,
        NULL,
        NULL,
        1,
        1
    ),
    (
        '2025-05-03',
        '2025-05-05',
        '4111111111111111',
        'Bob Lee',
        '2027-08-31',
        2,
        2
    ),
    (
        '2025-05-04',
        '2025-05-06',
        NULL,
        NULL,
        NULL,
        3,
        3
    ),
    (
        '2025-05-05',
        '2025-05-07',
        NULL,
        NULL,
        NULL,
        4,
        4
    ),
    ('2025-05-06', NULL, NULL, NULL, NULL, 5, 5);

-- 11. 重新啟用外鍵檢查
SET
    FOREIGN_KEY_CHECKS = 1;
