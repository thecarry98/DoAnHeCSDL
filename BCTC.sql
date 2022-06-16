USE QLDVVanChuyen 
GO 

-- Báo cáo 1 ( theo tháng, view công ty ): Báo cáo tổng số đơn hàng đã tiếp nhận, tổng đã giao thành công, 
-- tổng giá trị hàng hóa, tổng phí ship ( tính trên đơn hàng đã hoàn thành )
ALTER PROCEDURE proc_report_DoanhThu_DonHang
( @Year INT, @Month INT)
AS
BEGIN
    DECLARE @sum_DH INT, @DaGiao INT , @TongGiaTri MONEY, @TongPhiShip MONEY
	SELECT @sum_DH = COUNT(*) FROM view_DonHang
					WHERE YEAR(NgayTao) = @Year 
					AND MONTH(NgayTao) = @Month

	SELECT @DaGiao = COUNT(*) FROM dbo.view_DonHang
					WHERE YEAR(NgayGiao) = @Year
					AND MONTH(NgayGiao) = @Month

	SELECT @TongGiaTri = SUM(GiaTri) FROM dbo.view_DonHang
					WHERE YEAR(NgayGiao) = @Year
					AND MONTH(NgayGiao) = @Month
	SELECT @TongPhiShip = SUM(PhiShip) FROM dbo.view_DonHang
					WHERE YEAR(NgayGiao) = @Year
					AND MONTH(NgayGiao) = @Month
	SELECT @sum_DH AS N'Tổng đơn hàng đã nhận trong tháng',
			@DaGiao AS N'Tổng đơn đã giao trong tháng',
			@TongGiaTri AS N'Tổng giá trị giao dịch',
			@TongPhiShip AS N'Tổng chi phí vận chuyển'
END

GO 


