--1\1、定义函数RectArea，计算一个长方形的面积（长、宽作为函数的参数输入）。
--标量函数定义
USE SPDG
--检查是否已存在同名的存储过程，若有，则删除。
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'RectArea' AND type = 'FN')
   	  DROP function RectArea
GO

create function RectArea(@a float,@b float)
returns float
begin
	return @a*@b;
end
GO

--运行
declare @s float
exec @s=RectArea 100,100
select @s as '结果'

--1\2、在SPDG数据库中定义函数，根据商品编号，查询该商品的名称；（函数名为QryGoods）。
USE SPDG
--检查是否已存在同名的存储过程，若有，则删除。
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'QryGoods' AND type = 'FN')
   	  DROP function QryGoods
GO

create function QryGoods(@NUM varchar(10))
returns varchar(100)
begin
	return (SELECT 商品名称 FROM SPB WHERE 商品编号=@NUM);
end
GO

declare @name varchar(100)
exec @name=QryGoods '10010001'
select @name as '结果'


--2\1、在SPDG数据库中定义存储过程GetSPBH，返回所有商品编号，并使用EXEC语句执行该存储过程。 
USE SPDG
--检查是否已存在同名的存储过程，若有，则删除。
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'GetSPBH' AND type = 'P')
   	  DROP PROCEDURE GetSPBH
GO
--创建存储过程
CREATE PROCEDURE GetSPBH
AS
SELECT 
	spb.商品编号
   FROM SPB
GO 

exec GetSPBH;

--2\2、在SPDG数据库中定义存储过程KH_NJ_Qry，返回江苏南京的客户编号、姓名、及其订购商品的编号、商品名称和数量，并使用EXEC语句执行该存储过程。
USE SPDG
--检查是否已存在同名的存储过程，若有，则删除。
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'KH_NJ_Qry' AND type = 'P')
   	  DROP PROCEDURE KH_NJ_Qry
GO
--创建存储过程
CREATE PROCEDURE KH_NJ_Qry
AS
SELECT 
	KHB.客户编号,
	KHB.客户姓名,
	SPDGB.商品编号,
	SPB.商品名称,
	SPDGB.数量 as 订购数量
   FROM SPDGB, KHB,SPB
   where KHB.所在省市='江苏南京' and KHB.客户编号=SPDGB.客户编号 and SPDGB.商品编号=SPB.商品编号
GO 

exec KH_NJ_Qry;

--2\3、在SPDG数据库中定义存储过程SP_FOOD_Qry，返回食品类商品编号、商品名称及其订购客户编号、姓名、订购数量，并使用EXEC语句执行该存储过程。

USE SPDG
--检查是否已存在同名的存储过程，若有，则删除。
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_FOOD_Qry' AND type = 'P')
   	  DROP PROCEDURE SP_FOOD_Qry
GO
--创建存储过程
CREATE PROCEDURE SP_FOOD_Qry
AS
SELECT 
	SPDGB.商品编号,
	SPB.商品名称,
	KHB.客户编号,
	KHB.客户姓名,
	SPDGB.数量 as 订购数量
   FROM SPDGB, KHB,SPB
   where SPB.商品类别='食品' and SPB.商品编号=SPDGB.商品编号 and KHB.客户编号=SPDGB.客户编号
GO 

exec SP_FOOD_Qry;


--3\1、定义存储过程SP_Total，查询指定商品编号的总订购数；并执行该存储过程。

IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Total' AND type = 'P')
   	  DROP PROCEDURE SP_Total
GO
--创建存储过程
CREATE PROCEDURE SP_Total @SPnum VARCHAR(50) 
AS
SELECT 
	SUM(SPDGB.数量) as 总订购数
   FROM SPDGB
   group by SPDGB.商品编号
   having SPDGB.商品编号 = @SPnum
GO 

exec SP_Total '30010001';

--select * from SPDGB

--3\2、定义存储过程SP_TotalCost，查询指定商品编号的总订购金额；并执行该存储过程。

IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_TotalCost' AND type = 'P')
   	  DROP PROCEDURE SP_TotalCost
GO
--创建存储过程
CREATE PROCEDURE SP_TotalCost @SPnum VARCHAR(50) 
AS

declare @price float
select 
	@price = SPB.单价
from SPB
where SPB.商品编号 = @SPnum

SELECT 
	SUM(SPDGB.数量)*@price as 总订购金额
   FROM SPDGB
   group by SPDGB.商品编号
   having SPDGB.商品编号 = @SPnum
GO 

--select * from SPDGB

exec SP_TotalCost '10010001';

--4\1、定义存储过程SP_Name_Qry，查询指定商品名称的商品信息； 并执行该存储过程。
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Name_Qry' AND type = 'P')
   	  DROP PROCEDURE SP_Name_Qry
GO
--创建存储过程
CREATE PROCEDURE SP_Name_Qry @SPnum VARCHAR(50) 
AS

SELECT 
	*
   FROM SPB
   where spb.商品名称=@SPnum
GO 

--select * from SPB

exec SP_Name_Qry '咖啡';

--4\2、定义存储过程SP_Name_Qry1，查询指定商品名称的商品信息；若存在，输出1；否则，输出0；并执行该存储过程。
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Name_Qry' AND type = 'P')
   	  DROP PROCEDURE SP_Name_Qry
GO
--创建存储过程
CREATE PROCEDURE SP_Name_Qry @SPnum VARCHAR(50)
AS

SELECT 
	COUNT(*) as '是否存在'
   FROM SPB
   where spb.商品名称=@SPnum
GO 

--select * from SPB
exec SP_Name_Qry '咖啡'

--4\3、定义存储过程SP_Name_Qry2，查询指定商品名称的商品信息；若存在，用输出参数传出1；否则传出0。

IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Name_Qry2' AND type = 'P')
   	  DROP PROCEDURE SP_Name_Qry2
GO
--创建存储过程
CREATE PROCEDURE SP_Name_Qry2 @SPnum VARCHAR(50) ,@res int output
AS

SELECT 
	@res=COUNT(*)
   FROM SPB
   where spb.商品名称=@SPnum
GO 

--select * from SPB
declare @res int
exec SP_Name_Qry2 '阿狸',@res output;
select @res as '输出参数'