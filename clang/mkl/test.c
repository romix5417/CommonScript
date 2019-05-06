#include <stdio.h>

#include <time.h>
#include <complex.h>

int main()
{
    char key[6];
    clock_t start,stop;
    int i = 0;
    float x = 2.2e-16;

    float complex a = 1 + 2 * I;

    start=clock();
    for(int i = 0; i < 10000; i++){
        sprintf(key,"%05d", i);
    }
    stop=clock();
    printf("%f\r\n", (double)(stop-start)/CLOCKS_PER_SEC);

    printf("complex:%d\r\n", sizeof(float complex));


    for(i = 0; i < 8; i++){
        printf("0x%x ", *((char *)&a + i));
    }

    printf("\r\nx = %.17lf\r\n", x);

    printf("\r\n");
}
