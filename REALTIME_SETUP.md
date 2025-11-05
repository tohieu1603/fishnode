# 🔥 Hướng dẫn Setup Realtime WebSocket cho Seefood

## Tóm tắt
Đã implement **realtime order updates** bằng:
- **Backend**: Django Channels + Redis + WebSocket
- **Frontend**: Redux Toolkit + WebSocket middleware

## 🚀 Bước 1: Cài đặt Backend Dependencies

```bash
cd backend
pip install -r requirements.txt
```

Đã thêm vào `requirements.txt`:
```
channels==4.0.0
channels-redis==4.2.0
daphne==4.1.0
```

## 🐳 Bước 2: Khởi động Docker Services

```bash
# Từ thư mục gốc dự án
docker-compose up -d
```

Đã thêm Redis service vào `docker-compose.yml`:
- **PostgreSQL**: port 5432
- **Redis**: port 6379 (cho Django Channels layer)

## 🔧 Bước 3: Cài đặt Frontend Dependencies

```bash
cd frontend
npm install
```

Đã thêm vào `package.json`:
```json
"@reduxjs/toolkit": "^2.5.0",
"react-redux": "^9.2.0"
```

Đã xóa `zustand` khỏi dependencies (migration sang Redux).

## 🎯 Bước 4: Chạy Backend với ASGI

```bash
cd backend
python manage.py migrate
python manage.py runserver
```

Hoặc chạy với Daphne (ASGI server):
```bash
daphne -b 0.0.0.0 -p 8000 config.asgi:application
```

## 🌐 Bước 5: Chạy Frontend

```bash
cd frontend
npm run dev
```

Frontend sẽ tự động kết nối WebSocket tới `ws://localhost:8000/ws/orders/`

## 📝 Các thay đổi đã thực hiện

### Backend Changes

1. **Django Channels Configuration** ([config/settings/base.py](backend/config/settings/base.py))
   - Thêm `daphne` và `channels` vào `INSTALLED_APPS`
   - Cấu hình `CHANNEL_LAYERS` với Redis backend
   - Thêm `ASGI_APPLICATION` setting

2. **ASGI Application** ([config/asgi.py](backend/config/asgi.py))
   - Setup ProtocolTypeRouter cho HTTP và WebSocket
   - Cấu hình WebSocket routing với authentication

3. **WebSocket Consumer** ([apps/orders/consumers.py](backend/apps/orders/consumers.py))
   - `OrderConsumer` xử lý kết nối WebSocket
   - Các event handlers:
     - `order_created`
     - `order_updated`
     - `order_deleted`
     - `order_status_changed`
     - `order_image_uploaded`
     - `order_image_deleted`
     - `order_assigned`

4. **WebSocket Routing** ([apps/orders/routing.py](backend/apps/orders/routing.py))
   - WebSocket URL: `ws://localhost:8000/ws/orders/`

5. **Broadcast Utilities** ([apps/orders/websocket_utils.py](backend/apps/orders/websocket_utils.py))
   - Helper functions để broadcast events tới tất cả clients
   - Sử dụng `channels.layers.get_channel_layer()`

6. **Service Layer Integration** ([apps/orders/services/service_a.py](backend/apps/orders/services/service_a.py))
   - Tích hợp broadcast calls vào:
     - `create_order()` → broadcast_order_created
     - `update_order_status()` → broadcast_order_status_changed
     - `update_assigned_users()` → broadcast_order_assigned
     - `upload_order_image()` → broadcast_order_image_uploaded

7. **Router Integration** ([apps/orders/routers/router_a.py](backend/apps/orders/routers/router_a.py))
   - Thêm broadcast cho delete operations

### Frontend Changes

1. **Redux Store Setup** ([lib/redux/store.ts](frontend/lib/redux/store.ts))
   - Configure Redux store với WebSocket middleware
   - Combine reducers: `orders` và `ui`

