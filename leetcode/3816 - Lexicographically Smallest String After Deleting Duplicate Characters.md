# 3816. Lexicographically Smallest String After Deleting Duplicate Characters

**Difficulty:** Hard
**Tags:** Hash Table, String, Stack, Greedy, Monotonic Stack
**Acceptance Rate:** 20.1%
**Access:** Free
**URL:** https://leetcode.com/problems/lexicographically-smallest-string-after-deleting-duplicate-characters/

---

You are given a string `s` that consists of lowercase English letters.

You can perform the following operation any number of times (possibly zero times):

	
Choose any letter that appears **at least twice** in the current string `s` and delete any **one** occurrence.

Return the **lexicographically smallest** resulting string that can be formed this way.

 

**Example 1:**

**Input:** s = "aaccb"

**Output:** "aacb"

**Explanation:**

We can form the strings `"acb"`, `"aacb"`, `"accb"`, and `"aaccb"`. `"aacb"` is the lexicographically smallest one.

For example, we can obtain `"aacb"` by choosing `'c'` and deleting its first occurrence.

**Example 2:**

**Input:** s = "z"

**Output:** "z"

**Explanation:**

We cannot perform any operations. The only string we can form is `"z"`.

 

**Constraints:**

	
`1 <= s.length <= 105`

	
`s` contains lowercase English letters only.

**Hints:**
1. Solve greedily.
2. Each distinct letter must appear at least once in the final string.
3. For each letter, maintain a deque of its positions.
4. At each step, try letters from `'a'` to `'z'` and pick the smallest letter whose earliest position lies within a safe window.
5. Do not pick an occurrence if choosing it would make some other letter impossible to keep.
6. Mark positions as used and repeat, always minimizing the next chosen character.

---

## Solution

```python

```
