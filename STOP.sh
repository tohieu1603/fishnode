#!/bin/bash

echo "🛑 Stopping Seafood Order Management System..."

docker-compose down

echo ""
echo "✅ All services stopped!"
echo ""
echo "💡 To remove all data (database, media files):"
echo "   docker-compose down -v"