2. **Orders Slice** ([lib/redux/slices/ordersSlice.ts](frontend/lib/redux/slices/ordersSlice.ts))
   - State management cho orders
   - Async thunks: `fetchOrders`, `createOrder`, `updateOrderStatus`, `deleteOrder`
   - WebSocket event reducers:
     - `orderCreatedWS`
     - `orderUpdatedWS`
     - `orderDeletedWS`
     - `orderStatusChangedWS`

3. **UI Slice** ([lib/redux/slices/uiSlice.ts](frontend/lib/redux/slices/uiSlice.ts))
   - WebSocket connection state
   - Error handling

4. **WebSocket Middleware** ([lib/redux/middleware/websocketMiddleware.ts](frontend/lib/redux/middleware/websocketMiddleware.ts))
   - Auto-connect khi app loads
   - Auto-reconnect logic (max 5 attempts)
   - Parse và dispatch WebSocket messages
   - Toast notifications cho realtime events

5. **Redux Provider** ([lib/redux/ReduxProvider.tsx](frontend/lib/redux/ReduxProvider.tsx))
   - Wrapper component để provide Redux store
   - Auto-connect WebSocket on mount

6. **App Layout Update** ([app/layout.tsx](frontend/app/layout.tsx))
   - Wrap app với `ReduxProvider`

7. **Main Page Migration** ([app/page.tsx](frontend/app/page.tsx))
   - Migrate từ Zustand sang Redux hooks
   - Sử dụng `useAppDispatch` và `useAppSelector`

## 🔌 WebSocket Connection Flow

```
Frontend (React)
    ↓ (mount)
ReduxProvider
    ↓ (dispatch)
websocket/connect action
    ↓
WebSocket Middleware
    ↓ (new WebSocket)
ws://localhost:8000/ws/orders/
    ↓
Django Channels
    ↓
OrderConsumer
    ↓ (join group)
Redis Channel Layer
```

## 📡 Realtime Events

Khi có thao tác trên orders, flow như sau:

```
User Action → API Call → Service Layer → Broadcast → Redis → All Connected Clients
```

**Example: Tạo đơn hàng mới**
1. User click "Tạo đơn" → `orderApi.createOrder()`
2. Backend nhận request → `OrderService.create_order()`
3. Sau khi save → `broadcast_order_created(order_data)`
4. Redis channel layer broadcast tới group `order_updates`
5. Tất cả clients nhận event qua WebSocket
6. Frontend WebSocket middleware nhận message
7. Dispatch `orderCreatedWS` action → update Redux store
8. React components tự động re-render với order mới

## 🎨 Features Realtime

✅ **Tạo đơn hàng**: Hiển thị toast "Đơn hàng mới: #DHxxxxx"
✅ **Cập nhật trạng thái**: Tự động cập nhật UI khi status change
✅ **Xóa đơn**: Remove khỏi UI realtime
✅ **Upload ảnh**: Thông báo khi có ảnh mới
✅ **Phân công nhân viên**: Update assigned users realtime

## 🔍 Debug WebSocket

### Kiểm tra kết nối:
```javascript
// Mở browser console
// Sẽ thấy logs:
// 🔌 Connecting to WebSocket: ws://localhost:8000/ws/orders/
// ✅ WebSocket connected
// ✅ Connection established: Connected to order updates
```

### Test broadcast:
```bash
# Terminal 1: Chạy backend
python manage.py runserver

# Terminal 2: Tạo đơn hàng qua API
curl -X POST http://localhost:8000/api/orders/ \
  -H "Authorization: Bearer YOUR_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"customer_name":"Test","items":[],...}'

# Browser console sẽ log:
# 📨 WebSocket message: {type: "order_created", order: {...}}
# 🆕 Order created: {order_number: "DH2025010500001", ...}
```

## 🐛 Troubleshooting

### Backend không chạy WebSocket:
```bash
# Kiểm tra Redis đang chạy
docker ps | grep redis

# Kiểm tra channels đã cài
python -c "import channels; print(channels.__version__)"

# Test Redis connection
python manage.py shell
>>> from channels.layers import get_channel_layer
>>> channel_layer = get_channel_layer()
>>> print(channel_layer)
```

