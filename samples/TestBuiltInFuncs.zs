class TestBuiltInFuncs {
	void Main ()
		int i;
		char ch;
		int[] a;
		char[] b; 
	{
		i = ord('\');
		write('\'); write('='); write(i); write('\n');
		ch = chr(92);
		write(92); write('='); write(ch); write('\n');
		write('\n');
		a = new int[11];
		write(len(a)); write('\n');
		b = new char[4];
		write(len(b));
	}
}