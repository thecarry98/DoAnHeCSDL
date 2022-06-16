USE QLDVVanChuyen
GO 

-- tạo trigger kiểm tra điều kiện chuyển đến chi nhánh có đang trong trạng thái ngừng hoạt động hay ko
ALTER TRIGGER tg_check_traffer_NhanVien
ON dbo.NhanVien
FOR INSERT,UPDATE AS 
BEGIN
	DECLARE @TTHD INT
	SELECT @TTHD =  dbo.ChiNhanh.Ma_TTHD 
	FROM dbo.ChiNhanh JOIN Inserted 
	ON Inserted.Ma_CN = ChiNhanh.Ma_CN

	IF @TTHD = 2 
		BEGIN
			RAISERROR('Chi Nhánh Hiện Đang Đóng Cửa',16,1)
			ROLLBACK TRANSACTION
		END

END;

GO

ALTER TRIGGER tg_check_traffer_Shipper
ON dbo.Shippers
FOR INSERT, UPDATE
AS 
BEGIN
	DECLARE @TTHD INT
	SELECT @TTHD =  dbo.ChiNhanh.Ma_TTHD 
	FROM dbo.ChiNhanh,Inserted 
	WHERE Inserted.Ma_CN = dbo.ChiNhanh.Ma_CN
 
	IF @TTHD = 2
		BEGIN
			RAISERROR('Chi Nhánh Hiện Đang Đóng Cửa',17,1)
			ROLLBACK TRANSACTION
		END

END;

GO 
-- (2) : trigger kiểm tra khi thay đổi trạng thái đơn hàng có vi phạm đơn hàng đang giao ko


--(3) : trigger xử lý khiếu nại
CREATE TRIGGER tg_XuLy_KN
ON dbo.XuLyKN
FOR INSERT
AS
BEGIN
    DECLARE @TTKN INT 
	SELECT @TTKN = Ma_TTKN 
	FROM dbo.KhieuNai JOIN Inserted
	ON Inserted.Ma_KN = KhieuNai.Ma_KN

	IF @TTKN = 2 
	BEGIN
	    RAISERROR('Khiếu nại đang được xử lý',18,1)
		ROLLBACK TRANSACTION
	END
END
