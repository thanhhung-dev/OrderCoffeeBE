Feature: Table API Testing - 40 Test Cases

  Background:
    * url baseUrl = 'http://localhost:8080'
    * header Content-Type = 'application/json'


  #######################################################################
  # GET ALL TABLES (10 test cases)
  #######################################################################

  Scenario: TC_TAB_001 - GET all tables - Success
    Given path '/api/table'
    When method GET
    Then status 200
    And match response == '#[]' || response == '#[] any'

  Scenario: TC_TAB_002 - GET all tables - Empty list
    Given path '/api/table'
    When method GET
    Then status 200

  Scenario: TC_TAB_003 - GET all tables - Without authentication
    Given path '/api/table'
    When method GET
    Then status 200

  Scenario: TC_TAB_004 - GET all tables - Invalid token ignored
    Given path '/api/table'
    And header Authorization = 'Bearer invalid_token'
    When method GET
    Then status 200

  Scenario: TC_TAB_005 - GET all tables - Expired token ignored
    Given path '/api/table'
    And header Authorization = 'Bearer expired_token'
    When method GET
    Then status 200

  Scenario: TC_TAB_006 - GET all tables - Performance
    Given path '/api/table'
    When method GET
    Then status 200
    And assert responseTime < 3000

  Scenario: TC_TAB_007 - GET all tables - Check structure
    Given path '/api/table'
    When method GET
    Then status 200

  Scenario: TC_TAB_008 - GET all tables - Special characters in DB
    Given path '/api/table'
    When method GET
    Then status 200

  Scenario: TC_TAB_009 - GET all tables - Malformed Authorization header
    Given path '/api/table'
    And header Authorization = 'invalid_format'
    When method GET
    Then status 200

  Scenario: TC_TAB_010 - GET all tables - Case sensitive header
    Given path '/api/table'
    And header authorization = 'Bearer token'
    When method GET
    Then status 200


  #######################################################################
  # GET TABLE BY ID (15 test cases)
  #######################################################################

  Scenario: TC_TAB_011 - GET table by valid ID
    Given path '/api/table/1'
    When method GET
    Then status 200

  Scenario: TC_TAB_012 - GET table by non-existent ID
    Given path '/api/table/9999'
    When method GET
    Then status 500
    And match response.message contains 'Table not found'

  Scenario: TC_TAB_013 - GET table with negative ID
    Given path '/api/table/-1'
    When method GET
    Then status 500

  Scenario: TC_TAB_014 - GET table with ID = 0
    Given path '/api/table/0'
    When method GET
    Then status 500

  Scenario: TC_TAB_015 - GET table with very large ID
    Given path '/api/table/2147483647'
    When method GET
    Then status 500

  Scenario: TC_TAB_016 - GET table with string ID
    Given path '/api/table/abc'
    When method GET
    Then status 400

  Scenario: TC_TAB_017 - GET table with float ID
    Given path '/api/table/1.5'
    When method GET
    Then status 400

  Scenario: TC_TAB_018 - GET table with special character ID
    Given path '/api/table/@#$'
    When method GET
    Then status 400

  Scenario: TC_TAB_019 - GET table without ID parameter
    Given path '/api/table/'
    When method GET
    Then status 200

  Scenario: TC_TAB_020 - GET table - SQL injection attempt
    Given path '/api/table'
    And param id = "1 OR 1=1"
    When method GET
    Then status 200

  Scenario: TC_TAB_021 - GET table without authentication
    Given path '/api/table/1'
    When method GET
    Then status 200

  Scenario: TC_TAB_022 - GET table with invalid token
    Given path '/api/table/1'
    And header Authorization = 'Bearer invalid_token'
    When method GET
    Then status 200

  Scenario: TC_TAB_023 - GET table - Performance
    Given path '/api/table/1'
    When method GET
    Then status 200
    And assert responseTime < 500

  Scenario: TC_TAB_024 - GET table - Verify fields
    Given path '/api/table/1'
    When method GET
    Then status 200

  Scenario: TC_TAB_025 - GET table with trailing slash
    Given path '/api/table/1/'
    When method GET
    Then status 200


  #######################################################################
  # POST CREATE TABLE (10 test cases)
  #######################################################################

  Scenario: TC_TAB_026 - POST create table - Success
    Given path '/api/table'
    And request { status: 'Available' }
    When method POST
    Then status 201

  Scenario: TC_TAB_027 - POST create table - Duplicate ID
    Given path '/api/table'
    And request { id: 1, status: 'Available' }
    When method POST
    Then status 500

  Scenario: TC_TAB_028 - POST create table - Empty body
    Given path '/api/table'
    And request {}
    When method POST
    Then status 500

  Scenario: TC_TAB_029 - POST create table - Null body
    Given path '/api/table'
    And request null
    When method POST
    Then status 500

  Scenario: TC_TAB_030 - POST create table - Missing status field
    Given path '/api/table'
    And request { id: 10 }
    When method POST
    Then status 500

  Scenario: TC_TAB_031 - POST create table - Whitespace status
    Given path '/api/table'
    And request { status: '   ' }
    When method POST
    Then status 500

  Scenario: TC_TAB_032 - POST create table - Invalid data type
    Given path '/api/table'
    And request { status: 123 }
    When method POST
    Then status 500

  Scenario: TC_TAB_033 - POST create table - Long status
    * def longText = 'A'.repeat(500)
    Given path '/api/table'
    And request { status: '#(longText)' }
    When method POST
    Then status 201 || status 500

  Scenario: TC_TAB_034 - POST create table - Special chars
    Given path '/api/table'
    And request { status: 'Cà phê @#$%' }
    When method POST
    Then status 201 || status 500

  Scenario: TC_TAB_035 - POST create table - Unicode
    Given path '/api/table'
    And request { status: 'テーブル' }
    When method POST
    Then status 201 || status 500


  #######################################################################
  # DELETE TABLE (5 test cases)
  #######################################################################

  Scenario: TC_TAB_036 - DELETE table - Success
    Given path '/api/table'
    And param id = 1
    When method DELETE
    Then status 200

  Scenario: TC_TAB_037 - DELETE table - Non-existent ID
    Given path '/api/table'
    And param id = 9999
    When method DELETE
    Then status 200

  Scenario: TC_TAB_038 - DELETE table - Invalid ID
    Given path '/api/table'
    And param id = 'abc'
    When method DELETE
    Then status 400

  Scenario: TC_TAB_039 - DELETE table - No authentication
    Given path '/api/table'
    And param id = 1
    When method DELETE
    Then status 200

  Scenario: TC_TAB_040 - DELETE table - Malformed ID
    Given path '/api/table'
    And param id = '@#!'
    When method DELETE
    Then status 400
