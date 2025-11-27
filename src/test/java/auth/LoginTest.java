package auth;

import com.intuit.karate.junit5.Karate;

class LoginTest {

    @Karate.Test
    Karate testLogin() {
        return Karate.run("login").relativeTo(getClass());
    }
}