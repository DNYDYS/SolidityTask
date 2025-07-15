// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

// 用 GitHub 引用 OpenZeppelin 代码
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.1/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
// import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.1/contracts/access/Ownable.sol";

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


// 作业2：在测试网上发行一个图文并茂的 NFT
// 任务目标
// 使用 Solidity 编写一个符合 ERC721 标准的 NFT 合约。
// 将图文数据上传到 IPFS，生成元数据链接。
// 将合约部署到以太坊测试网（如 Goerli 或 Sepolia）。
// 铸造 NFT 并在测试网环境中查看。
// 任务步骤
// 编写 NFT 合约
// 使用 OpenZeppelin 的 ERC721 库编写一个 NFT 合约。
// 合约应包含以下功能：
// 构造函数：设置 NFT 的名称和符号。
// mintNFT 函数：允许用户铸造 NFT，并关联元数据链接（tokenURI）。
// 在 Remix IDE 中编译合约。
// 准备图文数据
// 准备一张图片，并将其上传到 IPFS（可以使用 Pinata 或其他工具）。
// 创建一个 JSON 文件，描述 NFT 的属性（如名称、描述、图片链接等）。
// 将 JSON 文件上传到 IPFS，获取元数据链接。
// JSON文件参考 https://docs.opensea.io/docs/metadata-standards
// 部署合约到测试网
// 在 Remix IDE 中连接 MetaMask，并确保 MetaMask 连接到 Goerli 或 Sepolia 测试网。
// 部署 NFT 合约到测试网，并记录合约地址。
// 铸造 NFT
// 使用 mintNFT 函数铸造 NFT：
// 在 recipient 字段中输入你的钱包地址。
// 在 tokenURI 字段中输入元数据的 IPFS 链接。
// 在 MetaMask 中确认交易。
// 查看 NFT
// 打开 OpenSea 测试网 或 Etherscan 测试网。
// 连接你的钱包，查看你铸造的 NFT。


contract MyNFT is ERC721URIStorage, Ownable {
    // ERC721URIStorage：支持给每个 NFT 设置 URI。

    // tokenCounter：记录 NFT 总数。
    uint256 public tokenCounter;

    constructor(address initialOwner) ERC721("MyNFT", "MNFT") Ownable(initialOwner) {
        tokenCounter = 0;
    }

    // onlyOwner：只有合约拥有者可以铸造 NFT。
    // mintNFT()：输入接收地址和 IPFS 元数据链接，即可铸造 NFT
    function mintNFT(address recipient, string memory tokenURI) public onlyOwner returns (uint256) {
        uint256 tokenId = tokenCounter;
        _safeMint(recipient, tokenId);
        _setTokenURI(tokenId, tokenURI);
        tokenCounter++;
        return tokenId;
    }
}





// 第二步：准备图文数据 + 上传 IPFS
// 1. 准备图片（例如一张 JPG）
// 文件名举例：nft-image.jpg

// 2. 使用 Pinata 或 Web3.Storage 上传
// 网站推荐：

// https://www.pinata.cloud

// https://web3.storage

// 上传后得到一个 IPFS 链接，形式如：
// https://gateway.pinata.cloud/ipfs/QmXyz123456abcdef/image.jpg
// 3. 创建 JSON 元数据文件

// {
//   "name": "My First NFT",
//   "description": "This is a test NFT with image and metadata on IPFS",
//   "image": "ipfs://QmXyz123456abcdef/image.jpg"
// }
// 保存为 metadata.json，再上传到 IPFS。

// 获得元数据 IPFS 链接，例如：
// ipfs://QmABCDEF1234567890/metadata.json
// 或用网关查看：
// https://gateway.pinata.cloud/ipfs/QmABCDEF1234567890/metadata.json

// 🚀 第三步：部署到测试网（Goerli 或 Sepolia）
// 使用 Remix 部署
// 打开 https://remix.ethereum.org。

// 新建 .sol 文件，粘贴上面的 Solidity 代码。

// 在 Remix 左侧点击 "Solidity Compiler"，选择 0.8.20 版本编译。

// 在 "Deploy & Run Transactions" 中：

// 环境选择 Injected Provider（连接到你的 MetaMask）

// 确保你的 MetaMask 链接 Goerli 或 Sepolia 并有测试币。

// 点击 "Deploy" → MetaMask 弹窗确认交易。

// ✅ 部署成功后，记下合约地址。

// 🧪 第四步：铸造 NFT
// 使用 Remix 调用 mintNFT
// 在 Remix 中合约已部署后，展开合约：

// 找到 mintNFT 方法

// 输入：

// recipient: 你的钱包地址（0x 开头）

// tokenURI: 元数据链接，例如：

// arduino
// 复制
// 编辑
// ipfs://QmABCDEF1234567890/metadata.json
// 点击交易 → MetaMask 确认

// 等待区块确认后，你就铸造成功了！

// 👀 第五步：查看 NFT
// 方式一：在 OpenSea 测试网查看
// 打开：
// https://testnets.opensea.io

// 连接钱包（与你铸造 NFT 时使用的相同）

// 在 "Profile" 页面查看你的 NFT

// 📝 注意：OpenSea 有延迟，几分钟后 NFT 才会显示出来。

