// File: src/test/java/helpers/auth-helper.js

function fn() {
    var config = {
        baseUrl: 'http://localhost:8080',
        loginPath: '/api/auth/login',

        // Credentials cho các users khác nhau
        users: {
            testuser3: {
                username: 'testuser3',
                password: 'UpdatedPass@123'
            },
            testuserchange: {
                username: 'testuser4',
                password: 'NewPass@456'
            },
            admin: {
                username: 'admin',
                password: 'AdminPass@123'
            },
            deletedUser: {
                username: 'deleteduser',
                password: 'DeletedPass@123'
            }
        }
    };

    // Hàm login và lấy token
    config.getToken = function(username) {
        var user = config.users[username];
        if (!user) {
            karate.log('User not found:', username);
            return null;
        }

        var loginUrl = config.baseUrl + config.loginPath;
        var response = karate.call({
            url: loginUrl,
            method: 'post',
            body: {
                username: user.username,
                password: user.password
            },
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (response.status === 200 && response.data && response.data.token) {
            karate.log('Login successful for user:', username);
            return response.data.token;
        } else {
            karate.log('Login failed for user:', username, 'Response:', response);
            return null;
        }
    };

    // Token mẫu cho test cases đặc biệt
    config.invalidToken = 'eyJhbGciOiJIUzUxMiJ9.invalid.token';
    config.expiredToken = 'eyJhbGciOiJIUzUxMiJ9.eyJyb2xlcyI6W3siYXV0aG9yaXR5IjoiUk9MRV9VU0VSIn1dLCJpZCI6MTU0LCJlbWFpbCI6ImpvaG4uZG9lQGV4YW1wbGUuY29tIiwic3ViIjoidGVzdHVzZXIzIiwiaWF0IjoxNzY0NzMxODU3LCJleHAiOjE3NjQ3MzU0NTd9.MYLF276X5ZYFVUw01iuSMdfOYk4Jgf_kQRSQvK0FioduCr7ODohG8YwGjuHTjRn_PGImRTbiy-JzR29A623';

    return config;
}