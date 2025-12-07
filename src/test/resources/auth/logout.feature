Feature: Logout API
  Scenario: TC-LOG-01	Logout với token hợp lệ của người dùng NHATNAM


    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_NHATNAM"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-02	Logout với token sai của NHATNAM



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "avb_token_NHATNAM"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-03	Logout với token người dùng không tồn tại



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_123_user"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-04	Logout với token rỗng



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": ""}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-05	Logout với token null



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": null}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-06	Logout token username chữ hoa/thường khác



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_NhatNam"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-07	Logout token password chữ thường



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_pass@123"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-08	Logout token username là số



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_123456"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-09	Logout token SQL injection



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_NHATNAM_OR_1=1"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-10	Logout token password ký tự đặc biệt



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_P@$$w0rd!"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-11	Logout thiếu token



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-12	Logout token username khoảng trắng



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_ "}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-13	Logout token username là email



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_nhatnam123@example.com"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-14	Logout token password chỉ chữ thường



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_pass@123"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-15	Logout token password chỉ chữ hoa



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_PASS@123"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-16	Logout token password chỉ số



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_1234567890"}


      """
    When method POST
    Then status 200

  Scenario: TC-LOG-17	Logout token username khoảng trắng đầu/cuối



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": " token_NHATNAM "}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-18	Logout token username toàn số



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_12345658"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-19	Logout token username cực dài



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_AAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-20	Logout token password khoảng trắng đầu



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": " token_Pass@123"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-21	Logout token username + password rỗng



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": ""}


      """
    When method POST
    Then status 200

  Scenario: TC-LOG-22	Logout token username không tồn tại + password đặc biệt



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_hckdnhk_@#$Pass123"}


      """
    When method POST
    Then status 200

  Scenario: TC-LOG-23	Logout nhiều lần liên tiếp



    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "token_NHATNAM"}

      """
    When method POST
    Then status 200

  Scenario: TC-LOG-24	Logout token ký tự đặc biệt




    Given url 'http://localhost:8080/api/auth/logout'
    And request
      """
      {"token": "!@#$%^&*()token"}

      """
    When method POST
    Then status 200