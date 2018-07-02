--个人博客  http://www.wenzheng.club/
local Http=luajava.bindClass "com.androlua.Http"
local File=luajava.bindClass "java.io.File"
local pairs,tostring,print,dump,xpcall=pairs,tostring,print,dump,xpcall
local cjson=require "cjson"
local table=require "table"
local string=require "string"
local type=type
module "bmob"
--转码
local function decode(s)
  s=tostring(s)
  return (s:gsub("%W",function(c) 
    return string.format("%%%02X",string.byte(c))
  end))
end

local function header(t)
  return {["X-Bmob-Application-Id"]= t.id,
    ["X-Bmob-REST-API-Key"]= t.key ,
    ["X-Bmob-Session-Token"]= t.token ,
    ["Content-Type:"]= "application/json"}
end
--回调
local function callback(code,json,func)
  if code~=-1 then
    json=cjson.decode(json)
  end
  func(code,json)
end
--格式化
local function format(t)
  local ret={}
  for k,v in pairs(t) do
    if type(v)=="table" then
      table.insert(ret,k.."="..decode(cjson.encode(v)))
    else
      table.insert(ret,k.."="..decode(v))
    end
  end
  return table.concat(ret,"&")
end

function new(self,id,key)
  self.id=id
  self.key=key
end
--查询
function query(self,...)
  local arg={...}
  local c=arg[#arg]
  table.remove(arg)
  local fmt
  if type(arg[#arg])=="table" then
    fmt=format(arg[#arg])
    table.remove(arg)
  end
  local t=table.concat(arg,"/")..("?"..(fmt or ""))
  Http.get("https://api.bmob.cn/1/classes/"..t,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
--插入
function insert(self,t,d,c)
  if type(d)=="table" then
    d=cjson.encode(d)
  end
  Http.post("https://api.bmob.cn/1/classes/"..t,d,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
--更新
function update(self,t,i,d,c)
  if type(d)=="table" then
    d=cjson.encode(d)
  end
  Http.put("https://api.bmob.cn/1/classes/"..t.."/"..i,d,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
--增加
function increment(self,t,i,k,v,c)
  local d={[k]={__op="Increment",amount=v}}
  if type(d)=="table" then
    d=cjson.encode(d)
  end
  Http.put("https://api.bmob.cn/1/classes/"..t.."/"..i,d,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
--删除
function delete(self,t,i,c)
  Http.delete("https://api.bmob.cn/1/classes/"..t.."/"..i,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
--上传
function upload(self,f,c)
  f=File(f)
  Http.HttpTask("https://api.bmob.cn/2/files/"..f.Name,"POST",nil,nil,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end).execute{f}
end
--移动
function remove(self,i,c)
  Http.delete("https://api.bmob.cn/2/files/"..i,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
--注册
function sign(self,u,p,s,e,c)
  local d={username=u,password=p,ip=e,yys=s}
  if type(d)=="table" then
    d=cjson.encode(d)
  end
  Http.post("https://api.bmob.cn/1/classes/users",d,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
--登陆
function login(self,u,p,c)
  Http.get("https://api.bmob.cn/1/classes/login/?username="..decode(u).."&password="..decode(p),header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
      self.token=json.sessionToken
    end
    c(code,json)
  end)
end
--重复登陆记录
function login_plus(self,u,p,s,e,c)
  local d={username=u,password=p,ip=e,yys=s}
  if type(d)=="table" then
    d=cjson.encode(d)
  end
  Http.post("https://api.bmob.cn/1/classes/login",d,header(self),function(code,json)
    if code~=-1 and code>=200 and code<400 then
      json=cjson.decode(json)
    end
    c(code,json)
  end)
end
