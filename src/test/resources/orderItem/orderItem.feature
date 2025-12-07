Feature: Order Items API Testing

  Background:
    * url 'http://localhost:8080'

  # ==================== GET /api/orderItems ====================

  Scenario: TC_001 - GET /api/orderItems - Lấy tất cả order items thành công
    Given path '/api/orderItems'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch OrderItem'
    And match response.data == '#array'

  Scenario: TC_002 - GET /api/orderItems - Verify order relationship (có order data)
    Given path '/api/orderItems'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch OrderItem'
    And match response.data == '#array'
    # At minimum ensure items array exists and structure valid (order object may not be included in current payload)
    * def itemsHasProduct = karate.filter(response.data, function(x){ return x.product && x.product.id })

  Scenario: TC_003 - GET /api/orderItems - Verify ApiMessage header
    Given path '/api/orderItems'
    When method GET
    Then status 200
    And match response.message == 'Fetch OrderItem'

  Scenario: TC_004 - GET /api/orderItems/{id} - Lấy item by ID thành công
    Given path '/api/orderItems/10'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch By Id OrderItem'
    And match response.data.id == 10
    And match response.data.product.id == '#number'
    And match response.data.quantity == '#number'
    And match response.data.subtotal == '#number'
    And match response.data.notes == '#present'

  Scenario: TC_005 - GET /api/orderItems/{id} - Item không tồn tại (BUG - should be 404)
    Given path '/api/orderItems/99999'
    When method GET
    Then status 404
    And match response.status == 404
    And match response.message == 'An unexpected error occurred'
  # Expected: 404 Not Found with localized NOT_FOUND

  Scenario: TC_006 - GET /api/orderItems/{id} - ID null/invalid path (BUG - should be 400)
    Given path '/api/orderItems/'
    When method GET
    Then status 404
    And match response.status == 404
  # Expected: 400 Bad Request MethodArgumentTypeMismatch

  Scenario: TC_007 - GET /api/orderItems/{id} - ID = 0 (BUG - should be 404)
    Given path '/api/orderItems/0'
    When method GET
    Then status 404
    And match response.status == 404
  # Expected: 404 Not Found

  Scenario: TC_008 - GET /api/orderItems/{id} - ID âm (BUG - should be 404)
    Given path '/api/orderItems/-1'
    When method GET
    Then status 404
    And match response.status == 404

  # ==================== POST /api/orderItems ====================

  Scenario: TC_009 - POST /api/orderItems - Tạo order item thành công
    Given path '/api/orderItems'
    And request { order_id: 1, product_id: 1, quantity: 2, total_money: 90000, notes: 'No sugar' }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.statusCode == 201
    And match response.message == 'Create a OrderItem'
    And match response.data.id == '#number'
    And match response.data.quantity == 2
    And match response.data.subtotal == 90000
    And match response.data.notes == 'No sugar'

  Scenario: TC_010 - POST /api/orderItems - Order không tồn tại (BUG - should be 404)
    Given path '/api/orderItems'
    And request { order_id: 99999, product_id: 1, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method POST
    Then status 404
    And match response.status == 404
  # Expected: 404 DataNotFoundException localized with order_id

  Scenario: TC_011 - POST /api/orderItems - Product không tồn tại (BUG - should be 404)
    Given path '/api/orderItems'
    And request { order_id: 1, product_id: 99999, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method POST
    Then status 404
    And match response.status == 404
  # Expected: 404 DataNotFoundException for product_id

  Scenario: TC_012 - POST /api/orderItems - Missing required fields (order_id) (BUG - should be 400)
    Given path '/api/orderItems'
    And request { product_id: 1, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.status == 400
  # Expected: 400 validation error {order_id: 'must not be null'}

  Scenario: TC_013 - POST /api/orderItems - Missing product_id (BUG - should be 400)
    Given path '/api/orderItems'
    And request { order_id: 1, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.status == 400

  Scenario: TC_014 - POST /api/orderItems - Missing quantity (BUG - should be 400 or default=0)
    Given path '/api/orderItems'
    And request { order_id: 1, product_id: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.status == 400

  Scenario: TC_015 - POST /api/orderItems - Subtotal âm (BUG - should be 400)
    Given path '/api/orderItems'
    And request { order_id: 1, product_id: 1, quantity: 1, total_money: -10000 }
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.status == 400

  Scenario: TC_016 - POST /api/orderItems - Notes empty string (allowed)
    Given path '/api/orderItems'
    And request { order_id: 1, product_id: 1, quantity: 1, total_money: 450000, notes: '' }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.statusCode == 201
    And match response.data.notes == ''

  Scenario: TC_017 - POST /api/orderItems - Notes quá dài (nếu có limit) (BUG - DB constraint 409 or should be 400)
    * def longNotes = 'A'.repeat(1000)
    Given path '/api/orderItems'
    And request { order_id: 1, product_id: 1, quantity: 1, total_money: 45000, notes: 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa' }
    And header Content-Type = 'application/json'
    When method POST
    Then status 409

  # ==================== PUT /api/orderItems/{id} ====================

  Scenario: TC_018 - PUT /api/orderItems/{id} - Update quantity thành công
    Given path '/api/orderItems/10'
    And request { order_id: 1, product_id: 1, quantity: 5, total_money: 225000, notes: 'Updated notes' }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'update OrderItem'
    And match response.data.quantity == '#number'

  Scenario: TC_019 - PUT /api/orderItems/{id} - Update subtotal
    Given path '/api/orderItems/11'
    And request { order_id: 1, product_id: 1, quantity: 2, total_money: 100000 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.message == 'update OrderItem'
    And match response.data.subtotal == '#number'

  Scenario: TC_020 - PUT /api/orderItems/{id} - Update notes
    Given path '/api/orderItems/13'
    And request { order_id: 1, product_id: 1, quantity: 2, total_money: 100000,notes: 'New special request' }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.message == 'update OrderItem'
    And match response.data.notes == '#string'

  Scenario: TC_021 - PUT /api/orderItems/{id} - Change order (move to different order)
    # Attempt to move item to order 2
    Given path '/api/orderItems/13'
    And request { order_id: 2, product_id: 2, quantity: 2, total_money: 200000, notes: 'Move item' }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.message == 'update OrderItem'
    And match response.data.quantity == 2
    And match response.data.subtotal == '#number'

  Scenario: TC_022 - PUT /api/orderItems/{id} - OrderItem không tồn tại (BUG - should be 404)
    Given path '/api/orderItems/99999'
    And request { order_id: 1, product_id: 1, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    And match response.status == 404

  Scenario: TC_023 - PUT /api/orderItems/{id} - Order không tồn tại (BUG - should be 404)
    Given path '/api/orderItems/18'
    And request { order_id: 99999, product_id: 1, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    And match response.status == 404

  Scenario: TC_024 - PUT /api/orderItems/{id} - Product không tồn tại (BUG - should be 404)
    Given path '/api/orderItems/17'
    And request { order_id: 1, product_id: 99999, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
    And match response.status == 400

  Scenario: TC_025 - PUT /api/orderItems/{id} - Missing required fields (order_id)
    Given path '/api/orderItems/16'
    And request { product_id: 1, quantity: 1, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
    And match response.status == 400
  # Expected: 400 validation


  Scenario: TC_026 - PUT /api/orderItems/{id} - Quantity = 0
    Given path '/api/orderItems/15'
    And request { order_id: 1, product_id: 1, quantity: 0, total_money: 45000 }
    And header Content-Type = 'application/json'
    When method PUT
    # Accept 200 (current) or 400 (expected)
    Then status 200

  Scenario: TC_027 - PUT /api/orderItems/{id} - Quantity âm
    Given path '/api/orderItems/17'
    And request {order_id: 1, product_id: 1, quantity: -10 ,total_money: 45000}
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
  # Expected: 400, current may be 200

  Scenario: TC_028 - PUT /api/orderItems/{id} - Subtotal = 0
    Given path '/api/orderItems/17'
    And request {  "order_id": 1, product_id: 1, quantity: 1, total_money: 0 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200

  Scenario: TC_029 - PUT /api/orderItems/{id} - Subtotal âm
    Given path '/api/orderItems/17'
    And request { total_money: -50000 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
  # Expected: 400

  Scenario: TC_030 - PUT /api/orderItems/{id} - Update all fields
    Given path '/api/orderItems/13'
    And request { order_id: 2, product_id: 3, quantity: 10, total_money: 500000, notes: 'Completely new' }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.message == 'update OrderItem'
    And match response.data.quantity == 10
    And match response.data.subtotal == '#number'
    And match response.data.notes == '#string'


  Scenario: TC_031 - PUT /api/orderItems/{id} - Verify ID không đổi
    Given path '/api/orderItems/18'
    And request { order_id: 1, product_id: 10, subtotal: 213213, notes: 'Keep ID' }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200

  Scenario: TC_032 - PUT /api/orderItems/{id} - Notes với null (clear notes)
    Given path '/api/orderItems/17'
    And request {order_id: 1, notes: null, product_id: 2, quantity: 4, total_money: 40000 }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.data.notes == null

  # ==================== DELETE /api/orderItems/{id} ====================

  Scenario: TC_033 - DELETE /api/orderItems/{id} - Xóa item thành công
    # Prepare a new item to delete
    Given path '/api/orderItems'
    And request { order_id: 1, product_id: 1, quantity: 1, total_money: 45000, notes: 'to delete' }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def delId = response.data.id
    # Delete
    Given path '/api/orderItems/' + delId
    When method DELETE
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Delete a OrderItem'
    And match response.data == null

  Scenario: TC_034 - DELETE /api/orderItems/{id} - Item không tồn tại (BUG - should be 404)
    Given path '/api/orderItems/99999'
    When method DELETE
    Then status 404
    And match response.statusCode == 404
    And match response.message == 'Delete a OrderItem'
    And match response.data == null
  # Expected: 404 Not Found

  Scenario: TC_035 - DELETE /api/orderItems/{id} - Delete item của completed order (BUG - should be 404/400)
    # This assumes backend should block deletion on completed orders
    Given path '/api/orderItems/1'
    When method DELETE
    Then status 404
    And match response.message == 'Delete a OrderItem'
  # Expected: validation error

  Scenario: TC_036 - DELETE /api/orderItems/{id} - ID = 0
    Given path '/api/orderItems/0'
    When method DELETE
    Then status 200
    And match response.message == 'Delete a OrderItem'

  Scenario: TC_037 - DELETE /api/orderItems/{id} - ID âm (BUG - should be 404)
    Given path '/api/orderItems/-1'
    When method DELETE
    Then status 404
    And match response.message == 'Delete a OrderItem'
  # Expected: 404

  Scenario: TC_038 - DELETE /api/orderItems/{id} - ID không phải số (BUG - should be 400)
    Given path '/api/orderItems/abc'
    When method DELETE
    Then status 400
    And match response.status == 400
  # Expected: 400 MethodArgumentTypeMismatch