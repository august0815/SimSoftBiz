using Gtk;
using Gee;

public class MainWindow : Window {
	private Gtk.Builder builder;
    private Gtk.VBox vbox;
    private TextView text_time;
    private TextView text_money;
    private TextView text_message;
    
    private TextView text_karma;
    private TreeView tree_bewerber;
	private TreeView tree_projecte;
	private TreeView tree_angestellte;
	private TreeView tree_software_to_write;
	private TreeView tree_software;
	private ListStore listmodel_project;
	private ListStore listmodel_bewerber;
	private ListStore listmodel_angestellte ;
	private ListStore listmodel_software_to_write ;
	private ListStore listmodel_software ;
    public TreeSelection selection_projecte;
	public TreeSelection selection_bewerber;
	public TreeSelection selection_angestellte;
	public TreeSelection selection_software_to_write;
	public int project_index=-1;
	public int bewerber_index=-1;
	public int angestellte_index=-1;
	public int software_to_write_index=-1;
	public int verkauf=0;
	string message="";
	
   public MasterState masterstate;
	
	 public MainWindow() {
	
        this.title = "Software Biz Sim";
        this.window_position = WindowPosition.CENTER;
        set_default_size (900, 800);
        this.load_from_file (); 
         
        //add_vbox
        vbox = this.builder.get_object ("vbox") as Gtk.VBox;
        this.add (vbox); 
        vbox.show ();
        
        text_time = this.builder.get_object ("time") as Gtk.TextView;
        text_money = this.builder.get_object ("money") as Gtk.TextView;
        text_karma = this.builder.get_object ("karma") as Gtk.TextView;
        text_message = this.builder.get_object ("Message") as Gtk.TextView;
        tree_bewerber = this.builder.get_object ("bewerber") as Gtk.TreeView;
        tree_projecte = this.builder.get_object ("projekte") as Gtk.TreeView;
        tree_angestellte = this.builder.get_object ("angestellte") as Gtk.TreeView;
		tree_software_to_write = this.builder.get_object ("software_to_write") as Gtk.TreeView;
		tree_software = this.builder.get_object ("Software") as Gtk.TreeView;
        
        this.selection_projecte = tree_projecte.get_selection();
		this.selection_projecte.changed.connect (get_row_projecte);
		this.selection_bewerber = tree_bewerber.get_selection();
		this.selection_bewerber.changed.connect (get_row_bewerber);
		this.selection_angestellte = tree_angestellte.get_selection();
		this.selection_angestellte.changed.connect (get_row_angestellte);
		this.selection_software_to_write = tree_software_to_write.get_selection();
		this.selection_software_to_write.changed.connect (get_row_software_to_write);
        
        setup_tree_projecte  (tree_projecte);
	    setup_tree_bewerber (tree_bewerber);
		setup_tree_angestellte (tree_angestellte);
        setup_tree_software_to_write (tree_software_to_write);
        setup_tree_software (tree_software);
		startinit();
		showStatus();
        this.menu ();
    }
    
