Feature: User Profile Management

  Background:
    * def baseUrl = 'http://localhost:8080'
    * def loginResult = call read('classpath:auth/login.feature') { username: 'testuser3', password: 'UpdatedPass@123' }
    * def token = loginResult.token
    * def invalidToken = 'Invalid_token_xyz'
    * def deletedUserToken = 'eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiUk9MRV9VU0VSIn1dLCJpZCI6OTk5LCJlbWFpbCI6ImRlbGV0ZWRAZXhhbXBsZS5jb20iLCJzdWIiOiJkZWxldGVkdXNlciIsImlhdCI6MTc2NDc1MjU2MiwiZXhwIjoxNzY0NzU2MTYyfQ.fake_signature'
    * def profilePath = '/api/users/profile/me'
    * def changePasswordPath = '/api/users/profile/change-password'
    * def avatarPath = '/api/users/profile/avatar'

#######################
# GET /api/users/profile/me
#######################

  Scenario: TC_001 - GET profile thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 200
    And match response ==
    """
    { statusCode: 200, error: null, message: 'CALL API SUCCESS', data: '#object' }
    """
    * print 'TC_001 PASS'

  Scenario: TC_002 - GET profile token không hợp lệ
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + invalidToken
    When method get
    Then status 401
    And match response.message == 'Token is invalid or expired'
    * print 'TC_002 PASS'

  Scenario: TC_003 - GET profile không có token
    Given url baseUrl + profilePath
    When method get
    Then status 401
    And match response.message == 'Unauthorized'
    * print 'TC_003 PASS'

  Scenario: TC_004 - GET profile token hợp lệ nhưng user bị xóa
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + deletedUserToken
    When method get
    Then status 404
    And match response.message == 'User not found'
    * print 'TC_004 PASS'

#######################
# PUT /api/users/profile/me
#######################

  Scenario: TC_005 - Update firstName thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: 'Michael' }
    When method put
    Then status 200
    And match response.data.firstName == 'Michael'
    * print 'TC_005 PASS'

  Scenario: TC_006 - Update lastName thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { lastName: 'Smith' }
    When method put
    Then status 200
    And match response.data.lastName == 'Smith'
    * print 'TC_006 PASS'

  Scenario: TC_007 - Update email thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { email: 'newemail@example.com' }
    When method put
    Then status 200
    And match response.data.email == 'newemail@example.com'
    * print 'TC_007 PASS'

  Scenario: TC_008 - Update email đã tồn tại
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { email: 'existing@example.com' }
    When method put
    Then status 400
    And match response.message == 'Email is already in use: existing@example.com'
    * print 'TC_008 PASS'

  Scenario: TC_009 - Update phoneNumber thành công
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { phoneNumber: '0912345678' }
    When method put
    Then status 200
    And match response.data.phoneNumber == '0912345678'
    * print 'TC_009 PASS'

  Scenario: TC_010 - Update multiple fields cùng lúc
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: 'Mike', lastName: 'Johnson', email: 'mike@example.com', phoneNumber: '0901234567' }
    When method put
    Then status 200
    And match response.data.firstName == 'Mike'
    And match response.data.lastName == 'Johnson'
    And match response.data.email == 'mike@example.com'
    And match response.data.phoneNumber == '0901234567'
    * print 'TC_010 PASS'

  Scenario: TC_011 - Update firstName trống
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: '' }
    When method put
    Then status 400
    And match response.errors.firstName == '#? _ contains "cannot be empty"'
    * print 'TC_011 PASS'

  Scenario: TC_012 - Update lastName trống
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { lastName: '' }
    When method put
    Then status 400
    And match response.errors.lastName == '#? _ contains "cannot be empty"'
    * print 'TC_012 PASS'

  Scenario: TC_013 - Update email sai định dạng
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { email: 'wrongemail' }
    When method put
    Then status 400
    And match response.errors.email == '#? _ contains "invalid"'
    * print 'TC_013 PASS'

  Scenario: TC_014 - Update phoneNumber sai định dạng
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { phoneNumber: 'abc123' }
    When method put
    Then status 400
    And match response.errors.phoneNumber == '#? _ contains "invalid"'
    * print 'TC_014 PASS'

  Scenario: TC_015 - Update profile không có token
    Given url baseUrl + profilePath
    And request { firstName: 'Test' }
    When method put
    Then status 401
    And match response.message == 'Unauthorized'
    * print 'TC_015 PASS'

