// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// ✅ 作业 1：ERC20 代币
// 任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
// 合约包含以下标准 ERC20 功能：
// balanceOf：查询账户余额。
// transfer：转账。
// approve 和 transferFrom：授权和代扣转账。
// 使用 event 记录转账和授权操作。
// 提供 mint 函数，允许合约所有者增发代币。
// 提示：
// 使用 mapping 存储账户余额和授权信息。
// 使用 event 定义 Transfer 和 Approval 事件。
// 部署到sepolia 测试网，导入到自己的钱包


// import "@openzeppelin/contracts/token/ERC20/ERC20.sol"

contract MyERC20 {
    //代币名称
    string public name = "MyERC20"; 
    //代币代码（比如 "MTK"，类似 BTC、ETH）
    string public symbol = "NEWREC20"; 
    //代币精度，18 是标准值（表示可以有 0.000000000000000001 单位）
    uint8 public decimals = 18 ; 
    // 总发行量（随着 mint 函数调用会增加）
    uint256 public totalSupply; 
    // 合约的拥有者（部署合约的人，只有他能增发代币）
    address public owner; 

    //储存每个地址持有的代币余额。
    mapping (address => uint256) private balances;
    // 嵌套映射，表示“谁授权谁多少代币可以花”
    // allowances[Alice][Bob] = 100; 表示 Alice 授权 Bob 可以花她的 100 个代币
    mapping (address => mapping (address => uint256)) private allowances;

    // Transfer：每次发生转账时触发，包括 mint（地址为 0x0 的时候表示新铸出来的代币）。
    event Transfer(address indexed from, address indexed to, uint256 value);
    // Approval：某人授权某人能使用自己的多少代币时触发。
    event Approval(address indexed owner, address indexed spender, uint256 value);

    // onlyOwner 是自定义的“修饰符 modifier”，表示这个函数只有合约部署者才能调用。
    // msg.sender 是发起调用的人地址。
    // require(...) 是条件检查，如果不是 owner，就报错。
    // _ 表示继续执行函数体。
    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    // 构造函数，合约部署时自动执行。
    // 把 owner 设置为部署人（也就是你）。
    constructor(){
        owner = msg.sender;
    }


    // 查询账户余额 这个函数是 ERC20 标准的必要接口，用来查某地址当前有多少代币
    function balancesOf(address account) public view returns (uint256){
        return balances[account];
    }
    
    // 转账
    function transfer(address to, uint256 amount) public returns (bool) {
        //检查余额是否够
        require(balances[msg.sender] >= amount,"Not enough balance");

        balances[msg.sender] -= amount;
        balances[to] += amount;

        //触发 Transfer 事件
        emit Transfer(msg.sender, to, amount);

        return true;

    }

    //授权别人代为使用代币
    function approve(address spender, uint256 amount) public returns (bool){
        // allowances[Alice][Bob] = 100; 表示 Alice 授权 Bob 可以花她的 100 个代币
        allowances[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }


    // 被授权人代为转账（transferFrom）
    function transferFrom(address from, address to, uint256 amount) public returns (bool){
        // 判断是否余额不足
        require(balances[from] >= amount, "Insufficient balance");
        // 判断是否超出限额
        require(allowances[from][msg.sender] >=amount, "Allowance exceeded");

        balances[from] -= amount;
        balances[to] += amount;
        // 账户 A 授权账户 B 花费代币 
        // MetaMask 切换到账户 B（被授权人）
        // 账户 B 调用：transferFrom(账户A地址, 账户C地址, 100 * 10^18)
        // 转账后验证状态，A 的余额减少，C 的余额增加
        // 此时操作账户是B-msg.sender，传入A-from，C-to
        allowances[from][msg.sender] -= amount;

        emit Transfer(from, to, amount);

        return true;

    }

    // 0x140dDE7974785808c3Ece9Af8761C7C4d419e505
    // 0x161AC745Ef71bBF1Ea04C9E45d1F190b25Dd1767
    // 0xecD74D68eB175aFc8Ff235904Db30Ad33CDd3DCA
    

    // 查看授权额度
    function allowance(address tokenOwner,address spender) public view returns (uint256){
        return allowances[tokenOwner][spender];
    }

    // 增发代币
    // msg.sender 是合约的拥有者（部署人，也就是你） 只有 owner 可以执行。
    function mint(address to, uint256 amount) public onlyOwner{
        require (amount > 0, "Minting zero token");
        
        // 更新总供应量
        totalSupply += amount;
        // 给某个地址增加代币；
        balances[to] += amount;

        // 从 address(0) 到 to 发出 Transfer，表示是新代币
        emit Transfer(address(0), to, amount); // 标准的mint事件写法
    
    }
    


}



// 🧪 目标：成功测试 transferFrom
// 我们模拟以下场景：

// A（账户1）拥有代币 → 授权 B（账户2）代替自己转出 → B 使用 transferFrom(A, C, amount) 给 C（账户3）转钱

// 你需要准备 3 个账户（地址），分别是：

// A：代币持有者（先 mint 给他）

// B：被授权人（调用 transferFrom）

// C：收款人

// 🪜 步骤 1：准备账户
// 打开 MetaMask：

// 创建 3 个账户（点击右上头像 → 创建账户）

// 分别复制它们地址备用：

// A：Account 1（例如 0xA...）

// B：Account 2（例如 0xB...）

// C：Account 3（例如 0xC...）

// 确保至少 A 和 B 有 Sepolia ETH（可以用 A 发给 B）

// 🪜 步骤 2：给 A mint 一些代币
// 在 Remix：

// 切换 MetaMask 到 账户 A

// 在部署后的合约中调用 mint(A地址, 100000000000000000000) （100 MTK）

// 等待交易确认

// 调用 balanceOf(A地址) 确认余额

// 🪜 步骤 3：A 授权 B 可代他花钱
// 在 Remix 合约中调用 approve(B地址, 50000000000000000000)
// → 授权 B 可以花 50 MTK

// 调用 allowance(A地址, B地址) 确认授权额度返回 50e18

// 🪜 步骤 4：切换 MetaMask 到账户 B（被授权人）
// 🚨 很重要：MetaMask 当前必须是授权对象 B

// 🪜 步骤 5：在 Remix 调用 transferFrom
// 在 Remix 输入以下参数：

// from：A 的地址（授权人）

// to：C 的地址（收款人）

// amount：想要转出的数量，例如 20000000000000000000（20 MTK）

// 点击 transact，MetaMask 会弹出窗口确认，确认交易。

// ✅ 如果成功：
// transferFrom 返回 true

// A 的余额减少

// C 的余额增加

// allowance(A, B) 被自动扣减对应额度

// 你可以通过调用：

// balanceOf(A)

// balanceOf(C)

// allowance(A, B)

// 分别确认它们是否变化正常。

// 💥 错误提示快速排查
// 报错	原因
// Allowance exceeded	没有授权或授权额度不够
// Insufficient balance	A 账户余额不足
// invalid address	地址拼错或少位
// onlyOwner 错误	你用非部署账户去 mint

// 🧾 总结
// 步骤	操作
// 1️⃣	A mint 获取代币
// 2️⃣	A 执行 approve 给 B 授权
// 3️⃣	切换 MetaMask 到 B
// 4️⃣	B 执行 transferFrom
// 5️⃣	验证转账是否成功