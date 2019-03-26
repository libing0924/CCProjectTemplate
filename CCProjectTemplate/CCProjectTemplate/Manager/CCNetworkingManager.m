//
//  LBNetworkingManager.m
//  PandaTakeaway
//
//  Created by smufs on 2017/5/17.
//  Copyright © 2017年 李冰. All rights reserved.
//

#import "CCNetworkingManager.h"
#import <AFNetworking/AFNetworking.h>

@interface CCNetworkingManager ()

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;

@end

@implementation CCNetworkingManager

+ (CCNetworkingManager *) sharedManager {
    
    static CCNetworkingManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[CCNetworkingManager alloc] init];
    });
    
    return manager;
    
}

#pragma mark - GET

- (void)requestGET:(NSString *)urlStr
        parameters:(NSDictionary *)params
           showHUD:(BOOL)showHUD
           success:(Success)success
{

    [self requestGET:urlStr
          parameters:params
             showHUD:showHUD
             headers:nil
            progress:nil
             success:success
             failure:nil];
}

- (void)requestGET:(NSString *)urlStr
        parameters:(NSDictionary *)params
           showHUD:(BOOL)showHUD
           success:(Success)success
           failure:(Failure)failure
{

    [self requestGET:urlStr
          parameters:params
             showHUD:showHUD
             headers:nil
            progress:nil
             success:success
             failure:failure];
}

- (void) requestGET:(NSString *) urlStr
         parameters:(NSDictionary *) params
            showHUD:(BOOL) showHUD
            headers:(NSDictionary *) headers
           progress:(Progress) progress
            success:(Success) success
            failure:(Failure) failure {
    
    [self.httpManager.requestSerializer setValue:[LBUserManager shareInstance].userToken forHTTPHeaderField:@"token"];
    
    // url encoding
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [self.httpManager GET:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
        if (progress) progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
#ifdef DEBUG
        NSAssert(responseObject, @"json is nil");
#endif
        NSInteger code = 200;
        NSString *message = @"null message!";
        if ([responseObject isKindOfClass:[NSDictionary class]])
        {
            code = [[responseObject objectForKey:@"code"] integerValue];
            message = [responseObject objectForKey:@"msg"] ?: @"null message!";
        }
        
        success(responseObject, code, message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        !failure ?: failure(error);
        
    }];
    
}

#pragma mark - upload
- (void)uploadImageWithOperations:(NSDictionary *)operations
                       ImageArray:(NSArray *)imageArray
                      targetWidth:(CGFloat)width
                       targetSize:(CGFloat)size
                        UrlString:(NSString *)urlString
                         progress:(Progress)progress
                          success:(Success)success
                          failure:(Failure)failure {

    [self.httpManager POST:urlString parameters:operations constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        /**出于性能考虑,将上传图片进行压缩*/
        
        NSData *data = nil;
        
        for (UIImage * image in imageArray) {
            
            data = UIImageJPEGRepresentation(image, 1.0);
            
            CGFloat imageKB = data.length/1024.0;
            
            CGFloat maxQuality = 0.9f;
            
            CGFloat lastData = imageKB;
            
            while (imageKB > size && maxQuality > 0.01f) {
                
                maxQuality = maxQuality - 0.01f;
                
                data = UIImageJPEGRepresentation(image, maxQuality);
                
                imageKB = data.length / 1024.0;
                
                if (lastData == imageKB) {
                    break;
                }else{
                    lastData = imageKB;
                }  
            }
            
            
            [formData appendPartWithFileData:data name:@"file" fileName:@"image.png" mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        if (progress) progress(uploadProgress.completedUnitCount/uploadProgress.totalUnitCount);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        NSInteger code = [[responseObject objectForKey:@"code"] integerValue];
        NSString *message = [responseObject objectForKey:@"message"];
        success(responseObject, code, message);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}


#pragma mark - cancel all request
- (void)cancelAllRequest {

    [self.httpManager.operationQueue cancelAllOperations];
}

#pragma mark - cancel specific request
- (void)cancelHttpRequestWithRequestType:(NSString *)requestType requestUrlString:(NSString *)string {

    NSError * error;
    
    /**根据请求的类型 以及 请求的url创建一个NSMutableURLRequest---通过该url去匹配请求队列中是否有该url,如果有的话 那么就取消该请求*/
    
    NSMutableURLRequest *request = [self.httpManager.requestSerializer requestWithMethod:requestType
                                                                               URLString:string
                                                                              parameters:nil
                                                                                   error:&error];
    NSString * urlToPeCanced = [[request URL] path];
    
    
    for (NSOperation * operation in self.httpManager.operationQueue.operations) {
        
        //如果是请求队列
        if ([operation isKindOfClass:[NSURLSessionTask class]]) {
            
            NSURLRequest *urlRequest = [(NSURLSessionTask *)operation currentRequest];
            
            //请求的类型匹配
            BOOL matchRequestType = [requestType isEqualToString:[urlRequest HTTPMethod]];
            
            //请求的url匹配
            BOOL matchRequestUrl = [urlToPeCanced isEqualToString:[[urlRequest URL] path]];
            
            //两项都匹配的话  取消该请求
            if (matchRequestType && matchRequestUrl) {
                
                [operation cancel];
                
            }
        }
        
    }
}

#pragma mark - upload video
- (void)uploadVideoWithPath:(NSString *)videoPath
                   severUrl:(NSString *)myRequestUrl
               successBlock:(Success)block {

    NSURL *myVideoUrl = [NSURL fileURLWithPath:videoPath];
    NSData *myVideoData = [NSData dataWithContentsOfURL:myVideoUrl];
    
    [self.httpManager POST:myRequestUrl parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:myVideoData name:@"file" fileName:@"video.mp4" mimeType:@"video/mp4"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    
    }];
}

#pragma mark - getter
- (AFHTTPSessionManager *) httpManager {
    if (!_httpManager) {
        
        _httpManager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl]];
        _httpManager.requestSerializer = [AFJSONRequestSerializer serializer];
        _httpManager.requestSerializer.timeoutInterval = 20.f;
        _httpManager.requestSerializer.cachePolicy = NSURLRequestReloadRevalidatingCacheData;
//        [_httpManager setSecurityPolicy:[self _customSecurityPolicy]];
        AFJSONResponseSerializer * response = [AFJSONResponseSerializer serializer];
        NSMutableIndexSet *set = [[NSMutableIndexSet alloc] initWithIndex:400];
        [set addIndexesInRange:NSMakeRange(400, 199)];
        [set addIndexesInRange:NSMakeRange(200, 100)];
        response.acceptableStatusCodes = set;
        response.removesKeysWithNullValues = YES;
        _httpManager.responseSerializer = response;
        NSSet *types = [NSSet setWithObjects:   @"application/json",
                                                @"text/plain",
                                                @"text/html",
                                                @"text/json",
                                                @"text/javascript",
                                                @"text/xml",
                                                nil];
        _httpManager.responseSerializer.acceptableContentTypes = types;
    }
    return _httpManager;
}