#######################
# POST /api/users/profile/change-password
#######################

  Scenario: TC_016 - Change password thành công
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: 'UpdatedPass@123', newPassword: 'UpdatedPass@123', confirmPassword: 'UpdatedPass@123' }
    When method post
    Then status 200
    And match response.data.success == true
    * print 'TC_016 PASS'

  Scenario: TC_017 - Change password sai currentPassword
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: 'WrongOld', newPassword: 'NewPass@456', confirmPassword: 'NewPass@456' }
    When method post
    Then status 400
    And match response.message == 'Current password is incorrect'
    * print 'TC_017 PASS'

  Scenario: TC_018 - Change password newPassword và confirmPassword khác nhau
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: 'UpdatedPass@123', newPassword: 'NewPass@456', confirmPassword: 'DiffPass@456' }
    When method post
    Then status 400
    And match response.message == 'Confirm password does not match new password'
    * print 'TC_018 PASS'

  Scenario: TC_019 - Change password không đủ độ dài
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: 'UpdatedPass@123', newPassword: '123', confirmPassword: '123' }
    When method post
    Then status 400
    And match response.errors.newPassword == '#? _ contains "too short"'
    * print 'TC_019 PASS'

  Scenario: TC_020 - Change password không có token
    Given url baseUrl + changePasswordPath
    And request { currentPassword: 'UpdatedPass@123', newPassword: 'NewPass@456', confirmPassword: 'NewPass@456' }
    When method post
    Then status 401
    And match response.message == 'Unauthorized'
    * print 'TC_020 PASS'

#######################
# PUT /api/users/profile/avatar
#######################

  Scenario: TC_021 - Update avatar thành công
    Given url baseUrl + avatarPath
    And header Authorization = 'Bearer ' + token
    And request 'https://example.com/avatars/user123.jpg'
    When method put
    Then status 200
    And match response.data.success == true
    * print 'TC_021 PASS'

  Scenario: TC_022 - Update avatar không hợp lệ (file type)
    Given url baseUrl + avatarPath
    And header Authorization = 'Bearer ' + token
    And request 'https://example.com/avatars/user123.txt'
    When method put
    Then status 400
    And match response.message == 'Invalid avatar format'
    * print 'TC_022 PASS'

  Scenario: TC_023 - Update avatar quá lớn
    Given url baseUrl + avatarPath
    And header Authorization = 'Bearer ' + token
    And request 'https://example.com/avatars/large_image.jpg'
    When method put
    Then status 400
    And match response.message == 'Avatar exceeds max size 2MB'
    * print 'TC_023 PASS'

  Scenario: TC_024 - Update avatar không có token
    Given url baseUrl + avatarPath
    And request 'https://example.com/avatars/user123.jpg'
    When method put
    Then status 401
    And match response.message == 'Unauthorized'
    * print 'TC_024 PASS'

  Scenario: TC_025 - Update profile và avatar cùng lúc
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: 'AvatarTest', avatar: 'https://example.com/avatars/avatar_test.jpg' }
    When method put
    Then status 200
    And match response.data.firstName == 'AvatarTest'
    And match response.data.avatar == 'https://example.com/avatars/avatar_test.jpg'
    * print 'TC_025 PASS'

