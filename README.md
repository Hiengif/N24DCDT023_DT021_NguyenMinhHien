<<<<<<< HEAD
# DT021 — TÌM KIẾM NỘI SUY SO VỚI TÌM KIẾM NHỊ PHÂN

Học viện Công nghệ Bưu chính Viễn thông — Cơ sở tại TP. Hồ Chí Minh  
Môn học: Cấu trúc dữ liệu và giải thuật (INT13185 — Nhóm 03)  
Giảng viên hướng dẫn: ThS. Hồ Nhựt Minh  

## Thông tin sinh viên và đề tài

- **Họ và tên**: Nguyễn Minh Hiển
- **MSSV**: N24DCDT023
- **Lớp**: D24CQDT01-N
- **Mã đề tài**: DT021
- **Tên đề tài**: Tìm kiếm nội suy so với tìm kiếm nhị phân
- **Tài liệu giáo trình**: *Giáo trình Cấu trúc dữ liệu và Giải thuật* (INT1306)
  - Chương 2, Mục 2.6.3 (Tìm kiếm nội suy); Bảng 2.10; Bài 2.4 trong thân chương.
  - Trang in: 52–54; Trang PDF: 64–66.
- **Ngôn ngữ lập trình**: Julia 1.12.7 (hoặc mới hơn).

---

## Hợp đồng dữ liệu đầu vào và đầu ra

### 1. Dữ liệu vào (Input)
- `a::Vector{Int}`: Mảng số nguyên đã sắp xếp tăng không giảm.
- Kích thước mảng: $0 \le n \le 10000$.
- Miền giá trị từng phần tử: $|a[i]| \le 10^6$ (tức $-10^6 \le a[i] \le 10^6$).
- `x::Int`: Khóa nguyên cần tìm.
- Nhập từ bàn phím hoặc truyền trực tiếp các giá trị/mảng đã khai báo trong mã nguồn.

### 2. Dữ liệu ra (Output)
- Vị trí tìm thấy (chỉ số 1-based theo quy ước Julia) hoặc trả về `0` nếu không tìm thấy.
- Nếu có khóa trùng lặp, trả về một vị trí hợp lệ bất kỳ.
- Số bước lặp thăm dò của cả hai phương pháp (Nội suy và Nhị phân).
- Bảng lần vết trạng thái các biến $l, r, a[l], a[r], pos, a[pos]$ qua từng lượt lặp nội suy.

### 3. Điều kiện biên & Bất biến tính đúng
- **Bất biến**: Khóa $x$, nếu tồn tại trong mảng, luôn nằm trong đoạn $[l, r]$, thỏa mãn $a[l] \le x \le a[r]$.
- **Xử lý trước chia**: Công thức nội suy:
  $$\text{pos} = l + \left\lfloor \frac{x - a[l]}{a[r] - a[l]} \times (r - l) \right\rfloor$$
  Khi $a[l] == a[r]$, kiểm tra ngay $a[l] == x$ để trả về vị trí hoặc kết luận không có, tuyệt đối không áp dụng công thức để tránh chia cho 0.
- **Dừng sớm khi ngoài khoảng**: Nếu $x < a[l]$ hoặc $x > a[r]$, dừng ngay lập tức và trả về 0.

---

## Cấu trúc thư mục mã nguồn

```text
Khung_ma_nguon_ca_nhan/
├── .gitignore
├── README.md                           # Tài liệu hướng dẫn và báo cáo kỹ thuật
├── demo.jl                             # Chương trình chạy 2 ví dụ và 8 ca minh họa A01-A08
├── src/
│   └── DeTai.jl                        # Module chứa toàn bộ thuật toán và hàm validator
├── test/
│   ├── runtests.jl                     # Bộ kiểm thử 12 ca chức năng + validator (68 assertions)
│   └── verify_exhaustive.jl            # Oracle đối chiếu kiểm nghiệm vét cạn độc lập
├── scripts/
│   └── trace_and_scales.jl             # Khảo sát quy mô n = 10, 100, 1000 theo Rubric C5
└── docs/
    └── anh_ket_qua/                    # Thư mục lưu 11 ảnh minh chứng A01-A11
```

---

## Hướng dẫn thực thi

Mở terminal tại thư mục mã nguồn và chạy các lệnh sau:

### 1. Kiểm tra môi trường
```powershell
julia --version
```

