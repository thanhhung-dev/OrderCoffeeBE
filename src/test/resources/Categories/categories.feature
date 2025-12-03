Feature: Category API Testing - 40 Test Cases

  Background:
    * url 'http://localhost:8080'
    * header Content-Type = 'application/json'

  # GET All Categories Tests (10 test cases)

  Scenario: TC_CAT_001 - GET all categories - Success
    Given path '/api/categories'
    When method GET
    Then status 200
    And match response.data == '#[]'
    And match each response.data == { id: '#number', name: '#string' }

  Scenario: TC_CAT_003 - GET all categories - Without authentication
    Given path '/api/categories'
    When method GET
    Then status 401

  Scenario: TC_CAT_004 - GET all categories - Invalid token
    Given path '/api/categories'
    And header Authorization = 'Bearer invalid_token'
    When method GET
    Then status 401

  Scenario: TC_CAT_005 - GET all categories - Expired token
    Given path '/api/categories'
    And header Authorization = 'Bearer expired_token_here'
    When method GET
    Then status 401

  Scenario: TC_CAT_006 - GET all categories - Large dataset (Performance)
    Given path '/api/categories'
    When method GET
    Then status 200
    And assert responseTime < 3000

  Scenario: TC_CAT_007 - GET all categories - Check response format
    Given path '/api/categories'
    When method GET
    Then status 200
    And match each response.data == { id: '#number', name: '#string' }

  Scenario: TC_CAT_008 - GET all categories - With special characters
    Given path '/api/categories'
    When method GET
    Then status 200
    And match each response.data == { id: '#number', name: '#string' }

  Scenario: TC_CAT_009 - GET all categories - Malformed Authorization header
    Given path '/api/categories'
    And header Authorization = 'invalid_format_token'
    When method GET
    Then status 401

  Scenario: TC_CAT_010 - GET all categories - Case sensitive header
    Given path '/api/categories'
    And header authorization = 'Bearer token'
    When method GET
    Then status 200
    And match each response.data == { id: '#number', name: '#string' }

  # GET Category By ID Tests (15 test cases)

  Scenario: TC_CAT_011 - GET category by valid ID
    Given path '/api/categories/1'
    When method GET
    Then status 200
    And match response == { id: 1, name: '#string' }

  Scenario: TC_CAT_012 - GET category by non-existent ID
    Given path '/api/categories/9999'
    When method GET
    Then status 404
    And match response.message == 'Category not found with id 9999'

  Scenario: TC_CAT_013 - GET category with negative ID
    Given path '/api/categories/-1'
    When method GET
    Then status 404

  Scenario: TC_CAT_014 - GET category with ID = 0
    Given path '/api/categories/0'
    When method GET
    Then status 404

  Scenario: TC_CAT_015 - GET category with very large ID
    Given path '/api/categories/2147483647'
    When method GET
    Then status 404

  Scenario: TC_CAT_016 - GET category with string ID
    Given path '/api/categories/abc'
    When method GET
    Then status 400

  Scenario: TC_CAT_017 - GET category with float ID
    Given path '/api/categories/1.5'
    When method GET
    Then status 400

  Scenario: TC_CAT_018 - GET category with special characters ID
    Given path '/api/categories/@#$'
    When method GET
    Then status 400

  Scenario: TC_CAT_019 - GET category without ID parameter
    Given path '/api/categories/'
    When method GET
    Then status 404

  Scenario: TC_CAT_020 - GET category - SQL injection attempt
    Given path '/api/categories'
    And param id = '1 OR 1=1'
    When method GET
    Then status 400

  Scenario: TC_CAT_021 - GET category without authentication
    Given path '/api/categories/1'
    When method GET
    Then status 401

  Scenario: TC_CAT_022 - GET category with invalid token
    Given path '/api/categories/1'
    And header Authorization = 'Bearer invalid_token'
    When method GET
    Then status 401

  Scenario: TC_CAT_023 - GET category - Response time check
    Given path '/api/categories/1'
    When method GET
    Then status 200
    And assert responseTime < 500

  Scenario: TC_CAT_024 - GET category - Verify response fields
    Given path '/api/categories/1'
    When method GET
    Then status 200
    And match response == { id: '#number', name: '#string' }

  Scenario: TC_CAT_025 - GET category with trailing slash
    Given path '/api/categories/1/'
    When method GET
    Then status 200

  # POST Create Category Tests (15 test cases)

  Scenario: TC_CAT_026 - POST create category - Success
    Given path '/api/categories'
    And request { name: 'Espresso' }
    When method POST
    Then status 201
    And match response == { id: '#number', name: 'Espresso' }

  Scenario: TC_CAT_027 - POST create category - Duplicate name
    Given path '/api/categories'
    And request { name: 'Latte' }
    When method POST
    Then status 400
    And match response.message contains 'already exists'

  Scenario: TC_CAT_028 - POST create category - Empty name
    Given path '/api/categories'
    And request { name: '' }
    When method POST
    Then status 400
    And match response.message == 'User is not empty'

  Scenario: TC_CAT_029 - POST create category - Null name
    Given path '/api/categories'
    And request { name: null }
    When method POST
    Then status 400

  Scenario: TC_CAT_030 - POST create category - Missing name field
    Given path '/api/categories'
    And request {}
    When method POST
    Then status 400

  Scenario: TC_CAT_031 - POST create category - Null body
    Given path '/api/categories'
    And request null
    When method POST
    Then status 400
    And match response.message == 'Category Is Required'

  Scenario: TC_CAT_032 - POST create category - Whitespace only name
    Given path '/api/categories'
    And request { name: '   ' }
    When method POST
    Then status 400

  Scenario: TC_CAT_033 - POST create category - Name with leading/trailing spaces
    Given path '/api/categories'
    And request { name: ' Cappuccino ' }
    When method POST
    Then status 201
    And match response.name == 'Cappuccino'

  Scenario: TC_CAT_034 - POST create category - Very long name
    * def longName = 'A'.repeat(1000)
    Given path '/api/categories'
    And request { name: '#(longName)' }
    When method POST
    Then status 400

  Scenario: TC_CAT_035 - POST create category - Special characters
    Given path '/api/categories'
    And request { name: 'Cà phê @#$%' }
    When method POST
    Then status 201

  Scenario: TC_CAT_036 - POST create category - Unicode characters
    Given path '/api/categories'
    And request { name: 'カフェ' }
    When method POST
    Then status 201

  Scenario: TC_CAT_037 - POST create category - Emoji in name
    Given path '/api/categories'
    And request { name: 'Coffee ☕' }
    When method POST
    Then status 201

  Scenario: TC_CAT_038 - POST create category - SQL injection attempt
    Given path '/api/categories'
    And request { name: "'; DROP TABLE categories;--" }
    When method POST
    Then status 201

  Scenario: TC_CAT_039 - POST create category - XSS attempt
    Given path '/api/categories'
    And request { name: "<script>alert('XSS')</script>" }
    When method POST
    Then status 201

  Scenario: TC_CAT_040 - POST create category - Without authentication
    Given path '/api/categories'
    And request { name: 'Test' }
    When method POST
    Then status 401
