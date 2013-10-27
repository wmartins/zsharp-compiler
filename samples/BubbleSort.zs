/* Bubble Sort Demo. 
 * 
 * This program sort a list of numbers with the Bubble Sort algorithm.
 * The numbers are read from standard input;
 * the first number specifies how many numbers will follow.
 */

class BubbleSort 
{
	/* Sorts the array. */
	void Sort (int[] array, int count)
		int i, j;
		int temp;
	{
		i = 1;
		while (i < count) {
			j = count - 1;
			while (j > 0) {
				if (array[j] < array[j - 1]) {
					temp = array[j];
					array[j] = array[j - 1];
					array[j - 1] = temp;
				}
				j--;
			}
			i++;
		}
	}
	
	void Main ()
		int[] array;
		int size;
		int i;
	{
		read(size);
		if (size <= 0) return;

		array = new int[size];
		i = 0;
		while (i < size) {
			read(array[i]);
			i++;
		}
		
		Sort(array, size);  /* sort the array */
		
		i = 0;
		while (i < size) {
			write(array[i]);
			write('\n');
			i++;
		}
	}
}
