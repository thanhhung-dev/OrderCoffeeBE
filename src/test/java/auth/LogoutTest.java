package auth;

import com.intuit.karate.junit5.Karate;

class LogoutTest {

    @Karate.Test
    Karate testLogout() {
        return Karate.run("logout").relativeTo(getClass());
    }
}