#######################
# Negative & Validation Tests
#######################

  Scenario: TC_026 - Update firstName quá dài
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: 'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA' }
    When method put
    Then status 400
    And match response.errors.firstName == '#? _ contains "too long"'
    * print 'TC_026 PASS'

  Scenario: TC_027 - Update lastName quá dài
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { lastName: 'BBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBBB' }
    When method put
    Then status 400
    And match response.errors.lastName == '#? _ contains "too long"'
    * print 'TC_027 PASS'

  Scenario: TC_028 - Update email trống
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { email: '' }
    When method put
    Then status 400
    And match response.errors.email == '#? _ contains "cannot be empty"'
    * print 'TC_028 PASS'

  Scenario: TC_029 - Update phoneNumber quá dài
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { phoneNumber: '0912345678901234567890' }
    When method put
    Then status 400
    And match response.errors.phoneNumber == '#? _ contains "too long"'
    * print 'TC_029 PASS'

  Scenario: TC_030 - Change password trống fields
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: '', newPassword: '', confirmPassword: '' }
    When method post
    Then status 400
    And match response.errors.currentPassword == '#? _ contains "cannot be empty"'
    And match response.errors.newPassword == '#? _ contains "cannot be empty"'
    And match response.errors.confirmPassword == '#? _ contains "cannot be empty"'
    * print 'TC_030 PASS'

  Scenario: TC_031 - Change password newPassword yếu
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: 'OldPass@123', newPassword: '123456', confirmPassword: '123456' }
    When method post
    Then status 400
    And match response.errors.newPassword == '#? _ contains "too weak"'
    * print 'TC_031 PASS'

  Scenario: TC_032 - GET profile server error (simulate 500)
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 500
    And match response.message == 'Internal server error'
    * print 'TC_032 PASS'

  Scenario: TC_033 - PUT profile server error (simulate 500)
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: 'Test500' }
    When method put
    Then status 500
    And match response.message == 'Internal server error'
    * print 'TC_033 PASS'

  Scenario: TC_034 - Change-password server error (simulate 500)
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: 'OldPass@123', newPassword: 'NewPass@123', confirmPassword: 'NewPass@123' }
    When method post
    Then status 500
    And match response.message == 'Internal server error'
    * print 'TC_034 PASS'

  Scenario: TC_035 - Update avatar server error (simulate 500)
    Given url baseUrl + avatarPath
    And header Authorization = 'Bearer ' + token
    And request 'https://example.com/avatars/error.jpg'
    When method put
    Then status 500
    And match response.message == 'Internal server error'
    * print 'TC_035 PASS'

  Scenario: TC_036 - PUT profile trùng dữ liệu cũ
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request { firstName: 'Michael', lastName: 'Smith', email: 'newemail@example.com', phoneNumber: '0912345678' }
    When method put
    Then status 200
    And match response.message == 'No changes detected'
    * print 'TC_036 PASS'

  Scenario: TC_037 - Change-password trùng currentPassword
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request { currentPassword: 'OldPass@123', newPassword: 'OldPass@123', confirmPassword: 'OldPass@123' }
    When method post
    Then status 400
    And match response.message == 'New password cannot be same as current password'
    * print 'TC_037 PASS'

  Scenario: TC_038 - GET profile chậm (simulate timeout)
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    When method get
    Then status 408
    And match response.message == 'Request timeout'
    * print 'TC_038 PASS'

  Scenario: TC_039 - PUT profile với JSON sai format
    Given url baseUrl + profilePath
    And header Authorization = 'Bearer ' + token
    And request '{ "firstName": "Mike" '
    When method put
    Then status 400
    And match response.message == 'Malformed JSON request'
    * print 'TC_039 PASS'

  Scenario: TC_040 - Change-password với JSON sai format
    Given url baseUrl + changePasswordPath
    And header Authorization = 'Bearer ' + token
    And request '{ currentPassword: "OldPass@123" '
    When method post
    Then status 400
    And match response.message == 'Malformed JSON request'
    * print 'TC_040 PASS'