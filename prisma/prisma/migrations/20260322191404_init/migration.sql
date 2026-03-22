-- CreateTable
CREATE TABLE `Departments` (
    `dept_id` INTEGER NOT NULL,
    `dept_name` VARCHAR(255) NOT NULL,

    PRIMARY KEY (`dept_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `EmployeeQualifications` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `emp_id` INTEGER NOT NULL,
    `qual_name` VARCHAR(100) NOT NULL,

    INDEX `emp_id`(`emp_id`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Employees` (
    `emp_id` INTEGER NOT NULL,
    `full_name` VARCHAR(255) NOT NULL,
    `position` VARCHAR(255) NOT NULL,
    `dept_id` INTEGER NULL,

    INDEX `dept_id`(`dept_id`),
    PRIMARY KEY (`emp_id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `EmployeeQualifications` ADD CONSTRAINT `EmployeeQualifications_ibfk_1` FOREIGN KEY (`emp_id`) REFERENCES `Employees`(`emp_id`) ON DELETE CASCADE ON UPDATE RESTRICT;

-- AddForeignKey
ALTER TABLE `Employees` ADD CONSTRAINT `Employees_ibfk_1` FOREIGN KEY (`dept_id`) REFERENCES `Departments`(`dept_id`) ON DELETE SET NULL ON UPDATE RESTRICT;
