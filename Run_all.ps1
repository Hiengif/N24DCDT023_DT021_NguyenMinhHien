# Kich ban chay toan bo quy trinh kiem thu va thuc nghiem de tai DT021
$ErrorActionPreference = "Stop"

Write-Host "======================================================================" -ForegroundColor Cyan
Write-Host "  HOC VIEN CONG NGHE BUU CHINH VIEN THONG - KHOA DT-VT" -ForegroundColor Cyan
Write-Host "  DO AN CUOI KY: CAU TRUC DU LIEU VA GIAI THUAT (INT13185 - NHOM 03)" -ForegroundColor Cyan
Write-Host "  DE TAI DT021: TIM KIEM NOI SUY SO VOI TIM KIEM NHI PHAN" -ForegroundColor Cyan
Write-Host "  Sinh vien: Nguyen Minh Hien | MSSV: N24DCDT023 | Lop: D24CQDT01-N" -ForegroundColor Cyan
Write-Host "======================================================================" -ForegroundColor Cyan

Write-Host "`n[1/5] Kiem tra phien ban moi truong Julia..." -ForegroundColor Yellow
julia --version

Write-Host "`n[2/5] Chay cac vi du chinh (demo.jl)..." -ForegroundColor Yellow
julia --startup-file=no demo.jl

Write-Host "`n[3/5] Chay bo kiem thu tu dong (test/runtests.jl)..." -ForegroundColor Yellow
julia --startup-file=no test/runtests.jl

Write-Host "`n[4/5] Chay mo hinh kiem nghiem doc lap (test/verify_exhaustive.jl)..." -ForegroundColor Yellow
julia --startup-file=no test/verify_exhaustive.jl

Write-Host "`n[5/5] Chay khao sat quy mo n = 10, 100, 1000 (scripts/trace_and_scales.jl)..." -ForegroundColor Yellow
julia --startup-file=no scripts/trace_and_scales.jl

Write-Host "`n======================================================================" -ForegroundColor Green
Write-Host "[OK] TOAN BO HE THONG THUC THI THANH CONG 100%!" -ForegroundColor Green
Write-Host "======================================================================" -ForegroundColor Green
