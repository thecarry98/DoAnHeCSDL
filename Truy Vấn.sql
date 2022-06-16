USE QLDVVanChuyen
GO

-- CHI NHÁNH

-- (1):truy vấn danh sách chi nhánh đang hoạt động hoặc ngừng hoạt động
ALTER PROCEDURE active_or_notActive_ChiNhanh
AS
BEGIN
	SELECT CN.Ma_CN,CN.DiaChi,TT.TenTTHD FROM dbo.ChiNhanh AS CN, dbo.TrangThaiHD AS TT
	WHERE CN.Ma_TTHD = TT.Ma_TTHD
END;

GO 

-- (2)đếm số lượng chi nhánh trên toàn quốc
ALTER PROCEDURE count_ChiNhanh
AS
BEGIN
	
	DECLARE @sum INT, @active INT, @notActive INT 
	SET @sum = ( SELECT COUNT(*) FROM dbo.ChiNhanh)
	SET @active = (SELECT COUNT(*) FROM dbo.ChiNhanh WHERE Ma_TTHD =1)
	SET @notActive = @sum - @active
	SELECT @sum AS sum, @active AS active, @notActive AS not_active
END;


-- (3):danh sách chi nhánh, địa chỉ, số lượng nv đang làm việc ,tạm nghỉ
ALTER PROCEDURE proc_infor_ChiNhanh
AS 
BEGIN

	SELECT CN.Ma_CN, CN.DiaChi, TT.TenTTHD,
	N'NV Đang làm việc' = 
	( SELECT COUNT(*) 
	FROM dbo.NhanVien 
	WHERE Ma_TTLV = 1 
	AND dbo.NhanVien.Ma_CN = CN.Ma_CN),
	N'NV Nghỉ tạm thời' = 
	( SELECT COUNT(*) 
	FROM dbo.NhanVien 
	WHERE Ma_TTLV = 3 
	AND dbo.NhanVien.Ma_CN = CN.Ma_CN),
	N'NV Đang nghỉ phép' = 
	( SELECT COUNT(*) 
	FROM dbo.NhanVien 
	WHERE Ma_TTLV = 4 
	AND dbo.NhanVien.Ma_CN = CN.Ma_CN),


	N'SP Đang làm việc' = 
	( SELECT COUNT(*) 
	FROM dbo.Shippers 
	WHERE Ma_TTLV = 1 
	AND dbo.Shippers.Ma_CN = CN.Ma_CN),
	N'SP Nghỉ tạm thời' = 
	( SELECT COUNT(*) 
	FROM dbo.Shippers 
	WHERE Ma_TTLV = 3 
	AND dbo.Shippers.Ma_CN = CN.Ma_CN),
	N'SP Đang nghỉ phép' = 
	( SELECT COUNT(*) 
	FROM dbo.Shippers 
	WHERE Ma_TTLV = 4 
	AND dbo.Shippers.Ma_CN = CN.Ma_CN)

	FROM dbo.ChiNhanh AS CN
	JOIN dbo.TrangThaiHD AS TT
	ON TT.Ma_TTHD = CN.Ma_TTHD 

END




GO 

-- (4)chuyển nv,shipper về trạng thái làm việc 3 ( tạm nghỉ) khi đóng cửa chi nhánh
ALTER PROCEDURE proc_update_NvAndSp_for_CN
( @idCN VARCHAR(5))
AS
BEGIN 
	UPDATE dbo.NhanVien
	SET Ma_TTLV = 3
	FROM dbo.NhanVien JOIN dbo.ChiNhanh
	ON ChiNhanh.Ma_CN = NhanVien.Ma_CN
	WHERE
	 ChiNhanh.Ma_CN = @idCN
	AND dbo.NhanVien.Ma_TTLV = 1

	UPDATE dbo.Shippers
	SET Ma_TTLV = 3
	FROM dbo.Shippers JOIN dbo.ChiNhanh
	ON ChiNhanh.Ma_CN = dbo.Shippers.Ma_CN
	WHERE 
	 ChiNhanh.Ma_CN = @idCN
	AND dbo.Shippers.Ma_TTLV = 1

