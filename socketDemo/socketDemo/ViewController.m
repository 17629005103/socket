//
//  ViewController.m
//  socketDemo
//
//  Created by 李鹏辉-PC on 17/8/24.
//  Copyright © 2017年 李鹏辉. All rights reserved.
//

#import "ViewController.h"
#include <netinet/in.h>
#include <sys/socket.h>
#include <arpa/inet.h>
#import "SocketManager.h"

@interface ViewController ()
//服务器socket
@property (nonatomic,assign)int server_socket;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[SocketManager shareSocketManager] connect];
}

//从服务端接受消息
- (void)acceptFromServer{
    while (1) {
        //接受服务器传来的数据
        char buf[1024];
        long iReturn = recv(self.server_socket, buf, 1024, 0);
        NSLog(@"%ld",iReturn);
    }
}



@end
