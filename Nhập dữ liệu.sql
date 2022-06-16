USE QLDVVanChuyen
GO 
-- NHẬP DỮ LIỆU TRẠNG THÁI HOẠT ĐỘNG

INSERT TrangThaiHD(TenTTHD) VALUES(N'Đang Hoạt Động')
INSERT TrangThaiHD(TenTTHD) VALUES(N'Ngừng Hoạt Động')

GO

-- NHẬP DỮ LIỆU CHI NHÁNH
-- IMPORT TỪ FILE EXCEL 

--DONE!

GO
-- nhập dữ liệu chức vụ
INSERT ChucVu(TenCV) VALUES(N'Trưởng phòng')
INSERT ChucVu(TenCV) VALUES(N'Trưởng kho')
INSERT ChucVu(TenCV) VALUES(N'NV kho')
INSERT ChucVu(TenCV) VALUES(N'NV hành chính')
INSERT ChucVu(TenCV) VALUES(N'NV kế toán')

GO
-- nhập dữ liệu tình trạng làm việc
INSERT TinhTrangLV(TenTTLV) VALUES(N'Đang làm việc') --1
INSERT TinhTrangLV(TenTTLV) VALUES(N'Đã nghỉ việc') --2
INSERT TinhTrangLV(TenTTLV) VALUES(N'Nghỉ tạm thời') --3
INSERT TinhTrangLV(TenTTLV) VALUES(N'Đang nghỉ phép') --4




GO 
-- nhập dữ liệu nhân viên -- import excel
-- done !	
-- nhập dữ liệu khách hàng -- import excel
-- DONE ! - LỖI VỀ SỐ LƯỢNG ĐH

-- nhập dữ liệu shipper -- import excel
-- Done !




-- nhập dữ liệu trạng thái đơn hàng
INSERT TrangThaiDH(TenTTDH) VALUES(N'Đang xử lý')
INSERT TrangThaiDH(TenTTDH) VALUES(N'Đã tiếp nhận')
INSERT TrangThaiDH(TenTTDH) VALUES(N'Đang vận chuyển')
INSERT TrangThaiDH(TenTTDH) VALUES(N'Đang giao hàng')
INSERT TrangThaiDH(TenTTDH) VALUES(N'Đã nhận hàng')
INSERT TrangThaiDH(TenTTDH) VALUES(N'Chuyển hoàn')
INSERT TrangThaiDH(TenTTDH) VALUES(N'Đã hủy')



-- nhập dữ liệu loại hàng
GO
INSERT LoaiHang(TenLH) VALUES(N'Hàng thường')
INSERT LoaiHang(TenLH) VALUES(N'Hàng dễ vỡ')
INSERT LoaiHang(TenLH) VALUES(N'Hàng giá trị cao')
INSERT LoaiHang(TenLH) VALUES(N'Khác')

GO


-- NHẬP DỮ LIỆU TÌNH TRẠNG KHIẾU NẠI
INSERT dbo.TinhTrangKN
(
    NoiDungTTKN
)
VALUES
(N'Đã tiếp nhận' -- NoiDungTTKN - nvarchar(50)
    )

INSERT dbo.TinhTrangKN
(
    NoiDungTTKN
)
VALUES
(N'Đang xử lý' -- NoiDungTTKN - nvarchar(50)
    )

INSERT dbo.TinhTrangKN
(
    NoiDungTTKN
)
VALUES
(N'Đã xử lý' -- NoiDungTTKN - nvarchar(50)
    )

-- NHẬP DỮ LIỆU KHIẾU NẠI
INSERT dbo.KhieuNai
(
    NoiDungKN,
    NgayGui,
    Ma_DH,
    Ma_KH,
    Ma_TTKN
)
VALUES
(   N'Khiếu nại hỏng hàng hóa',       -- NoiDungKN - ntext
    GETDATE(), -- NgayGui - date
    'DH234',        -- Ma_DH - varchar(10)
    'KH01',        -- Ma_KH - varchar(10)
    1         -- Ma_TTKN - int
)


GO
-- nhập dữ liệu xử lý khiếu nại
INSERT dbo.XuLyKN
(
    Ma_NV,
    Ma_KN,
    NoiDung,
    ThoiGian
)
VALUES
(   'NV1245',       -- Ma_NV - varchar(10)
    6,        -- Ma_KN - int
    N'Xử lý đền bù cho khách hàng',      -- NoiDung - ntext
    GETDATE() -- ThoiGian - date
    )
