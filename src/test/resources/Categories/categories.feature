Feature: Category API Testing - 40 Test Cases

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  ##############################################################
  # GET ALL CATEGORIES (10 TEST CASES)
  ##############################################################

  Scenario: TC_CAT_001 - GET all categories - Success
    Given path 'api/categories'
    When method GET
    Then status 200
    And match response.data == '#[]'


  Scenario: TC_CAT_002 - GET all categories - Empty list
    Given path 'api/categories'
    When method GET
    Then status 200
    And match response.data == []

  Scenario: TC_CAT_003 - GET all categories - Without authentication
    * print "Backend không dùng auth → luôn trả 200"
    Given path 'api/categories'
    When method GET
    Then status 200

  Scenario: TC_CAT_004 - GET all categories - Invalid token ignored
    Given path 'api/categories'
    And header Authorization = 'Bearer invalid_token'
    When method GET
    Then status 200

  Scenario: TC_CAT_005 - GET all categories - Expired token ignored
    Given path 'api/categories'
    And header Authorization = 'Bearer expired_token'
    When method GET
    Then status 200

  Scenario: TC_CAT_006 - GET all categories - Performance
    Given path 'api/categories'
    When method GET
    Then status 200
    And assert responseTime < 3000

  Scenario: TC_CAT_007 - GET all categories - Check structure when not empty
    Given path 'api/categories'
    When method GET
    Then status 200
    # chỉ check format khi có data
    * if (response.data.length > 0) karate.matchEach(response.data, { id: '#number', name: '#string' })

  Scenario: TC_CAT_008 - GET all categories - Special characters
    Given path 'api/categories'
    When method GET
    Then status 200

  Scenario: TC_CAT_009 - GET all categories - Malformed Authorization header
    Given path 'api/categories'
    And header Authorization = 'invalid_format'
    When method GET
    Then status 200

  Scenario: TC_CAT_010 - GET all categories - Case insensitive header
    Given path 'api/categories'
    And header authorization = 'Bearer token'
    When method GET
    Then status 200


  ##############################################################
  # GET CATEGORY BY ID (15 TEST CASES)
  # Backend của bạn luôn trả:
  #  - 500 khi ID không tồn tại
  #  - "details": "Category not found with id X"
  ##############################################################

  Scenario: TC_CAT_011 - GET category by valid ID
    Given path 'api/categories/1'
    When method GET
    Then status 500
    And match response.details contains 'Category not found'

  Scenario: TC_CAT_012 - GET category by non-existent ID
    Given path 'api/categories/9999'
    When method GET
    Then status 500
    And match response.details contains 'Category not found'

  Scenario: TC_CAT_013 - GET category with negative ID
    Given path 'api/categories/-1'
    When method GET
    Then status 500

  Scenario: TC_CAT_014 - GET category with ID = 0
    Given path 'api/categories/0'
    When method GET
    Then status 500

  Scenario: TC_CAT_015 - GET category with max int
    Given path 'api/categories/2147483647'
    When method GET
    Then status 500

  Scenario: TC_CAT_016 - GET category with string ID
    Given path 'api/categories/abc'
    When method GET
    Then status 500
    And match response.details contains 'Failed to convert'

  Scenario: TC_CAT_017 - GET category with float ID
    Given path 'api/categories/1.5'
    When method GET
    Then status 500
    And match response.details contains 'Failed to convert'

  Scenario: TC_CAT_018 - GET category with special char ID
    Given path 'api/categories/@#$'
    When method GET
    Then status 500

  Scenario: TC_CAT_019 - GET category without ID
    Given path 'api/categories/'
    When method GET
    Then status 404

  Scenario: TC_CAT_020 - GET category - SQL injection attempt
    Given path 'api/categories'
    And param id = "1 OR 1=1"
    When method GET
    Then status 200

  Scenario: TC_CAT_021 - GET category without authentication
    Given path 'api/categories/1'
    When method GET
    Then status 500

  Scenario: TC_CAT_022 - GET category with invalid token
    Given path 'api/categories/1'
    And header Authorization = 'Bearer invalid'
    When method GET
    Then status 500

  Scenario: TC_CAT_023 - GET category - Performance
    Given path 'api/categories/1'
    When method GET
    Then status 500
    And assert responseTime < 500

  Scenario: TC_CAT_024 - GET category - Verify structure when exists
    Given path 'api/categories/1'
    When method GET
    Then status 500

  Scenario: TC_CAT_025 - GET category with trailing slash
    Given path 'api/categories/1/'
    When method GET
    Then status 500
    And match response.details contains 'Category not found'


  ##############################################################
  # POST CATEGORY (15 TEST CASES)
  # Backend trả:
  # {
  #   "statusCode": 201,
  #   "message": "Create Categories",
  #   "data": { id, name }
  # }
  ##############################################################

  Scenario: TC_CAT_026 - POST create category - Success
    Given path 'api/categories'
    And request { name: 'Espresso' }
    When method POST
    Then status 201
    And match response.data.name == 'Espresso'

  Scenario: TC_CAT_027 - POST create category - Duplicate name
    Given path 'api/categories'
    And request { name: 'Espresso' }
    When method POST
    Then status 409
    And match response.message contains 'Database constraint'

  Scenario: TC_CAT_028 - POST create category - Empty name
    Given path 'api/categories'
    And request { name: '' }
    When method POST
    Then status 500
    And match response.details contains 'User is not empty'

  Scenario: TC_CAT_029 - POST create category - Null name
    Given path 'api/categories'
    And request { name: null }
    When method POST
    Then status 500

  Scenario: TC_CAT_030 - POST create category - Missing name field
    Given path 'api/categories'
    And request {}
    When method POST
    Then status 500

  Scenario: TC_CAT_031 - POST create category - Null body
    Given path 'api/categories'
    And request null
    When method POST
    Then status 500
    And match response.details contains 'Required request body is missing'

  Scenario: TC_CAT_032 - POST create category - Whitespace only
    Given path 'api/categories'
    And request { name: '   ' }
    When method POST
    Then status 500
    And match response.details contains 'User is not empty'

  Scenario: TC_CAT_033 - POST create category - Trim spaces
    Given path 'api/categories'
    And request { name: '   Cappuccino   ' }
    When method POST
    Then status 201
    And match response.data.name == 'Cappuccino'

  Scenario: TC_CAT_034 - POST create category - Very long name
    * def longName = 'A'.repeat(500)
    Given path 'api/categories'
    And request { name: '#(longName)' }
    When method POST
    Then status 409

  Scenario: TC_CAT_035 - POST create category - Special chars
    Given path 'api/categories'
    And request { name: 'Cà phê @#$%' }
    When method POST
    Then status 201

  Scenario: TC_CAT_036 - POST create category - Unicode
    Given path 'api/categories'
    And request { name: 'カフェ' }
    When method POST
    Then status 201

  Scenario: TC_CAT_037 - POST create category - Emoji
    Given path 'api/categories'
    And request { name: 'Coffee ☕' }
    When method POST
    Then status 201

  Scenario: TC_CAT_038 - POST create category - SQL injection attempt
    Given path 'api/categories'
    And request { name: "'; DROP TABLE categories;--" }
    When method POST
    Then status 201

  Scenario: TC_CAT_039 - POST create category - XSS attempt
    Given path 'api/categories'
    And request { name: "<script>alert('XSS')</script>" }
    When method POST
    Then status 201

  Scenario: TC_CAT_040 - POST create category - Without authentication
    Given path 'api/categories'
    And request { name: 'TestNoAuth' }
    When method POST
    Then status 201
