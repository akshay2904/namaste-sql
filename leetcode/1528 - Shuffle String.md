# 1528. Shuffle String

**Difficulty:** Easy
**Tags:** Array, String
**Acceptance Rate:** 85.4%
**Access:** Free
**URL:** https://leetcode.com/problems/shuffle-string/

---

You are given a string `s` and an integer array `indices` of the **same length**. The string `s` will be shuffled such that the character at the `ith` position moves to `indices[i]` in the shuffled string.

Return the shuffled string.

 

**Example 1:**

**Input:** s = "codeleet", `indices` = [4,5,6,7,0,2,1,3]
**Output:** "leetcode"
**Explanation:** As shown, "codeleet" becomes "leetcode" after shuffling.

**Example 2:**

**Input:** s = "abc", `indices` = [0,1,2]
**Output:** "abc"
**Explanation:** After shuffling, each character remains in its position.

 

**Constraints:**

	
`s.length == indices.length == n`

	
`1 <= n <= 100`

	
`s` consists of only lowercase English letters.

	
`0 <= indices[i] < n`

	
All values of `indices` are **unique**.

**Hints:**
1. You can create an auxiliary string t of length n.
2. Assign t[indexes[i]] to s[i] for each i from 0 to n-1.

---

## Solution

```python

```
