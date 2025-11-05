# 🚀 Quick Start Guide - Chạy Hệ Thống với Docker

## 📋 Yêu Cầu

- **Docker Desktop** đã cài đặt và đang chạy
- **Docker Compose** (đi kèm với Docker Desktop)

## ⚡ Cách Chạy Nhanh

### Option 1: Sử dụng Script (Recommended)

```bash
# Chạy toàn bộ hệ thống (DB + Backend + Frontend)
./START.sh

# Dừng hệ thống
./STOP.sh
```

### Option 2: Sử dụng Docker Compose

```bash
# Build và start tất cả services
docker-compose up --build

# Hoặc chạy ở background
docker-compose up -d --build

# Xem logs
docker-compose logs -f

# Dừng
docker-compose down
```

## 📍 Các Services

Sau khi chạy thành công:

- **PostgreSQL Database**: `localhost:5432`
- **Django Backend**: http://localhost:8000
- **API Documentation**: http://localhost:8000/api/docs
- **Next.js Frontend**: http://localhost:3000

## 👤 Tài Khoản Admin Mặc Định

```
Username: admin
Password: admin123
```

## 🔧 Commands Hữu Ích

### Xem logs
```bash
# Tất cả services
docker-compose logs -f

# Chỉ backend
docker-compose logs -f backend

# Chỉ frontend
docker-compose logs -f frontend
```

### Truy cập shell
```bash
# Django shell
docker-compose exec backend python manage.py shell

# Backend bash
docker-compose exec backend bash

# Frontend bash
docker-compose exec frontend sh
```

### Database operations
```bash
# Chạy migrations
docker-compose exec backend python manage.py makemigrations
docker-compose exec backend python manage.py migrate

# Tạo superuser mới
docker-compose exec backend python manage.py createsuperuser
```

### Restart services
```bash
# Restart tất cả
docker-compose restart

# Restart backend
docker-compose restart backend

# Restart frontend
docker-compose restart frontend
```

### Stop và xóa tất cả (bao gồm data)
```bash
docker-compose down -v
```

## 🐛 Troubleshooting

### Port đã được sử dụng
```bash
# Kiểm tra port 8000
lsof -ti:8000 | xargs kill -9

# Kiểm tra port 3000
lsof -ti:3000 | xargs kill -9

# Kiểm tra port 5432
lsof -ti:5432 | xargs kill -9
```

### Rebuild từ đầu
```bash
# Xóa tất cả containers và volumes
docker-compose down -v

# Xóa images
docker-compose rm -f

# Build lại
docker-compose up --build
```

### Database không kết nối được
```bash
# Kiểm tra database có chạy không
docker-compose ps

# Xem logs database
docker-compose logs db

# Restart database
docker-compose restart db
```

### Backend báo lỗi migrations
```bash
# Chạy lại migrations
docker-compose exec backend python manage.py makemigrations
docker-compose exec backend python manage.py migrate --run-syncdb
```

## 📝 Seed Data (Tạo Dữ Liệu Mẫu)

```bash
# Truy cập Django shell
docker-compose exec backend python manage.py shell

# Paste code sau:
from apps.users.models import User
from apps.products.models import Product

# Tạo users
sale1 = User.objects.create_user(
    username='sale1',
    email='sale1@example.com',
    password='sale123',
    first_name='Nguyễn',
    last_name='Văn A',
    role='sale'
)

sale2 = User.objects.create_user(
    username='sale2',
    email='sale2@example.com',
    password='sale123',
    first_name='Trần',
    last_name='Thị B',
    role='sale'
)

# Tạo products
Product.objects.create(
    name='Tôm hùm Alaska',
    unit='kg',
    price=800000,
    description='Tôm hùm Alaska cao cấp',
    in_stock=True
)

Product.objects.create(
    name='Cua hoàng đế',
    unit='kg',
    price=1200000,
    description='Cua hoàng đế tươi sống',
    in_stock=True
)

Product.objects.create(
    name='Ghẹ xanh',
    unit='kg',
    price=300000,
    description='Ghẹ xanh tươi',
    in_stock=True
)

Product.objects.create(
    name='Tôm sú',
    unit='kg',
    price=400000,
    in_stock=True
)

print("✅ Seed data created successfully!")
```

## 🎯 Test API

### Sử dụng curl
```bash
# Health check
curl http://localhost:8000/api/health

# Get all orders
curl http://localhost:8000/api/orders/

# Get order statistics
curl http://localhost:8000/api/orders/statistics/summary
```

### Sử dụng API Docs
Mở trình duyệt: http://localhost:8000/api/docs

## 📊 Kiểm Tra Hệ Thống

1. **Backend**: http://localhost:8000/api/health → Should return `{"status": "healthy"}`
2. **Frontend**: http://localhost:3000 → Hiển thị Kanban board
3. **Database**: Kết nối bằng tool như DBeaver:
   - Host: localhost
   - Port: 5432
   - Database: seafood_db
   - User: postgres
   - Password: postgres

---

**🎉 Chúc bạn sử dụng hệ thống thành công!**
