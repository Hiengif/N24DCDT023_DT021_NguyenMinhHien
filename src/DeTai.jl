# ==============================================================================
# HỌC VIỆN CÔNG NGHỆ BƯU CHÍNH VIỄN THÔNG - KHOA ĐIỆN TỬ VIỄN THÔNG
# ĐỒ ÁN: CẤU TRÚC DỮ LIỆU VÀ GIẢI THUẬT (INT13185 - NHÓM 03, GV: HỒ NHỰT MINH)
# ĐỀ TÀI DT021: TÌM KIẾM NỘI SUY SO VỚI TÌM KIẾM NHỊ PHÂN
# Sinh viên: Nguyễn Minh Hiển - MSSV: N24DCDT023 - Lớp: D24CQDT01-N
# ==============================================================================

module DeTai

using Printf

export kiem_tra_dau_vao,
       tim_noi_suy,
       tim_nhi_phan,
       lan_vet_noi_suy,
       tim_kiem_lai,
       giai_bai

"""
    kiem_tra_dau_vao(a::Vector{Int}, x::Int)

Hợp đồng dữ liệu đầu vào theo phiếu giao đề tài DT021:
- `a::Vector{Int}`: Mảng số nguyên đã sắp xếp tăng không giảm.
- Kích thước mảng: `0 <= length(a) <= 10000`.
- Giá trị mỗi phần tử: `|a[i]| <= 10^6` (tức `-10^6 <= a[i] <= 10^6`).
- `x::Int`: Khóa cần tìm.

Ném `ArgumentError` kèm thông báo rõ ràng nếu dữ liệu không thỏa mãn hợp đồng.
"""
function kiem_tra_dau_vao(a::Vector{Int}, x::Int)
    n = length(a)
    (0 <= n <= 10000) || throw(ArgumentError("Kich thuoc mang n=$n vi pham dieu kien 0 <= n <= 10000"))
    
    # Kiểm tra miền giá trị của từng phần tử
    for i in 1:n
        abs(a[i]) <= 1000000 || throw(ArgumentError("Phan tu a[$i]=$(a[i]) vuot qua gioi han |a[i]| <= 10^6"))
    end
    
    # Kiểm tra tính chất sắp xếp tăng không giảm
    for i in 1:(n - 1)
        a[i] <= a[i + 1] || throw(ArgumentError("Mang chua duoc sap xep tang: a[$i]=$(a[i]) > a[$(i+1)]=$(a[i+1])"))
    end
    
    return true
end

"""
    tim_noi_suy(a::Vector{Int}, x::Int)

Cài đặt thuật toán Tìm kiếm nội suy (Interpolation Search).
Dự đoán vị trí theo công thức:
    pos = l + floor(Int, ((x - a[l]) / (a[r] - a[l])) * (r - l))

Trả về một NamedTuple:
    (; vi_tri, so_buoc, da_tim_thay)
- `vi_tri`: Chỉ số 1-based tìm thấy (hoặc 0 nếu không tìm thấy).
- `so_buoc`: Số lượt lặp đã thực hiện.
- `da_tim_thay`: `true` nếu tìm thấy, `false` nếu không.
"""
function tim_noi_suy(a::Vector{Int}, x::Int)
    kiem_tra_dau_vao(a, x)
    n = length(a)
    n == 0 && return (; vi_tri=0, so_buoc=0, da_tim_thay=false)

    l = 1
    r = n
    buoc = 0

    # Bất biến: Khóa x nếu có trong mảng thì luôn nằm trong đoạn [l, r], tức a[l] <= x <= a[r].
    # Điều kiện dừng: l > r hoặc x nằm ngoài khoảng [a[l], a[r]].
    while l <= r && x >= a[l] && x <= a[r]
        buoc += 1

        # Xử lý trường hợp biên quan trọng: hai đầu bằng nhau (tránh chia cho 0)
        if a[l] == a[r]
            if a[l] == x
                return (; vi_tri=l, so_buoc=buoc, da_tim_thay=true)
            else
                return (; vi_tri=0, so_buoc=buoc, da_tim_thay=false)
            end
        end

        # Áp dụng công thức nội suy dự đoán vị trí (1-based index):
        phan_so = (x - a[l]) / (a[r] - a[l])
        pos = l + floor(Int, phan_so * (r - l))

        # Do a[l] <= x <= a[r] nên 0 <= phan_so <= 1 => l <= pos <= r
        @assert l <= pos <= r "Bat bien vi tri: pos phai nam trong doan [l, r]"

        if a[pos] == x
            return (; vi_tri=pos, so_buoc=buoc, da_tim_thay=true)
        elseif a[pos] < x
            l = pos + 1
        else
            r = pos - 1
        end
    end

    return (; vi_tri=0, so_buoc=buoc, da_tim_thay=false)
