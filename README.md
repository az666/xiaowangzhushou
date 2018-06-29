---
title: lua对接bmob数据库
tags: lua
date: 2018-6-29 11:09:00
---
## lua对接bmob数据库 ##

![](https://i.loli.net/2018/06/29/5b35cbd14d883.png)
----------

> 学习的最终结果：

 1. 实现用户注册和登录
 2. 数据库增删改查
 3. 远程公告
 4. 远程更新版本
 5. 微信反馈
 6. 甚至自己做一个聊天室服务器，等等。。。
 


----------

> 准备安卓lua解释器可以使用酷安上的所有lua编程软件，想自己做UI就用基础的软件，不想自己做UI就用FusionApp来做
![](https://i.loli.net/2018/06/29/5b35cd9d331f5.png)
## 开始##


----------

> 注册bmob数据库新建一个应用和数据库
> 我把它起名lua其中一个表为（tuisong）推送

![](https://i.loli.net/2018/06/29/5b35cfffa741a.png)

----------


![](https://i.loli.net/2018/06/29/5b35ceda7b9c8.png)


----------


> 包含以下值
> 	  
on_off   类型Boolean	 ---代表开启公告标志位
gx_url   类型String	    ---更新软件链接
gx_gg   类型String	    ---更新公告
gg        类型String	    ---公告
bb        类型String      ---版本号


----------

> 在程序启动时间添加更新检测函数：

```
import "bmob"
当前版本 = "2.0"
function 检查更新()
  local b=bmob("你的appid","你的apikey")
  b:query("tuisong",function(code,json)
    if code~=-1 and code>=200 and code<400 then
      --print(dump(json))
      if (json.results[1].bb>当前版本)then
        对话框()
        .设置标题("版本更新")
        .设置消息(json.results[1].gx_gg)
        .设置积极按钮("下载更新",function()
          加载网页(json.results[1].gx_url)
        end)
        .设置消极按钮("取消")
        .显示()
      end
    end
  end)
end
```
