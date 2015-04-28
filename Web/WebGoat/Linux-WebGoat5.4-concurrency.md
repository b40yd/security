## 并发
并发，在操作系统中，是指一个时间段中有几个程序都处于已启动运行到运行完毕之间，且这几个程序都是在同一个处理机上运行，但任一个时刻点上只有一个程序在处理机上运行。

### 使用场景
并发的使用场景，在互联网上，每个应用基本都是并发的。

### 漏洞分析
一般并发的漏洞都体现在有限的资源竞争上，比如一个网上商店有限时限个的某个商品，如果大家同一时间都去购买，必然会造成并发。最后到底谁买到了谁没有买到？
如果这个情况是，在现实中可能是先到先得，卖完为止。在互联网上就不一定了，有可能几十个人同时到达，而物品只有10个那么怎么分配这10个物品呢？

那么清楚大概的情况后，那么着手处理。比如：
```php
<?php
    class Shop {
        private $id    = 0;
        private $name  = "";
        private $price = 0;
        private $num   = 0;
        private $lock  = false;
        
        public function getId(){
            return $this->goods_id;
        }
        
        public function setId($id){
            $this->id = md5($id);
            return $this;
        }
        
        public function getName(){
            return $this->name;
        }
        
        public function setName($name){
            $this->name = strip_tags($name);
            return $this;
        }
        
        public function getPrice(){
            return $this->price;
        }
        
        public function setPrice($price){
            if(is_integer($price))
                $this->price = $price;

            return $this;
        }
        
        public function getNum(){
            return $this->num;
        }
        
        public function setNum($num){
            if(is_integer($num))
                $this->num = $num;

            return $this;
        }
        
        public function getLock(){
            return $this->lock;
        }
        
        public function setLock($lock){
            if(is_bool($lock))
                $this->lock = $lock;
            return $this;
        }
    }


    class Shops{
        private $mux = false;
        //private $unclock = false;
        private $lock = false;

        private $shops = array();

        private $shop = array(
                            "goods_name" => "",
                            "goods_id" => 0,
                            "goods_price" => 0
                            );

        public function test_shops($num){
            if(is_integer($num)){
                for ($i=0; $i < $num; $i++) { 
                    # code...
                    $shop["goods_id"] = md5($i);
                    $shop["goods_name"] = "the {$i} goods.";
                    $shop["goods_price"] = (($i == 0)?4:($i * 2) + ($i * 2) % 10);
                    array_push($shops, $shop);
                }
            }
        }

        public function addShop(array $arr){
            foreach ($this->shop as $key => $value) {
                    # code...
                if(array_key_exists($key, $arr)){
                    continue;
                }else{
                    return false;
                }
            }

            array_push($this->shops, $arr);
            return $this;
        }

        public function addShopGroup(array $arr){

            $status = array_map(function(array $arr1){
                foreach ($this->shop as $key => $value) {
                    # code...
                    if(array_key_exists($key, $arr1)){
                        continue;
                    }else{
                        return false;
                    }
                }
                return true;
            },$arr);

            if(is_array($status)){
                foreach ($status as $key => $value) {
                    # code...
                    if(!$value){
                        return ;
                    }
                }
            }

            foreach ($arr as $key => $value) {
                # code...
                array_push($this->shops, $value);
            }
            
            return $this;
        }

        public function getShopsAll(){
            return $this->shops;
        }

        public function getShop(){
            return $this->shop;
        }

        public function getShopById($id){
            foreach ($this->shops as $key => $value) {
                # code...
                if($value['goods_id'] === $id){
                    return $value;
                }
            }
            return array();
        }

    }
?>
```
假设这个对象用在非线程安全中的话，这样用：
```php
<?php
    $shop_obj = new Shop();
    $shop_obj->test_shops(10);

?>
```


### 危害

### 解决方案