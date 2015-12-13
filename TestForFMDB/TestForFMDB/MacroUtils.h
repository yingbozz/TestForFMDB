//
//  MacroUtils.h
//  TestForFMDB
//
//  Created by 薛迎波 on 15/12/13.
//  Copyright © 2015年 XueYingbo. All rights reserved.
//

#ifndef MacroUtils_h
#define MacroUtils_h

#define PATH_OF_APP_HOME NSHomeDirectory()
#define PATH_OF_TEMP     NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

#endif /* MacroUtils_h */
