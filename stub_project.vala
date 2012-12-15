using Gee;

public class StubProject :AbstractProject {

    public StubProject (int projectnr,int umfang,int status,bool fertig) {
		
        attributes.add(new ProjectNr(projectnr));
		attributes.add(new Umfang(umfang));
		attributes.add(new Status(status));
		attributes.add(new Fertig(fertig));
    }
}