END;

GO 
--(5) cho ngừng hoạt động 1 chi nhánh
ALTER PROCEDURE stop_ChiNhanh
( @id VARCHAR(10))
AS
BEGIN
	EXECUTE proc_update_NvAndSp_for_CN @idCN = @id -- varchar(5)

	UPDATE dbo.ChiNhanh
	SET Ma_TTHD = 2
	WHERE Ma_CN = @id
	-- cho nv,shipper về trạng thái 3 ( tạm nghỉ việc )
END;

GO 
EXECUTE dbo.stop_ChiNhanh @id = 'CN01'
DROP PROCEDURE dbo.stop_ChiNhanh
GO 

-- (6)chuyển nv về trạng thái làm việc 1 ( đang làm việc) khi mở cửa chi nhánh
CREATE PROCEDURE proc_update_NvAndSp_for_CN_2
( @idCN VARCHAR(5))
AS
BEGIN 
	UPDATE dbo.NhanVien
	SET Ma_TTLV = 1
	FROM dbo.NhanVien JOIN dbo.ChiNhanh
	ON ChiNhanh.Ma_CN = NhanVien.Ma_CN
	WHERE ChiNhanh.Ma_TTHD = 1
	AND ChiNhanh.Ma_CN = @idCN
	AND Ma_TTLV = 3

	UPDATE dbo.Shippers
	SET Ma_TTLV = 1
	FROM dbo.Shippers JOIN dbo.ChiNhanh
	ON ChiNhanh.Ma_CN = dbo.Shippers.Ma_CN
	WHERE ChiNhanh.Ma_TTHD = 1
	AND ChiNhanh.Ma_CN = @idCN
	AND Ma_TTLV = 3
END;



--(7) cho hoạt động trở lại
GO 
ALTER PROCEDURE active_again_ChiNhanh
(
	@id VARCHAR(10)
)
AS 
BEGIN
	UPDATE dbo.ChiNhanh
	SET Ma_TTHD = 1
	WHERE Ma_CN = @id
	-- cho nv về trạng thái 1 ( đang làm việc )
	EXECUTE proc_update_NvAndSp_for_CN_2 @idCN = @id
END;


-- (8)mở cửa chi nhánh theo địa chỉ 
GO 
CREATE PROCEDURE active_again_ChiNhanh_address
( @diachi NVARCHAR(50))
AS 
BEGIN
	UPDATE dbo.ChiNhanh
	SET Ma_TTHD = 1
	WHERE DiaChi = @diachi
END;

EXECUTE dbo.active_again_ChiNhanh_address @diachi = N'Hà Nam' -- nvarchar(50)



-- run
EXECUTE dbo.active_again_ChiNhanh @id = 'CN06'     -- varchar(10)


GO 
-- NHÂN VIÊN
--(9) thay đổi trạng thái nv, cho đi làm lại, cho nghỉ phép, đuổi việc
ALTER PROCEDURE proc_change_status_NhanVien
( @ID VARCHAR(10), @IDTTNV INT )
AS 
BEGIN
	UPDATE dbo.NhanVien
	SET Ma_TTLV = @IDTTNV
	WHERE Ma_NV = @ID
END
--run


-- (10)ds nhân viên đang làm việc, đã nghỉ việc, tạm nghỉ tại chi nhánh bất kỳ
GO 
CREATE PROCEDURE proc_list_active_orNOT_NhanVien
(   @idCN VARCHAR(10),
	@idTTLV INT
)
AS
BEGIN
	SELECT * FROM dbo.NhanVien
	WHERE Ma_CN = @idCN AND Ma_TTLV = @idTTLV
END;


GO 

-- (11)điều chuyển công tác cho nhân viên: nhân viên nào đến chi nhánh nào
ALTER PROCEDURE proc_transfer_NhanVien
( @IDNV VARCHAR(10),
@IDCN VARCHAR(5)
)
AS 
BEGIN 
	UPDATE dbo.NhanVien
	SET Ma_CN = @IDCN
	WHERE Ma_NV = @idNV
END;

-- 

