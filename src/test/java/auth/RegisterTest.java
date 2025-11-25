package auth;

import com.intuit.karate.junit5.Karate;

class RegisterTest {

    @Karate.Test
    Karate testRegister() {
        return Karate.run("register").relativeTo(getClass());
    }
}