package categories;

import com.intuit.karate.junit5.Karate;

class CategoriesTest {

    @Karate.Test
    Karate testCategories() {
        return Karate.run("categories").relativeTo(getClass());
    }
}