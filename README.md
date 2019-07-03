## 使用方法：

1.导入头文件“#import "HLTimer.h"并声明一个表示定时器唯一标识符的属性

```
#import "HLTimer.h"
//定时器唯一标识符
@property (nonatomic, copy) NSString *task;
```

2.开启定时器

```
//doTask方法是待轮询任务。
self.task =  [HLTimer executeTask:self selector:@selector(doTask) start:2.0 interval:1.0 repeats:YES async:YES];
```

3.取消定时器

```
[HLTimer cancelTimerTaskWithIdentifier:self.task];
```
