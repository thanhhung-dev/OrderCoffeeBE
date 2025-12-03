package Order;

import com.intuit.karate.junit5.Karate;

public class OrderTest {
    @Karate.Test
    Karate testOrder() {
        return Karate.run("order"). relativeTo(getClass());
    }
}
