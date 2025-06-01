#include <stdio.h>
#include <stdlib.h>

const size_t input_size = 1000;

int cmp(const void* a, const void* b) {
	return *((const int*) a) - *((const int*) b);
}

int main() {
	auto file = fopen("input", "r");

	int lc[input_size];
	int rc[input_size];
	
	size_t insert_ind = 0;
	while (fscanf(file, "%d   %d\n", &lc[insert_ind], &rc[insert_ind]) == 2)
		insert_ind ++;

	qsort(lc, input_size, sizeof(int), cmp);
	qsort(rc, input_size, sizeof(int), cmp);

	auto part1 = 0ULL;
	for (size_t i = 0; i < input_size; i++) {
		part1 += abs(lc[i] - rc[i]);
	}
	printf("%llu\n", part1);

	auto part2 = 0ULL;
	
	for (size_t i = 0, j = 0; i < input_size && j < input_size;) {
		while (j < input_size && rc[j] < lc[i]) j++;
		if (j == input_size) break;
		while (i < input_size && lc[i] < rc[j]) i++;
		if (i == input_size) break;

		if (lc[i] == rc[j]) {
			const auto js = j;
			for (; j < input_size && rc[j] == rc[js]; j++);

			const auto is = i;
			for (; i < input_size && lc[i] == lc[is]; i++);

			part2 += lc[is] * (j - js) * (i - is);
		}
	}
	printf("%llu\n", part2);

	return 0;
}
