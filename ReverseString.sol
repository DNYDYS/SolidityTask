// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

//题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"
contract ReverseString{
    
    function reverseString(string memory input) public pure returns(string memory){
        bytes memory inputBytes =bytes(input);
        uint256 length = inputBytes.length; // 10
      
        for(uint256 i=0;i<length/2;i++){
            bytes1 temp =inputBytes[i];
            inputBytes[i] = inputBytes[length-i-1];
            inputBytes[length-i-1] = temp;
        }
        return string(inputBytes);
    }
}