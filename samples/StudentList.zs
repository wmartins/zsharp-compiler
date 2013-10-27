class StudentList
	const int MAXLEN = 20;
	
	class Student {
		int matrNr;
		char[] name;
	}
	
	Student[] list;
	int stCnt;

{
	void WriteString (char[] str)
		int i;
	{
		if (str != null) {
			i = 0;
			while (i < len(str)) {
				write(str[i]);
				i++;
			}
		}
	}
	
	void Init () {
		list = new Student[MAXLEN];
		stCnt = 0;
	}
	
	void Add (Student s)
		int i;
	{	
		/* insert sorted by matrNr */
		i = stCnt - 1;
		while (i >= 0 && s.matrNr < list[i].matrNr) {
			list[i+1] = list[i];
			i--;
		}
		list[i+1] = s;
		stCnt++;
	}

	int Find (int matrNr) 
		int l, r, x;
	{
		/* binary search */
		l = 0; r = stCnt-1; 
		while (l <= r && matrNr != list[x].matrNr) {
			x = (l+r)/2;
			if (matrNr < list[x].matrNr) r = x-1;
			else l = x+1;
		}
		if (matrNr == list[x].matrNr) return x;

		return -1;	
	}

	void WriteStudent (int i) {
		write('m'); write('['); write(i); write(']'); write('=');
		write(list[i].matrNr); write(','); WriteString(list[i].name); 
		write('\n');
	}

	void Main ()
		Student s;
	{	
		Init();
		s = new Student; s.matrNr = 1234567; s.name = new char[3]; 
		s.name[0] = 'X'; s.name[1] = '\'; s.name[2] = 'Y'; 
		Add(s);
		WriteStudent(0);

		s = new Student; s.matrNr = 9876543; s.name = new char[4]; 
		s.name[0] = 'M'; s.name[1] = 'r'; s.name[2] = '.'; s.name[3] = 'X';
		Add(s);
		WriteStudent(1);

		s = new Student; s.matrNr = 9090900; s.name = new char[2]; 
		s.name[0] = 'A'; s.name[1] = 'l';
		Add(s);
		WriteStudent(2);
  
		write(9876543); write(' '); WriteString(list[Find(9876543)].name); write('\n');
		write(1234567); write(' '); WriteString(list[Find(1234567)].name); write('\n');
		write(9090900); write(' '); WriteString(list[Find(9090900)].name); write('\n');
		write(8888888); write(' '); WriteString(list[Find(9056999)].name); write('\r'); write('\n');
	}
}
