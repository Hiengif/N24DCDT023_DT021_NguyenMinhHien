# ==============================================================================
# HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG - KHOA ĐIỆN TỬ VIỄN THÔNG
# ĐỒ ÁN: CẤU TRÚC DỮ LIỆU VÀ GIẢI THUẬT (INT13185 - NHÓM 03, GV: HỒ NHỰT MINH)
# ĐỀ TÀI DT021: TÌM KIẾM NỘI SUY SO VỚI TÌM KIẾM NHỊ PHÂN
# Sinh viên: Nguyễn Minh Hiển - MSSV: N24DCDT023 - Lớp: D24CQDT01-N
# File: demo.jl (Chương trình chạy minh họa và thu thập ảnh kết quả A01-A08)
# ==============================================================================

include(joinpath(@__DIR__, "src", "DeTai.jl"))
using .DeTai
using Printf

function in_ket_qua_chi_tiet(a::Vector{Int}, x::Int; tieu_de::String="")
    println("="^72)
    if !isempty(tieu_de)
        println("  $tieu_de")
    else
        println("  DT021 - TÌM KIẾM NỘI SUY SO VỚI TÌM KIẾM NHỊ PHÂN")
    end
    println("="^72)
    println("Dữ liệu vào (Input):")
    println("  - Mảng a: ", length(a) <= 20 ? string(a) : "[$(a[1]), $(a[2]), ..., $(a[end])] (n=$(length(a)))")
    println("  - Khóa x: $x")
    println("-"^72)

    # Chạy hai thuật toán
    kq_ns = tim_noi_suy(a, x)
    kq_np = tim_nhi_phan(a, x)
    lan_vet = lan_vet_noi_suy(a, x)

    # Bảng lần vết nội suy từng bước
    println("Tiến trình lần vết Nội suy (Interpolation Search Trace):")
    if isempty(lan_vet)
        println("  (Không có bước lặp nào - dừng ngay do mảng rỗng hoặc ngoài khoảng [a[1], a[n]])")
    else
        @printf("  %-6s | %-6s | %-6s | %-10s | %-10s | %-6s | %-10s | %s\n",
                "Bước", "l", "r", "a[l]", "a[r]", "pos", "a[pos]", "Hành động / Nhận xét")
        println("  " * "-"^68)
        for b in lan_vet
            @printf("  %-6d | %-6d | %-6d | %-10d | %-10d | %-6d | %-10d | %s (%s)\n",
                    b.buoc, b.l, b.r, b.a_l, b.a_r, b.pos, b.a_pos, b.hanh_dong, b.nhan_xet)
        end
    end

    println("-"^72)
    println("BẢNG TỔNG KẾT ĐỐI CHIẾU HAI THUẬT TOÁN:")
    @printf("  %-28s | %-18s | %-18s\n", "Tiêu chí", "Nội suy (Interp)", "Nhị phân (Binary)")
    println("  " * "-"^68)
    @printf("  %-28s | %-18s | %-18s\n", "Vị trí tìm thấy (1-based)", string(kq_ns.vi_tri), string(kq_np.vi_tri))
    @printf("  %-28s | %-18s | %-18s\n", "Số lượt lặp thăm dò", "$(kq_ns.so_buoc) lượt", "$(kq_np.so_buoc) lượt")
    @printf("  %-28s | %-18s | %-18s\n", "Trạng thái", kq_ns.da_tim_thay ? "TÌM THẤY" : "KHÔNG TÌM THẤY", kq_np.da_tim_thay ? "TÌM THẤY" : "KHÔNG TÌM THẤY")
    println("  " * "-"^68)

    # Đánh giá lý thuyết
    if kq_ns.so_buoc < kq_np.so_buoc
        println("  => ĐÁNH GIÁ: Nội suy NHANH HƠN nhị phân ($(kq_ns.so_buoc) < $(kq_np.so_buoc) lượt) nhờ mảng phân bố đều!")
    elseif kq_ns.so_buoc > kq_np.so_buoc
        println("  => ĐÁNH GIÁ: Nhị phân NHANH HƠN nội suy ($(kq_np.so_buoc) < $(kq_ns.so_buoc) lượt) do mảng bị lệch giá trị!")
    else
        println("  => ĐÁNH GIÁ: Cả hai thuật toán có số lượt lặp BẰNG NHAU ($(kq_ns.so_buoc) lượt).")
    end
    println("="^72 * "\n")
end

function nhap_ban_phim()
    println("="^72)
    println("  NHẬP DỮ LIỆU TỪ BÀN PHÍM (ĐỀ TÀI DT021)")
    println("="^72)
    print("Nhập các phần tử mảng số nguyên tăng dần (cách nhau bởi dấu cách hoặc phẩy):\n> ")
    dong_a = readline()
    cac_chuoi = filter(!isempty, split(dong_a, [' ', ',']))
    if isempty(cac_chuoi)
        println("Mảng rỗng []")
        a = Int[]
    else
        a = parse.(Int, cac_chuoi)
    end

    print("Nhập khóa x cần tìm:\n> ")
    x = parse(Int, strip(readline()))

    try
        kiem_tra_dau_vao(a, x)
        in_ket_qua_chi_tiet(a, x; tieu_de="KẾT QUẢ TỰ NHẬP TỪ BÀN PHÍM")
    catch err
        println("\n(!) DỮ LIỆU KHÔNG HỢP LỆ: ", sprint(showerror, err))
    end
