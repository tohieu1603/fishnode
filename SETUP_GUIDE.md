# 🚀 Hướng Dẫn Setup Hệ Thống Quản Lý Bán Hải Sản

## 📋 Yêu Cầu Hệ Thống

- **Python**: 3.11+
- **Node.js**: 18.0+
- **PostgreSQL**: 15+
- **Docker & Docker Compose** (optional)

---

## 🔧 Setup Backend (Django Ninja)

### Bước 1: Cài đặt Dependencies

```bash
cd backend

# Tạo virtual environment
python -m venv venv

# Kích hoạt virtual environment
# macOS/Linux:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Cài đặt packages
pip install -r requirements.txt
```

### Bước 2: Cấu hình Database

1. Tạo PostgreSQL database:
```sql
CREATE DATABASE seafood_db;
CREATE USER postgres WITH PASSWORD 'postgres';
GRANT ALL PRIVILEGES ON DATABASE seafood_db TO postgres;
```

2. Copy và cấu hình .env:
```bash
cp .env.example .env
```

Chỉnh sửa [.env](backend/.env):
```env
SECRET_KEY=your-secret-key-here
DEBUG=True
DB_NAME=seafood_db
DB_USER=postgres
DB_PASSWORD=postgres
DB_HOST=localhost
DB_PORT=5432
CORS_ALLOWED_ORIGINS=http://localhost:3000
```

### Bước 3: Chạy Migrations

```bash
# Tạo migrations
python manage.py makemigrations

# Chạy migrations
python manage.py migrate
```

### Bước 4: Tạo Superuser

```bash
python manage.py createsuperuser
```

### Bước 5: Chạy Server

```bash
python manage.py runserver
```

Backend chạy tại: `http://localhost:8000`

API Docs: `http://localhost:8000/api/docs`

---

## 🎨 Setup Frontend (Next.js 15)

### Bước 1: Cài đặt Dependencies

```bash
cd frontend

# Cài đặt packages
npm install
```

### Bước 2: Cấu hình Environment

Copy [.env.local](frontend/.env.local):
```bash
cp .env.local.example .env.local
```

Chỉnh sửa:
```env
NEXT_PUBLIC_API_URL=http://localhost:8000/api
```

### Bước 3: Chạy Development Server

```bash
npm run dev
```

Frontend chạy tại: `http://localhost:3000`

---

## 🐳 Setup với Docker (Recommended)

### Chạy toàn bộ hệ thống với Docker Compose:

```bash
cd backend

# Build và start services
docker-compose up --build

# Chạy migrations trong container
docker-compose exec backend python manage.py migrate

# Tạo superuser
docker-compose exec backend python manage.py createsuperuser

# Seed data (optional)
docker-compose exec backend python manage.py loaddata initial_data.json
```

Services sẽ chạy tại:
- Backend: `http://localhost:8000`
- Frontend: `http://localhost:3000` (cần chạy riêng)
- PostgreSQL: `localhost:5432`

---

## 📊 Seed Data (Optional)

### Tạo dữ liệu mẫu:

```bash
# Backend
python manage.py shell

from apps.customers.models import Customer
from apps.products.models import Product
from apps.users.models import User
from django.contrib.auth import get_user_model

# Tạo users
User = get_user_model()
admin = User.objects.create_superuser('admin', 'admin@example.com', 'admin123')
sale = User.objects.create_user('sale1', 'sale@example.com', 'sale123', role='sale')

# Tạo customers
customer1 = Customer.objects.create(
    name='Nguyễn Văn An',
    phone='0901234567',
    address='123 Đường ABC, Quận 1, TP.HCM',
    is_vip=True
)

# Tạo products
Product.objects.create(name='Tôm hùm', unit='kg', price=800000, in_stock=True)
Product.objects.create(name='Cua hoàng đế', unit='kg', price=1200000, in_stock=True)
Product.objects.create(name='Ghẹ xanh', unit='kg', price=300000, in_stock=True)
```

---

## ✅ Kiểm Tra Setup

### Backend
```bash
# Test API health
curl http://localhost:8000/api/health

# Test orders endpoint
curl http://localhost:8000/api/orders/
```

### Frontend
Mở browser tại `http://localhost:3000` và kiểm tra:
- Kanban board hiển thị
- Có thể kéo thả cards
- Timer đếm ngược hoạt động

---

## 🧪 Chạy Tests

### Backend Tests
```bash
cd backend
pytest
```

### Frontend Tests (nếu có)
```bash
cd frontend
npm run test
```

---

## 📝 Troubleshooting

### Lỗi kết nối Database
```bash
# Kiểm tra PostgreSQL đã chạy
sudo service postgresql status

# Restart PostgreSQL
sudo service postgresql restart
```

### Lỗi CORS
Đảm bảo trong [backend/.env](backend/.env):
```env
CORS_ALLOWED_ORIGINS=http://localhost:3000,http://127.0.0.1:3000
```

### Lỗi migrations
```bash
# Reset migrations (CHỈ DÙNG TRONG DEVELOPMENT!)
python manage.py migrate --fake app_name zero
python manage.py migrate app_name
```

---

## 🚀 Deploy Production

### Backend (Django)
```bash
# Set production settings
export DJANGO_SETTINGS_MODULE=config.settings.production

# Collect static files
python manage.py collectstatic --noinput

# Run with gunicorn
gunicorn config.wsgi:application --bind 0.0.0.0:8000
```

### Frontend (Next.js)
```bash
# Build
npm run build

# Start production server
npm run start
```

Hoặc deploy lên Vercel:
```bash
vercel --prod
```

---

## 📚 Tài Liệu Tham Khảo

- [Django Ninja Docs](https://django-ninja.rest-framework.com/)
- [Next.js 15 Docs](https://nextjs.org/docs)
- [PostgreSQL Docs](https://www.postgresql.org/docs/)
- [Docker Compose Docs](https://docs.docker.com/compose/)

---

**Chúc bạn setup thành công! 🎉**
