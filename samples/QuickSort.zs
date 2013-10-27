/* Quick Sort Demo.
 * 
 * This program sorts a list of number with the Quicksort algorithm.
 * The numbers are read from standard input;
 * the first number specified how many numbers will follow.
 */
class QuickSort 
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
	
	/* Sorts the list. */
	void SortList (int first, int last)
		int i, j;
		int mid;
		int swap;
	{
		i = first;
		j = last;
		mid = list[(first + last) / 2];

		while (i < j) {
			while (list[i] < mid) i++; 
			while (mid < list[j]) j--;

			if (i <= j) {
				swap = list[i];
				list[i] = list[j];
				list[j] = swap;
				i++; j--;
			}
		}

		/* print the intermediate lists */
		WriteSeparator();
		WriteList();
		
		/* sort right sublist */
		if (first < j) 
			SortList(first, j);
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