#pragma mark - 配置自建证书
- (AFSecurityPolicy *)_customSecurityPolicy
{
    //先导入证书，找到证书的路径
    NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"panda.dengcesuo.com" ofType:@"cer"];
    NSData *certData = [NSData dataWithContentsOfFile:cerPath];
    
    //AFSSLPinningModeCertificate 使用证书验证模式
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
    
    //allowInvalidCertificates 是否允许无效证书（也就是自建的证书），默认为NO
    //如果是需要验证自建证书，需要设置为YES
    securityPolicy.allowInvalidCertificates = YES;
    
    //validatesDomainName 是否需要验证域名，默认为YES；
    //假如证书的域名与你请求的域名不一致，需把该项设置为NO；如设成NO的话，即服务器使用其他可信任机构颁发的证书，也可以建立连接，这个非常危险，建议打开。
    //置为NO，主要用于这种情况：客户端请求的是子域名，而证书上的是另外一个域名。因为SSL证书上的域名是独立的，假如证书上注册的域名是www.google.com，那么mail.google.com是无法验证通过的；当然，有钱可以注册通配符的域名*.google.com，但这个还是比较贵的。
    //如置为NO，建议自己添加对应域名的校验逻辑。
    securityPolicy.validatesDomainName = NO;
    NSSet *set = [[NSSet alloc] initWithObjects:certData, nil];
    securityPolicy.pinnedCertificates = set;
    
    return securityPolicy;
}