### Frontend không kết nối:
1. Kiểm tra WebSocket URL trong console
2. Kiểm tra backend có chạy
3. Kiểm tra CORS settings cho WebSocket
4. Check browser console cho errors

### Redis connection error:
```bash
# Kiểm tra Redis host/port trong settings
# Mặc định: localhost:6379
# Docker: có thể cần đổi thành tên service "redis"

# Test Redis
redis-cli ping
# Nên trả về: PONG
```

## 🔐 Environment Variables

Tạo file `.env` trong thư mục `backend/`:
```env
REDIS_HOST=localhost
REDIS_PORT=6379
```

Tạo file `.env.local` trong thư mục `frontend/`:
```env
NEXT_PUBLIC_WS_URL=ws://localhost:8000/ws/orders/
NEXT_PUBLIC_API_URL=http://localhost:8000
```

## 📦 Project Structure

```
Seefood/
├── backend/
│   ├── apps/
│   │   └── orders/
│   │       ├── consumers.py          # WebSocket consumer
│   │       ├── routing.py            # WebSocket routing
│   │       ├── websocket_utils.py    # Broadcast helpers
│   │       └── services/
│   │           └── service_a.py      # Integrated broadcasts
│   ├── config/
│   │   ├── asgi.py                   # ASGI config
│   │   └── settings/
│   │       └── base.py               # Channels settings
│   └── requirements.txt
├── frontend/
│   ├── app/
│   │   ├── layout.tsx                # ReduxProvider wrapper
│   │   └── page.tsx                  # Main page (Redux)
│   ├── lib/
│   │   └── redux/
│   │       ├── store.ts              # Redux store
│   │       ├── hooks.ts              # Typed hooks
│   │       ├── ReduxProvider.tsx     # Provider component
│   │       ├── slices/
│   │       │   ├── ordersSlice.ts    # Orders state
│   │       │   └── uiSlice.ts        # UI state
│   │       └── middleware/
│   │           └── websocketMiddleware.ts  # WebSocket logic
│   └── package.json
├── docker-compose.yml                # PostgreSQL + Redis
└── REALTIME_SETUP.md                 # This file
```

## ✅ Checklist

- [x] Backend: Install Django Channels + Redis
- [x] Backend: Configure ASGI application
- [x] Backend: Create WebSocket consumer
- [x] Backend: Add broadcast utilities
- [x] Backend: Integrate broadcasts into service layer
- [x] Docker: Add Redis service
- [x] Frontend: Install Redux Toolkit + react-redux
- [x] Frontend: Setup Redux store
- [x] Frontend: Create WebSocket middleware
- [x] Frontend: Migrate from Zustand to Redux
- [x] Frontend: Wrap app with ReduxProvider
- [ ] Testing: Run both backend and frontend
- [ ] Testing: Verify WebSocket connection
- [ ] Testing: Test realtime order creation
- [ ] Testing: Test realtime status updates
- [ ] Production: Configure production WebSocket URL

## 🚀 Next Steps

1. **Run the app**:
   ```bash
   # Terminal 1: Docker
   docker-compose up -d

   # Terminal 2: Backend
   cd backend
   python manage.py runserver

   # Terminal 3: Frontend
   cd frontend
   npm run dev
   ```

2. **Test realtime**: Mở 2 browser windows, tạo order ở window 1, xem nó xuất hiện ở window 2

3. **Production deployment**:
   - Update `NEXT_PUBLIC_WS_URL` với production WebSocket URL
   - Configure Daphne/Uvicorn cho production
   - Setup Redis với authentication
   - Configure CORS cho WebSocket

## 📚 Documentation

- [Django Channels](https://channels.readthedocs.io/)
- [Redux Toolkit](https://redux-toolkit.js.org/)
- [WebSocket API](https://developer.mozilla.org/en-US/docs/Web/API/WebSocket)

---

**Created by**: Claude Code
**Date**: 2025-01-05
**Version**: 1.0.0
