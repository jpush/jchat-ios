//
//  JMSGFileManager.m
//  PAChat
//
//  Created by xiao on 9/5/13.
//  Copyright (c) 2013 FreeDo. All rights reserved.
//

#import "JCHATFileManager.h"

static NSString *filePath = nil;
@implementation JCHATFileManager
//TODO:
+ (BOOL)initWithFilePath{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
  NSString *docDir = paths[0];
  filePath = docDir;
  [[NSFileManager defaultManager] createDirectoryAtPath: [NSString stringWithFormat:@"%@/image",filePath] withIntermediateDirectories:YES attributes:nil error:nil];
  [[NSFileManager defaultManager] createDirectoryAtPath: [NSString stringWithFormat:@"%@/audio",filePath] withIntermediateDirectories:YES attributes:nil error:nil];
  [[NSFileManager defaultManager] createDirectoryAtPath: [NSString stringWithFormat:@"%@/video",filePath] withIntermediateDirectories:YES attributes:nil error:nil];
  return YES;
}

//type is the messageType(etc.voice,image), fileType is type of file,(etc. jpg for image)
+ (NSString *)generatePathWithConversationID:(NSString *)conID withMessageType:(FILE_TYPE)type withFileType:(NSString *)fileType{
  NSString *pathType;
  NSString *suffix;
  switch (type){
    case FILE_IMAGE:
      pathType = @"image";
      if (!fileType){
        suffix = @".jpg";
      } else{
        suffix = [NSString stringWithFormat:@".%@",fileType];
      }
      break;
    case FILE_AUDIO:
      pathType = @"voice";
      if (!fileType){
        suffix = @".mp3";
      } else{
        suffix = [NSString stringWithFormat:@".%@",fileType];
      }
      break;
    default:
      break;
  }

  CFUUIDRef udid = CFUUIDCreate(NULL);
  NSString *desPath = [NSString stringWithFormat:@"%@/%@/%@/%@%@",filePath,pathType,conID,(__bridge_transfer NSString *) CFUUIDCreateString(NULL, udid),suffix];
  CFRelease(udid);

  return desPath;
}

+ (BOOL)saveToPath:(NSString *)path withData:(NSData *)data {
  BOOL success = NO;
  if (data) {
    NSFileManager *file = [NSFileManager defaultManager];
    NSString *pathDir = [path stringByDeletingLastPathComponent];

    if ([file createDirectoryAtPath:pathDir withIntermediateDirectories:YES attributes:nil error:nil]) {
      success = [file createFileAtPath:path contents:data attributes:nil];
    }
  }
  return success;
}

+ (NSString*)saveImageWithConversationID:(NSString*)conID andData:(NSData *)imgData{
  CFUUIDRef udid = CFUUIDCreate(NULL);
  NSString *desPath = [NSString stringWithFormat:@"%@/image/%@/%@.jpg",filePath,conID,(__bridge_transfer NSString *) CFUUIDCreateString(NULL, udid)];
  CFRelease(udid);
  if (imgData) {
    NSFileManager *file = [NSFileManager defaultManager];
    BOOL success = NO;
    if ([file createDirectoryAtPath:[NSString stringWithFormat:@"%@/image/%@",filePath,conID] withIntermediateDirectories:YES attributes:nil error:nil]) {
      success =  [file createFileAtPath:desPath contents:imgData attributes:nil];
    }
    if (success) {
      return desPath;
    }
   
  }
  return nil;
}

+ (NSString*)saveChatBackgroundImageWithConversationID:(NSString*)conID andData:(NSData *)imgData{
  NSString *desPath = [NSString stringWithFormat:@"%@/setting/image/%@/back.png",filePath,conID];
  if (imgData) {
    NSFileManager *file = [NSFileManager defaultManager];
    BOOL success = NO;
    if ([file createDirectoryAtPath:[NSString stringWithFormat:@"%@/setting/image/%@",filePath,conID] withIntermediateDirectories:YES attributes:nil error:nil]) {
      success =  [file createFileAtPath:desPath contents:imgData attributes:nil];
    }
    if (success) {
      return desPath;
    }
        
  }
  return nil;
}

