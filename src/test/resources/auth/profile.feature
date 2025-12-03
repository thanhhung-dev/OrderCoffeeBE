Feature: GTest Update Profile

  Background:
    * def baseUrl = 'http://localhost:8080'
    * def token = 'eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiUk9MRV9VU0VSIn1dLCJpZCI6MTU0LCJlbWFpbCI6Im1pa2VAZXhhbXBsZS5jb20iLCJzdWIiOiJ0ZXN0dXNlcjMiLCJpYXQiOjE3NjQ3NDYzOTIsImV4cCI6MTc2NDc0OTk5Mn0.SmakeOtl4WSheMA2TyaonjAR1ghL9_aV_4CMrwJiRRgU7b9xEEAn-sx3GPLSyxcv4_1ADKKmUZamWEuSR1NrGg'
    * def invalidToken = 'eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiUk9MRV9VU0VSIn1dLCJpZCI6MTU0LCJlbWFpbCI6ImpvaG4uZG9lQGV4YW1wbGUuY29tIiwic3ViIjoidGVzdHVzZXIzIiwiaWF0IjoxNzY0NzMxODU3LCJleHAiOjE3NjQ3MzU0NTd9.MYLF276X5ZYFVUw01iuSMdfOYk4Jgf_kQRSQvK0FioduCr7ODohG8YwGjuHTjRn_PGImRTbiy-JzR29A623'
    * def profilePath = '/api/users/profile/me'
    * def changePasswordPath = '/api/users/profile/change-password'
  Scenario: TC_001 - GET /api/users/profile/me - Lấy profile thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200

    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """
  Scenario: TC_002 - Trả về 401 Unauthorized khi Bearer token không hợp lệ
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + invalidToken
    When method get
    Then status 401

    And match response ==
      """
      {
        status: 401,
        message: '#string',
        timestamp: '#string',
        path: '#string'
      }
      """
  Scenario: TC_003 - GET /api/users/profile/me - Không có Authorization header
    Given url baseUrl + profilePath
    When method get
    Then status 500
    And match response ==
      """
      {
        message: 'An unexpected error occurred',
        success: false
      }
      """
    * karate.fail('System returns 500 when Authorization header is missing; expected 401 Unauthorized')



  Scenario: TC_004 - GET /api/users/profile/me - Token đúng nhưng user bị xóa hoặc disabled
    * def expectedPath = profilePath
    Given url baseUrl + expectedPath
    And header Authorization = 'Bearer ' + deletedUserToken
    When method get
    Then status 400

    * def msg = response.message ? response.message : (response.error ? response.error : '')
    And match msg contains 'User not found'
    * print 'TC_004 response status:', karate.responseStatus, 'message:', msg


  Scenario: TC_005 - GET /api/users/profile/me - Verify logging
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """
    * def username = response.data && response.data.username ? response.data.username : '<unknown>'
    * print 'Expect application logs contain: "Getting profile for authenticated user: ' + username + '"'
    * karate.log('Manual verification required: Check application log contains: "Getting profile for authenticated user: ' + username + '"')
  Scenario: TC_006 - GET /api/users/profile/me - Profile với avatar null
    Given url baseUrl + '/api/users/profile/me'
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200

    # Xác nhận khung response chuẩn
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """

    # Xác nhận avatarUrl null và các field chính
    And match response.data ==
      """
      {
        id: '#number',
        username: '#ignore',
        email: '#ignore',
        firstName: '#ignore',
        lastName: '#ignore',
        displayName: '#ignore',
        avatarUrl: "null",
        phoneNumber: '#ignore',
        roles: ['ROLE_USER'],
        createdAt: '#string',
        updatedAt: '#string'
      }
      """

  # TC_007 - Update firstName thành công
  Scenario: TC_007 - PUT /api/users/profile/me - Update firstName thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: 'John' }
    When method put
    Then status 200

    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """

    * def currentLastName = response.data.lastName


  Scenario: TC_008 - PUT /api/users/profile/me - Update lastName thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { lastName: 'Smith' }
    When method put
    Then status 200

    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """

    # Optional: kiểm tra updatedAt thay đổi (nếu server trả khác đi)
    * def isIsoInstant = function(s){ return java.time.Instant.parse(s) != null }
    And match isIsoInstant(response.data.updatedAt) == true
  Scenario: TC_009 - PUT /api/users/profile/me - Update email thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { email: 'newemail@example.com' }
    When method put
    Then status 200

    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """

    And match response.data ==
      """
      {
        id: '#number',
        username: 'testuser',
        email: 'newemail@example.com',
        firstName: '#string',
        lastName: '#string',
        displayName: '#( response.data.firstName + " " + response.data.lastName )',
        avatarUrl: '#ignore',
        phoneNumber: '#string',
        roles: ['ROLE_USER'],
        createdAt: '#string',
        updatedAt: '#string'
      }
      """

    * print "Expect log contains: 'Updated email for user testuser'"

  # TC_010 - Update email đã tồn tại - kỳ vọng 400, hiện trạng FAIL (trả 200 và set email)
  Scenario: TC_010 - PUT /api/users/profile/me - Update email đã tồn tại - FAIL hiện trạng
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { email: 'existing@example.com' }
    When method put
    # Kỳ vọng đúng: Then status 400 và body lỗi
    # Hiện trạng thực tế bạn ghi nhận: 200 OK và data.email = 'existing@example.com'
    Then status 200
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """
    And match response.data.email == 'existing@example.com'

    # Đánh dấu test này là FAIL so với kỳ vọng nghiệp vụ
    * karate.fail("Expected 400 Bad Request when email already exists, but system returned 200 and updated email")


  # TC_011 - Update phoneNumber thành công
  Scenario: TC_011 - PUT /api/users/profile/me - Update phoneNumber thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { phoneNumber: '0912345678' }
    When method put
    Then status 200

    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """

    And match response.data ==
      """
      {
        id: '#number',
        username: 'testuser',
        email: '#string',
        firstName: '#string',
        lastName: '#string',
        displayName: '#( response.data.firstName + " " + response.data.lastName )',
        avatarUrl: '#ignore',
        phoneNumber: '0912345678',
        roles: ['ROLE_USER'],
        createdAt: '#string',
        updatedAt: '#string'
      }
      """
    * print "Expect log contains: 'Updated phone number for user testuser'"
  Scenario: TC_012 - PUT /api/users/profile/me - Update nhiều fields cùng lúc
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        firstName: 'Mike',
        lastName: 'Johnson',
        email: 'mike@example.com',
        phoneNumber: '0901234567'
      }
      """
    When method put
    Then status 200
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """
    And match response.data ==
      """
      {
        id: '#number',
        username: '#string',
        email: 'mike@example.com',
        firstName: 'Mike',
        lastName: 'Johnson',
        displayName: 'Mike Johnson',
        avatarUrl: '#ignore',
        phoneNumber: '0901234567',
        roles: ['ROLE_USER'],
        createdAt: '#string',
        updatedAt: '#string'
      }
      """

  # TC_013 - Update với body rỗng {}
  Scenario: TC_013 - PUT /api/users/profile/me - Update với body rỗng
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request {}
    When method put
    Then status 200
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """
    * print "Manual/secondary verification: No changes detected for user via logs"

  # TC_014 - Update với dữ liệu giống cũ
  Scenario: TC_014 - PUT /api/users/profile/me - Update với dữ liệu giống cũ
    # B1: Get current profile
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    * def currentProfile = response.data

    # B2: Gửi lại các giá trị cũ (ví dụ chỉ firstName/lastName)
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: '#(currentProfile.firstName)', lastName: '#(currentProfile.lastName)' }
    When method put
    Then status 200
    And match response.statusCode == 200
    * print "Manual/secondary verification: No changes detected for user via logs"

  # TC_015 - Validation error: email sai format (kỳ vọng 400) - hiện trạng bạn ghi nhận FAIL trả 200
  Scenario: TC_015 - PUT /api/users/profile/me - Validation error: email sai format
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { email: 'invalid-email-format' }
    When method put
    # Kỳ vọng đúng là 400 Bad Request với errors.email
    # Nhưng theo hiện trạng hệ thống của bạn: trả 200 và set email sai định dạng
    Then status 200
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: '#object'
      }
      """
    And match response.data.email == 'invalid-email-format'
    * karate.fail('Expected 400 Bad Request for invalid email format, but system returned 200')

  Scenario: TC_016 - PUT /api/users/profile/me - Validation error: firstName quá dài
    * def longName = 'X'.repeat(300)
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: '#(longName)' }
    When method put
    Then status 400
    And match response ==
      """
      {
        path: '/api/users/profile/me',
        message: 'Validation failed',
        errors: { firstName: '#string' },
        status: 400,
        timestamp: '#string'
      }
      """
    And match response.errors.firstName == '#? _ contains "less than" || _ contains "too long"'

  # TC_017 - Không có token
  Scenario: TC_017 - PUT /api/users/profile/me - Không có token
    Given url baseUrl + profilePath
    And request { firstName: 'Test' }
    When method put
    # Kỳ vọng 401, hiện trạng hệ thống trả 500
    Then status 500
    And match response ==
      """
      {
        message: 'An unexpected error occurred',
        success: false
      }
      """
    * karate.fail('Expected 401 Unauthorized when Authorization header is missing; got 500')

  # TC_018 - Token hết hạn
  Scenario: TC_018 - PUT /api/users/profile/me - Token hết hạn
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + expiredToken
    And request { firstName: 'Test' }
    When method put
    # Kỳ vọng 401, hiện trạng hệ thống trả 500 theo mô tả
    Then status 500
    And match response ==
      """
      {
        message: 'An unexpected error occurred',
        success: false
      }
      """
    * karate.fail('Expected 401 Unauthorized for expired token; got 500')

  # TC_019 - Update với special characters
  Scenario: TC_019 - PUT /api/users/profile/me - Update với special characters
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + validToken
    And request { firstName: "O'Brien", lastName: 'García' }
    When method put
    # Kỳ vọng 200 và lưu đúng; hiện trạng bạn ghi nhận 500
    Then status 500
    And match response ==
      """
      {
        message: 'An unexpected error occurred',
        success: false
      }
      """
    * karate.fail('Expected 200 OK for names with special characters; got 500')

#   TC_020 - Đổi password thành công
  Scenario: TC_020 - POST /api/users/profile/change-password - Đổi password thành công
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request
      """
      {
        currentPassword: 'NewPass@456',
        newPassword:    'NewPass@456',
        confirmPassword:'NewPass@456'
      }
      """
    When method post
    Then status 200
    And match response ==
      """
      {
        statusCode: 200,
        error: null,
        message: 'CALL API SUCCESS',
        data: { message: 'Password changed successfully', success: true }
      }
      """
    * print "Expect logs: 'Changing password for user: testuser3' and 'Password changed successfully for user: testuser3'"
