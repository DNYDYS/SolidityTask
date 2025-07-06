
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

// 用 solidity 实现罗马数字转数整数
// 题目描述在 https://leetcode.cn/problems/integer-to-roman/description/
contract RomanToInt{
    mapping(string => uint)private  romanSymbols;

    constructor(){
        romanSymbols["I"] = 1;
        romanSymbols["V"] = 5; 
        romanSymbols["X"] =  10;    
        romanSymbols["L"]= 50;   
        romanSymbols["C"]=100;      
        romanSymbols["D"]= 500;     
        romanSymbols["M"] = 1000;
    }
    function convert(string memory _input) public view returns (uint256){   
        bytes memory input = bytes(_input);
        uint beforeNum;
        uint totalNum;

        for (uint i=0; i < input.length; i++){
            uint  j = romanSymbols[string(abi.encodePacked(input[i]))];
            if( j != 0 && j > beforeNum){
                j = j - beforeNum -  beforeNum;
            }
            beforeNum = j;
            totalNum += j;
        }
        return totalNum;    
        }



}