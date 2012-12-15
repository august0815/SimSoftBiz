using GLib;
using Gee;

public class Company
{
  public ArrayList<AbstractPersona>  employee = new ArrayList<AbstractPersona>();
  public ArrayList<AbstractProject>  projects = new ArrayList<AbstractProject>();
  public ArrayList<AbstractProduct>  product = new ArrayList<AbstractProduct>();

  private string _name;
  public int _karma;
  private int sloc_per_day=19;
  private int totsloc=-16;
  private int _money;
  
   public Company(string name, int money,int karma)
  {	_karma=karma;
	_name = name;
	_money = money;
	}
 
  public string getName()
  {
    return _name; 
  }
  public void setName(string name)
  {
    _name=name; 
  }
    public int getKarma()
  {
    return _karma; 
  }
     public void setKarma(int karma)
  {
     _karma=karma; 
  }
    public int getSloc()
  {
    return totsloc; 
  }
  public int Money() {
	return _money;
 }
 public void setMoney(int money){
	_money=money;
	}
 

public int doPayments(int time) {
	// Every two weeks, pay your people.
	
	int totalPayout = 0;
	if (time % 14 == 0) {
			foreach (AbstractPersona p in employee) {
			        var o = p.attributes[3] as Money;

                    if (o != null)
                      totalPayout += o.money/26;
                      }
			}

	int overheadCost = getOverheadCost();
	overheadCost += totalPayout;
	_money -= overheadCost;//this._money - overheadCost;
	return overheadCost;
}

public int getOverheadCost() {
	// No matter what, you cannot get away scot free.
	int overhead = 0;

	overhead += this.employee.size * 10;

	// Every 10 days something random happens.
	// The higher your everyday costs, the more
	// an occurence costs.
	int random_number = Random.int_range(0,10);
	if (random_number==0){
		int random=Random.int_range(0,100);
		double over = (overhead * random ) /3;
		overhead= (int)over;
		}
	return overhead;
	}

public void doSoftwareWrite(int time){
		
		if (projects.size>0){
			int pos=0;
		var sloc_per_Project =totsloc/projects.size;

			foreach (AbstractProject p in projects) {
					var id= p.attributes[0] as ProjectNr;
			        var n = p.attributes[1] as Umfang;
			        var o = p.attributes[2] as Status;
                    var f = p.attributes[3] as Fertig;
                    var nn =n.umfang;
                    if (!(f.fertig)){
                    if (o.status<nn){
					o.status += sloc_per_Project;
				}else
				{f.fertig=true;}
				}
				if (((f.fertig)) || (o.status>nn)){
					addSoftware_for_sale(id.projectnr,10,time,0);
					projects.remove_at (pos);
				}
				}
			pos ++;
	}
}
   public void addSoftware_for_sale(int nr ,int preis ,int alter,int sold)
  {	
            product.add(new StubProduct (nr,preis,alter,sold));
        
        
        _karma += 5;
          }


 
  public void addEmployee(int id ,string name ,string vorname, int money,int skill)
  {	
		totsloc = totsloc+(int)(sloc_per_day*skill)/100;
		bool free=false;
	   employee.add(new StubPersona(id,name,vorname,money,_name,free,skill));
    
    _karma +=5;
  }
   public void removeEmployee(int id )
  {		int iii=0;
		int ii=0;
		
		foreach (AbstractPersona i in employee) {
			
				    var jj =i.attributes[0] as Ident;
				  if (jj.id==id) { 
						ii=iii;	}
						iii ++;
					}
					if (ii>0)
					employee.remove_at (ii);			
					_karma -=15;
  }
    public void removeProjekt(int id )
  {		int iii=0;
		int ii=0;
		
		foreach (AbstractProject i in projects) {
			
				    var jj =i.attributes[0] as ProjectNr;
				  if (jj. projectnr==id) { 
						ii=iii;	}
						iii ++;
					}
					if (ii>0)
					projects.remove_at (ii);			
					_karma -= 10;
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
public string getEmplyeeDisplay() {
	string outtext ="";
			foreach (AbstractPersona p in employee) {
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
public string getSoftware() {
	string outtext ="";
			foreach (AbstractProduct p in product) {
					var ii =p.attributes[0]	as ProductNr;
                    var n =p.attributes[1] as Preis ;		
                    var v =p.attributes[2] as Alter ;
                     var s =p.attributes[3] as Sold ;
			       if (ii != null)
                      outtext=outtext +  ii.productnr.to_string() +"\n";
                   if (n != null)
                      outtext=outtext +  n.preis.to_string() +"\n";
				   if (v != null)
                      outtext=outtext +  v.alter.to_string()+"\n" ;
                    if (s != null)
                      outtext=outtext +  s.sold.to_string()+"\n" ;
				   }
	return outtext;
}

public int getSoftware_sale(int time) {
	var divider=1.25;
	int verkauft=0;
	int anzahl;
	int preis;
	if (product.size>0){
			foreach (AbstractProduct p in product) {
			 
			       //var o = p.attributes[0] as ProductNr;
			       var n= p.attributes[1] as Preis;
			        var m = p.attributes[2] as Alter;
			        var s=p.attributes[3] as Sold;
			      var r1= (int) (200-((time-m.alter))/divider);
			      if (r1<0)
					{r1=3;}
			         anzahl=Random.int_range(3,r1);
			         s.sold=anzahl;
                  preis =Random.int_range(-3,5);
                    if (n != null)
                     verkauft +=(n.preis+preis)*anzahl;
                }
	
			
			
		}
		_money += verkauft;
	return verkauft;
}
  public ArrayList<AbstractPersona> getEmployee(){
	return employee;
	}
	  public ArrayList<AbstractProject> getProjects(){
	return projects;
	}
	  public ArrayList<AbstractProduct> getProdukt(){
	return product;
	}
	public void addProject(int id ,int umfang ,int status)
  {
		bool fertig=false;
	   projects.add(new StubProject (id,umfang,status,fertig));

	   _karma += 5;
      }
 
}

