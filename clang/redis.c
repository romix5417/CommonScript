#include <stdio.h>
#include <hiredis/hiredis.h>
#include <time.h>
#include <stdlib.h>
#include <string.h>

#define DATA_SIZE 1024*1024*128

int main()
{
    //char data[DATA_SIZE*4]={0};
    char *data=NULL;
    char *recv=NULL;
    int i=0;
    int valuelen = DATA_SIZE*4;
    int number=0;
    clock_t start, stop;
    double duration;

    data=(char *)malloc(DATA_SIZE*4);

    srand(time(NULL));

    for(i=0; i<DATA_SIZE; i++){
        number = rand()%10000;
        //printf("number=%d\r\n", number);
        memcpy(data+i*4, (char *)(&number), sizeof(number));
    }


    redisContext* conn = redisConnect("127.0.0.1",6379);

    if(conn->err)
        printf("connection error:%s\n",conn->errstr);

    start=clock();

    redisReply* reply = redisCommand(conn,"set data %b", data, (size_t)valuelen);
    freeReplyObject(reply);

    stop=clock();

    reply = redisCommand(conn,"get data");
    printf("\r\n\r\n");

    recv=reply->str;


    duration=((double)(stop-start)/CLOCKS_PER_SEC);
    printf("duration=%f\r\n", duration);
    /*for(i=0;i<DATA_SIZE;i++){
        number = 0;
        //memcpy((char *)(&number), recv+i*4, sizeof(int));
        //printf("number:%d\r\n", number);
    }*/

    freeReplyObject(reply);

    redisFree(conn);

    return 0;

}
