--1\1�����庯��RectArea������һ�������ε��������������Ϊ�����Ĳ������룩��
--������������
USE SPDG
--����Ƿ��Ѵ���ͬ���Ĵ洢���̣����У���ɾ����
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

--����
declare @s float
exec @s=RectArea 100,100
select @s as '���'

--1\2����SPDG���ݿ��ж��庯����������Ʒ��ţ���ѯ����Ʒ�����ƣ���������ΪQryGoods����
USE SPDG
--����Ƿ��Ѵ���ͬ���Ĵ洢���̣����У���ɾ����
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'QryGoods' AND type = 'FN')
   	  DROP function QryGoods
GO

create function QryGoods(@NUM varchar(10))
returns varchar(100)
begin
	return (SELECT ��Ʒ���� FROM SPB WHERE ��Ʒ���=@NUM);
end
GO

declare @name varchar(100)
exec @name=QryGoods '10010001'
select @name as '���'


--2\1����SPDG���ݿ��ж���洢����GetSPBH������������Ʒ��ţ���ʹ��EXEC���ִ�иô洢���̡� 
USE SPDG
--����Ƿ��Ѵ���ͬ���Ĵ洢���̣����У���ɾ����
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'GetSPBH' AND type = 'P')
   	  DROP PROCEDURE GetSPBH
GO
--�����洢����
CREATE PROCEDURE GetSPBH
AS
SELECT 
	spb.��Ʒ���
   FROM SPB
GO 

exec GetSPBH;

--2\2����SPDG���ݿ��ж���洢����KH_NJ_Qry�����ؽ����Ͼ��Ŀͻ���š����������䶩����Ʒ�ı�š���Ʒ���ƺ���������ʹ��EXEC���ִ�иô洢���̡�
USE SPDG
--����Ƿ��Ѵ���ͬ���Ĵ洢���̣����У���ɾ����
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'KH_NJ_Qry' AND type = 'P')
   	  DROP PROCEDURE KH_NJ_Qry
GO
--�����洢����
CREATE PROCEDURE KH_NJ_Qry
AS
SELECT 
	KHB.�ͻ����,
	KHB.�ͻ�����,
	SPDGB.��Ʒ���,
	SPB.��Ʒ����,
	SPDGB.���� as ��������
   FROM SPDGB, KHB,SPB
   where KHB.����ʡ��='�����Ͼ�' and KHB.�ͻ����=SPDGB.�ͻ���� and SPDGB.��Ʒ���=SPB.��Ʒ���
GO 

exec KH_NJ_Qry;

--2\3����SPDG���ݿ��ж���洢����SP_FOOD_Qry������ʳƷ����Ʒ��š���Ʒ���Ƽ��䶩���ͻ���š�������������������ʹ��EXEC���ִ�иô洢���̡�

USE SPDG
--����Ƿ��Ѵ���ͬ���Ĵ洢���̣����У���ɾ����
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_FOOD_Qry' AND type = 'P')
   	  DROP PROCEDURE SP_FOOD_Qry
GO
--�����洢����
CREATE PROCEDURE SP_FOOD_Qry
AS
SELECT 
	SPDGB.��Ʒ���,
	SPB.��Ʒ����,
	KHB.�ͻ����,
	KHB.�ͻ�����,
	SPDGB.���� as ��������
   FROM SPDGB, KHB,SPB
   where SPB.��Ʒ���='ʳƷ' and SPB.��Ʒ���=SPDGB.��Ʒ��� and KHB.�ͻ����=SPDGB.�ͻ����
GO 

exec SP_FOOD_Qry;


--3\1������洢����SP_Total����ѯָ����Ʒ��ŵ��ܶ���������ִ�иô洢���̡�

IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Total' AND type = 'P')
   	  DROP PROCEDURE SP_Total
GO
--�����洢����
CREATE PROCEDURE SP_Total @SPnum VARCHAR(50) 
AS
SELECT 
	SUM(SPDGB.����) as �ܶ�����
   FROM SPDGB
   group by SPDGB.��Ʒ���
   having SPDGB.��Ʒ��� = @SPnum
GO 

exec SP_Total '30010001';

--select * from SPDGB

--3\2������洢����SP_TotalCost����ѯָ����Ʒ��ŵ��ܶ�������ִ�иô洢���̡�

IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_TotalCost' AND type = 'P')
   	  DROP PROCEDURE SP_TotalCost
GO
--�����洢����
CREATE PROCEDURE SP_TotalCost @SPnum VARCHAR(50) 
AS

declare @price float
select 
	@price = SPB.����
from SPB
where SPB.��Ʒ��� = @SPnum

SELECT 
	SUM(SPDGB.����)*@price as �ܶ������
   FROM SPDGB
   group by SPDGB.��Ʒ���
   having SPDGB.��Ʒ��� = @SPnum
GO 

--select * from SPDGB

exec SP_TotalCost '10010001';

--4\1������洢����SP_Name_Qry����ѯָ����Ʒ���Ƶ���Ʒ��Ϣ�� ��ִ�иô洢���̡�
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Name_Qry' AND type = 'P')
   	  DROP PROCEDURE SP_Name_Qry
GO
--�����洢����
CREATE PROCEDURE SP_Name_Qry @SPnum VARCHAR(50) 
AS

SELECT 
	*
   FROM SPB
   where spb.��Ʒ����=@SPnum
GO 

--select * from SPB

exec SP_Name_Qry '����';

--4\2������洢����SP_Name_Qry1����ѯָ����Ʒ���Ƶ���Ʒ��Ϣ�������ڣ����1���������0����ִ�иô洢���̡�
IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Name_Qry' AND type = 'P')
   	  DROP PROCEDURE SP_Name_Qry
GO
--�����洢����
CREATE PROCEDURE SP_Name_Qry @SPnum VARCHAR(50)
AS

SELECT 
	COUNT(*) as '�Ƿ����'
   FROM SPB
   where spb.��Ʒ����=@SPnum
GO 

--select * from SPB
exec SP_Name_Qry '����'

--4\3������洢����SP_Name_Qry2����ѯָ����Ʒ���Ƶ���Ʒ��Ϣ�������ڣ��������������1�����򴫳�0��

IF EXISTS ( SELECT name FROM sysobjects 
                      WHERE name = 'SP_Name_Qry2' AND type = 'P')
   	  DROP PROCEDURE SP_Name_Qry2
GO
--�����洢����
CREATE PROCEDURE SP_Name_Qry2 @SPnum VARCHAR(50) ,@res int output
AS

SELECT 
	@res=COUNT(*)
   FROM SPB
   where spb.��Ʒ����=@SPnum
GO 

--select * from SPB
declare @res int
exec SP_Name_Qry2 '����',@res output;
select @res as '�������'