end

"""
    tim_nhi_phan(a::Vector{Int}, x::Int)

Cài đặt thuật toán Tìm kiếm nhị phân (Binary Search) để đối chiếu so sánh.
Chia đôi đoạn xét theo công thức:
    mid = div(l + r, 2)

Trả về NamedTuple:
    (; vi_tri, so_buoc, da_tim_thay)
"""
function tim_nhi_phan(a::Vector{Int}, x::Int)
    kiem_tra_dau_vao(a, x)
    n = length(a)
    n == 0 && return (; vi_tri=0, so_buoc=0, da_tim_thay=false)

    l = 1
    r = n
    buoc = 0

    while l <= r
        buoc += 1
        mid = div(l + r, 2)

        if a[mid] == x
            return (; vi_tri=mid, so_buoc=buoc, da_tim_thay=true)
        elseif a[mid] < x
            l = mid + 1
        else
            r = mid - 1
        end
    end

    return (; vi_tri=0, so_buoc=buoc, da_tim_thay=false)
end

"""
    lan_vet_noi_suy(a::Vector{Int}, x::Int)

Ghi nhận toàn bộ tiến trình lần vết các biến l, r, a[l], a[r], pos, a[pos] qua từng bước.
Trả về danh sách các NamedTuple phục vụ lập bảng theo dõi trong báo cáo.
"""
function lan_vet_noi_suy(a::Vector{Int}, x::Int)
    kiem_tra_dau_vao(a, x)
    n = length(a)
    n == 0 && return NamedTuple[]

    l = 1
    r = n
    buoc = 0
    cac_buoc = NamedTuple[]

    while l <= r && x >= a[l] && x <= a[r]
        buoc += 1

        if a[l] == a[r]
            nhan_xet = a[l] == x ? "Hai dau bang nhau, tim thay x tai l=$l" : "Hai dau bang nhau, x khong co trong mang"
            push!(cac_buoc, (; buoc, l, r, a_l=a[l], a_r=a[r], pos=l, a_pos=a[l], hanh_dong="DUNG", nhan_xet))
            break
        end

        phan_so = (x - a[l]) / (a[r] - a[l])
        pos = l + floor(Int, phan_so * (r - l))

        if a[pos] == x
            push!(cac_buoc, (; buoc, l, r, a_l=a[l], a_r=a[r], pos, a_pos=a[pos], hanh_dong="TIM_THAY", nhan_xet="a[pos] == x"))
            break
        elseif a[pos] < x
            push!(cac_buoc, (; buoc, l, r, a_l=a[l], a_r=a[r], pos, a_pos=a[pos], hanh_dong="SANG_PHAI", nhan_xet="a[pos] < x => l = pos + 1 = $(pos+1)"))
            l = pos + 1
        else
            push!(cac_buoc, (; buoc, l, r, a_l=a[l], a_r=a[r], pos, a_pos=a[pos], hanh_dong="SANG_TRAI", nhan_xet="a[pos] > x => r = pos - 1 = $(pos-1)"))
            r = pos - 1
        end
    end

    return cac_buoc
end