    private bool load_from_file() {
        try {
            this.builder = new Gtk.Builder ();
            this.builder.add_from_file ("main.ui");
            return false;
        } catch (Error e) {
            printerr ("Could not load UI: %s\n", e.message);
            return true;
        }
    }
    private void menu () {
		
        Gtk.ImageMenuItem menu_about =  this.builder.get_object ("about") as Gtk.ImageMenuItem;
        menu_about.activate.connect (() => {
     
        });
         var toolbutton_bt2 = this.builder.get_object ("button2") as Gtk.Button;
        toolbutton_bt2.clicked.connect (() => {
			
        });
         var toolbutton_bt4 = this.builder.get_object ("Anzeige") as Gtk.Button;
        toolbutton_bt4.clicked.connect (() => {
			
        });
      
         var toolbutton_bt3 = this.builder.get_object ("button3") as Gtk.Button;
        toolbutton_bt3.clicked.connect (() => {
			message +=masterstate.getPlayerCompany().getEmployee().size.to_string();
         //ausgabe länge der Beschäftigten liste
           	
        });
        var toolbutton_new = this.builder.get_object ("neu") as Gtk.ToolButton;
        toolbutton_new.clicked.connect (() => {
			masterstate = null;
			startinit(); 
			
	   });
	     var toolbutton_open = this.builder.get_object ("open") as Gtk.ToolButton;
         toolbutton_open.clicked.connect (() => {
			on_openfile_clicked();
			oneDayForward();
	   });
	   
	    var toolbutton_save = this.builder.get_object ("save") as Gtk.ToolButton;
         toolbutton_save.clicked.connect (() => {
			on_save_clicked();
	   });
         
        Gtk.ImageMenuItem menu_new =  this.builder.get_object ("new") as Gtk.ImageMenuItem;
        menu_new.activate.connect (() => {
			masterstate = null;
			startinit();
	    }); 
        var toolbutton_next = this.builder.get_object ("next") as Gtk.ToolButton;
        toolbutton_next.clicked.connect (() => {
				oneDayForward();
				sellSoftware();
				showStatus();
        });    
         var toolbutton_next10 = this.builder.get_object ("next10") as Gtk.ToolButton;
        toolbutton_next10.clicked.connect (() => {
			for (int j = 0; j < 10; j++) {
				oneDayForward();
				sellSoftware();
				showStatus();
			}
			
        });        
         var toolbutton_hire = this.builder.get_object ("hire") as Gtk.ToolButton;
        toolbutton_hire.clicked.connect (() => {
			int iii=0;
			int ii=0;
			if (bewerber_index>=0){
           var com=  masterstate.getPlayerCompany();
           var pers =masterstate.getPerson();
           foreach (AbstractPersona i in pers) {
				    var jj =i.attributes[0] as Ident;
				  if (jj.id==bewerber_index) { 
						ii=iii;	}
						iii ++;
					}
				var iiii =pers[ii].attributes[0] as Ident;
				var a =pers[ii].attributes[1] as Name ;
				var b =pers[ii].attributes[2] as Vorname ;
                var c =pers[ii].attributes[3] as Money ;
                var e =pers[ii].attributes[6] as Skill ;
                int karma=com.getKarma();
                var r1=Random.int_range(1,301-karma);
                if (r1<100){
                com.addEmployee(iiii.id,a.name,b.vorname,c.money,e.skill);}
                else {
				message +="Keine Vertrag "+r1.to_string();}
            pers.remove_at (ii);
			oneDayForward();
			bewerber_index=-1;
			sellSoftware();
			showStatus();
			 }
           else { message +="Keiner zum Einstellen \n Erst Person auswählen \n";showStatus();}
        }); 
                   
         var toolbutton_fire = this.builder.get_object ("fire") as Gtk.ToolButton;
        toolbutton_fire.clicked.connect (() => {
			if (angestellte_index>=0){
            var com=masterstate.getPlayerCompany();
            com.removeEmployee(angestellte_index);
			angestellte_index=-1;
			oneDayForward();
			sellSoftware();
			showStatus();
			 }
           else {message +="Keiner zum Entlassen \n Erst Person auswählen \n";showStatus();}
        });
          var toolbutton_addSoftware = this.builder.get_object ("addSoftware") as Gtk.ToolButton;
        toolbutton_addSoftware.clicked.connect (() => {
			int iii=0;
			int ii=0;
			var com=  masterstate.getPlayerCompany();
			if (project_index>=0){
			var proj =masterstate.getProjects();
           
			foreach (AbstractProject i in proj) {
				    var jj =i.attributes[0] as ProjectNr;
				   if (jj.projectnr==project_index) { 
						ii=iii;	}
						iii ++;
					}
				
				var a =proj[ii].attributes[0] as ProjectNr ;
                var b =proj[ii].attributes[1] as Umfang ;
                var c =proj[ii].attributes[2] as Status ;
              com.addProject(a.projectnr,b.umfang,c.status);
			proj.remove_at (ii);
			project_index =-1;
			
			oneDayForward();
			sellSoftware();
			showStatus();
			 }
           else {message +="Nichts ausgewählt \n Erst Project auswählen\n";showStatus();}
        });
         var toolbutton_removeProjekt = this.builder.get_object ("removeProjekt") as Gtk.ToolButton;
        toolbutton_removeProjekt.clicked.connect (() => {
			if (software_to_write_index>=0){
			var com=masterstate.getPlayerCompany();
            com.removeProjekt(software_to_write_index);
			software_to_write_index=-1;
			oneDayForward();
			sellSoftware();
			showStatus();
			 }
           else {message +="Nichts ausgewählt \n Erst Project auswählen\n";showStatus();}
        });
                                                  
    }
    
