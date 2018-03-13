## IDS
入侵检测系统，主要实现入侵检测规则更新去重；

### 更新
主要在工作中，对第三方规则与自定义规则合并时，需要在庞大的规则中去验证是否已经支持；在这样下采用自动化验证去重合并，将减轻日常工作；

### 主要支持
目前主要使用suricata引擎，规则支持snort规则与suricata规则；

### 特性
* 支持自动查找并去重
* 支持自动合并

### 使用
```shell
root@local $ ./update-rulesets.sh /snort/rules rules /suricata/rules rules
Origin ruleset total: 59870
New ruleset total: 7870
Repeat rules total: 450
done
```

### 规则订阅
如有需订阅最新规则集，可以联系我；
