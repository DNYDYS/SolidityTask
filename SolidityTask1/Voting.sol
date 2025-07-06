
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// ✅ 创建一个名为Voting的合约，包含以下功能：
// 一个mapping来存储候选人的得票数
// 一个vote函数，允许用户投票给某个候选人
// 一个getVotes函数，返回某个候选人的得票数
// 一个resetVotes函数，重置所有候选人的得票数
contract Voting{

    mapping (address user => uint256 voteCount) public voteMap;
    
    address[]  public  candidates;

    function vote(address user) public{
        if(voteMap[user] == 0){
            candidates.push(user);
        }
        voteMap[user]++;
    }

    function getVotes(address user) public view returns (uint256) {
        return voteMap[user];
    }

    function resetVotes() public {
        for(uint256 i=0;i<candidates.length;i++){
            delete voteMap[candidates[i]];
        }
    
        while(candidates.length>0){
            candidates.pop();
        }
    }

}