## 会话管理缺陷
会话ID 时经常忘记整合的复杂性和随机性，会话ID 不具备复杂和随机性，那么应用程序很容易受到基于会话的暴力攻击的威胁。

### 使用场景
用户登录认证。

### 漏洞分析
会话ID 一般由Session 生成，存储在客户端Cookie 的某个字段中。还有就是直接把认证存储在cookie中，这种最容易被伪造和劫持。
例如:
```go
import (
        "github.com/wackonline/gosession"
)
var provider *gosession.Adapter
var session gosession.SessionStore

type MyMux struct {
}

func (p *MyMux) ServeHTTP(w http.ResponseWriter, r *http.Request) {

    provider, _ = gosession.Bootstrap("file", `{"cookieName":"gosessionid","Gctime":3600,"ProviderConfig":"./tmp"}`)

    session, _ = provider.StartSession(w, r)
    if r.URL.Path == "/login" {
        login(w, r)
        return
    }

    http.NotFound(w, r)
    return
}

func login(params map[string]string) bool{
    if params["username"] == "admin" && params["passwd"] == "admin" {
        s := md5.New()
        session.Set("logid", hex.EncodeToString(s.Sum([]byte(params["username"]+params["passwd"]))))
        return true
    }
    return false
}

func main() {

    mux := &MyMux{}
    http.ListenAndServe(":8080", mux)
}
```
这样就可以得到一个`session id`了，查看浏览器的cookie，找到一个key是`md5`加密的字符串，它的值就是当前生成的`seesion id`,然后使用其他浏览器添加cookie，把得到的cookie添加
进去就可以使用当前的sessionid登录了。
Cookie 存储在客户端，可随时被篡改用于特别用途。比如网站很多可以登陆一次后在一段时间内自动登录，如果cookie的加密值是一个容易猜到的算法，也可以跨站攻击截获cookie的值，就可以做到
Cookie认证欺骗了。跟Session固定的id攻击同样的手法。它们最终的目的就是拿到用户登录的认证授权，从而可以使用用户的账号进行其他操作。

### 危害
无密码欺骗认证，造成用户账户在不知情的情况下被人恶意使用。

### 解决方案
认证信息不能存储在cookie中，session随机生成id，避免`session id`固定，每次请求加上认证授权串。