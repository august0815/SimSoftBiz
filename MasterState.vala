using GLib;
using Json;
using Gee;


public class MasterState
{

public ArrayList<AbstractPersona>  personas = new ArrayList<AbstractPersona>();
public ArrayList<AbstractProject>  projects = new ArrayList<AbstractProject>();
public ArrayList<AbstractProduct>  product = new ArrayList<AbstractProduct>();
 
  private Company _playerCompany;
  
  private int _time;
  

  public ArrayList<string> firstNames = new ArrayList<string> ();


  public ArrayList<string> lastNames = new ArrayList<string> ();

  public MasterState()
  {
	_playerCompany = new Company("Testing Corp", 100000,40);
    _setupFirstNames();
    _setupLastNames();
   
    _time = 0;
     }
          ~MasterState() {
        
        _playerCompany = null;
    _time = 0;
    }
public void startinits(){
	_createPeople(1);
	_createProject(1);
    }

  public Company getPlayerCompany()
  {
    return _playerCompany; 
  }


  public void advanceTime(int amount)
  { 
	for (int i = 0; i < amount; i++) {
		_time++;
		}
	
	// One in ten chance of creating a new person.
	float r2=20/(_playerCompany.employee.size+1);
	int r1=Random.int_range(1,100);
		if (r1 <= r2) {
			 _createPeople(1);
			
		}
	// One in ten chance of creating a new project.
	 r2=20/(_playerCompany.projects.size+1);
	 r1=Random.int_range(1,100);
		if (r1 <= r2) {
			 _createProject(1);
			
		}
		
  }


   private void _setupFirstNames()
  {
   
    firstNames.add ("Jon");
    firstNames.add ("Barbara");
	firstNames.add ("Brianna");
	firstNames.add ("Charles");
	firstNames.add ("Christopher");
	firstNames.add ("Daniel");
	firstNames.add ("David");
	firstNames.add ("Donald");
	firstNames.add ("Elizabeth");
	firstNames.add ("James");
	firstNames.add ("Jennifer");
	firstNames.add ("Jeremy");
	firstNames.add ("John");
	firstNames.add ("Joseph");
	firstNames.add ("Linda");
	firstNames.add ("Maria");
	firstNames.add ("Mark");
	firstNames.add ("Mary");
	firstNames.add ("Michael");
	firstNames.add ("Patricia");
	firstNames.add ("Paul");
	firstNames.add ("Richard");
	firstNames.add ("Robert");
	firstNames.add ("Susan");
	firstNames.add ("Thomas");
	firstNames.add ("William");
  }


  private void _setupLastNames()
  {

	lastNames.add("Amundson");
	lastNames.add("Anderson");
	lastNames.add("Anniston");
	lastNames.add("Birthler");
	lastNames.add("Bishop");
	lastNames.add("Bremer");
	lastNames.add("Cannon");
	lastNames.add("Compton");
	lastNames.add("Dorland");
	lastNames.add("Esbensen");
	lastNames.add("Frazier");
	lastNames.add("Gemoets");
	lastNames.add("Gloege");
	lastNames.add("Gohde");
	lastNames.add("Grace");
	lastNames.add("Green");
	lastNames.add("Hemmingway");
	lastNames.add("Jones");
	lastNames.add("Kamke");
	lastNames.add("Koehl");
	lastNames.add("Lamb");
	lastNames.add("Mars");
	lastNames.add("Mason");
	lastNames.add("Miller");
	lastNames.add("Myers");
	lastNames.add("Olson");
	lastNames.add("Pepper");
	lastNames.add("Poeschl");
	lastNames.add("Reed");
	lastNames.add("Reynolds");
	lastNames.add("Runyon");
	lastNames.add("Schilken");
	lastNames.add("Schneider");
	lastNames.add("Seemann");
	lastNames.add("Simula");
	lastNames.add("Smith");
	lastNames.add("Spradlin");
	lastNames.add("Tava");
	lastNames.add("Wade");
	lastNames.add("Wolever");
	lastNames.add("Wurm");
  }

  public void _createPeople(int count)
  {
	  for (int j = 0; j < count; j++) {
		//Simple _time stamp as IdentNR
		// Random Names
	    string firstName = firstNames[Random.int_range(1,26)];
		string lastName = lastNames[Random.int_range(1,40)];
		
		int money =Random.int_range(35000,85000);;
		//TODO:skill in Languages !
		int skill =Random.int_range(45,95);
		
		//TODO: is needed ?
		bool free=true;
		
	    personas.add(new StubPersona(_time,firstName,lastName,money,"",free,skill));
	}
  }
   public void loadPeople(int id,string name,string vorname,int money,int skill)
  {
	  //TODO: is needed ?
		bool free=true;
		
	    personas.add(new StubPersona(id,name,vorname,money,"",free,skill));
	
  }
  public void loadProject(int r1,int r2,int status)
  {
	  		projects.add (new StubProject (r1,r2,status,false));
     
 }
   private void _createProject(int count)
  {
	  
	   for (int j = 0; j < count; j++) {
	    int r1=Random.int_range(1,100)*100+_time;
	    int r2=Random.int_range(100,1000);
	    int status=0;
		projects.add (new StubProject (r1,r2,status,false));
     }
 }
  public string getProjectsDisplay() {
	string outtext ="";
			foreach (AbstractProject p in projects) {
			       var o = p.attributes[0] as ProjectNr;
			       var n= p.attributes[1] as Umfang;
			        var m = p.attributes[2] as Status;
			        var f = p.attributes[3] as Fertig;
			       if (o != null)
                      outtext=outtext +  o.projectnr.to_string() +"\n";
                    if (n != null)
                      outtext=outtext +  n.umfang.to_string() +"\n";
					 if (m != null)
                      outtext=outtext +  m.status.to_string()+"\n" ;
						if (f !=null)
						outtext += f.fertig.to_string()+"\n";
					}
	return outtext;
}
public string getPeopleDisplay() {
	string outtext ="";
			foreach (AbstractPersona p in personas) {
					var ii =p.attributes[0]	as Ident;
                    var n =p.attributes[1] as Name ;		
                    var v =p.attributes[2] as Vorname ;
                    var m =p.attributes[3] as Money ;
                    var s =p.attributes[6]	as Skill;
			       if (ii != null)
                      outtext=outtext +  ii.id.to_string() +"\n";
                   if (n != null)
                      outtext=outtext +  n.name +"\n";
				   if (v != null)
                      outtext=outtext +  v.vorname+"\n" ;
				   if (m !=null)
						outtext += m.money.to_string()+"\n";
					if (s != null)
                      outtext=outtext +  s.skill.to_string()+"\n" ;
					}
	return outtext;
}

 public int getTime() {
	return _time;
}
 public void setTime(int time) {
	_time=time;
}
 public ArrayList<AbstractProject> getProjects() {
	 	return projects;
	} 
 public ArrayList<AbstractPersona> getPerson() {
	 	return personas;
	}
}

