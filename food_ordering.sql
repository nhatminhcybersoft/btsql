-- Tạo database
CREATE DATABASE food_ordering;

-- Sử dụng database mới tạo
USE food_ordering;

-- Tạo bảng user
CREATE TABLE user (
user_id INT PRIMARY KEY IDENTITY(1,1),
full_name VARCHAR(50),
email VARCHAR(50),
password VARCHAR(50)
);

-- Tạo bảng restaurant
CREATE TABLE restaurant (
res_id INT PRIMARY KEY IDENTITY(1,1),
res_name VARCHAR(50),
image VARCHAR(50),
description VARCHAR(255)
);

-- Tạo bảng food_type
CREATE TABLE food_type (
type_id INT PRIMARY KEY IDENTITY(1,1),
type_name VARCHAR(50)
);

-- Tạo bảng food
CREATE TABLE food (
food_id INT PRIMARY KEY IDENTITY(1,1),
food_name VARCHAR(50),
image VARCHAR(50),
price VARCHAR(50),
description VARCHAR(255),
type_id INT,
FOREIGN KEY (type_id) REFERENCES food_type(type_id)
);

-- Tạo bảng sub_food
CREATE TABLE sub_food (
sub_id INT PRIMARY KEY IDENTITY(1,1),
sub_name VARCHAR(50),
sub_price FLOAT,
food_id INT,
FOREIGN KEY (food_id) REFERENCES food(food_id)
);

-- Tạo bảng like_res
CREATE TABLE like_res (
user_id INT,
res_id INT,
date_like DATETIME,
FOREIGN KEY (user_id) REFERENCES user(user_id),
FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Tạo bảng rate_res
CREATE TABLE rate_res (
user_id INT,
res_id INT,
amount INT,
date_rate DATETIME,
FOREIGN KEY (user_id) REFERENCES user(user_id),
FOREIGN KEY (res_id) REFERENCES restaurant(res_id)
);

-- Tạo bảng order
CREATE TABLE [order] (
user_id INT,
food_id INT,
amount INT,
code VARCHAR(50),
arr_sub_id VARCHAR(255),
FOREIGN KEY (user_id) REFERENCES user(user_id),
FOREIGN KEY (food_id) REFERENCES food(food_id)
);

--Tìm 5 người đã like cho nhà hàng nhiều nhất
SELECT TOP 5 user.user_id, user.full_name, COUNT(like_res.res_id) AS num_likes
FROM user
INNER JOIN like_res ON user.user_id = like_res.user_id
GROUP BY user.user_id, user.full_name
ORDER BY num_likes DESC;

---Tìm 2 nhà hàng có lượt like nhiều nhất
SELECT TOP 2 restaurant.res_id, restaurant.res_name, COUNT(like_res.user_id) AS num_likes
FROM restaurant
INNER JOIN like_res ON restaurant.res_id = like_res.res_id
GROUP BY restaurant.res_id, restaurant.res_name
ORDER BY num_likes DESC;

--Tìm người đã đặt hàng nhiều nhất
SELECT TOP 1 user.user_id, user.full_name, COUNT(order.user_id) AS num_orders
FROM user
INNER JOIN order ON user.user_id = order.user_id
GROUP BY user.user_id, user.full_name
ORDER BY num_orders DESC;

--Tìm người dùng không hoạt động trong hệ thống (không đặt hàng, không like, không đánh giá nhà hàng)
SELECT user.user_id, user.full_name
FROM user
LEFT JOIN order ON user.user_id = order.user_id
LEFT JOIN rate_res ON user.user_id = rate_res.user_id
LEFT JOIN like_res ON user.user_id = like_res.user_id
WHERE order.user_id IS NULL AND rate_res.user_id IS NULL AND like_res.user_id IS NULL;


--Tính trung bình sub_food của một food
SELECT AVG(sub_price) AS average_sub_price
FROM sub_food
WHERE food_id = [ID của food cần tính trung bình sub_food]

