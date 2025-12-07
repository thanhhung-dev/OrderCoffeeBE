
Feature: Product API Testing - Full 45 Test Cases

  Background:
    * url 'http://localhost:8080'

  # ==================== GET /api/products - Get All Products ====================

  Scenario: TC_001 - GET /api/products - Lấy tất cả sản phẩm thành công
    Given path '/api/products'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch Product'
    And match response.data == '#array'
    And match response.error == null

  Scenario: TC_002 - GET /api/products - Verify response structure
    Given path '/api/products'
    When method GET
    Then status 200
    And match response.data == '#array'
    And match each response.data ==
      """
      {
        id: '#number',
        name: '##string',
        description: '##string',
        price: '#number',
        image: '##string',
        createdAt: '#string',
        updatedAt: '#string',
        status: '#number',
        category: {
          id: '#number',
          name: '#string'
        }
      }
      """

  Scenario: TC_003 - GET /api/products - Verify ApiMessage header
    Given path '/api/products'
    When method GET
    Then status 200
    And match response.message == 'Fetch Product'

  # ==================== GET /api/products/{id} - Get Product by ID ====================

  Scenario: TC_004 - GET /api/products/{id} - Lấy product by ID thành công
    Given path '/api/products/1'
    When method GET
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Fetch By Id Product'
    And match response.data.id == 1
    And match response.data.category != null
    And match response.error == null

  Scenario: TC_005 - GET /api/products/{id} - Product không tồn tại (BUG - Should return 404)
    Given path '/api/products/9999'
    When method GET
    Then status 404
    And match response.status == 404
    And match response.details contains 'Product not found with id: 9999'
  # Expected: status 404

  Scenario: TC_006 - GET /api/products/{id} - ID âm (BUG - Should return 404)
    Given path '/api/products/-1'
    When method GET
    Then status 404
    And match response.status == 404
    And match response.details contains 'Product not found with id: -1'
  # Expected: status 404

  Scenario: TC_007 - GET /api/products/{id} - ID không phải số (BUG - Should return 400)
    Given path '/api/products/abc'
    When method GET
    Then status 400
    And match response.status == 400
    And match response.details contains "Failed to convert value of type 'java.lang.String' to required type 'java.lang.Integer'"
  # Expected: status 400

  Scenario: TC_008 - GET /api/products/{id} - ID = 0 (BUG - Should return 404)
    Given path '/api/products/0'
    When method GET
    Then status 404
    And match response.status == 404
    And match response.details contains 'Product not found with id: 0'
  # Expected: status 404

  Scenario: TC_009 - GET /api/products/{id} - Verify category data
    Given path '/api/products/1'
    When method GET
    Then status 200
    And match response.data.category != null
    And match response.data.category.id == '#number'
    And match response.data.category.name == '#string'

  Scenario: TC_010 - GET /api/products/{id} - Verify image field
    Given path '/api/products/1'
    When method GET
    Then status 200
    And match response.data.image == '#present'

  # ==================== POST /api/products - Create Product ====================

  Scenario: TC_011 - POST /api/products - Tạo product thành công với image
    Given path '/api/products'
    And multipart field name = 'Test Product Karate'
    And multipart field description = 'Test Description'
    And multipart field price = 25000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 201
    And match response.statusCode == 201
    And match response.message == 'Create Product'
    And match response.data.name == 'Test Product Karate'
    And match response.data.price == 25000
    And match response.data.imageUrl == '#string'

  Scenario: TC_012 - POST /api/products - Tạo product không có image (optional)
    Given path '/api/products'
    And multipart field name = 'Espresso'
    And multipart field description = 'Strong coffee'
    And multipart field price = 35000
    And multipart field status = 1
    And multipart field category_id = 1
    When method POST
    Then status 403
    And match response.message == 'Access denied'
  # Note: API requires image field

  Scenario: TC_013 - POST /api/products - Category không tồn tại (BUG - Should return 404)
    Given path '/api/products'
    And multipart field name = 'Test Product'
    And multipart field description = 'Test'
    And multipart field price = 10000
    And multipart field status = 1
    And multipart field category_id = 99999
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 404
    And match response.status == 404
    And match response.details == 'Category not found'
  # Expected: status 404

  Scenario: TC_014 - POST /api/products - Missing required fields (name) (BUG - Should validate)
    Given path '/api/products'
    And multipart field description = 'Test'
    And multipart field price = 10000
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-imagetest.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 400
    And match response.data.name == null
  # Expected: status 400 with validation error

  Scenario: TC_015 - POST /api/products - Missing price (BUG - Should validate)
    Given path '/api/products'
    And multipart field name = 'Test Product'
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 400
    And match response.message == 'The server encountered an internal error'
  # Expected: status 400 with validation error

  Scenario: TC_016 - POST /api/products - Missing category_id (BUG - Should validate)
    Given path '/api/products'
    And multipart field name = 'Test'
    And multipart field price = 10000
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 400
    And match response.status == 400
    And match response.details == 'The given id must not be null'
  # Expected: status 400 with validation error

  Scenario: TC_017 - POST /api/products - Price âm (BUG - Should validate)
    Given path '/api/products'
    And multipart field name = 'Test Negative Price'
    And multipart field description = 'Test'
    And multipart field price = -10000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 400
    And match response.data. price == -10000
  # Expected: status 400 with validation error

  Scenario: TC_018 - POST /api/products - Name quá dài (BUG - Should validate length)
    * def longName = 'A'.repeat(500)
    Given path '/api/products'
    And multipart field name = longName
    And multipart field price = 10000
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 400
    And match response.status == 400
    And match response.message == 'Database constraint violation'
  # Expected: status 400 with validation error before DB

  Scenario: TC_019 - POST /api/products - Name empty string (BUG - Should validate)
    Given path '/api/products'
    And multipart field name = ''
    And multipart field description = 'Test'
    And multipart field price = 10000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 400
    And match response.data.name == ''
  # Expected: status 400 with validation error

  Scenario: TC_020 - POST /api/products - Upload file không phải image
    Given path '/api/products'
    And multipart field name = 'Test Non-Image File'
    And multipart field price = 10000
    And multipart field category_id = 1
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:text.txt', filename: 'test.txt' }
    When method POST
    Then status 201
    And match response.data.imageUrl contains '.txt'
  # Note: Should validate image file types (jpg, png, jpeg, gif)

  Scenario: TC_021 - POST /api/products - Duplicate product name (nếu có unique constraint)
    # First create a product
    Given path '/api/products'
    And multipart field name = 'Duplicate Test'
    And multipart field price = 10000
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:text.txt', filename: 'test.txt', contentType: 'text/plain' }
    When method POST
    Then status 201
    * def firstProductId = response.data.id

    # Try to create duplicate
    Given path '/api/products'
    And multipart field name = 'Duplicate Test'
    And multipart field price = 20000
    And multipart field category_id = 1
    And multipart file image = { read: 'test-image.jpg', filename: 'test2. jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 409
  # Note: Allows duplicates, should return 409 if unique constraint exists


  Scenario: TC_022 - POST /api/products - Verify database record
    # 1. Tạo product mới
    Given path '/api/products'
    And multipart field name = 'DB Verify Product'
    And multipart field description = 'Test DB Record'
    And multipart field price = 15000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 201
    And match response.statusCode == 201

    # 2. Lấy id product vừa tạo
    * def createdId = response.data.id


  Scenario: TC_023 - POST /api/products - Description optional
    Given path '/api/products'
    And multipart field name = 'Test No Desc'
    And multipart field description = ''
    And multipart field price = 10000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 201
    And match response.data.description == '#present'

  Scenario: TC_024 - POST /api/products - Verify ProductResponse structure
    Given path '/api/products'
    And multipart field name = 'Structure Test'
    And multipart field description = 'Test Structure'
    And multipart field price = 25000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 201
    And match response.data ==
      """
      {
        id: '#number',
        name: '#string',
        description: '##string',
        price: '#number',
        status: '#number',
        category_id: '#number',
        imageUrl: '#string'
      }
      """

  # ==================== PATCH /api/products/{id} - Update Product ====================

  Scenario: TC_025 - PATCH /api/products/{id} - Update product thành công với image mới
    Given path '/api/products/1'
    And multipart field name = 'Updated Latte'
    And multipart field description = 'New description'
    And multipart field price = 55000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method PATCH
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Update Product'
    And match response.data.name == 'Updated Latte'
    And match response.data.price == 55000

  Scenario: TC_026 - PATCH /api/products/{id} - Update product không thay đổi image
    * def productId = 1
    Given path '/api/products', productId
    And multipart field name = 'New Name'
    And multipart field description = 'New description'
    And multipart field price = 60000
    And multipart field category_id = 1
    And multipart field status = 1
    When method PATCH
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Update Product'

    And match response.data.id == productId
    And match response.data.name == 'New Name'
    And match response.data.price == 60000
    And match response.data.category_id == 1
    And match response.data.imageUrl == 'test-image.jpg'

  Scenario: TC_027 - PATCH /api/products/{id} - Product không tồn tại (BUG - Should return 404)
    Given path '/api/products/99999'
    And multipart field name = 'Test'
    And multipart field price = 10000
    And multipart field category_id = 1
    When method PATCH
    Then status 404
    And match response.status == 404
    And match response.details == 'Product Not Found'
  # Expected: status 404

  Scenario: TC_028 - PATCH /api/products/{id} - Update với category không tồn tại (BUG - Should return 404)
    Given path '/api/products/1'
    And multipart field category_id = 99999
    When method PATCH
    Then status 404
    And match response.status == 404
    And match response.details == 'Category not found'
  # Expected: status 404

  Scenario: TC_029 - PATCH /api/products/{id} - ProductDTO null (BUG - Should return 400)
    Given path '/api/products/1'
    When method PATCH
    Then status 400
    And match response.status == 400
  # Expected: status 400

  Scenario: TC_030 - PATCH /api/products/{id} - Update name empty (BUG - Should validate)
    Given path '/api/products/1'
    And multipart field name = ''
    And multipart field price = 10000
    And multipart field category_id = 1
    And multipart field status = 1
    When method PATCH
    Then status 400
    And match response.data. name == ''
  # Expected: status 400 with validation error

  Scenario: TC_031 - PATCH /api/products/{id} - Update price âm (BUG - Should validate)
    Given path '/api/products/1'
    And multipart field price = -10000
    And multipart field category_id = 1
    And multipart field status = 1
    When method PATCH
    Then status 400
    And match response.data.price == -10000
  # Expected: status 400 with validation error

  Scenario: TC_032 - PATCH /api/products/{id} - Update status field
    Given path '/api/products/1'
    And multipart field price = 10000
    And multipart field status = 0
    And multipart field category_id = 1
    When method PATCH
    Then status 200
    And match response.data.status == 0

  Scenario: TC_033 - PATCH /api/products/{id} - Update description
    Given path '/api/products/1'
    And multipart field description = 'New detailed description'
    And multipart field price = 10000
    And multipart field category_id = 1
    And multipart field status = 0
    When method PATCH
    Then status 200
    And match response.data.description == 'New detailed description'

  Scenario: TC_034 - PATCH /api/products/{id} - Update category
    Given path '/api/products/2'
    And multipart field category_id = 1
    And multipart field description = 'New detailed description'
    And multipart field price = 10000
    And multipart field status = 1
    When method PATCH
    Then status 200
    And match response.data.category_id == 1

  Scenario: TC_035 - PATCH /api/products/{id} - Update chỉ 1 field
    # Get original product first
    Given path '/api/products/2'
    When method GET
    And multipart field category_id = 1
    And multipart field description = 'New detailed description'
    And multipart field price = 10000
    And multipart field status = 1
    Then status 200


    # Update only name
    Given path '/api/products/2'
    And multipart field name = 'Only Name Changed'
    And multipart field category_id = 1
    And multipart field description = 'New detailed description'
    And multipart field price = 10000
    And multipart field status = 1
    When method PATCH
    Then status 200
    And match response.data.name == 'Only Name Changed'

  Scenario: TC_036 - PATCH /api/products/{id} - Update với image null (empty upload)
    Given path '/api/products/2'
    And multipart field name = 'Test Image Null'
    And multipart field description = 'New detailed description'
    And multipart field price = 10000
    And multipart field status = 1
    And multipart field category_id = 1
    When method PATCH
    Then status 200

  Scenario: TC_037 - PATCH /api/products/{id} - Update all fields cùng lúc
    Given path '/api/products/2'
    And multipart field name = 'New Name All'
    And multipart field description = 'New Desc'
    And multipart field price = 99000
    And multipart field status = 0
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test-image.jpg', filename: 'test-image.jpg', contentType: 'image/jpeg' }
    When method PATCH
    Then status 200
    And match response.data.name == 'New Name All'
    And match response.data.description == 'New Desc'
    And match response.data.price == 99000
    And match response.data.status == 0

  Scenario: TC_038 - PATCH /api/products/{id} - Upload image có special characters
    Given path '/api/products/2'
    And multipart field price = 99000
    And multipart field status = 0
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:test@323!.jpg', filename: 'test@323!.jpg', contentType: 'image/jpeg' }
    When method PATCH
    Then status 200
    And match response.data.imageUrl == 'test@323!.jpg'

  Scenario: TC_039 - PATCH /api/products/{id} - Upload image với Vietnamese filename
    * def productId = 3
    Given path '/api/products', productId
    And multipart field price = 99000
    And multipart field status = 0
    And multipart field category_id = 1
    And multipart file image = { read: 'classpath:cà_phê_việt.jpg', filename: 'cà_phê_việt.jpg', contentType: 'image/jpeg' }
    When method PATCH
    Then status 200
    And match response.statusCode == 200
    And match response.message == 'Update Product'

    # Kiểm tra imageUrl không null và có extension .jpg hoặc .jpeg
    And match response.data.imageUrl != null
    And match response.data.imageUrl contains '.jpg'

  Scenario: TC_040 - PATCH /api/products/{id} - Verify response structure
    Given path '/api/products/2'
    And multipart field name = 'Updated Product'
    And multipart field category_id = 1
    And multipart field price = 99000
    And multipart field status = 0
    When method PATCH
    Then status 200
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'Update Product',
        data: {
          id: '#number',
          name: '##string',
          description: '##string',
          price: '#number',
          status: '#number',
          category_id: '#number',
          imageUrl: '##string'
        }
      }
      """

  # ==================== DELETE /api/products/{id} - Delete Product ====================

  Scenario: TC_041 - DELETE /api/products/{id} - Product không tồn tại
    Given path '/api/products/9999'
    When method DELETE
    Then status 404
    And match response.status == 404
    And match response. details == 'Product not found'
  # Expected: status 404

  Scenario: TC_042 - DELETE /api/products/{id} - ID âm (BUG - Should return 404)
    Given path '/api/products/-1'
    When method DELETE
    Then status 404
    And match response.status == 404
  # Expected: status 404

  Scenario: TC_043 - DELETE /api/products/{id} - ID không phải số (BUG - Should return 400)
    Given path '/api/products/abc'
    When method DELETE
    Then status 400
    And match response.status == 400
    And match response.details contains "Failed to convert value of type 'java.lang.String' to required type 'int'"
  # Expected: status 400

  Scenario: TC_044 - DELETE /api/products/{id} - Verify database record deleted
    # First create a product to delete
    Given path '/api/products'
    And multipart field name = 'Product To Delete'
    And multipart field price = 10000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'test-image. jpg', filename: 'delete-test.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 201
    * def productIdToDelete = response.data.id

    # Delete the product
    Given path '/api/products/' + productIdToDelete
    When method DELETE
    Then status 200

    # Verify product is deleted by trying to get it
    Given path '/api/products/' + productIdToDelete
    When method GET
    Then status 404
    And match response.details contains 'Product not found'
  # Note: Due to foreign key constraint, actual delete may fail
  # Expected: status 404 when getting deleted product

  Scenario: TC_045 - DELETE /api/products/{id} - Response body is null
    # Create a product to delete
    Given path '/api/products'
    And multipart field name = 'Response Test Delete'
    And multipart field price = 10000
    And multipart field status = 1
    And multipart field category_id = 1
    And multipart file image = { read: 'test-image.jpg', filename: 'response-delete.jpg', contentType: 'image/jpeg' }
    When method POST
    Then status 201
    * def deleteProductId = response.data.id

    # Delete and check response
    Given path '/api/products/' + deleteProductId
    When method DELETE
    Then status 200
  # Note: Current implementation returns ResponseEntity. ok(null)
  # Expected: Should return proper response body or 204 No Content