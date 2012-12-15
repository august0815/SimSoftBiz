public class Name : AbstractAttribute {

    public string name {get; set;}

    public Name (string name) {
        this.name = name;
    }
}

public class Vorname : AbstractAttribute {

    public string vorname {get; set;}

    public Vorname (string vorname) {
        this.vorname = vorname;
    }
}

public class Money : AbstractAttribute {

    public int money {get; set;}

    public Money (int money) {
        this.money = money;
    }
}

public class Comp : AbstractAttribute {

    public string company {get; set;}

    public Comp (string company) {
        this.company = company;
    }
    public void change (string company){
		this.company=company;
	}
}

public class Free : AbstractAttribute {

    public bool free {get; set;}

    public Free (bool free) {
        this.free = free;
    }
    public void change (){
		if (free){
		free=false;}
		else{
		free=true;}
}
}

public class Ident : AbstractAttribute {

    public int id{get; set;}

    public Ident (int id) {
        this.id = id;
    }
}

public class Skill : AbstractAttribute {

    public int skill {get; set;}

    public Skill (int skill) {
        this.skill = skill;
    }
}
