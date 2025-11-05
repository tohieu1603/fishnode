# Seefood - Order Management System

Hệ thống quản lý đơn hàng cho cửa hàng hải sản với đầy đủ tính năng tracking, in phiếu và mobile-friendly.

## 🚀 Tính năng chính

- ✅ Quản lý đơn hàng theo workflow (9 giai đoạn)
- ✅ Tracking thời gian realtime cho từng giai đoạn
- ✅ Cảnh báo đơn hàng muộn deadline
- ✅ Upload và quản lý hình ảnh (cân hàng, phiếu ĐH)
- ✅ In phiếu đa dạng (Bill đặt hàng, Phiếu cân hàng, Bill thanh toán, Phiếu giao hàng)
- ✅ Hỗ trợ nhiều khổ giấy (K57, K80, A4, A5)
- ✅ Mobile-friendly với SwipeButton và responsive design
- ✅ Drag & Drop để chuyển trạng thái đơn hàng
- ✅ Lịch sử hoạt động và audit trail đầy đủ

## 📁 Cấu trúc dự án

```
Seefood/
├── backend/          # FastAPI backend
│   ├── app/
│   ├── .env         # Config (không commit)
│   └── .env.example # Template config
├── frontend/        # Next.js 16 frontend
│   ├── app/
│   ├── components/
│   ├── .env.local   # Config (không commit)
│   └── .env.example # Template config
└── README.md
```

## 🛠️ Setup Backend (FastAPI)

### 1. Di chuyển vào thư mục backend
```bash
cd backend
```

### 2. Tạo virtual environment
```bash
python -m venv venv
source venv/bin/activate  # macOS/Linux
# hoặc
venv\Scripts\activate  # Windows
```

### 3. Cài đặt dependencies
```bash
pip install -r requirements.txt
```

### 4. Tạo file .env từ template
```bash
cp .env.example .env
```

Sửa file `.env` với cấu hình của bạn:
```env
DATABASE_URL=sqlite:///./seefood.db
SECRET_KEY=your-secret-key-here
ALLOWED_ORIGINS=http://localhost:3000
```

### 5. Chạy migrations
```bash
python manage.py migrate
```

### 6. Khởi chạy server
```bash
python manage.py runserver 0.0.0.0:8000
```

Backend sẽ chạy tại: `http://localhost:8000`
API docs: `http://localhost:8000/api/docs`

**Lưu ý:** Folder `media/` sẽ tự động được tạo khi backend khởi động. Đây là nơi lưu trữ ảnh upload.

## 🎨 Setup Frontend (Next.js)

### 1. Di chuyển vào thư mục frontend
```bash
cd frontend
```

### 2. Cài đặt dependencies
```bash
npm install
```

### 3. Tạo file .env.local từ template
```bash
cp .env.example .env.local
```

Sửa file `.env.local`:
```env
NEXT_PUBLIC_API_URL=http://localhost:8000
```

**Lưu ý:** Không thêm `/api` vào cuối URL, nó sẽ tự động được thêm trong code.

### 4. Khởi chạy dev server
```bash
npm run dev
```

Frontend sẽ chạy tại: `http://localhost:3000`

## 📝 API Endpoints chính

### Authentication
- `POST /api/auth/login` - Đăng nhập
- `POST /api/auth/register` - Đăng ký
- `GET /api/auth/me` - Lấy thông tin user

### Orders
- `GET /api/orders` - Danh sách đơn hàng (có phân trang, filter)
- `POST /api/orders` - Tạo đơn hàng mới
- `GET /api/orders/{id}` - Chi tiết đơn hàng
- `PUT /api/orders/{id}/status` - Cập nhật trạng thái
- `POST /api/orders/{id}/images` - Upload hình ảnh

### Statistics
- `GET /api/statistics` - Thống kê tổng quan

## 🖨️ Chức năng In phiếu

Hệ thống hỗ trợ in 4 loại phiếu:

1. **Bill đặt hàng** (K57/K80) - Phiếu trắng lưu bếp
2. **Phiếu cân hàng** (A4/A5) - Có ảnh cân và chi tiết trọng lượng
3. **Bill thanh toán** (K57/K80) - Hóa đơn cho khách với QR thanh toán
4. **Phiếu giao hàng** (A4/A5) - Cho shipper với checklist

### Cách sử dụng:
1. Vào chi tiết đơn hàng
2. Click nút "In phiếu"
3. Chọn loại phiếu và khổ giấy
4. Click "Xem trước" hoặc "In ngay"

## 🔒 Bảo mật

- File `.env` và `.env.local` đã được gitignore
- Không commit API keys hoặc secrets
- JWT authentication cho API
- CORS configuration cho production

## 📱 Mobile Support

- Responsive design cho tất cả màn hình
- SwipeButton để chuyển trạng thái nhanh trên mobile
- Modal dialog tối ưu cho mobile (44px minimum touch target)
- Compact UI cho overdue alerts trên mobile

## 🚢 Production Deployment

### Backend
```bash
# Set environment variables
export DATABASE_URL=postgresql://...
export SECRET_KEY=...
export ALLOWED_ORIGINS=https://yourdomain.com

# Run with gunicorn
gunicorn app.main:app -w 4 -k uvicorn.workers.UvicornWorker
```

### Frontend
```bash
# Build
npm run build

# Set production API URL
NEXT_PUBLIC_API_URL=https://api.yourdomain.com

# Start
npm start
```

## 📄 License

MIT

## 👥 Contributors

- Hieu To - Initial development
