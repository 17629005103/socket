//
//  SocketManager.h
//  socketDemo
//
//  Created by 李鹏辉-PC on 17/8/24.
//  Copyright © 2017年 李鹏辉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SocketManager : NSObject

+ (SocketManager *)shareSocketManager;

- (void)connect;

@end