+ (NSString *)copyFile:(NSString *)sourepath withType:(FILE_TYPE)type From:(NSString *)sourceID to:(NSString *)destinationID {
  NSError* error;
  NSString *desPath= nil;
  switch (type) {
    case FILE_IMAGE:
    {
      desPath = [NSString stringWithFormat:@"%@/image/%@/%@",filePath,destinationID,[sourepath lastPathComponent]];
    }
      break;
    case FILE_AUDIO:
    {
      desPath = [NSString stringWithFormat:@"%@/audio/%@/%@",filePath,destinationID,[sourepath lastPathComponent]];
    }
            
      break;
    case FILE_VIDIO:
    {
      desPath = [NSString stringWithFormat:@"%@/video/%@/%@",filePath,destinationID,[sourepath lastPathComponent]];
    }
      break;
            
    default:
            
      break;
  }
  if (!desPath) {
    NSLog(@"保存文件地址错误");
    assert(desPath);
    return @"";
  }
  NSFileManager *file = [NSFileManager defaultManager];
    
  if ([file createDirectoryAtPath:[desPath stringByDeletingLastPathComponent] withIntermediateDirectories:YES attributes:nil error:nil]) {
    if ([file fileExistsAtPath:desPath]) {
      NSString *fileName = [desPath lastPathComponent];
      CFUUIDRef udid = CFUUIDCreate(NULL);
      fileName = [NSString stringWithFormat:@"%@_%@",(__bridge_transfer NSString *) CFUUIDCreateString(NULL, udid),fileName];
      desPath = [[desPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:fileName];
    }
    [file copyItemAtPath:sourepath toPath:desPath  error:&error];
  }
    
  if (error != nil) {
    NSLog(@"Error message is %@", [error localizedDescription]);
    return @"";
  }
  return desPath;
}

+ (BOOL)deleteFile:(NSString *)path{
  NSError* error;
  if (path.length) {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    [fileManager removeItemAtPath:path error:&error];
    if (error != nil) {
      NSLog(@"Error message is %@", [error localizedDescription]);
      return NO;
    }
    return YES;
  }
  return NO;
}

+ (NSString*)saveGlobalBackGround:(NSData *)imgData{
  NSString *desPath = [NSString stringWithFormat:@"%@/setting/image/globalback.png",filePath];
  if (imgData) {
    NSFileManager *file = [NSFileManager defaultManager];
    BOOL success = NO;
    if ([file createDirectoryAtPath:[NSString stringWithFormat:@"%@/setting/image",filePath] withIntermediateDirectories:YES attributes:nil error:nil]) {
      success =  [file createFileAtPath:desPath contents:imgData attributes:nil];
    }
    if (success) {
      return desPath;
    }
        
  }
  return nil;

}

//清空个人用户单个会话下所有下载文件
+ (void)deletAllFilesByConversationID:(NSString *)conversationID{
  NSString *imagePath = [NSString stringWithFormat:@"%@/image/%@",filePath,conversationID];
  NSString *audioPath = [NSString stringWithFormat:@"%@/audio/%@",filePath,conversationID];
  NSString *videoPath = [NSString stringWithFormat:@"%@/video/%@",filePath,conversationID];
   
  [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
  [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
  [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}

//清空个人用户所有下载文件和db
+ (void)deletAllFiles{
  NSString *imagePath = [NSString stringWithFormat:@"%@/image",filePath];
  NSString *audioPath = [NSString stringWithFormat:@"%@/audio",filePath];
  NSString *videoPath = [NSString stringWithFormat:@"%@/video",filePath];

  [[NSFileManager defaultManager] removeItemAtPath:imagePath error:nil];
  [[NSFileManager defaultManager] removeItemAtPath:audioPath error:nil];
  [[NSFileManager defaultManager] removeItemAtPath:videoPath error:nil];
}

//清空documnet 目录
+ (void)deletAllFilesAtDocument{
  NSArray*  paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  [[NSFileManager defaultManager] removeItemAtPath:[paths objectAtIndex:0] error:nil];

}

@end
