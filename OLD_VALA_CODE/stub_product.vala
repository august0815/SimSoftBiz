using Gee;

public class StubProduct :AbstractProduct {

    public StubProduct (int productnr,int preis,int alter,int sold) {
		
        attributes.add(new ProductNr(productnr));
		attributes.add(new Preis(preis));
		attributes.add(new Alter(alter));
		attributes.add(new Sold(sold));
    }
}
