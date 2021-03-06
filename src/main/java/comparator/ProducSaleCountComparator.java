package comparator;

import com.hdljava.skycat.pojo.Product;

import java.util.Comparator;

public class ProducSaleCountComparator implements Comparator<Product> {
    @Override
    public int compare(Product p1, Product p2) {
        return p2.getSaleCount().compareTo( p1.getSaleCount() );
    }
}
