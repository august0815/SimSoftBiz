public class ProductNr : AbstractAttribute {

    public int productnr{get; set;}

    public ProductNr (int productnr) {
        this.productnr = productnr;
    }
}
public class Preis : AbstractAttribute {

    public int preis{get; set;}

    public Preis (int preis) {
        this.preis = preis;
    }
}
public class Alter : AbstractAttribute {

    public int alter{get; set;}

    public Alter (int alter) {
        this.alter = alter;
    }
}
public class Sold : AbstractAttribute {

    public int sold{get; set;}

    public Sold (int sold) {
        this.sold = sold;
    }
}