 private void on_openfile_clicked () {
        var file_chooser = new FileChooserDialog ("BizSim LOAD File", this,
                                      FileChooserAction.OPEN,
                                      Stock.CANCEL, ResponseType.CANCEL,
                                      Stock.OPEN, ResponseType.ACCEPT);
        if (file_chooser.run () == ResponseType.ACCEPT) {
            open_file (file_chooser.get_filename ());
        }
        file_chooser.destroy ();
    }
  private void open_file (string filename) {
            masterstate = null;
			masterstate= new MasterState ();
			File file = File.new_for_path(filename);

try {
    if(file.query_exists() == true){
		
        var dis = new DataInputStream (file.read ());
        string line;
        // Read lines until end of file (null) is reached
         line = dis.read_line (null); stdout.printf("%s\n",line); 
         var com=masterstate.getPlayerCompany(); 
         com.setName(line);
         line = dis.read_line (null); stdout.printf("%s\n",line); 
         com.setMoney(int.parse(line));
         line = dis.read_line (null); stdout.printf("%s\n",line);
         masterstate.setTime(int.parse(line));          
         line = dis.read_line (null); stdout.printf("%s\n",line);
         com.setKarma(int.parse(line));          
         line = dis.read_line (null); stdout.printf("%s\n",line);
         int index=int.parse(line);
         if (index<0) {index=0;}
        // masterstate._playerCompany.employee.size=index;
         if (index>0){
         stdout.printf("INDEX PEOPLE %s\n",line);
         for(int j = 0; j < index; j++){
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 int id=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			string name=line;
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			string vorname=line;
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int money=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 int skill=int.parse(line);
			 masterstate.loadPeople(id,name,vorname,money,skill);
			 }
		 }
		 line = dis.read_line (null); stdout.printf("%s\n",line);
          index=int.parse(line);
          if (index<0) {index=0;}
        // masterstate._projects=index;
         if (index>0){
         stdout.printf("INDEX Projekt %s\n",line);
         for(int j = 0; j < index; j++){
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 int id=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int umfang=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int status=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 //bool fertig=bool.parse(line);
			 masterstate.loadProject(id,umfang,status);
			 }
		 }
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 index=int.parse(line);
			 if (index<0) {index=0;}
         //com.allEmployees=index;
         if (index>0){
         stdout.printf("INDEX Employee %s\n",line);
         for(int j = 0; j < index; j++){
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 int id=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			string name=line;
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			string vorname=line;
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int money=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 int skill=int.parse(line);
			 com.addEmployee(id,name,vorname,money,skill);
			 com._karma -=5;
			 }
		 }
		 line = dis.read_line (null); stdout.printf("%s\n",line);
          index=int.parse(line);
          if (index<0) {index=0;}
         //com.allProject=index;
         if (index>0){
         stdout.printf("INDEX Softw %s\n",line);
         for(int j = 0; j < index; j++){
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 int id=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int umfang=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int status=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 //bool fertig=bool.parse(line);
			 com.addProject(id,umfang,status);
			 com._karma -=5;
			 }
		 }
			 line = dis.read_line (null); stdout.printf("%s\n",line);
          index=int.parse(line);
          if (index<0) {index=0;}
        // com.allSoftware_for_sale=index;
         if (index>0){
         stdout.printf("INDEX SoftwFertig %s\n",line);
         for(int j = 0; j < index; j++){
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			 int id=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int preis=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int alter=int.parse(line);
			 line = dis.read_line (null); stdout.printf("%s\n",line);
			int sold=int.parse(line);
			 com.addSoftware_for_sale(id,preis,alter,sold);
			 com._karma -=5;
			 }
		 }
		 stdout.printf("INDEX Fertig \n");
       
    }
} catch (Error e) {
    stderr.printf ("Error: %s\n", e.message);
	}
            
}    
      private void on_save_clicked () {
    	
				string filepath="/mario/home/t_vala/";
						var dialog = new FileChooserDialog(("Choose a file name"),this,
																								FileChooserAction.SAVE,
																								Stock.SAVE,1,Stock.CANCEL,2,null);
						dialog.set_current_folder((filepath == "" ? Environment.get_home_dir() : filepath));
						dialog.file_activated.connect(() => {
						var confirm_dialog = new MessageDialog(this,DialogFlags.MODAL,
																MessageType.WARNING,
																ButtonsType.YES_NO,
																("That file alreadly exists. Overwrite?"));
							confirm_dialog.response.connect((id) => {
							confirm_dialog.destroy();
								if(id == Gtk.ResponseType.YES && dialog.get_filename() != null) {
									save_file(dialog.get_filename().split("/"));
								
								}
								dialog.destroy();
							});
							confirm_dialog.run();
						});
						dialog.response.connect((id) => {
							if(id==2){dialog.destroy(); return;}
							save_file(dialog.get_filename().split("/"));
							dialog.destroy();
						});
						dialog.run();
					
										
        }
private void save_file(string[]? _raw_path = null) {
			if(_raw_path != null) {
				string filename = _raw_path[_raw_path.length-1];
				var file = File.new_for_path (filename);
	try {
        // delete if file already exists
        if (file.query_exists ()) {
            file.delete ();
        }
          var dos = new DataOutputStream (file.create (FileCreateFlags.REPLACE_DESTINATION));
        var com =masterstate.getPlayerCompany();
		string  save_string =com.getName()+"\n"+com.Money().to_string()+"\n"+masterstate.getTime().to_string()+"\n";
		save_string +=com._karma.to_string()+"\n";
		if (masterstate.personas.size==0){save_string+="-1\n";}else{
		save_string +=masterstate.personas.size.to_string()+"\n"+masterstate.getPeopleDisplay();}
		if (masterstate.projects.size==0){save_string+="-1\n";}else{
		save_string +=masterstate.projects.size.to_string()+"\n"+masterstate.getProjectsDisplay();}
		if (com.employee.size==0){save_string+="-1\n";}else{
		save_string +=com.employee.size.to_string()+"\n" + com.getEmplyeeDisplay();}
		if (com.projects.size==0){save_string+="-1\n";}else{
		save_string +=com.projects.size.to_string()+"\n"+com.getProjectsDisplay();}
		if (com.product.size==0){save_string+="-1\n";}else{
		save_string +=com.product.size.to_string()+"\n"+com.getSoftware();}
        dos.put_string (save_string);

} catch (Error e) {
    stderr.printf ("Error: %s\n", e.message);
}
				//file.filepath = path;
			}
			}
public void oneDayForward(){
			masterstate.advanceTime(1);
			masterstate.getPlayerCompany().doSoftwareWrite(masterstate.getTime());
            tree_projecte_display();
			tree_bewerber_display();
			tree_angestellte_display();
			tree_software_to_write_display();
			tree_software_display();
			this.text_karma.buffer.text =masterstate.getPlayerCompany().getName()+"\n"+masterstate.getPlayerCompany().getKarma().to_string();
			this.text_time.buffer.text ="Es ist  Tag  :"+ masterstate.getTime().to_string()+"\n"+ masterstate.getPlayerCompany().getSloc().to_string();
            var com=  masterstate.getPlayerCompany();
            var tme= masterstate.getTime();
            var cost=com.doPayments(tme);
            this.text_money.buffer.text = masterstate.getPlayerCompany().Money().to_string();
           	this.text_money.buffer.text +="\nKosten  in dieser Runde   "+cost.to_string();
           	}
public void showStatus(){
			this.text_message.buffer.text =message;
			message="";
		tree_projecte_display();
        tree_bewerber_display();
        tree_angestellte_display();
        tree_software_to_write_display();
        tree_software_display();
			} 
			
public void sellSoftware(){
	verkauf=masterstate.getPlayerCompany().getSoftware_sale(masterstate.getTime());
   }
public void startinit(){
		masterstate= new MasterState ();
		masterstate.startinits();
		masterstate.advanceTime(10);
        var com=masterstate.getPlayerCompany();
        com.addEmployee(-1,"CEO","HIMSELF",100000,100);
       
        this.text_karma.buffer.text =masterstate.getPlayerCompany().getName()+"\n"+masterstate.getPlayerCompany().getKarma().to_string();
        this.text_money.buffer.text =masterstate.getPlayerCompany().Money().to_string();		
		this.text_time.buffer.text ="Es ist  Tag  : "+ masterstate.getTime().to_string()+"\n"+ masterstate.getPlayerCompany().getSloc().to_string();
        this.text_money.buffer.text =masterstate.getPlayerCompany().Money().to_string();
        showStatus();  
	}   
private void get_row_projecte () {
TreeModel model;
TreeIter iter;

if( this.selection_projecte.get_selected (out model, out iter) ) {
model.get (iter, 0, out project_index);
}
}

private void get_row_bewerber () {

TreeModel model;
TreeIter iter;

if( this.selection_bewerber.get_selected (out model, out iter) ) {
int index;
model.get (iter, 0, out index);
bewerber_index=index;
}
}
private void get_row_angestellte() {
TreeModel model;
TreeIter iter;

if( this.selection_angestellte.get_selected (out model, out iter) ) {
model.get (iter, 0, out angestellte_index);
}
}
private void get_row_software_to_write() {
TreeModel model;
TreeIter iter;

if( this.selection_software_to_write.get_selected (out model, out iter) ) {
model.get (iter, 0, out software_to_write_index);
}
}


private void setup_tree_projecte (TreeView view){
    
	listmodel_project = new ListStore (2, typeof (int), typeof (int),typeof (string));
	view.set_model (listmodel_project);
	listmodel_project.clear();
	view.insert_column_with_attributes (-1, " Nummer", new
	CellRendererText (), "text", 0);
	view.insert_column_with_attributes (-1, " Umfang", new
	CellRendererText (), "text", 1);
	}
public void tree_projecte_display () { 
	listmodel_project.clear();
	TreeIter iter;
	var proj =masterstate.getProjects();
	       foreach (AbstractProject p in proj) {
                    listmodel_project.append (out iter);	
                    var n =p.attributes[0] as ProjectNr ;		
                    var v =p.attributes[1] as Umfang ;
         listmodel_project.set (iter, 0,n.projectnr,1,v.umfang);
             }
		
     }
private void setup_tree_software_to_write (TreeView view){
    
	listmodel_software_to_write = new ListStore (3, typeof (int), typeof (int),typeof (int),typeof (string));
	view.set_model (listmodel_software_to_write);
	listmodel_software_to_write.clear();
	view.insert_column_with_attributes (-1, " Nummer", new
	CellRendererText (), "text", 0);
	view.insert_column_with_attributes (-1, " Umfang", new
	CellRendererText (), "text", 1);
	view.insert_column_with_attributes (-1, " Status", new
	CellRendererText (), "text", 2);
	}
public void tree_software_to_write_display () { 
	listmodel_software_to_write.clear();
	TreeIter iter;
	var proj =masterstate.getPlayerCompany().getProjects();
	       foreach (AbstractProject p in proj) {
                    listmodel_software_to_write.append (out iter);	
                    var n =p.attributes[0] as ProjectNr ;		
                    var v =p.attributes[1] as Umfang ;
                    var s =p.attributes[2] as Status ;
              listmodel_software_to_write.set (iter, 0,n.projectnr,1,v.umfang,2,s.status);
             }
		
     }


private void setup_tree_bewerber (TreeView view){
	listmodel_bewerber = new ListStore (5, typeof (int),typeof (string), typeof (string),
	typeof (string), typeof (int));
	view.set_model (listmodel_bewerber);
	listmodel_bewerber.clear();
	view.insert_column_with_attributes (-1, " Nummer", new
	CellRendererText (), "text", 0);
	view.insert_column_with_attributes (-1, " Name", new
	CellRendererText (), "text", 1);
	view.insert_column_with_attributes (-1, " Vorname", new
	CellRendererText (), "text", 2);
	view.insert_column_with_attributes (-1, "Money",new
	CellRendererText (),"text", 3);
	view.insert_column_with_attributes (-1, "Skill",new
	CellRendererText (),"text", 4);
}
public void tree_bewerber_display () {  
	TreeIter iter;
	listmodel_bewerber.clear();
    var pers =masterstate.getPerson();
           foreach (AbstractPersona p in pers) {
                    listmodel_bewerber.append (out iter);	
                    var ii =p.attributes[0]	as Ident;
                    var n =p.attributes[1] as Name ;		
                    var v =p.attributes[2] as Vorname ;
                    var m =p.attributes[3] as Money ;
                    var s =p.attributes[6]	as Skill;
			listmodel_bewerber.set (iter, 0,ii.id,1,n.name,2,v.vorname,3,m.money.to_string(),4,s.skill);
             }
		
     }
private void setup_tree_angestellte  (TreeView view){
	listmodel_angestellte  = new ListStore (5, typeof (int),typeof (string), typeof (string),
	typeof (string), typeof (int));
	view.set_model (listmodel_angestellte );
	listmodel_angestellte .clear();
	view.insert_column_with_attributes (-1, " Nummer", new
	CellRendererText (), "text", 0);
	view.insert_column_with_attributes (-1, " Name", new
	CellRendererText (), "text", 1);
	view.insert_column_with_attributes (-1, " Vorname", new
	CellRendererText (), "text", 2);
	view.insert_column_with_attributes (-1, "Money",new
	CellRendererText (),"text", 3);
	view.insert_column_with_attributes (-1, "Skill",new
	CellRendererText (),"text", 4);
}
public void tree_angestellte_display () {  
	TreeIter iter;
	listmodel_angestellte .clear();
    var com=  masterstate.getPlayerCompany();
    var pers =com.getEmployee();
           foreach (AbstractPersona p in pers) {
                    listmodel_angestellte .append (out iter);	
                    var ii =p.attributes[0]	as Ident;
                    var n =p.attributes[1] as Name ;		
                    var v =p.attributes[2] as Vorname ;
                    var m =p.attributes[3] as Money ;
                    var s =p.attributes[6]	as Skill;
			listmodel_angestellte .set (iter, 0,ii.id,1,n.name,2,v.vorname,3,m.money.to_string(),4,s.skill);
             }
		
     }

private void setup_tree_software (TreeView view){
    
	listmodel_software = new ListStore (4, typeof (int), typeof (int),typeof (int),typeof (int),typeof (string));
	view.set_model (listmodel_software);
	listmodel_software.clear();
	view.insert_column_with_attributes (-1, " Nummer", new
	CellRendererText (), "text", 0);
	view.insert_column_with_attributes (-1, " Preis", new
	CellRendererText (), "text", 1);
	view.insert_column_with_attributes (-1, " Alter", new
	CellRendererText (), "text", 2);
	view.insert_column_with_attributes (-1, " Verkauft", new
	CellRendererText (), "text", 3);
	}
public void tree_software_display () { 
	listmodel_software.clear();
	TreeIter iter;
	var prod =masterstate.getPlayerCompany().getProdukt();
	       foreach (AbstractProduct p in prod) {
                    listmodel_software.append (out iter);	
                    var n =p.attributes[0] as  ProductNr ;		
                    var v =p.attributes[1] as Preis ;
                    var s =p.attributes[2] as Alter ;
                    var t =p.attributes[3] as Sold;
                  listmodel_software.set (iter, 0,n.productnr,1,v.preis,2,s.alter,3,t.sold);
             }
		
     }


       public static int main (string[] args) {    
        Gtk.init (ref args);
        var mainwindow = new MainWindow ();
        mainwindow.show_all (); //kein show_all da das Fenster Widgets enthält die versteckt bleiben müssen
        mainwindow.destroy.connect(Gtk.main_quit);
        Gtk.main ();
        return 0;
    }
}
