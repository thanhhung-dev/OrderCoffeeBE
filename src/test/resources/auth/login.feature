
Feature: Login API Testing

Background:
* def baseUrl = 'http://localhost:8080/api/auth/login'

Scenario: TEST 1 - Successful login with valid credentials
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.statusCode == 200
And match response.error == null
And match response.message == 'CALL API SUCCESS'
And match response.data.accessToken == '#string'
And match response.data.refreshToken == '#string'
And match response.data.tokenType == 'Bearer'
And match response.data.id == '#number'
And match response.data.username == 'thanhhung12'
And match response.data.email == '#string'
And match response.data.roles == '#array'

Scenario: TEST 2 - Empty username
Given url baseUrl
And request
"""
{
"username": "",
"password": "1235699@"
}
"""
When method POST
Then status 400
And match response.errors.username == 'Username is required'

Scenario: TEST 3 - Empty password
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": ""
}
"""
When method POST
Then status 400
And match response.errors.password == 'Password is required'

Scenario: TEST 4 - Null username
Given url baseUrl
And request
"""
{
"password": "1235699@"
}
"""
When method POST
Then status 400
And match response.errors.username == 'Username is required'

Scenario: TEST 5 - Null password
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
}
"""
When method POST
Then status 400
And match response.errors.password == 'Password is required'

Scenario: TEST 6 - Both fields empty
Given url baseUrl
And request
"""
{
"username": "",
"password": ""
}
"""
When method POST
Then status 400
And match response.errors.username == 'Username is required'
And match response.errors.password == 'Password is required'

Scenario: TEST 7 - Invalid username (wrong user)
Given url baseUrl
And request
"""
{
"username": "wronguser123",
"password": "1235699@"
}
"""
When method POST
Then status 401
And match response.message == 'Invalid username or password'

Scenario: TEST 8 - Invalid password (wrong password)
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "wrongpass123"
}
"""
When method POST
Then status 401
And match response.message == 'Invalid username or password'

Scenario: TEST 9 - SQL Injection attempt
Given url baseUrl
And request
"""
{
"username": "admin' OR '1'='1",
"password": "1235699@"
}
"""
When method POST
Then status 401
And match response.message == 'Invalid Username or Password'

Scenario: TEST 10 - XSS attack prevention
Given url baseUrl
And request
"""
{
"username": "<script>alert('XSS')</script>",
"password": "1235699@"
}
"""
When method POST
Then status 401
And match response.message == 'Invalid Username or Password'

Scenario: TEST 11 - Special characters in password
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "!@#$%^&*!!"
}
"""
When method POST
Then status 401
And match response.error == 'Invalid Username or password'

Scenario: TEST 12 - Username too long
Given url baseUrl
And request
"""
{
"username": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
"password": "1235699@"
}
"""
When method POST
Then status 400
And match response.errors.username == 'Username too long'

Scenario: TEST 13 - Password too long
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
}
"""
When method POST
Then status 400
And match response.errors.password == 'Password too long'

Scenario: TEST 14 - Missing username field
Given url baseUrl
And request
"""
{
"password": "1235699@"
}
"""
When method POST
Then status 400
And match response.errors.username == 'Username is required'

Scenario: TEST 15 - Missing password field
Given url baseUrl
And request
"""
{
"username": "thanhhung12"
}
"""
When method POST
Then status 400
And match response.errors.password == 'Password is required'

Scenario: TEST 16 - Case sensitive username
Given url baseUrl
And request
"""
{
"username": "THANHHUNG12",
"password": "1235699@"
}
"""
When method POST
Then status 401
Scenario: TEST 17 - Username with spaces (trim test)
Given url baseUrl
And request
"""
{
"username": " thanhhung12 ",
"password": "1235699@"
}
"""
When method POST
Then status 401
Scenario: TEST 18 - Response contains accessToken field
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data contains { accessToken: '#string' }
And match response.data.accessToken == '#notnull'

Scenario: TEST 19 - Response contains refreshToken field
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data contains { refreshToken: '#string' }
And match response.data.refreshToken == '#notnull'

Scenario: TEST 20 - Response contains user id
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data contains { id: '#number' }
And match response.data.id == '#present'

Scenario: TEST 21 - Response contains username field
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data contains { username: '#string' }
And match response.data.username == 'thanhhung12'

Scenario: TEST 22 - Response contains email field
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data contains { email: '#string' }
And match response.data.email == '#notnull'

Scenario: TEST 23 - Response contains roles array
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data contains { roles: '#array' }
And match response.data.roles == '#[1]'
And match response.data.roles[0] == 'ROLE_USER'

Scenario: TEST 24 - accessToken matches JWT format
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data.accessToken == '#regex ^[A-Za-z0-9-_]+\\.[A-Za-z0-9-_]+\\.[A-Za-z0-9-_]+$'

Scenario: TEST 25 - refreshToken matches UUID format
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data.refreshToken == '#regex ^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'

Scenario: TEST 26 - tokenType equals "Bearer"
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data.tokenType == 'Bearer'

Scenario: TEST 27 - statusCode equals 200
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.statusCode == 200

Scenario: TEST 28 - message equals "CALL API SUCCESS"
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.message == 'CALL API SUCCESS'

Scenario: TEST 29 - Deactivated account
Given url baseUrl
And request
"""
{
"username": "inactiveuser",
"password": "password123"
}
"""
When method POST
Then status 401
And match response.details == 'Account is deactivated'

Scenario: TEST 30 - Locked account
Given url baseUrl
And request
"""
{
"username": "inactiveuser",
"password": "password123"
}
"""
When method POST
Then status 401
And match response.details == 'Account is temporarily locked until 2026-01-01T00:00:00Z'

Scenario: TEST 31 - Password NOT present in response
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.data !contains { password: '#present' }

Scenario: TEST 32 - Response time less than 2000ms
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And assert responseTime < 2000

Scenario: TEST 33 - Error field is null on success
Given url baseUrl
And request
"""
{
"username": "thanhhung12",
"password": "1235699@"
}
"""
When method POST
Then status 200
And match response.error == null