### 2. Chạy chương trình chính (Demo)
```powershell
# Chạy hai ví dụ chuẩn trên phiếu giao đề tài
julia --startup-file=no demo.jl

# Chạy từng ca minh họa theo kế hoạch ảnh chụp A01-A08
julia --startup-file=no demo.jl --ca=1   # A01 / Hình 4.1: Ví dụ 1 phiếu giao (Dãy đều)
julia --startup-file=no demo.jl --ca=2   # A02 / Hình 4.2: Ví dụ 2 phiếu giao (Hai đầu bằng nhau)
julia --startup-file=no demo.jl --ca=3   # A03 / Hình 4.3: Ca tự thiết kế 1 (Khóa trùng lặp)
julia --startup-file=no demo.jl --ca=4   # A04 / Hình 4.4: Ca tự thiết kế 2 (Dãy cực lệch)
julia --startup-file=no demo.jl --ca=5   # A05 / Hình 4.5: Ca biên 1 (Mảng rỗng [])
julia --startup-file=no demo.jl --ca=6   # A06 / Hình 4.6: Ca biên 2 (Mảng 1 phần tử)
julia --startup-file=no demo.jl --ca=7   # A07 / Hình 4.7: Ca biên 3 (Khóa ngoài khoảng hai đầu)
julia --startup-file=no demo.jl --ca=8   # A08 / Hình 4.8: Từ chối dữ liệu đầu vào không hợp lệ

# Chế độ tự nhập mảng và khóa từ bàn phím
julia --startup-file=no demo.jl --nhap
```

### 3. Chạy bộ kiểm thử tự động (Unit Tests)
```powershell
julia --startup-file=no test/runtests.jl
```
*Kết quả thực tế*: **12/12 ca chức năng ĐẠT**, toàn bộ ca Validator và Hybrid ĐẠT (Tổng cộng 68/68 phép kiểm tra Pass 100%).

### 4. Chạy đối chiếu mô hình độc lập (Oracle Exhaustive Test)
```powershell
julia --startup-file=no test/verify_exhaustive.jl
```
*Kết quả thực tế*: `EXHAUSTIVE_OK` trên 229 mảng và 2.605 lượt truy vấn độc lập.

### 5. Khảo sát số bước trên 3 quy mô (n = 10, 100, 1000)
```powershell
julia --startup-file=no scripts/trace_and_scales.jl
```

---

## Tóm tắt kết quả khảo sát thực nghiệm

| Phân bố mảng | Quy mô $n$ | Khóa cần tìm $x$ | Vị trí | Số bước Nội suy | Số bước Nhị phân | Số bước Lai (Hybrid) |
|---|---|---|---|---|---|---|
| **Đều** (giữa) | $10$ | $25$ | $5$ | **1** | $1$ | $1$ |
| **Đều** (cuối) | $10$ | $50$ | $10$ | **1** | $4$ | $1$ |
| **Đều** (giữa) | $100$ | $250$ | $50$ | **1** | $1$ | $1$ |
| **Đều** (cuối) | $100$ | $500$ | $100$ | **1** | $7$ | $1$ |
| **Đều** (giữa) | $1000$ | $2500$ | $500$ | **1** | $1$ | $1$ |
| **Đều** (cuối) | $1000$ | $5000$ | $1000$ | **1** | $10$ | $1$ |
| **Cực lệch** | $10$ | $9$ | $9$ | $9$ | **3** | $5$ |
| **Cực lệch** | $100$ | $99$ | $99$ | $99$ | **6** | $9$ |
| **Cực lệch** | $1000$ | $999$ | $999$ | $999$ | **9** | $13$ |

**Nhận xét lý thuyết & thực nghiệm**:
1. Trên phân bố đều: Thuật toán nội suy đạt hiệu năng vượt trội $O(1)$ hoặc $O(\log \log n)$, nhanh hơn đáng kể so với nhị phân $O(\log n)$.
2. Trên phân bố cực lệch: Thuật toán nội suy bị suy biến về $O(n)$ bước do mỗi lượt chỉ co đoạn được 1 phần tử.
3. Thuật toán lai (Hybrid Search - Rubric C6) tự động phát hiện tình trạng co đoạn chậm để chuyển sang chia đôi nhị phân, đảm bảo cận trên không vượt quá $O(\log n)$.

