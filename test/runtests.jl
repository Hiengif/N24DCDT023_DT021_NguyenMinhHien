using Test
include(joinpath(@__DIR__, "..", "src", "DeTai.jl"))
using .DeTai

@testset "DT021 - 12 ca chuc nang" begin
    # T01: Vi du 1 tren phieu giao - Day deu, tim thay ngay buoc 1
    kq1 = tim_noi_suy([10, 20, 30, 40, 50], 40)
    @test kq1.vi_tri == 4
    @test kq1.so_buoc == 1
    @test kq1.da_tim_thay == true
    kq1_np = tim_nhi_phan([10, 20, 30, 40, 50], 40)
    @test kq1_np.vi_tri == 4
    @test kq1_np.so_buoc == 2

    # T02: Vi du 2 tren phieu giao - Hai dau bang nhau, khoa ngoai mien [a[l], a[r]]
    kq2 = tim_noi_suy([5, 5, 5], 7)
    @test kq2.vi_tri == 0
    @test kq2.da_tim_thay == false
    @test kq2.so_buoc == 0  # Ngoai khoang nen dung ngay, tranh loi chia cho 0

    # T03: Day deu lon n=10, tim thay khoa tai phan tu dau tien a[1]
    a_deu10 = collect(10:10:100)
    kq3 = tim_noi_suy(a_deu10, 10)
    @test kq3.vi_tri == 1
    @test kq3.so_buoc == 1
    @test kq3.da_tim_thay == true

    # T04: Day deu lon n=10, tim thay khoa tai phan tu cuoi cung a[n]
    kq4 = tim_noi_suy(a_deu10, 100)
    @test kq4.vi_tri == 10
    @test kq4.so_buoc == 1
    @test kq4.da_tim_thay == true

    # T05: Mang co hai dau bang nhau va khoa trung x = a[l] = a[r]
    kq5 = tim_noi_suy([5, 5, 5], 5)
    @test 1 <= kq5.vi_tri <= 3
    @test kq5.da_tim_thay == true
    @test [5, 5, 5][kq5.vi_tri] == 5

    # T06: Mang co cum gia tri trung lap o giua
    a_trung = [2, 4, 4, 4, 4, 9]
    kq6 = tim_noi_suy(a_trung, 4)
    @test 2 <= kq6.vi_tri <= 5
    @test a_trung[kq6.vi_tri] == 4
    @test kq6.da_tim_thay == true

    # T07: Mang phan bo cuc lech [1, 2, 3, 4, 1000000]
    a_lech = [1, 2, 3, 4, 1000000]
    kq7 = tim_noi_suy(a_lech, 4)
    @test kq7.vi_tri == 4
    @test kq7.da_tim_thay == true
    # So sanh voi nhi phan: tren day lech, nhi phan tim nhanh hon hoac bang
    kq7_np = tim_nhi_phan(a_lech, 4)
    @test kq7_np.vi_tri == 4
    @test kq7_np.so_buoc <= kq7.so_buoc

    # T08: Mang cap so nhan (ham mu)
    a_mu = [1, 2, 4, 8, 16, 32, 64, 128]
    kq8 = tim_noi_suy(a_mu, 32)
    @test kq8.vi_tri == 6
    @test kq8.da_tim_thay == true
    @test a_mu[kq8.vi_tri] == 32

    # T09: Ca bien - Mang rong []
    kq9 = tim_noi_suy(Int[], 10)
    @test kq9.vi_tri == 0
    @test kq9.so_buoc == 0
    @test kq9.da_tim_thay == false

    # T10: Ca bien - Mang 1 phan tu duy nhat
    kq10_a = tim_noi_suy([-5], -5)
    @test kq10_a.vi_tri == 1
    @test kq10_a.da_tim_thay == true
    kq10_b = tim_noi_suy([-5], 0)
    @test kq10_b.vi_tri == 0
    @test kq10_b.da_tim_thay == false

    # T11: Khoa nam ngoai khoang hai dau (be hon can trai va lon hon can phai)
    kq11_trai = tim_noi_suy([10, 20, 30], 5)
    @test kq11_trai.vi_tri == 0
    @test kq11_trai.so_buoc == 0
    kq11_phai = tim_noi_suy([10, 20, 30], 35)
    @test kq11_phai.vi_tri == 0
    @test kq11_phai.so_buoc == 0

    # T12: Mang lon n = 1000 phan bo deu, tim phan tu o giua
    a_1000 = [2 * i for i in 1:1000]
    kq12 = tim_noi_suy(a_1000, 1400)
    @test kq12.vi_tri == 700
    @test kq12.so_buoc == 1  # Tren day deu, noi suy chi mat 1 buoc du doan
    @test kq12.da_tim_thay == true
