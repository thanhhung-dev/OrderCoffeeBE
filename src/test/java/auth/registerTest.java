package auth;

import com.intuit.karate.junit5.Karate;

class registerTest {

    @Karate.Test
    Karate testregister() {
        return Karate.run("register").relativeTo(getClass());
    }
}