"""
    tim_kiem_lai(a::Vector{Int}, x::Int; nguong_co_doan=4)

Thuật toán Tìm kiếm lai (Hybrid Search - Yêu cầu nâng cao cộng điểm Rubric C6):
Khởi đầu bằng công thức nội suy để tận dụng tốc độ O(log log n) trên đoạn phân bố đều.
Nếu đoạn xét không thu hẹp đủ nhanh (đoạn mới dài hơn 1 - 1/nguong_co_doan đoạn cũ),
thuật toán tự động chuyển sang phép chia đôi nhị phân để đảm bảo cận trên O(log n).
"""
function tim_kiem_lai(a::Vector{Int}, x::Int; nguong_co_doan=4)
    kiem_tra_dau_vao(a, x)
    n = length(a)
    n == 0 && return (; vi_tri=0, so_buoc=0, da_tim_thay=false, so_lan_chuyen_nhi_phan=0)

    l = 1
    r = n
    buoc = 0
    so_lan_chuyen = 0

    while l <= r && x >= a[l] && x <= a[r]
        buoc += 1

        if a[l] == a[r]
            return (; vi_tri=(a[l] == x ? l : 0), so_buoc=buoc, da_tim_thay=(a[l] == x), so_lan_chuyen_nhi_phan=so_lan_chuyen)
        end

        do_dai_cu = r - l + 1
        phan_so = (x - a[l]) / (a[r] - a[l])
        pos = l + floor(Int, phan_so * (r - l))

        if a[pos] == x
            return (; vi_tri=pos, so_buoc=buoc, da_tim_thay=true, so_lan_chuyen_nhi_phan=so_lan_chuyen)
        elseif a[pos] < x
            do_dai_moi = r - (pos + 1) + 1
            # Nếu co đoạn quá chậm (do_dai_moi > do_dai_cu - do_dai_cu/nguong_co_doan), chuyển sang nhị phân
            if do_dai_moi > do_dai_cu - max(1, div(do_dai_cu, nguong_co_doan))
                so_lan_chuyen += 1
                pos = div(l + r, 2)
                if a[pos] == x
                    return (; vi_tri=pos, so_buoc=buoc, da_tim_thay=true, so_lan_chuyen_nhi_phan=so_lan_chuyen)
                elseif a[pos] < x
                    l = pos + 1
                else
                    r = pos - 1
                end
            else
                l = pos + 1
            end
        else
            do_dai_moi = (pos - 1) - l + 1
            if do_dai_moi > do_dai_cu - max(1, div(do_dai_cu, nguong_co_doan))
                so_lan_chuyen += 1
                pos = div(l + r, 2)
                if a[pos] == x
                    return (; vi_tri=pos, so_buoc=buoc, da_tim_thay=true, so_lan_chuyen_nhi_phan=so_lan_chuyen)
                elseif a[pos] < x
                    l = pos + 1
                else
                    r = pos - 1
                end
            else
                r = pos - 1
            end
        end
    end

    return (; vi_tri=0, so_buoc=buoc, da_tim_thay=false, so_lan_chuyen_nhi_phan=so_lan_chuyen)
end

"""
    giai_bai(du_lieu)

Hàm thực thi chuẩn theo giao diện khung đề tài:
Nhận đầu vào là một Tuple hoặc NamedTuple `(a, x)`:
- Kiểm tra hợp đồng đầu vào
- Chạy cả tìm kiếm nội suy và tìm kiếm nhị phân
- Thu thập lần vết
- Trả về cấu trúc tổng hợp kết quả
"""
function giai_bai(du_lieu)
    du_lieu === nothing && throw(ArgumentError("Du lieu dau vao khong duoc la nothing"))
    a, x = if du_lieu isa Tuple
        du_lieu[1], du_lieu[2]
    elseif hasproperty(du_lieu, :a) && hasproperty(du_lieu, :x)
        du_lieu.a, du_lieu.x
    else
        throw(ArgumentError("Du lieu phai la Tuple (a, x) hoac NamedTuple (; a, x)"))
    end

    kiem_tra_dau_vao(a, x)
    kq_ns = tim_noi_suy(a, x)
    kq_np = tim_nhi_phan(a, x)
    cac_buoc_ns = lan_vet_noi_suy(a, x)
    kq_lai = tim_kiem_lai(a, x)

    # Kiểm tra tính nhất quán giữa 2 phương pháp
    if kq_ns.da_tim_thay
        @assert kq_np.da_tim_thay "Bat bien: Noi suy tim thay thi Nhi phan cung phai tim thay"
        @assert a[kq_ns.vi_tri] == x "Gia tri tai vi tri noi suy phai bang x"
        @assert a[kq_np.vi_tri] == x "Gia tri tai vi tri nhi phan phai bang x"
    else
        @assert !kq_np.da_tim_thay "Bat bien: Noi suy khong tim thay thi Nhi phan cung khong tim thay"
        @assert kq_ns.vi_tri == 0
        @assert kq_np.vi_tri == 0
    end

    return (;
        a,
        x,
        noi_suy=kq_ns,
        nhi_phan=kq_np,
        lai=kq_lai,
        lan_vet=cac_buoc_ns,
        hop_le=true
    )
end

end # module DeTai
