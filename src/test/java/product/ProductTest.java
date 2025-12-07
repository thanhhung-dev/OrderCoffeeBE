package product;

import com.intuit.karate.junit5.Karate;

public class ProductTest {
    @Karate.Test
    Karate testProduct() {
        return Karate.run("product"). relativeTo(getClass());
    }
}
