package Table;

import com.intuit.karate.junit5.Karate;

class TableTest {

    @Karate.Test
    Karate testTable() {
        return Karate.run("table").relativeTo(getClass());
    }
}