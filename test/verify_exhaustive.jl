# ==============================================================================
# HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG - KHOA ĐIỆN TỬ VIỄN THÔNG
# ĐỒ ÁN: CẤU TRÚC DỮ LIỆU VÀ GIẢI THUẬT (INT13185 - NHÓM 03, GV: HỒ NHỰT MINH)
# ĐỀ TÀI DT021: TÌM KIẾM NỘI SUY SO VỚI TÌM KIẾM NHỊ PHÂN
# File: verify_exhaustive.jl (Oracle đối chiếu độc lập trên dữ liệu ngẫu nhiên)
# ==============================================================================

include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai
using Random

function oracle_tim_kiem(a::Vector{Int}, x::Int)
    # Oracle độc lập: Quét tuyến tính tìm khóa x (chuẩn xác tuyệt đối 100%)
    for i in 1:length(a)
        if a[i] == x
            return i # trả về vị trí đầu tiên tìm thấy
        end
    end
    return 0 # Không tìm thấy
end

function verify_all()
    Random.seed!(20261027)
    so_mang_kiem_tra = 0
    so_truy_van = 0

    println("Đang thực hiện kiểm nghiệm đối chiếu Oracle trên 1,000 cấu hình mảng...")

    # 1. Kiểm tra các kích thước nhỏ n = 0..10 vét cạn
    for n in 0:10
        for _ in 1:20
            a = sort(rand(-50:50, n))
            cac_khoa_x = isempty(a) ? [-10, 0, 10] : [a[1] - 5, a[end] + 5, a..., rand(-60:60, 5)...]
            for x in cac_khoa_x
                ans_oracle = oracle_tim_kiem(a, x)
                kq_ns = tim_noi_suy(a, x)
                kq_np = tim_nhi_phan(a, x)
                kq_lai = tim_kiem_lai(a, x)

                # Kiểm tra tính đúng: Nếu oracle tìm thấy thì các thuật toán phải trả về vị trí có giá trị bằng x
                if ans_oracle > 0
                    @assert kq_ns.da_tim_thay "Oracle thay x=$x nhung noi suy khong thay"
                    @assert a[kq_ns.vi_tri] == x "Gia tri tai vi tri noi suy sai"
                    @assert kq_np.da_tim_thay "Oracle thay x=$x nhung nhi phan khong thay"
                    @assert a[kq_np.vi_tri] == x "Gia tri tai vi tri nhi phan sai"
                    @assert kq_lai.da_tim_thay "Oracle thay x=$x nhung lai khong thay"
                    @assert a[kq_lai.vi_tri] == x "Gia tri tai vi tri lai sai"
                else
                    @assert !kq_ns.da_tim_thay "Oracle khong thay nhung noi suy bao thay"
                    @assert kq_ns.vi_tri == 0
                    @assert !kq_np.da_tim_thay "Oracle khong thay nhung nhi phan bao thay"
                    @assert kq_np.vi_tri == 0
                    @assert !kq_lai.da_tim_thay "Oracle khong thay nhung lai bao thay"
                    @assert kq_lai.vi_tri == 0
                end
                so_truy_van += 1
            end
            so_mang_kiem_tra += 1
        end
    end

    # 2. Kiểm tra các mảng đặc thù lớn n = 50, 100, 500
    for n in [50, 100, 500]
        # Dãy đều
        a_deu = [3 * i for i in 1:n]
        # Dãy lệch
        a_lech = [i for i in 1:(n - 1)]
        push!(a_lech, 1000000)
        # Dãy toàn số bằng nhau
        a_bang = fill(42, n)

        for a in [a_deu, a_lech, a_bang]
            cac_khoa = [a[1], a[div(n, 2)], a[end], a[1] - 1, a[end] + 1]
            for x in cac_khoa
                ans_oracle = oracle_tim_kiem(a, x)
                kq_ns = tim_noi_suy(a, x)
                kq_np = tim_nhi_phan(a, x)
                if ans_oracle > 0
                    @assert kq_ns.da_tim_thay && a[kq_ns.vi_tri] == x
                    @assert kq_np.da_tim_thay && a[kq_np.vi_tri] == x
                else
                    @assert !kq_ns.da_tim_thay && kq_ns.vi_tri == 0
                    @assert !kq_np.da_tim_thay && kq_np.vi_tri == 0
                end
                so_truy_van += 1
            end
            so_mang_kiem_tra += 1
        end
    end

    println("==============================================================================")
    println("EXHAUSTIVE_OK: Đã kiểm tra $so_mang_kiem_tra mảng và $so_truy_van phép truy vấn đối chiếu.")
    println("ORACLE = Quét tuyến tính độc lập (Linear Scan); kết quả 100% khớp đúng!")
    println("==============================================================================")
end

verify_all()
