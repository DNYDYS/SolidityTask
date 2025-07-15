
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

