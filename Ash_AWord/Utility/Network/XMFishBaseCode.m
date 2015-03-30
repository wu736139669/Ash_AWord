//
//  XMFishBaseCode.m
//  FanLiKa
//
//  Created by aDu on 14-10-23.
//  Copyright (c) 2014年 xmfish. All rights reserved.
//

#import "XMFishBaseCode.h"
#import "NSString+HXAddtions.h"
#import "SecureUDID.h"
#import <CoreLocation/CoreLocation.h>
@implementation XMFishBaseCode

static char encodingTable[] = "<Aa0Bb1Cc2Dd3Ee4Ff5Gg6Hh7Ii8Jj9KkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz>";

- (id)init
{
    self = [super init];
    
    return self;
}

- (void)setParams:(NSMutableDictionary *)Params
{
    if (_params != Params)
    {
        _params = nil;
        _params = Params;
    }
}

- (NSString *)getBaseCode
{
   
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    data[@"timestamp"] = [NSString stringWithFormat:@"%f", timeStamp];
    

    //app版本号
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    if (appVersion)
    {
        [data setObject:appVersion forKey:@"appversion"];
    }
    
    //网络类型
    NSString *netWorkType = [NSString stringWithFormat:@"%d", [CommonUtil networkType]];
    [data setObject:netWorkType forKey:@"networktype"];
    
    //设备类型
    NSString *deviceName = [CommonUtil getUtsName];
    if (deviceName)
    {
        [data setObject:deviceName forKey:@"devicename"];
    }
    
    //唯一的设备号，用于服务端识别游客
    NSString *domain = @"com.shengshi.ufun";
    NSString *key = @"xmfishufunkey";
    NSString *udid = [SecureUDID UDIDForDomain:domain usingKey:key];
    if (udid)
    {
        [data setObject:udid forKey:@"udid"];
    }
    
    DLog(@"Http param : %@", data);
    return [NSString jsonStringWithDictionary:data];
}

- (NSData *)encode:(const uint8_t*) input length:(NSInteger) length
{
    NSInteger _dlen =((length + 2)/3 * 4)+1;
    NSMutableData* tmpdata = [NSMutableData dataWithLength:_dlen];
    uint8_t* tmpchar = (uint8_t*)tmpdata.mutableBytes;
    srand((unsigned)time(NULL));
    
    for (NSInteger i = 0; i < length; i += 3)
    {
        NSInteger value = 0;
        for (NSInteger j = i; j < (i + 3); j++)
        {
            value <<= 8;
            if (j < length)
            {
                value |= (0xFF & input[j]);
            }
        }
        NSInteger index = (i / 3) * 4;
        tmpchar[index + 0] =                    encodingTable[(value >> 18) & 0x3F];
        tmpchar[index + 1] =                    encodingTable[(value >> 12) & 0x3F];
        if ((i + 1) < length)
        {
            tmpchar[index + 2] = encodingTable[(value >> 6) & 0x3F];
        }
        else
        {
            tmpchar[index + 2] = 0;
            _dlen--;
        }
        if ((i + 2) < length)
        {
            tmpchar[index + 3] = encodingTable[(value >> 0) & 0x3F];
        }
        else
        {
            tmpchar[index + 3] = 0;
            _dlen--;
        }
    }
    int pos=1+ abs((rand()*1234))%60; //字符偏移量
    int add=encodingTable[pos];
    int step=((add%_dlen)%5)+4;
    NSMutableData *_output = [NSMutableData dataWithLength:_dlen];
    uint8_t* output = (uint8_t*)_output.mutableBytes;
    tmpchar[_dlen-1]=add;
    for (int k = 0; k <= _dlen; k+=step)
    {
        int m=0;
        if (k+step+1 > _dlen)
        {
            while (m < step && tmpchar[k+m] > 0)
            {
                output[k+m]=tmpchar[k+m];
                m++;
            }
        }
        else
        {
            while (m < step && tmpchar[k+step-m-1] > 0)
            {
                output[k+m]=tmpchar[k+step-m-1];
                m++;
            }
        }
    }
    return _output;
}

- (NSString *)encode:(NSString *)string
{
    NSData *rayBety=[string  dataUsingEncoding:NSUTF8StringEncoding];
    NSData *newBety=[self encode:rayBety.bytes length:rayBety.length];
    NSString *newString=[[NSString alloc]initWithData:newBety encoding:NSUTF8StringEncoding];
    return newString;
}

+ (NSString *)getWkey
{
    return [[[XMFishBaseCode alloc] init] getBaseCode];
}

@end
