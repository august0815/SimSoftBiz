public class ProjectNr : AbstractAttribute {

    public int projectnr{get; set;}

    public ProjectNr (int projectnr) {
        this.projectnr = projectnr;
    }
}
public class Umfang : AbstractAttribute {

    public int umfang{get; set;}

    public Umfang (int umfang) {
        this.umfang = umfang;
    }
}
public class Status : AbstractAttribute {

    public int status{get; set;}

    public Status (int status) {
        this.status = status;
    }
}
public class Fertig : AbstractAttribute {

    public bool fertig{get; set;}

    public Fertig (bool fertig) {
        this.fertig = fertig;
    }
   public void change (){
		fertig=true;
	}
}
