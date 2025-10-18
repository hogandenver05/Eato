#!/bin/bash
set -e

BASE_URL="http://localhost/Eato/Eato/code"
USERNAME="testuser"
PASSWORD="testpass"

# -----------------------------
# Utility function to print JSON nicely
# -----------------------------
function pretty() {
    echo "$1" | jq .
}

# -----------------------------
# 1. Register a user
# -----------------------------
echo "=== Testing user registration ==="
REGISTER=$(curl -s -X POST "$BASE_URL/register.php" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}")
pretty "$REGISTER"
echo

# -----------------------------
# 2. Register same user again (should fail)
# -----------------------------
echo "=== Testing duplicate registration ==="
DUP_REGISTER=$(curl -s -X POST "$BASE_URL/register.php" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}")
pretty "$DUP_REGISTER"
echo

# -----------------------------
# 3. Login user (valid)
# -----------------------------
echo "=== Testing login ==="
LOGIN=$(curl -s -X POST "$BASE_URL/login.php" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}")

TOKEN=$(echo "$LOGIN" | jq -r '.token')
if [ "$TOKEN" = "null" ] || [ -z "$TOKEN" ]; then
    echo "Login failed. Response:"
    pretty "$LOGIN"
    exit 1
fi
echo "Login successful. Token: $TOKEN"
echo

# -----------------------------
# 4. Login user (invalid password)
# -----------------------------
echo "=== Testing login with invalid password ==="
LOGIN_FAIL=$(curl -s -X POST "$BASE_URL/login.php" \
    -H "Content-Type: application/json" \
    -d "{\"username\":\"$USERNAME\",\"password\":\"wrongpass\"}")
pretty "$LOGIN_FAIL"
echo

# -----------------------------
# 5. Add food
# -----------------------------
echo "=== Adding a food ==="
ADD_FOOD=$(curl -s -X POST "$BASE_URL/foods.php" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"food_name":"Banana","calories":105}')
pretty "$ADD_FOOD"

FOOD_ID=$(echo "$ADD_FOOD" | jq -r '.food_id')
echo "Added food ID: $FOOD_ID"
echo

# -----------------------------
# 6. Add food with missing name (should fail)
# -----------------------------
echo "=== Adding food with missing name (should fail) ==="
ADD_FOOD_FAIL=$(curl -s -X POST "$BASE_URL/foods.php" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d '{"calories":50}')
pretty "$ADD_FOOD_FAIL"
echo

# -----------------------------
# 7. Get all foods
# -----------------------------
echo "=== Listing foods ==="
LIST_FOODS=$(curl -s -X GET "$BASE_URL/foods.php" \
    -H "Authorization: Bearer $TOKEN")
pretty "$LIST_FOODS"
echo

# -----------------------------
# 8. Get single food by food_id
# -----------------------------
echo "=== Fetch single food by food_id ==="
SINGLE_FOOD=$(curl -s -X GET "$BASE_URL/foods.php" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "{\"food_id\":$FOOD_ID}")
pretty "$SINGLE_FOOD"
echo

# -----------------------------
# 9. Add favorite
# -----------------------------
echo "=== Adding favorite ==="
ADD_FAV=$(curl -s -X POST "$BASE_URL/favorites.php" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "{\"food_id\":$FOOD_ID}")
pretty "$ADD_FAV"
echo

# -----------------------------
# 10. Add duplicate favorite (should fail)
# -----------------------------
echo "=== Adding duplicate favorite ==="
ADD_FAV_DUP=$(curl -s -X POST "$BASE_URL/favorites.php" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "{\"food_id\":$FOOD_ID}")
pretty "$ADD_FAV_DUP"
echo

# -----------------------------
# 11. List favorites
# -----------------------------
echo "=== Listing favorites ==="
LIST_FAVS=$(curl -s -X GET "$BASE_URL/favorites.php" \
    -H "Authorization: Bearer $TOKEN")
pretty "$LIST_FAVS"
echo

# -----------------------------
# 12. Unfavorite
# -----------------------------
echo "=== Removing favorite ==="
UNFAV=$(curl -s -X DELETE "$BASE_URL/favorites.php" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "{\"food_id\":$FOOD_ID}")
pretty "$UNFAV"
echo

# -----------------------------
# 13. Delete food
# -----------------------------
echo "=== Deleting food ==="
DELETE_FOOD=$(curl -s -X DELETE "$BASE_URL/foods.php" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $TOKEN" \
    -d "{\"food_id\":$FOOD_ID}")
pretty "$DELETE_FOOD"
echo

# -----------------------------
# 14. Invalid method test
# -----------------------------
echo "=== Testing invalid HTTP method on foods ==="
INVALID_METHOD=$(curl -s -X PATCH "$BASE_URL/foods.php" \
    -H "Authorization: Bearer $TOKEN")
pretty "$INVALID_METHOD"
echo

echo "=== All tests complete ==="
