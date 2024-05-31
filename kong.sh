# Create all KONG services and routes
kong_admin_url="http://ec2-54-204-107-185.compute-1.amazonaws.com:8001"
create_service_and_route() {
  local service_name=$1
  local service_url=$2
  local route_path=$3

  echo "Creating service: $service_name"
  curl -i -X POST \
    --url $kong_admin_url/services/ \
    --data "name=$service_name" \
    --data "url=$service_url"

  echo "Creating route for service: $service_name"
  curl -i -X POST \
    --url $kong_admin_url/services/$service_name/routes \
    --data-urlencode "paths[]=$route_path" \
    --data "strip_path=false"
}

# Create services and routes
create_service_and_route "customer-service" "http://ec2-54-159-68-51.compute-1.amazonaws.com:8080" "/Customer(/.*)?"
create_service_and_route "purchase-service" "http://ec2-174-129-102-72.compute-1.amazonaws.com:8080" "/Purchase(/.*)?"
create_service_and_route "shop-service" "http://ec2-174-129-102-72.compute-1.amazonaws.com:9000" "/Shop(/.*)?"
create_service_and_route "loyaltycard-service" "http://ec2-54-159-68-51.compute-1.amazonaws.com:9000" "/Loyaltycard(/.*)?"
create_service_and_route "discountcoupon-service" "http://ec2-3-81-205-122.compute-1.amazonaws.com:8080" "/Discountcoupon(/.*)?"
create_service_and_route "crosssell-service" "http://ec2-18-212-150-122.compute-1.amazonaws.com:8080" "/Crosssell(/.*)?"
create_service_and_route "selledproduct-service" "http://ec2-3-92-54-126.compute-1.amazonaws.com:8080" "/Selledproduct(/.*)?"

# Create services and routes
create_service_and_route "customer-service" "http://ec2-54-159-68-51.compute-1.amazonaws.com:8080" "/Customer"
create_service_and_route "purchase-service" "http://ec2-174-129-102-72.compute-1.amazonaws.com:8080" "/Purchase"
create_service_and_route "shop-service" "http://ec2-174-129-102-72.compute-1.amazonaws.com:9000" "/Shop"
create_service_and_route "loyaltycard-service" "http://ec2-54-159-68-51.compute-1.amazonaws.com:9000" "/Loyaltycard"
create_service_and_route "discountcoupon-service" "http://ec2-3-81-205-122.compute-1.amazonaws.com:8080" "/Discountcoupon"
create_service_and_route "crosssell-service" "http://ec2-18-212-150-122.compute-1.amazonaws.com:8080" "/Crosssell"
create_service_and_route "selledproduct-service" "http://ec2-3-92-54-126.compute-1.amazonaws.com:8080" "/Selledproduct"
