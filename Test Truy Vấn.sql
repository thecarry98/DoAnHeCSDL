USE QLDVVanChuyen
GO	

-- tìm kiếm ds chi nhánh đang HĐ hoặc ngừng HĐ
EXECUTE dbo.active_or_notActive_ChiNhanh -- int

-- đếm số chi nhánh ( tổng, đang hđ, đã đóng cửa)
EXECUTE count_ChiNhanh

-- -- danh sách chi nhánh, địa chỉ, số lượng nv đang làm việc và tạm nghỉ
EXECUTE proc_infor_ChiNhanh

-- cho 1 chi nhánh ngừng hđ, mọi nv, shipper từ 1 -> 3
EXECUTE stop_ChiNhanh @id = 'CN06'	
EXECUTE proc_infor_ChiNhanh


-- mở cửa lại chi nhánh, mọi nhân viên,shipper từ tt 3 -> 1
EXECUTE active_again_ChiNhanh @id = 'CN06'
EXECUTE proc_infor_ChiNhanh


---------------------------NHÂN VIÊN

-- -- ds nhân viên đang làm việc, đã nghỉ việc, tạm nghỉ tại chi nhánh bất kỳ
EXECUTE dbo.proc_list_active_orNOT_NhanVien @idCN = 'CN06', -- varchar(10)
                                            @idTTLV = 1 -- int

-- thay đổi trạng thái của từng nhân viên ( mã nv, trạng thái )
EXECUTE proc_change_status_NhanVien @ID = 'NV2537', @IDTTNV = 4

-- điều chuyển công tác cho nhân viên: nhân viên nào đến chi nhánh nào
EXECUTE dbo.proc_transfer_NhanVien @idNV = 'NV1346', -- varchar(10)
                                   @idCN = 'CN01'  -- varchar(5)

EXECUTE dbo.proc_DonHang_view_KhachHang

--(16) Tra cứu thông tin đơn hàng theo SĐT
EXECUTE proc_search_DH_from_view_DonHang_by_SDTKH @SDT = '0978564575'

--(14): tạo view đơn hàng
SELECT * FROM view_DonHang

--(15) tra cứu tình trạng đơn hàng theo mã ĐH
EXECUTE proc_search_TTDH_from_view_DonHang @ID_DH = 'DH234'

--(16) Tra cứu thông tin đơn hàng theo SĐT
EXECUTE proc_search_DH_from_view_DonHang_by_SDTKH @SDT = '0978564575'

--(17): update TTDH cho đơn hàng
EXECUTE proc_update_TTDH_for_DonHang @ID_DH = 'DH243', @TTDH = 2, @ID_NV = 'NV6542'

--(18): update Ngày giao cho đơn hàng
EXECUTE proc_update_Day_for_DonHang @ID_DH = 'DH235', @ID_NV = 'NV6542'

--(19): update Shipper cho đơn hàng
EXECUTE proc_update_Shipper_for_DonHang @ID_DH = 'DH240', @ID_SP = 'SP6', @ID_NV = 'NV1346'


--(21): sửa đổi thông tin đơn hàng
EXECUTE proc_fix_infor_DonHang @Ten_NgNhan = N'Dương Việt Anh', @SDT_NgNhan = '0982323904', 
@DiaChi = 'Hà Nội' , @GiaTri = 199000 , @ThanhToan = N'Banking ', @ID_DH = 'DH241', @ID_NV = 'NV6542'

--(22): Truy vấn đơn hàng theo tháng ( view khách hàng, tính theo ngày tạo )
EXECUTE proc_view_DonHang_as_Month @ID_KH = 'KH10', @Year = 2021, @Month = 9


-- Báo cáo 1 ( theo tháng ): Báo cáo tổng số đơn hàng đã tiếp nhận, tổng đã giao thành công, 
-- tổng giá trị hàng hóa, tổng phí ship ( tính trên đơn hàng đã hoàn thành )
EXECUTE proc_report_DoanhThu_DonHang @Year = 2021, @Month = 10


--(23) Truy vấn khách hàng, tổng số đơn hàng, tổng đã giao ( theo tháng)
EXECUTE	 proc_top_KhachHang_as_Month @Year = 2021, @Month = 1, @top = 5

--(24): Khi KH gửi đơn khiếu nại
EXECUTE proc_send_KhieuNai
 @ID_DH = 'DH243', @ND_KN = N'Shipper làm hỏng hàng, yêu cầu bồi thường'

 --(25): Khi nhân viên tham gia xử lý khiếu nại
EXECUTE proc_join_XuLy_KN
 @ID_NV = 'NV7672', @ID_KN = 3 , @ND_XLKN = N'Khách hàng đồng ý bồi thường' 

 --(26): Đổi trạng thái khiếu nại: 

	EXECUTE proc_change_TT_KN 
	@ID_NV = 'NV7672', @ID_KN = 3 , @ID_TT_KN = 3

	-- thử cho nv khách tham gia
		EXECUTE proc_change_TT_KN 
	@ID_NV = 'NV3829', @ID_KN = 2 , @ID_TT_KN = 3


--(27): Tạo view khiếu nại theo đơn hàng
SELECT * FROM view_KhieuNai_DonHang

--(28): Kiểm tra tình trạng khiếu nại của 1đơn hàng
EXECUTE proc_check_KN_as_DH @ID_DH = 'DH243'


INSERT dbo.NhanVien
(
    Ma_NV,
    TenNV,
    DiaChi,
    SDT,
    CCCD,
    Ngay_LV,
    Ma_CN,
    Ma_CV,
    Ma_TTLV
)
VALUES
(   'NN2333',        -- Ma_NV - varchar(10)
    N'ádffsdfds',       -- TenNV - nvarchar(30)
    N'sdfd',       -- DiaChi - nvarchar(50)
    '98756576',        -- SDT - varchar(10)
    '87565778',        -- CCCD - varchar(12)
    GETDATE(), -- Ngay_LV - date
    'CN01',        -- Ma_CN - varchar(5)
    1,         -- Ma_CV - int
    1          -- Ma_TTLV - int
    )