- (void)compressedImageFiles:(UIImage *)image
                     imageKB:(CGFloat)fImageKBytes
                  imageBlock:(void(^)(UIImage *image))block {
    
    __block UIImage *imageCope = image;
    CGFloat fImageBytes = fImageKBytes * 1024;//需要压缩的字节Byte
    
    __block NSData *uploadImageData = nil;
    
    uploadImageData = UIImagePNGRepresentation(imageCope);
    NSLog(@"图片压前缩成 %fKB",uploadImageData.length/1024.0);
    CGSize size = imageCope.size;
    CGFloat imageWidth = size.width;
    CGFloat imageHeight = size.height;
    
    if (uploadImageData.length > fImageBytes && fImageBytes >0) {
        
        dispatch_async(dispatch_queue_create("CompressedImage", DISPATCH_QUEUE_SERIAL), ^{
            
            /* 宽高的比例 **/
            CGFloat ratioOfWH = imageWidth/imageHeight;
            /* 压缩率 **/
            CGFloat compressionRatio = fImageBytes/uploadImageData.length;
            /* 宽度或者高度的压缩率 **/
            CGFloat widthOrHeightCompressionRatio = sqrt(compressionRatio);
            
            CGFloat dWidth   = imageWidth *widthOrHeightCompressionRatio;
            CGFloat dHeight  = imageHeight*widthOrHeightCompressionRatio;
            if (ratioOfWH >0) { /* 宽 > 高,说明宽度的压缩相对来说更大些 **/
                dHeight = dWidth/ratioOfWH;
            }else {
                dWidth  = dHeight*ratioOfWH;
            }
            
            imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
            uploadImageData = UIImagePNGRepresentation(imageCope);
            
            NSLog(@"当前的图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            //微调
            NSInteger compressCount = 0;
            /* 控制在 1M 以内**/
            while (fabs(uploadImageData.length - fImageBytes) > 1024) {
                /* 再次压缩的比例**/
                CGFloat nextCompressionRatio = 0.9;
                
                if (uploadImageData.length > fImageBytes) {
                    dWidth = dWidth*nextCompressionRatio;
                    dHeight= dHeight*nextCompressionRatio;
                }else {
                    dWidth = dWidth/nextCompressionRatio;
                    dHeight= dHeight/nextCompressionRatio;
                }
                
                imageCope = [self drawWithWithImage:imageCope width:dWidth height:dHeight];
                uploadImageData = UIImagePNGRepresentation(imageCope);
                
                /*防止进入死循环**/
                compressCount ++;
                if (compressCount == 10) {
                    break;
                }
                
            }
            
            NSLog(@"图片已经压缩成 %fKB",uploadImageData.length/1024.0);
            imageCope = [[UIImage alloc] initWithData:uploadImageData];
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                block(imageCope);
            });
        });
    }
    else
    {
        block(imageCope);
    }
}

- (UIImage *)drawWithWithImage:(UIImage *)imageCope width:(CGFloat)dWidth height:(CGFloat)dHeight{
    
    UIGraphicsBeginImageContext(CGSizeMake(dWidth, dHeight));
    [imageCope drawInRect:CGRectMake(0, 0, dWidth, dHeight)];
    imageCope = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageCope;
    
}

- (void)requestPOST:(NSString *)urlStr parameters:(NSDictionary *)params showHUD:(BOOL)showHUD success:(Success)success failure:(Failure)failure {
    
    [self.httpManager.requestSerializer setValue:[LBUserManager shareInstance].userToken forHTTPHeaderField:@"token"];
    
    [self requestPOST:urlStr parameters:params showHUD:showHUD headers:nil progress:nil success:success failure:failure];
}

- (void) requestPOST:(NSString *) urlStr
          parameters:(NSDictionary *) params
             showHUD:(BOOL) showHUD
             headers:(NSDictionary *) headers
            progress:(Progress) progress
             success:(Success) success
             failure:(Failure) failure {
    
    // url encoding
    urlStr = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    if (!params) {
        
        [self.httpManager POST:urlStr parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            
            if (progress) progress(downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
#ifdef DEBUG
            NSAssert(responseObject, @"json is nil");
#endif
            NSInteger code = 200;
            NSString *message = @"null message!";
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                code = [[responseObject objectForKey:@"code"] integerValue];
                message = [responseObject objectForKey:@"msg"] ?: @"null message!";
            }
            
            success(responseObject, code, message);
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            !failure ? : failure(error);
            
        }];
    } else {
        
        [self.httpManager POST:urlStr parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
            
            for (NSString *key in params.allKeys) {
                
                NSString *value = [params objectForKey:key];
                
                if ([value isKindOfClass:[NSString class]]) {
                    
                    NSData *data = [value dataUsingEncoding:NSUTF8StringEncoding];
                    [formData appendPartWithFormData:data name:key];
                } else if ([value isKindOfClass:[NSArray class]]) {
                    
                    NSArray *imageArray = (NSArray *) value;
                    int i = 0;
                    for (UIImage * image in imageArray) {
                        
                        NSData *data = UIImageJPEGRepresentation(image, 0.5);
                        NSString *newKey = [NSString stringWithFormat:@"%@[%d]", key, i];
                        [formData appendPartWithFileData:data name:newKey fileName:@"image.png" mimeType:@"image/jpeg"];
                        i++;
                    }
                }
            }
            
        } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
#ifdef DEBUG
            NSAssert(responseObject, @"json is nil");
#endif
            NSInteger code = 200;
            NSString *message = @"null message!";
            if ([responseObject isKindOfClass:[NSDictionary class]])
            {
                code = [[responseObject objectForKey:@"code"] integerValue];
                message = [responseObject objectForKey:@"msg"] ?: @"null message!";
            }
            
            success(responseObject, code, message);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            !failure ? : failure(error);
        }];
    }
    
}

@end