end

function minh_hoa_tu_choi_input_sai()
    println("="^72)
    println("  A08 / HÌNH 4.8 - MINH HỌA TỪ CHỐI DỮ LIỆU KHÔNG HỢP LỆ")
    println("="^72)
    a_sai = [30, 10, 20]
    x = 10
    println("Dữ liệu thử nghiệm: a = $a_sai (vi phạm điều kiện sắp xếp tăng); x = $x")
    println("Mong đợi: Trình validator kiem_tra_dau_vao ném ArgumentError từ chối mảng chưa sắp xếp.")
    try
        tim_noi_suy(a_sai, x)
        error("LOI: Chuong trinh da chap nhan mang chua sap xep!")
    catch loi
        if loi isa ArgumentError && occursin("Mang chua duoc sap xep", sprint(showerror, loi))
            println("✓ ĐÃ TỪ CHỐI DỮ LIỆU THÀNH CÔNG: ", sprint(showerror, loi))
            println("✓ KẾT QUẢ MINH HỌA: ĐÚNG; Lỗi dự kiến đã được bắt chính xác theo hợp đồng.")
        else
            rethrow()
        end
    end
    println("="^72 * "\n")
end

# ------------------------------------------------------------------------------
# ĐIỀU PHỐI DÒNG LỆNH (COMMAND-LINE DISPATCHER)
# ------------------------------------------------------------------------------
if "--nhap" in ARGS
    nhap_ban_phim()
elseif any(startswith("--ca="), ARGS)
    ca = only(filter(startswith("--ca="), ARGS))
    if ca == "--ca=1"
        
        # A01: Ví dụ 1 phiếu giao (Dãy đều)
        in_ket_qua_chi_tiet([10, 20, 30, 40, 50], 40; tieu_de="A01 / HÌNH 4.1 - VÍ DỤ 1 TRÊN PHIẾU GIAO (DÃY ĐỀU)")
    elseif ca == "--ca=2"
        # A02: Ví dụ 2 phiếu giao (Hai đầu bằng nhau, x ngoài khoảng)
        in_ket_qua_chi_tiet([5, 5, 5], 7; tieu_de="A02 / HÌNH 4.2 - VÍ DỤ 2 TRÊN PHIẾU GIAO (HAI ĐẦU BẰNG NHAU, NGOÀI MIỀN)")
    elseif ca == "--ca=3"
        # A03: Ca tự thiết kế 1 (Khóa trùng lặp)
        in_ket_qua_chi_tiet([5, 5, 5], 5; tieu_de="A03 / HÌNH 4.3 - CA TỰ THIẾT KẾ 1 (KHÓA TRÙNG LẶP HỢP LỆ)")
    elseif ca == "--ca=4"
        # A04: Ca tự thiết kế 2 (Dãy cực lệch)
        in_ket_qua_chi_tiet([1, 2, 3, 4, 1000000], 4; tieu_de="A04 / HÌNH 4.4 - CA TỰ THIẾT KẾ 2 (DÃY PHÂN BỐ CỰC LỆCH)")
    elseif ca == "--ca=5"
        # A05: Ca biên 1 (Mảng rỗng)
        in_ket_qua_chi_tiet(Int[], 10; tieu_de="A05 / HÌNH 4.5 - CA BIÊN 1 (MẢNG RỖNG [])")
    elseif ca == "--ca=6"
        # A06: Ca biên 2 (Mảng 1 phần tử)
        in_ket_qua_chi_tiet([42], 42; tieu_de="A06 / HÌNH 4.6 - CA BIÊN 2 (MẢNG 1 PHẦN TỬ)")
    elseif ca == "--ca=7"
        # A07: Ca biên 3 (Khóa ngoài hai đầu)
        in_ket_qua_chi_tiet([10, 20, 30], 5; tieu_de="A07 / HÌNH 4.7 - CA BIÊN 3 (KHÓA NHỎ HƠN CẬN TRÁI a[1])")
    elseif ca == "--ca=8"
        # A08: Input không hợp lệ bị từ chối
        minh_hoa_tu_choi_input_sai()
    else
        throw(ArgumentError("Tham số không hợp lệ: vui lòng chọn --ca=1 đến --ca=8"))
    end
else
    # Mặc định: Chạy Ví dụ 1 và Ví dụ 2 theo đúng phiếu giao DT021
    in_ket_qua_chi_tiet([10, 20, 30, 40, 50], 40; tieu_de="VÍ DỤ 1 TRÊN PHIẾU GIAO (DÃY ĐỀU)")
    in_ket_qua_chi_tiet([5, 5, 5], 7; tieu_de="VÍ DỤ 2 TRÊN PHIẾU GIAO (HAI ĐẦU BẰNG NHAU, NGOÀI KHOẢNG)")
end
