# 2619. Array Prototype Last

**Difficulty:** Easy
**Tags:** N/A
**Acceptance Rate:** 74.7%
**Access:** Free
**URL:** https://leetcode.com/problems/array-prototype-last/

---

Write code that enhances all arrays such that you can call the `array.last()` method on any array and it will return the last element. If there are no elements in the array, it should return `-1`.

You may assume the array is the output of `JSON.parse`.

 

**Example 1:**

**Input:** nums = [null, {}, 3]
**Output:** 3
**Explanation:** Calling nums.last() should return the last element: 3.

**Example 2:**

**Input:** nums = []
**Output:** -1
**Explanation:** Because there are no elements, return -1.

 

**Constraints:**

	
`arr` is a valid JSON array

	
`0 <= arr.length <= 1000`

**Hints:**
1. Inside the Array.prototype.last function body, you have access to the "this" keyword. "this" is equal to the contents of the array in this case.
2. You can access elements in the array via this[0], this[1], etc. You can also access properties and method like this.length, this.forEach, etc.

---

## Solution

```python

```
