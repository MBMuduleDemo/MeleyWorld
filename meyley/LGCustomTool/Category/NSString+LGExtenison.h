//
//  NSString+LBKJExtenison.h
// 
//
//

#import <Foundation/Foundation.h>

@interface NSString (LGExtenison)

@property (readonly) NSString *md5String;
@property (readonly) NSString *sha1String;
@property (readonly) NSString *sha256String;
@property (readonly) NSString *sha512String;

- (NSString *)hmacSHA1StringWithKey:(NSString *)key;
- (NSString *)hmacSHA256StringWithKey:(NSString *)key;
- (NSString *)hmacSHA512StringWithKey:(NSString *)key;

//+ (NSString *)getBase64StrWithAppraiseArray:(NSArray *)appraiseArray;

//####################################
- (CGSize)sizeWithFont:(UIFont *)font;
- (CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxW;
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;

//判断字符串是否为空
-(BOOL)isEmptyString;

//清空字符串中的空白字符
-(NSString *)trimString;

//是否是表情
-(BOOL)isEmoji;

@end
