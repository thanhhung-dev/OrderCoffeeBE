Feature: Register API

  Scenario: Register success
    Given url 'http://localhost:8080/api/auth/register'
    And request
      """
      {
        "username": "hung123111122",
        "email": "hung213221321322@example.com",
        "password": "12345678",
        "phoneNumber": "+84987654321",
        "roles": ["USER"]
      }
      """
    When method POST
    Then status 201
