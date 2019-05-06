
#include <stdio.h>
#include <stdlib.h>

#include <complex.h>

#include "mkl.h"

#define RADAR_RANGEBIN_NUMBER 3000
#define RADAR_PRT_NUMBER 64

#define RADAR_RADIAL_NUMBER 80

int main()
{
    int ret = 0;

    FILE *fp = fopen("data.bin", "r");
    char *data = (char *)malloc(RADAR_RANGEBIN_NUMBER * RADAR_PRT_NUMBER * sizeof(MKL_Complex8));

    /*MKL_Complex8 matrix[2][3] = {
        {{1,2}, {2,3}, {3,4}},
        {{2,2}, {2,3}, {3,4}},
    };*/

    //ret = fread(data, RADAR_RANGEBIN_NUMBER * RADAR_PRT_NUMBER, 1, fp);
    //if(ret < 0){
    //    printf("fread data failed!\r\n");
    //}

    vcConj(2, matrix, matrix);

    printf("matrix[0][0] = %f%+fi\r\n", matrix[0][0].real, matrix[0][0].imag);
    printf("matrix[1][0] = %f%+fi\r\n", matrix[1][0].real, matrix[1][0].imag);
    //printf("matrix[0][2] = %f%fi\r\n", matrix[0][2].real, matrix[0][2].imag);
}
