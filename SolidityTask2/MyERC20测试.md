🧪 目标：成功测试 transferFrom
我们模拟以下场景：

A（账户1）拥有代币 → 授权 B（账户2）代替自己转出 → B 使用 transferFrom(A, C, amount) 给 C（账户3）转钱

你需要准备 3 个账户（地址），分别是：

A：代币持有者（先 mint 给他）

B：被授权人（调用 transferFrom）

C：收款人

🪜 步骤 1：准备账户
打开 MetaMask：

创建 3 个账户（点击右上头像 → 创建账户）

分别复制它们地址备用：

A：Account 1（例如 0xA...）

B：Account 2（例如 0xB...）

C：Account 3（例如 0xC...）

确保至少 A 和 B 有 Sepolia ETH（可以用 A 发给 B）

🪜 步骤 2：给 A mint 一些代币
在 Remix：

切换 MetaMask 到 账户 A

在部署后的合约中调用 mint(A地址, 100000000000000000000) （100 MTK）

等待交易确认

调用 balanceOf(A地址) 确认余额

🪜 步骤 3：A 授权 B 可代他花钱
在 Remix 合约中调用 approve(B地址, 50000000000000000000)
→ 授权 B 可以花 50 MTK

调用 allowance(A地址, B地址) 确认授权额度返回 50e18

🪜 步骤 4：切换 MetaMask 到账户 B（被授权人）
🚨 很重要：MetaMask 当前必须是授权对象 B

🪜 步骤 5：在 Remix 调用 transferFrom
在 Remix 输入以下参数：

from：A 的地址（授权人）

to：C 的地址（收款人）

amount：想要转出的数量，例如 20000000000000000000（20 MTK）

点击 transact，MetaMask 会弹出窗口确认，确认交易。

✅ 如果成功：
transferFrom 返回 true

A 的余额减少

C 的余额增加

allowance(A, B) 被自动扣减对应额度

你可以通过调用：

balanceOf(A)

balanceOf(C)

allowance(A, B)

分别确认它们是否变化正常。

💥 错误提示快速排查
报错	原因
Allowance exceeded	没有授权或授权额度不够
Insufficient balance	A 账户余额不足
invalid address	地址拼错或少位
onlyOwner 错误	你用非部署账户去 mint

🧾 总结
步骤	操作
1️⃣	A mint 获取代币
2️⃣	A 执行 approve 给 B 授权
3️⃣	切换 MetaMask 到 B
4️⃣	B 执行 transferFrom
5️⃣	验证转账是否成功