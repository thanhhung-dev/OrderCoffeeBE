package auth;

import com.intuit.karate.junit5.Karate;

public class ProfileTest {
    @Karate.Test
    Karate testLogin() {
        return Karate.run("profile").relativeTo(getClass());
    }
}
