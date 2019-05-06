#include <stdio.h>
#include <unistd.h>

double uniform_random(double a, double b, long int *seed)
{
    double t = 0;

    *seed = 2045 * (*seed) + 1;
    *seed = *seed - (*seed/1048576) * 1048576;
    t = (*seed)/1048576.0;
    t=a + (b-a)*t;

    return t;
}

int main()
{
    long int seed=14576;
    double a = 0;
    double b = 100.0;
    double x = 0;
    int i=0;

    for(i=0; i<10; i++){
        printf("\33[2K\r");
        x = uniform_random(a, b, &seed);
        printf("random number:%f\r", x);
        fflush(stdout);
        sleep(1);
    }
}
