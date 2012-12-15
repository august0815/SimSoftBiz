/*************************PROJECTS ******************/
sind Listen von Projekten mit Listen von Atributen

Erzeugung zB :

	  for (int j = 0; j < count; j++) {
	   projects.add (new StubProject (j,100,100,false));
   }
   
   Ausgabe :
    var soft= masterstate.getProjects();
            string outtext="";
            foreach (AbstractProject p in soft) {
               foreach (AbstractAttribute a in p.attributes) {
                    
                    var n = a as ProjectNr;
                    var m = a as Umfang;
                   
                    if (n != null)
                      outtext=outtext +  n.projectnr.to_string() +" ";

                    if (m != null)
                     outtext=outtext +  m.umfang.to_string()+" \n";

					}
                }
            
            this.text_view.buffer.text ="NEW gedrückt "+outtext;
