#!/bin/bash

echo "🦞 Starting Seafood Order Management System with Docker"
echo "=================================================="

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker Desktop first."
    exit 1
fi

echo "✅ Docker is running"
echo ""
echo "🏗️  Building and starting containers..."
echo ""

# Build and start all services
docker-compose up --build -d

echo ""
echo "⏳ Waiting for services to start..."
sleep 10

# Show status
docker-compose ps

echo ""
echo "=================================================="
echo "✅ All services are running!"
echo ""
echo "📍 Services:"
echo "   - Database:  http://localhost:5432"
echo "   - Backend:   http://localhost:8000"
echo "   - API Docs:  http://localhost:8000/api/docs"
echo "   - Frontend:  http://localhost:3000"
echo ""
echo "📝 Default Admin Account:"
echo "   Username: admin"
echo "   Password: admin123"
echo ""
echo "🔧 Useful Commands:"
echo "   - View logs:     docker-compose logs -f"
echo "   - Stop all:      docker-compose down"
echo "   - Restart:       docker-compose restart"
echo "   - Shell backend: docker-compose exec backend python manage.py shell"
echo ""
echo "=================================================="