GO 
-- Shippers
--(12) thay đổi trạng thái SP, cho đi làm lại, cho nghỉ phép, đuổi việc
CREATE PROCEDURE proc_change_status_Shipper
( @ID VARCHAR(10), @IDTTNV INT )
AS 
BEGIN
	UPDATE dbo.Shippers
	SET Ma_TTLV = @IDTTNV
	WHERE Ma_Shipper = @ID
END


-- (13)ds Shipper đang làm việc, đã nghỉ việc, tạm nghỉ tại chi nhánh bất kỳ
GO 
CREATE PROCEDURE proc_list_active_orNOT_Shipper
(   @idCN VARCHAR(10),
	@idTTLV INT
)
AS
BEGIN
	SELECT * FROM dbo.Shippers
	WHERE Ma_CN = @idCN AND Ma_TTLV = @idTTLV
END;

GO 
--(14): tạo view đơn hàng

ALTER VIEW view_DonHang
AS 
	SELECT DH.Ma_DH,DH.TenDH,DH.Ten_NguoiNhan,
	DH.SDT_NguoiNhan,DH.DiaChi AS DiaChi_NguoiNhan
	,DH.KichThuoc,
	DH.GiaTri, DH.PhiShip, DH.ThanhToan,DH.NgayTao,
	DH.NgayGiao, DH.Ma_TTDH, TenTTDH,
	DH.Ma_KH, KH.HoTen AS HoTen_KH, KH.SDT, KH.DiaChi AS DiaChi_KH,
	DH.Ma_Shipper, SP.HoTen AS HoTen_Shipper, SP.SDT AS SDT_SP

	FROM dbo.DonHang AS DH 
	JOIN dbo.KhachHang AS KH
	ON KH.Ma_KH = DH.Ma_KH
	FULL OUTER JOIN dbo.Shippers AS SP
	ON SP.Ma_Shipper = DH.Ma_Shipper
	JOIN dbo.TrangThaiDH
	ON TrangThaiDH.Ma_TTDH = DH.Ma_TTDH


--(15) tra cứu tình trạng đơn hàng theo mã ĐH ( view everyone)
GO 
ALTER PROCEDURE proc_search_TTDH_from_view_DonHang
( @ID_DH VARCHAR(10) )
AS BEGIN 
	SELECT TenTTDH FROM view_DonHang
	WHERE view_DonHang.Ma_DH = @ID_DH
END 


EXECUTE proc_search_TTDH_from_view_DonHang @ID_DH = 'DH234'

--(16) Tra cứu thông tin đơn hàng theo SĐT
GO 
ALTER PROCEDURE proc_search_DH_from_view_DonHang_by_SDTKH
( @SDT VARCHAR(10))
AS BEGIN 
	SELECT Ma_DH,TenDH, Ten_NguoiNhan, SDT_NguoiNhan,
	DiaChi_NguoiNhan, KichThuoc, GiaTri, PhiShip, ThanhToan,
	NgayTao, NgayGiao, TenTTDH, HoTen_KH, SDT, DiaChi_KH,
	HoTen_Shipper, SDT_SP
	FROM view_DonHang
	WHERE SDT = @SDT
END;

GO	
--(17): update TTDH cho đơn hàng
ALTER PROCEDURE proc_update_TTDH_for_DonHang
(@ID_DH VARCHAR(10), @TTDH INT, @ID_NV VARCHAR(10))
AS 
BEGIN
	UPDATE view_DonHang
	SET Ma_TTDH = @TTDH
	WHERE Ma_DH = @ID_DH

	EXECUTE proc_addTable_CapNhatDonHang
	@ID_DH = @ID_DH, @ID_NV = @ID_NV, 
	@NoiDung = N'Cập Nhật Trạng Thái ĐH'
END
GO 
--(18): update Ngày giao cho đơn hàng
ALTER PROCEDURE proc_update_Day_for_DonHang
(@ID_DH VARCHAR(10), @ID_NV VARCHAR(10))
AS 
BEGIN
    UPDATE view_DonHang
	SET NgayGiao = GETDATE()
	WHERE Ma_DH = @ID_DH

	EXECUTE proc_update_TTDH_for_DonHang @ID_DH = @ID_DH,@TTDH = 5,@ID_NV = @ID_NV

	EXECUTE proc_addTable_CapNhatDonHang
	@ID_DH = @ID_DH, @ID_NV = @ID_NV, 
	@NoiDung = N'Cập Nhật Ngày Giao'

