// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.1/contracts/access/Ownable.sol";


// ✅ 作业3：编写一个讨饭合约
// 任务目标
// 使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
// 记录每个捐赠者的地址和捐赠金额。
// 允许合约所有者提取所有捐赠的资金。

// 任务步骤
// 编写合约
// 创建一个名为 BeggingContract 的合约。
// 合约应包含以下功能：
// 一个 mapping 来记录每个捐赠者的捐赠金额。
// 一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
// 一个 withdraw 函数，允许合约所有者提取所有资金。
// 一个 getDonation 函数，允许查询某个地址的捐赠金额。
// 使用 payable 修饰符和 address.transfer 实现支付和提款。
// 部署合约
// 在 Remix IDE 中编译合约。
// 部署合约到 Goerli 或 Sepolia 测试网。
// 测试合约
// 使用 MetaMask 向合约发送以太币，测试 donate 功能。
// 调用 withdraw 函数，测试合约所有者是否可以提取资金。
// 调用 getDonation 函数，查询某个地址的捐赠金额。

// 任务要求
// 合约代码：
// 使用 mapping 记录捐赠者的地址和金额。
// 使用 payable 修饰符实现 donate 和 withdraw 函数。
// 使用 onlyOwner 修饰符限制 withdraw 函数只能由合约所有者调用。
// 测试网部署：
// 合约必须部署到 Goerli 或 Sepolia 测试网。
// 功能测试：
// 确保 donate、withdraw 和 getDonation 函数正常工作。

// 提交内容
// 合约代码：提交 Solidity 合约文件（如 BeggingContract.sol）。
// 合约地址：提交部署到测试网的合约地址。
// 测试截图：提交在 Remix 或 Etherscan 上测试合约的截图。

// 额外挑战（可选）
// 捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
// 捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
// 时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。



// | 功能              | 描述                                |
// | --------------- | --------------------------------- |
// | ✅ `Donation` 事件 | 每次捐赠会记录捐赠者地址和金额                   |
// | ✅ 捐赠排行榜         | `topDonors` 保存捐款最多的 3 个地址         |
// | ✅ 时间限制          | 只在 `startTime ~ endTime` 时间范围内可捐赠 |
// | ✅ 可查询           | 可查询排行榜、余额、某个地址捐款等                 |


contract BeggingContract is Ownable {
    // 每个捐赠者的捐款总额
    mapping(address => uint256) public donations;

    // 捐赠事件
    event Donation(address indexed donor, uint256 amount);

    // 排行榜（Top 3）
    address[3] public topDonors;

    // 开始和结束时间戳（UNIX时间）
    uint256 public startTime;
    uint256 public endTime;

    constructor(address initialOwner, uint256 _startTime, uint256 _endTime) Ownable(initialOwner) {
        require(_startTime < _endTime, "Start must be before end");
        startTime = _startTime;
        endTime = _endTime;
    }

    // 捐赠函数（限制时间 + 排行榜 + 事件）
    function donate() external payable {
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Donation not allowed now");
        require(msg.value > 0, "Must donate > 0");

        donations[msg.sender] += msg.value;
        emit Donation(msg.sender, msg.value);

        _updateTopDonors(msg.sender);
    }

    // 内部函数：更新前三名捐赠者
    function _updateTopDonors(address donor) internal {
        // 如果已在榜，更新后排序即可
        for (uint i = 0; i < 3; i++) {
            if (topDonors[i] == donor) {
                _sortTopDonors();
                return;
            }
        }

        // 可能取代当前榜单中的最小者
        uint256 donorAmount = donations[donor];
        uint256 minIndex = 0;

        for (uint i = 1; i < 3; i++) {
            if (donations[topDonors[i]] < donations[topDonors[minIndex]]) {
                minIndex = i;
            }
        }

        if (donorAmount > donations[topDonors[minIndex]]) {
            topDonors[minIndex] = donor;
            _sortTopDonors();
        }
    }

    // 内部函数：按捐赠额从高到低排序 topDonors
    function _sortTopDonors() internal {
        // 简单冒泡排序，适合 3 个元素
        for (uint i = 0; i < 2; i++) {
            for (uint j = i + 1; j < 3; j++) {
                if (donations[topDonors[j]] > donations[topDonors[i]]) {
                    (topDonors[i], topDonors[j]) = (topDonors[j], topDonors[i]);
                }
            }
        }
    }

    // 提现函数（只有 owner 可以提取所有捐款）
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No funds");
        payable(owner()).transfer(balance);
    }

    // 查询某个地址的捐款额
    function getDonation(address addr) external view returns (uint256) {
        return donations[addr];
    }

    // 查看合约当前余额
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    // 查看当前捐赠排行榜
    function getTopDonors() external view returns (address[3] memory) {
        return topDonors;
    }
}


// --------------------------测试步骤------------------------------------------------
// 🧪 1. 测试 donate() 捐赠函数
// 👣 操作步骤：
// 找到合约界面中的 donate() 函数

// 在上方 Value 输入框中填入捐赠金额，例如：

// 复制
// 编辑
// 0.01 ether
// 点击 donate() 按钮 → MetaMask 会弹出支付确认框

// 确认交易 → 等待完成

// ✅ 成功后：

// 控制台中会显示 Donation 事件日志

// 捐赠金额会记录到 donations[msg.sender]

// 🧪 2. 测试 getDonation(address) 查询捐赠额
// 找到合约的 getDonation 函数

// 在输入框里填入你刚才捐赠的钱包地址，例如：

// 复制
// 编辑
// 0xAbc123...789
// 点击 call → 会显示你总共捐赠的 ETH（单位：wei）

// 🧪 3. 测试 getTopDonors() 查看捐赠排行榜
// 点击 getTopDonors() → call

// 它会返回 address[3]，分别是当前捐赠额最多的三个地址（可能有空地址）

// 📌 如果你用多个账户捐赠，就可以观察到排行榜排序是否正确。

// 🧪 4. 测试 withdraw() 提款
// ⚠️ 注意：你必须用合约的 initialOwner 地址执行，否则会失败。

// 确保当前 MetaMask 钱包是合约部署时用的那个地址

// 点击 withdraw() → MetaMask 弹窗 → 确认

// ETH 会转入 owner 钱包，合约余额归零

// 🧪 5. 测试 getBalance() 查看合约余额
// 点击 getBalance()，它会显示当前合约中持有多少 wei。