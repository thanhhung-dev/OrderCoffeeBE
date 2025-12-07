package OrderItem;

import com.intuit.karate.junit5.Karate;

public class OrderItemTest {
    @Karate.Test
    Karate testOrderItem() {
        return Karate.run("orderItem"). relativeTo(getClass());
    }
}
