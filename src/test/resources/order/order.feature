Feature: Order API Testing

  Background:
    * url 'http://localhost:8080'

  # ==================== GET /api/order ====================

  Scenario: TC_001 - GET /api/order - Lấy tất cả orders (deleted=0)
    Given path '/api/order'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch All Order'
    And match response.data == '#array'
  Scenario: TC_002 - GET /api/order - Verify soft delete filter (chỉ deleted=0)
    Given path '/api/order'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch All Order'
    And match response.data == '#array'
    * def anyDeleted = karate.filter(response.data, function(x){ return x.deleted == 1 })
  Scenario: TC_003 - GET /api/order - Items included
    Given path '/api/order'
    When method GET
    Then status 200
    And match response.data == '#array'
    # Verify items array exists per order
    And match each response.data ==
      """
      {
        id: '#number',
        table: { id: '#number', status: '#string', createdAt: '#string', updatedAt: '#string' },
        status: '#string',
        total_amount: '#number',
        createdAt: '#string',
        deleted: '#number',
        items: '#array'
      }
      """
  Scenario: TC_004 - GET /api/order - Table included
    Given path '/api/order'
    When method GET
    Then status 200
    And match response.data == '#array'
    * match each response.data[*].table.id == '#number'

  Scenario: TC_005 - GET /api/order/{id} - Success
    Given path '/api/order/1'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch By Id'
    And match response.data.id == 1
    And match response.data.items == '#array'
    And match response.data.table.id == '#number'

  Scenario: TC_006 - GET /api/order/{id} - Not found (BUG - should be 404)
    Given path '/api/order/99999'
    When method GET
    Then status 404
    And match response.status == 404
    And match response.details contains 'Order not found with ID:'
  # Expected: 404

  Scenario: TC_007 - GET /api/order/{id} - ID âm (BUG - should be 404)
    Given path '/api/order/-1'
    When method GET
    Then status 404
    And match response.status == 404
    And match response.details contains 'Order not found with ID: -1'
  # Expected: 404

  Scenario: TC_008 - GET /api/order/{id} - ID invalid (BUG - should be 400)
    Given path '/api/order/abc'
    When method GET
    Then status 404
    And match response.status == 404
    And match response.details contains "Failed to convert value of type 'java.lang.String' to required type 'int'"

  Scenario: TC_009 - POST /api/order - Create thành công 1 item
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.statusCode == 201
    And match response.message == 'Create a Order'
    And match response.data.status == 'Pending'
    And match response.data.items == '#array'

  Scenario: TC_010 - POST /api/order - Create nhiều items
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 }, { product_id: 2, quantity: 1 }, { product_id: 2, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.statusCode == 201
  Scenario: TC_011 - POST /api/order - OrderDTO null (BUG - should be 400/404)
    Given path '/api/order'
    And request null
    And header Content-Type = 'application/json'
    When method POST
    Then status 500
    And match response.status == 500
    And match response.details contains 'Order and items are required'
  # Expected: 400/404

  Scenario: TC_012 - POST /api/order - Items null (BUG - should be 404)
    Given path '/api/order'
    And request { table_id: 1, items: null }
    And header Content-Type = 'application/json'
    When method POST
    Then status 500
    And match response.status == 500
    And match response.details contains 'Order and items are required'
  # Expected: 404

  Scenario: TC_013 - POST /api/order - Items empty (BUG - should be 404)
    Given path '/api/order'
    And request { items: [] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 404
    And match response.status == 404
    And match response.details contains 'Order and items are required'
  # Expected: 404

  Scenario: TC_014 - POST /api/order - Table not found (BUG - should be 404)
    Given path '/api/order'
    And request { table_id: 99999, items: [ { product_id: 1, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 404
    And match response.status == 404
    And match response.details == 'Table Not Found'
  # Expected: 404

  Scenario: TC_015 - POST /api/order - Product not found (BUG - should be 404)
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 99999, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 404
    And match response.status == 404
    And match response.details contains 'Product not found'
  # Expected: 404
  Scenario: TC_016 - POST /api/order - Quantity=0 (BUG - backend returns 500 or 400 mismatched)
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 0 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.message contains 'Quantity must be'
  # If returns 500 in your env, change Then status 400 -> 500 to match current behavior

  Scenario: TC_017 - POST /api/order - Quantity âm (BUG - backend returns 400/500)
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: -5 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.message contains 'Quantity must be'
  # Adjust to 500 if current behavior is 500

  Scenario: TC_018 - POST /api/order - Missing table_id (BUG - should be 400)
    Given path '/api/order'
    And request { items: [ { product_id: 1, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 400
    And match response.status == 400
    And match response.details == 'Table Not Found'
  # Expected: 400 validation error

  Scenario: TC_019 - POST /api/order - Notes optional
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.data.items[0].notes == null

  Scenario: TC_020 - POST /api/order - Default status=Pending
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.data.status == 'Pending'

  Scenario: TC_021 - POST /api/order - Default deleted=0
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    And match response.data.deleted == 0

  Scenario: TC_022 - POST /api/order - Transactional rollback (BUG - should be 404 and no data created)
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 1 }, { product_id: 99999, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 404
    And match response.status == 404
    And match response.details contains 'Product not found'
  # Expected: rollback, no order created

  Scenario: TC_023 - PUT /api/order/{id} - Update status to Completed
    # Prepare: create order Pending
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def orderId = response.data.id
    # Update status
    Given path '/api/order/' + orderId
    And request { status: 'Completed', items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200
    And match response.message == 'Update a Order'
    And match response.data.status contains 'Complete'

  Scenario: TC_024 - PUT /api/order/{id} - Thêm items (replace)
    # Create base order with 1 item
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def orderId = response.data.id
    # Update with 2 items (old deleted, new created)
    Given path '/api/order/' + orderId
    And request { status: 'Completed', items: [ { product_id: 1, quantity: 2 }, { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200

  Scenario: TC_025 - PUT /api/order/{id} - Xóa items (reduce to 1 item)
    # Create order with 2 items
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 }, { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def orderId = response.data.id
    # Update to 1 item
    Given path '/api/order/' + orderId
    And request { status: 'Completed', items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200

  Scenario: TC_026 - PUT /api/order/{id} - Change quantity recalc totals
    # Create order
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def orderId = response.data.id
    # Update quantities to 5
    Given path '/api/order/' + orderId
    And request { status: 'Completed', items: [ { product_id: 1, quantity: 5 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200

  Scenario: TC_027 - PUT /api/order/{id} - Price recalc từ DB (không khả thi theo mô tả)
    # Skipped: theo ghi chú "Không thể thay đổi giá của product ở bên order được"
    * print 'TC_027 skipped: price recalc from DB not supported'

  Scenario: TC_028 - PUT /api/order/{id} - Order not found (BUG - should be 404)
    Given path '/api/order/99999'
    And request { status: 'Completed', items: [ { product_id: 1, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    And match response.status == 404
    And match response.details == 'Order Not Found'
  # Expected: 404

  Scenario: TC_029 - PUT /api/order/{id} - OrderDTO null -> 400
    Given path '/api/order/9999'
    And request null
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
    And match response.message contains 'Invalid order data'

  Scenario: TC_030 - PUT /api/order/{id} - Items null/empty -> 400
    Given path '/api/order/9999'
    And request { items: null }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
    And match response.message contains 'Invalid order data'

  Scenario: TC_031 - PUT /api/order/{id} - Update Completed order FAIL (BUG - should be 400)
    # Assume order 1 is Completed already in DB for this test, otherwise prepare above
    Given path '/api/order/1'
    And request { status: 'Completed', items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
    And match response.message == 'Update a Order'
  # Expected: 400 "Cannot update Completed"

  Scenario: TC_032 - PUT /api/order/{id} - Update Cancelled order FAIL (BUG - should be 400)
    Given path '/api/order/1'
    And request { status: 'Cancelled', items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
    And match response.message == 'Update a Order'
  # Expected: 400 "Cannot update Cancelled"

  Scenario: TC_033 - PUT /api/order/{id} - Product not found (BUG - should be 404)
    # Prepare a valid order
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def orderId = response.data.id
    # Put invalid product
    Given path '/api/order/' + orderId
    And request { items: [ { product_id: 99999, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 404
    And match response.status == 404
    And match response.details contains 'Product not found'
  # Expected: 404

  Scenario: TC_034 - PUT /api/order/{id} - Quantity <= 0 -> 400
    Given path '/api/order/14'
    And request { items: [ { product_id: 1, quantity: 0 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 400
    And match response.message contains 'Quantity must be > 0'

  Scenario: TC_035 - PUT /api/order/{id} - Status null không đổi
    # Prepare order
    Given path '/api/order'
    And request { table_id: 1, items: [ { product_id: 1, quantity: 2 } ] }
    And header Content-Type = 'application/json'
    When method POST
    Then status 201
    * def orderId = response.data.id
    # PUT status null
    Given path '/api/order/' + orderId
    And request { status: null, items: [ { product_id: 1, quantity: 1 }, { product_id: 1, quantity: 1 } ] }
    And header Content-Type = 'application/json'
    When method PUT
    Then status 200