/* Quick Sort Demo.
 * 
 * This program sorts a list of number with the Quicksort algorithm
 * as described by Knuth in "The Art of Computer Programming", Vol. 3, 2nd ed., p.114.
 * The numbers are read from standard input;
 * the first number specified how many numbers will follow.
 */
class QuickSort2 
	int[] list;
{
	/* Prints the list to the console. */
	void WriteList () 
		int i;
	{
		i = 0;
		while (i < len(list)) {
			write(list[i]);
			write(' ');
			i++;
		}
		write('\n');
	}
	
	void WriteSeparator ()
		int i;
	{
		i = 0;
		while (i < 10) { write('-'); i++; }
		write('\n');
	}
	
	void Swap (int i, int j)
		int swap;
	{
		swap = list[i];
		list[i] = list[j];
		list[j] = swap;		
	}
	
	/* Sorts the list. */
	void SortList (int first, int last)
		int i, j;
		int x;
	{
		i = first+1;
		j = last;
		x = list[first];

		/* "burn the candle at both ends" */
		while (i < j) {
			while (list[i] < x) i++; 
			while (x < list[j]) j--;

			if (i < j) {
				Swap(i,j);
				i++; j--;
			}
		}
		Swap(first, j);

		/* print the intermediate lists */
		WriteSeparator();
		WriteList();
		
		/* sort right sublist */
		if (first < j) 
			SortList(first, j-1);
		/* sort left sublist */			
		if (i < last)
			SortList(i, last);
	}

	/* Reads the list of numbers from the console. */
	void ReadList () 
		int size, i;
	{
		read(size);
		if (size <= 0) return;
		
		
		list = new int[size];
		i = 0;
		while (i < size) {
			read(list[i]);
			i++;
		}
	}

	void Main () {
		ReadList();
		
		SortList(0, len(list) - 1);

		WriteSeparator();		
		WriteList();
	}
}
