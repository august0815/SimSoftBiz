using Gee;

public class StubPersona : AbstractPersona {

    public StubPersona (int id,string name, string vorname, int money ,string company,bool free,int skill) {
		
		attributes.add(new Ident(id));
        attributes.add(new Name(name));
        attributes.add(new Vorname(vorname));
        attributes.add(new Money(money));
        attributes.add(new Comp(company));
        attributes.add(new Free(free));
        attributes.add(new Skill(skill));
    }
   

   
}

