Feature: Login API

  Scenario: TEST 1
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "thanhhung12",
        "password": "1235699@"
      }
      """
    When method POST
    Then status 200
  Scenario: TEST 2
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "",
        "password": "1235699@"
      }
      """
    When method POST
    Then status 400
  Scenario: TEST 3
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "thanhhung12",
        "password": ""
      }
      """
    When method POST
    Then status 400
  Scenario: TEST 4
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "password": "1235699@"
      }
      """
    When method POST
    Then status 400
  Scenario: TEST 5
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "password": ""
      }
      """
    When method POST
    Then status 400
  Scenario: TEST 6
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "",
        "password": ""
      }
      """
    When method POST
    Then status 400
  Scenario: TEST 7
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "wronguser123",
        "password": "1235699"
      }
      """
    When method POST
    Then status 401
  Scenario: TEST 8
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "thanhhung12",
        "password": "wrongpass123"
      }
      """
    When method POST
    Then status 401
  Scenario: TEST 9
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "admin' OR '1'='1",
        "password": "1235699@"
      }
      """
    When method POST
    Then status 401
  Scenario: TEST 10
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "<script>alert('XSS')</script>",
        "password": "1235699@"
      }
      """
    When method POST
    Then status 401
  Scenario: TEST 11
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "thanhhung12",
        "password": "!@#$%^&*()"
      }
      """
    When method POST
    Then status 401

  Scenario: TEST 12
    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
        "password": "!@#$%^&*()"
      }
      """
    When method POST
    Then status 401