END

GO 
--(19): update Shipper cho đơn hàng
ALTER PROCEDURE proc_update_Shipper_for_DonHang
(@ID_DH VARCHAR(10), @ID_SP VARCHAR(10), @ID_NV VARCHAR(10))
AS 
BEGIN
    UPDATE view_DonHang
	SET Ma_Shipper = @ID_SP
	WHERE Ma_DH = @ID_DH

	EXECUTE proc_addTable_CapNhatDonHang
	@ID_DH = @ID_DH, @ID_NV = @ID_NV, 
	@NoiDung = N'Cập Nhật Shipper'
END

GO 
--(20): tạo 1 procedure lưu trữ cập nhật đơn hàng
CREATE PROCEDURE proc_addTable_CapNhatDonHang
( @ID_DH VARCHAR(10), @ID_NV VARCHAR(10), @NoiDung NTEXT)
AS 
BEGIN
    INSERT dbo.CapNhatDH
    (
        Ma_NV,
        Ma_DH,
        NoiDung,
        ThoiGian
    )
    VALUES
    (   @ID_NV,       -- Ma_NV - varchar(10)
        @ID_DH,       -- Ma_DH - varchar(10)
        @NoiDung,      -- NoiDung - ntext
        GETDATE() -- ThoiGian - datetime
        )
END

GO 
--(21): sửa đổi thông tin đơn hàng
CREATE PROCEDURE proc_fix_infor_DonHang
(@Ten_NgNhan NVARCHAR(30), @SDT_NgNhan VARCHAR(10), 
@DiaChi NVARCHAR(50), @GiaTri MONEY, @ThanhToan NVARCHAR(50),
@ID_DH VARCHAR(10), @ID_NV VARCHAR(10))
AS 
BEGIN
    UPDATE view_DonHang
	SET Ten_NguoiNhan = @Ten_NgNhan,
	SDT_NguoiNhan = @SDT_NgNhan,
	DiaChi_NguoiNhan = @DiaChi,
	GiaTri = @GiaTri,
	ThanhToan = @ThanhToan
	WHERE Ma_DH = @ID_DH

	EXECUTE proc_addTable_CapNhatDonHang
	@ID_DH = @ID_DH, @ID_NV = @ID_NV, 
	@NoiDung = N'Sửa thông tin đơn hàng'

END
GO 
--(22): Truy vấn đơn hàng theo tháng ( view khách hàng, tính theo ngày tạo )
CREATE PROCEDURE proc_view_DonHang_as_Month
(@ID_KH VARCHAR(10), @Year INT, @Month INT)
AS 
BEGIN
    SELECT Ma_DH,TenDH, Ten_NguoiNhan, SDT_NguoiNhan,
	DiaChi_NguoiNhan, KichThuoc, GiaTri, PhiShip, ThanhToan,
	NgayTao, NgayGiao, TenTTDH, HoTen_KH, SDT, DiaChi_KH,
	HoTen_Shipper, SDT_SP
	FROM view_DonHang
	WHERE Ma_KH = @ID_KH
	AND YEAR(NgayTao) = @Year
	AND MONTH(NgayTao) = @Month
END

GO 

--(23) Truy vấn khách hàng, tổng số đơn hàng, tổng đã giao ( theo tháng)
ALTER PROCEDURE proc_top_KhachHang_as_Month
(@Year INT, @Month INT, @top INT)
AS 
BEGIN
    SELECT TOP (@top) *,Tong_DH = 
	(SELECT COUNT(*) FROM dbo.DonHang
	WHERE Ma_KH = KH.Ma_KH 
	AND MONTH(NgayTao) = @Month 
	AND YEAR(NgayTao) = @Year)
	FROM dbo.KhachHang AS KH
	ORDER BY Tong_DH DESC
END

