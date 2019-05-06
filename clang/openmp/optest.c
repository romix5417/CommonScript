#include <stdio.h>
#include <time.h>
#include <stdlib.h>

int main(int argc, char* argv[])
{
    int s;
    clock_t start, end;

    start = clock();

#pragma omp parallel for
    for (int i = 0; i < 100000000; i++ )
    {
        s=s*i;
        //printf("i = %d\n", i);
    }

    end = clock();

    printf("%f\n", (double)(end - start)/CLOCKS_PER_SEC);
    printf("%d", s)

    return 0;
}
