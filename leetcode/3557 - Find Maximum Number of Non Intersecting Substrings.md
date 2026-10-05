# 3557. Find Maximum Number of Non Intersecting Substrings

**Difficulty:** Medium
**Tags:** Hash Table, String, Dynamic Programming, Greedy
**Acceptance Rate:** 30.7%
**Access:** Free
**URL:** https://leetcode.com/problems/find-maximum-number-of-non-intersecting-substrings/

---

You are given a string `word`.

Return the **maximum** number of non-intersecting **substrings** of word that are at **least** four characters long and start and end with the same letter.

 

**Example 1:**

**Input:** word = "abcdeafdef"

**Output:** 2

**Explanation:**

The two substrings are `"abcdea"` and `"fdef"`.

**Example 2:**

**Input:** word = "bcdaaaab"

**Output:** 1

**Explanation:**

The only substring is `"aaaa"`. Note that we cannot **also** choose `"bcdaaaab"` since it intersects with the other substring.

 

**Constraints:**

	
`1 <= word.length <= 2 * 105`

	
`word` consists only of lowercase English letters.

**Hints:**
1. Can we solve the problem using Dynamic Programming?
2. For each character `c`, store all occurrence indices in order
3. At each position `i`, let `j` be the first index of `word[i]`; if `i - j >= 3`, we can form substring `[j, i]`
4. For each index, also store the maximum for **any** substring ending before that index in the dp.

---

## Solution

```python

```
