Feature: register API

  Scenario: TC-TUR-01	Đăng ký người dùng không hợp lệ


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NHATNAM02540",
          "email": "nhatnam_an000@example.com",
        "phonenumber": "1234567890",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 201

  Scenario: TC-TUR-02	Đăng ký username toàn số


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "12345658",
        "email": "nhatnam151@example.com",
        "phonenumber": "123456789",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-03	Đăng ký người dùng với password trống


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NHATNAM13",
        "email": "nhatnam125@example.com",
        "phonenumber": "123456781",
        "password": ""
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-04  Đăng ký người dùng với username trống


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "",
        "email": "nhatnam124@example.com",
        "phonenumber": "123456780",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-05	Đăng ký người dùng với password yếu



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NHATNAM14",
        "email": "nhatnam126@example.com",
        "phonenumber": "123456782",
        "password": "123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-06	Đăng ký với username có ký tự đặc biệt



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NHATNAM@@#",
        "email": "nhatnama126@example.com",
        "phonenumber": "123456783",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 200

  Scenario: TC-TUR-07	Đăng ký người dùng với username độ dài tối đa



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "ABCDECGHIJKLMNOPQRSTUVWXYZABCD",
        "email": "nhatnam40009@example.com",
        "phonenumber": "1234567845",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 201

  Scenario: TC-TUR-08	Đăng ký người dùng vượt quá độ dài username tối đa



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA",
        "email": "nhatnam129@example.com",
        "phonenumber": "123456785",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-09	Đăng ký username là số



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "123456",
        "email": "nhatnam130@example.com",
        "phonenumber": "123456786",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-10	Đăng ký password dài tối đa



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NHATNAM10065",
        "email": "nhatnam510017@example.com",
        "phonenumber": "123456787",
        "password":"AAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
      }
      """
    When method POST
    Then status 201

  Scenario: TC-TUR-11	Đăng ký password vượt quá độ dài tối đa


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NHATNAM256s5",
        "email": "nhatnam11311@example.com",
        "phonenumber": "123456787",
        "password":"PPPPasdsafsdavzsadsdfzsdffedsádasdasdasdasdPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-12	Đăng ký SQL injection trong username


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NHATNAM'; DROP TABLE users;",
        "email": "nhatnam133@example.com",
        "phonenumber": "1234567890",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-13	Đăng ký thiếu trường username


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "email": "nhatnam134@example.com",
        "phonenumber": "1234567891",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-14	Đăng ký với email sai định dạng


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NAM14",
        "email": "nhatnam@@mail",
        "phonenumber": "123456789",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-15	Đăng ký với số điện thoại chứa chữ


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NAM1215",
        "email": "nhatnam1340@example.com",
        "phonenumber": "12345ABCD",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-16	Đăng ký email viết hoa



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NAM118",
        "email": "NHATNAM1351@EXAMPLE.COM",
        "phonenumber": "123456789",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-17	Đăng ký password chỉ ký tự đặc biệt




    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NAM19",
        "email": "nhatnam143@example.com",
        "phonenumber": "123456789",
        "password": "@@@@@@@@"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-18	Đăng ký phonenumber trống



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NAM22",
        "email": "nhatnam145@example.com",
        "phonenumber": "",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-19	Đăng ký tất cả trường trống




    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "",
        "email": "",
        "phonenumber": "",
        "password": ""
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-20	Đăng ký username có khoảng trắng đầu/cuối



    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": " NHATNAM ",
        "email": "nhatnam1146@example.com",
        "phonenumber": "123456789",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-21	Đăng ký password chỉ toàn số


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "NAM29",
        "email": "nhatnam150@example.com",
        "phonenumber": "123456789",
        "password": "123456789"
      }
      """
    When method POST
    Then status 400

  Scenario: TC-TUR-22	Đăng ký username cực ngắn (1 ký tự)


    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "A",
        "email": "nhatnam151@example.com",
        "phonenumber": "123456789",
        "password": "Pass@123"
      }
      """
    When method POST
    Then status 400