GO 
--(24): Khi KH gửi đơn khiếu nại
CREATE PROCEDURE proc_send_KhieuNai
( @ID_DH VARCHAR(10), @ND_KN NTEXT)
AS
BEGIN
    DECLARE @ID_KH VARCHAR(10)
	SELECT @ID_KH = Ma_KH FROM dbo.view_DonHang 
	WHERE dbo.view_DonHang.Ma_DH = @ID_DH

	INSERT dbo.KhieuNai
	(
	    NoiDungKN,
	    NgayGui,
	    Ma_DH,
	    Ma_KH,
	    Ma_TTKN
	)
	VALUES
	(   @ND_KN,       -- NoiDungKN - ntext
	    GETDATE(), -- NgayGui - datetime
	    @ID_DH,        -- Ma_DH - varchar(10)
	    @ID_KH,        -- Ma_KH - varchar(10)
	    1          -- Ma_TTKN - int
	    )
END

GO 
--(25): Khi nhân viên tham gia xử lý khiếu nại
CREATE PROCEDURE proc_join_XuLy_KN
( @ID_NV VARCHAR(10), @ID_KN INT, @ND_XLKN NTEXT )
AS
BEGIN

    INSERT dbo.XuLyKN
    (
        Ma_NV,
        Ma_KN,
        NoiDung,
        ThoiGian
    )
    VALUES
    (   @ID_NV,       -- Ma_NV - varchar(10)
        @ID_KN,        -- Ma_KN - int
        @ND_XLKN,      -- NoiDung - ntext
        GETDATE() -- ThoiGian - datetime
        )

END

GO 
--(26): Đổi trạng thái khiếu nại: 

ALTER PROCEDURE proc_change_TT_KN
( @ID_NV VARCHAR(10), @ID_KN INT , @ID_TT_KN INT )
AS
BEGIN

    UPDATE dbo.KhieuNai
	SET Ma_TTKN = 1
	WHERE Ma_KN = @ID_KN

	IF (@ID_TT_KN = 1)
	BEGIN
	    EXECUTE proc_join_XuLy_KN
		@ID_NV = @ID_NV, @ID_KN = @ID_KN, @ND_XLKN = N'Không thành công'
	END
	
	IF(@ID_TT_KN = 2)
	BEGIN
		 EXECUTE proc_join_XuLy_KN
		@ID_NV = @ID_NV, @ID_KN = @ID_KN, @ND_XLKN = N'Đang xử lý'
	END

	IF(@ID_TT_KN = 3)
	BEGIN
	    EXECUTE proc_join_XuLy_KN
		@ID_NV = @ID_NV, @ID_KN = @ID_KN, @ND_XLKN = N'Đã xử lý'
	END


    UPDATE dbo.KhieuNai
	SET Ma_TTKN = @ID_TT_KN
	WHERE Ma_KN = @ID_KN
END

GO 

--(27): Tạo view khiếu nại theo đơn hàng
ALTER VIEW view_KhieuNai_DonHang
AS
	SELECT Ma_KN, NoiDungKN, NgayGui, KhieuNai.Ma_DH,Ten_NguoiNhan,
	SDT_NguoiNhan,DiaChi_NguoiNhan, GiaTri, NgayTao,
	NgayGiao,KhieuNai.Ma_KH, HoTen_KH, SDT, DiaChi_KH,
	Ma_Shipper, HoTen_Shipper, SDT_SP FROM dbo.KhieuNai  
	JOIN dbo.view_DonHang
	ON view_DonHang.Ma_DH = KhieuNai.Ma_DH
	
GO 

--(28): Kiểm tra tình trạng khiếu nại của 1đơn hàng
ALTER PROCEDURE proc_check_KN_as_DH
(@ID_DH VARCHAR(10))
AS 
BEGIN
    SELECT * FROM dbo.XuLyKN
	JOIN view_KhieuNai_DonHang
	ON dbo.XuLyKN.Ma_KN = view_KhieuNai_DonHang.Ma_KN
	WHERE view_KhieuNai_DonHang.Ma_DH = @ID_DH
END


EXECUTE proc_check_KN_as_DH @ID_DH = 'DH243'