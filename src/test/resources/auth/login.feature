Feature: Login API

  Scenario: TC-TUR-01	Đăng nhập với thông tin hợp lệ

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 200
  Scenario: TC-TUR-02	Đăng nhập với password sai

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": "nam123"
      }
      """
    When method POST
    Then status 401
  Scenario: TC-TUR-03	Đăng nhập với username không tồn tại

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "nam5678",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 401
  Scenario: TC-TUR-04	Đăng nhập với username trống

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400
  Scenario: TC-TUR-05	Đăng nhập với password trống

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": ""
      }
      """
    When method POST
    Then status 400
  Scenario: TC-TUR-06	Đăng nhập kiểm tra phân biệt chữ hoa/thường của username

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NhatNam",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 200
  Scenario: TC-TUR-07	Đăng nhập kiểm tra phân biệt chữ hoa/thường của password

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": "pass@123"
      }
      """
    When method POST
    Then status 401
  Scenario: TC-TUR-08	Đăng nhập với username là số

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "123456",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 200
  Scenario: TC-TUR-09	Đăng nhập với SQL injection

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM' OR '1'='1",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 401
  Scenario: TC-TUR-10	Đăng nhập với password có ký tự đặc biệt

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": "P@$$w0rd!"
      }
      """
    When method POST
    Then status 401
  Scenario: TC-TUR-11	Đăng nhập thiếu trường password

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-12	Đăng nhập với username là khoảng trắng

    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-13	Login username là email


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "nhatnam123@example.com",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 401

  Scenario: TC-TUR-14	Login password chỉ chữ thường


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": "pass@123
    "
      }
      """
    When method POST
    Then status 401

  Scenario: TC-TUR-15	Login password chỉ chữ hoa


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": "PASS@123"
      }
      """
    When method POST
    Then status 401

  Scenario: TC-TUR-16	Login password chỉ số


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": "1234567890"
      }
      """
    When method POST
    Then status 401

  Scenario: TC-TUR-17	Login username + password ký tự escape


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHAT\NAM",
        "password": "Pass\123"
      }
      """
    When method POST
    Then status 200

  Scenario: TC-TUR-18	Login username có khoảng trắng đầu và cuối


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": " NHATNAM",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 401

  Scenario: TC-TUR-19	Login username toàn số


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "12345658",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 200

  Scenario: TC-TUR-20	Login username cực dài (50 ký tự)


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 401

  Scenario: TC-TUR-21	Login password có khoảng trắng đầu


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "NHATNAM",
        "password": " Pass@123"
      }
      """
    When method POST
    Then status 401

  Scenario: TC-TUR-22	Login username + password rỗng


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

  Scenario: TC-TUR-23	Login username không tồn tại + password đặc biệt


    Given url 'http://localhost:8080/api/auth/login'
    And request
      """
      {
        "username": "hckdnhk",
        "password": "@#$Pass123"
      }
      """
    When method POST
    Then status 401

