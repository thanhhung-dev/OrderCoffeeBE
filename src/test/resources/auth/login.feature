Feature: Login Helper

  Scenario: Login and get token
    * def baseUrl = 'http://localhost:8080'
    * def loginPath = '/api/auth/login'

  # Nhận username và password từ caller
    * def username = __arg.username
    * def password = __arg.password

    Given url baseUrl + loginPath
    And request { username: '#(username)', password: '#(password)' }
    When method post
    Then status 200

  # Validate response structure
    And match response ==
    """
    {
      statusCode: 200,
      error: null,
      message: 'CALL API SUCCESS',
      data: {
        accessToken: '#string',
        refreshToken: '#string',
        tokenType: 'Bearer',
        id: '#number',
        username: '#string',
        email: '#string',
        roles: '#array'
      }
    }
    """

  # Trả về accessToken để feature khác sử dụng
    * def token = response.data.accessToken
    * def refreshToken = response.data.refreshToken
    * def userId = response.data.id
    * def userEmail = response.data.email