#include <stdlib.h>
#include <stdio.h>
#include <stddef.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <errno.h>
#include <string.h>
#include <unistd.h>
#include <ctype.h>
#include <stdbool.h>

#include <pthread.h>

#define MAXLINE 1500

#define failed -1
#define ok 1

char socket_path[] = "/tmp/server.sock";
char json_file_path[] = "/tmp/DevConfTree.json";


int init_board_info()
{
    system("./sysinfo.sh init");

    return ok;
}

int get_board_info(char *cmd, char **text)
{
    char bufcmd[1500]={0};
    FILE *fp = NULL;
    int file_len = 0;
    int i = 0;
    int ret = 0;

    sprintf(bufcmd, "./sysinfo.sh %s", cmd);
    fp = popen(bufcmd, "r");
    if (fp == NULL) {
        return failed;
    }

    *text=(char *)malloc(4096);
    memset(*text,0,4096);

    while (true) {
        ret = fread(*text+i, 1, 1, fp);
        if(0 < ret){
            file_len = i;
            i++;
            continue;
        }

        break;
    }

    pclose(fp);

    return file_len;
}

int set_board_info(char *cmd)
{
    return ok;
}

void *proc_fun(void *arg)
{
    int ret = 0;

    ret = init_board_info();
    if (ret < 0) {
        perror("init json error.");
    }

    return NULL;
}

int main(void)
{
    struct sockaddr_un serun, cliun;
    socklen_t cliun_len;
    int listenfd, connfd, size;
    char buf[MAXLINE] = {0};
    int i, n;
    char *context = NULL;
    int len = 0;
    char bufnull[1]={" "};

    if ((listenfd = socket(AF_UNIX, SOCK_STREAM, 0)) < 0) {
        perror("socket error");
        exit(1);
    }

    memset(&serun, 0, sizeof(serun));
    serun.sun_family = AF_UNIX;
    strcpy(serun.sun_path, socket_path);
    size = offsetof(struct sockaddr_un, sun_path) + strlen(serun.sun_path);
    unlink(socket_path);
    if (bind(listenfd, (struct sockaddr *)&serun, size) < 0) {
        perror("bind error");
        exit(1);
    }
    printf("UNIX domain socket bound\n");

    if (listen(listenfd, 20) < 0) {
        perror("listen error");
        exit(1);
    }

    printf("Accepting connections ...\n");

    init_board_info();

    while(1) {
        cliun_len = sizeof(cliun);
        if ((connfd = accept(listenfd, (struct sockaddr *)&cliun, &cliun_len)) < 0){
            perror("accept error");
            continue;
        }

        while(1) {
            n = read(connfd, buf, sizeof(buf));
            if (n < 0) {
                perror("read error");
                break;
            } else if(n == 0) {
                printf("EOF\n");
                break;
            }

            printf("received: %s\r\n", buf);

            /*for(i = 0; i < n; i++) {
                buf[i] = toupper(buf[i]);
            }*/

            len = get_board_info(buf,&context);
            if (len > 0) {
                write(connfd, context, len);
                free(context);
                memset(buf,0,MAXLINE);
            } else {

                write(connfd, bufnull, 1);
                free(context);
                memset(buf,0,MAXLINE);
            }
        }
        close(connfd);
    }
    close(listenfd);
    return 0;
}
