class P

	const int size = 10;
	
	class Table {
		int[] pos;
		int[] neg;
	}
	
	Table val;
{
	void Main ()
		int x, i;
	{
		/*---------- Initialize val ----------*/
		val = new Table;
		val.pos = new int[size]; val.neg = new int[size];
		i = 0;
		while (i < size) {
			val.pos[i] = 0; val.neg[i] = 0;
			i++;	
		}

		/*---------- Read values ----------*/
		read(x);
		while (-size < x && x < size) {
			if (0 <= x) val.pos[x]++;
			else val.neg[-x]++;
			read(x);
		}
		
		/*---------- Write result ----------*/
		i = 0;
		while (i < size) {
			write(val.pos[i]);
			write(' ');
			i++;
		}
		write('\n');
		i = 0;
		while (i < size) {
			write(val.neg[i]);
			write(' ');
			i++;
		}
	}
}
