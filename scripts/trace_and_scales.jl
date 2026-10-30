# ==============================================================================
# HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG - KHOA ĐIỆN TỬ VIỄN THÔNG
# ĐỒ ÁN: CẤU TRÚC DỮ LIỆU VÀ GIẢI THUẬT (INT13185 - NHÓM 03, GV: HỒ NHỰT MINH)
# ĐỀ TÀI DT021: TÌM KIẾM NỘI SUY SO VỚI TÌM KIẾM NHỊ PHÂN
# Sinh viên: Nguyễn Minh Hiển - MSSV: N24DCDT023 - Lớp: D24CQDT01-N
# File: trace_and_scales.jl (Khảo sát quy mô n = 10, 100, 1000 theo Rubric C5)
# ==============================================================================

include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai
using Printf

function in_trace_chi_tiet()
    println("="^78)
    println("PHẦN 1: BẢNG LẦN VẾT CHI TIẾT CỦA CÁC CA ĐẶC TRƯNG")
    println("="^78)

    # Ca 1: Dãy đều n = 10
    a_deu = [10 * i for i in 1:10]
    x_deu = 70
    println("\n[TRACE 1] Dãy đều n=10: a = $a_deu, tìm x = $x_deu (mong đợi vị trí 7)")
    vet1 = lan_vet_noi_suy(a_deu, x_deu)
    @printf("%-6s | %-6s | %-6s | %-10s | %-10s | %-6s | %-10s | %s\n",
            "Bước", "l", "r", "a[l]", "a[r]", "pos", "a[pos]", "Nhận xét")
    println("-"^78)
    for b in vet1
        @printf("%-6d | %-6d | %-6d | %-10d | %-10d | %-6d | %-10d | %s\n",
                b.buoc, b.l, b.r, b.a_l, b.a_r, b.pos, b.a_pos, b.nhan_xet)
    end

    # Ca 2: Dãy lệch n = 5
    a_lech = [1, 2, 3, 4, 1000000]
    x_lech = 4
    println("\n[TRACE 2] Dãy lệch n=5: a = $a_lech, tìm x = $x_lech (mong đợi vị trí 4)")
    vet2 = lan_vet_noi_suy(a_lech, x_lech)
    @printf("%-6s | %-6s | %-6s | %-10s | %-10s | %-6s | %-10s | %s\n",
            "Bước", "l", "r", "a[l]", "a[r]", "pos", "a[pos]", "Nhận xét")
    println("-"^78)
    for b in vet2
        @printf("%-6d | %-6d | %-6d | %-10d | %-10d | %-6d | %-10d | %s\n",
                b.buoc, b.l, b.r, b.a_l, b.a_r, b.pos, b.a_pos, b.nhan_xet)
    end
end

function in_scales_khao_sat()
    println("\n" * "="^78)
    println("PHẦN 2: BẢNG KHẢO SÁT QUY MÔ n = 10, 100, 1000 (RUBRIC C5)")
    println("="^78)
    @printf("%-10s | %-8s | %-12s | %-15s | %-12s | %-12s | %-10s\n",
            "Phân bố", "n", "Khóa x", "Vị trí tìm", "Bước Nội suy", "Bước Nhị phân", "Bước Lai")
    println("-"^78)

    # 1. Khảo sát trên phân bố đều: a[i] = 5 * i
    for n in [10, 100, 1000]
        a = [5 * i for i in 1:n]
        # Tìm phần tử ở giữa mảng
        idx_giua = div(n, 2)
        x = a[idx_giua]
        ns = tim_noi_suy(a, x)
        np = tim_nhi_phan(a, x)
        lai = tim_kiem_lai(a, x)
        @printf("%-10s | %-8d | %-12d | %-15d | %-12d | %-12d | %-10d\n",
                "Đều (giữa)", n, x, ns.vi_tri, ns.so_buoc, np.so_buoc, lai.so_buoc)

        # Tìm phần tử ở cuối mảng
        x_cuoi = a[n]
        ns_c = tim_noi_suy(a, x_cuoi)
        np_c = tim_nhi_phan(a, x_cuoi)
        lai_c = tim_kiem_lai(a, x_cuoi)
        @printf("%-10s | %-8d | %-12d | %-15d | %-12d | %-12d | %-10d\n",
                "Đều (cuối)", n, x_cuoi, ns_c.vi_tri, ns_c.so_buoc, np_c.so_buoc, lai_c.so_buoc)
    end

    println("-"^78)

    # 2. Khảo sát trên phân bố cực lệch: a = [1, 2, ..., n-1, 10^6], tìm x = n-1
    for n in [10, 100, 1000]
        a_lech = [i for i in 1:(n - 1)]
        push!(a_lech, 1000000)
        x = n - 1
        ns = tim_noi_suy(a_lech, x)
        np = tim_nhi_phan(a_lech, x)
        lai = tim_kiem_lai(a_lech, x)
        @printf("%-10s | %-8d | %-12d | %-15d | %-12d | %-12d | %-10d\n",
                "Cực lệch", n, x, ns.vi_tri, ns.so_buoc, np.so_buoc, lai.so_buoc)
    end
    println("="^78)
    println("KẾT LUẬN THỰC NGHIỆM:")
    println("1. Trên phân bố đều: Nội suy đạt số bước xấp xỉ O(1) hoặc O(log log n) cực nhanh.")
    println("2. Trên phân bố lệch: Nội suy bị thoái hóa về gần O(n) bước (tăng tuyến tính theo n).")
    println("3. Nhị phân luôn duy trì O(log n) ổn định không phụ thuộc vào phân bố giá trị.")
    println("4. Thuật toán lai (Hybrid) tự động phát hiện suy biến và chuyển sang nhị phân,")
    println("   giúp giới hạn số bước tương đương nhị phân ngay cả trên dãy cực lệch!")
    println("="^78)
end

in_trace_chi_tiet()
in_scales_khao_sat()