end

@testset "Du lieu vao va Validator" begin
    # V01: Tu choi mang chua sap xep tang dan
    @test_throws ArgumentError kiem_tra_dau_vao([30, 10, 20], 20)
    @test_throws ArgumentError tim_noi_suy([5, 4, 3, 2, 1], 3)
    @test_throws ArgumentError tim_nhi_phan([2, 1], 1)

    # V02: Tu choi phan tu vuot qua gioi han |a[i]| <= 10^6
    @test_throws ArgumentError kiem_tra_dau_vao([1, 2, 1000001], 2)
    @test_throws ArgumentError kiem_tra_dau_vao([-1000001, 0, 10], 0)

    # V03: Tu choi mang vuot qua kich thuoc n > 10000
    mang_qua_tai = zeros(Int, 10001)
    @test_throws ArgumentError kiem_tra_dau_vao(mang_qua_tai, 0)

    # V04: Mang hop le voi gia tri am
    @test kiem_tra_dau_vao([-50, -20, 0, 10], -20) == true
    kq_am = tim_noi_suy([-50, -20, 0, 10], -20)
    @test kq_am.vi_tri == 2
    @test kq_am.da_tim_thay == true

    # V05: Ham giai_bai tu choi input sai dinh dang
    @test_throws ArgumentError giai_bai(nothing)
    @test_throws ArgumentError giai_bai("sai_kieu")
end

@testset "Thuat toan lai Hybrid va Lan vet" begin
    # H01: Kiem tra lan_vet_noi_suy tren Vi du 1
    vet1 = lan_vet_noi_suy([10, 20, 30, 40, 50], 40)
    @test length(vet1) == 1
    @test vet1[1].buoc == 1
    @test vet1[1].l == 1
    @test vet1[1].r == 5
    @test vet1[1].pos == 4
    @test vet1[1].hanh_dong == "TIM_THAY"

    # H02: Kiem tra lan_vet tren ca khong co trong mang
    vet2 = lan_vet_noi_suy([10, 20, 30, 40, 50], 25)
    @test length(vet2) >= 1
    @test vet2[1].pos == 2  # 1 + floor((15/40)*4) = 1 + 1 = 2
    @test vet2[1].hanh_dong == "SANG_PHAI"

    # H03: Kiem tra Thuat toan lai (Hybrid Search) tren day lech
    a_lech = [1, 2, 3, 4, 1000000]
    kq_lai = tim_kiem_lai(a_lech, 4)
    @test kq_lai.vi_tri == 4
    @test kq_lai.da_tim_thay == true
    @test kq_lai.so_buoc <= 4

    # H04: Kiem tra ham giai_bai dong goi toan dien
    kq_tong = giai_bai(([10, 20, 30, 40, 50], 40))
    @test kq_tong.hop_le == true
    @test kq_tong.noi_suy.vi_tri == 4
    @test kq_tong.nhi_phan.vi_tri == 4
    @test length(kq_tong.lan_vet) == 1
end

println("\n========================================================")
println("✓ DA QUA TOAN BO 12 CA CHUC NANG VA CAC CA KIEM TRA VALIDATOR.")
println("========================================================")
