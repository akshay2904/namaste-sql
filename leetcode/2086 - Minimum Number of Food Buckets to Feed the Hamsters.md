# 2086. Minimum Number of Food Buckets to Feed the Hamsters

**Difficulty:** Medium
**Tags:** String, Dynamic Programming, Greedy
**Acceptance Rate:** 48.3%
**Access:** Free
**URL:** https://leetcode.com/problems/minimum-number-of-food-buckets-to-feed-the-hamsters/

---

You are given a **0-indexed** string `hamsters` where `hamsters[i]` is either:

	
`'H'` indicating that there is a hamster at index `i`, or

	
`'.'` indicating that index `i` is empty.

You will add some number of food buckets at the empty indices in order to feed the hamsters. A hamster can be fed if there is at least one food bucket to its left or to its right. More formally, a hamster at index `i` can be fed if you place a food bucket at index `i - 1` **and/or** at index `i + 1`.

Return the minimum number of food buckets you should **place at empty indices** to feed all the hamsters or `-1` if it is impossible to feed all of them.

 

**Example 1:**

**Input:** hamsters = "H..H"
**Output:** 2
**Explanation:** We place two food buckets at indices 1 and 2.
It can be shown that if we place only one food bucket, one of the hamsters will not be fed.

**Example 2:**

**Input:** hamsters = ".H.H."
**Output:** 1
**Explanation:** We place one food bucket at index 2.

**Example 3:**

**Input:** hamsters = ".HHH."
**Output:** -1
**Explanation:** If we place a food bucket at every empty index as shown, the hamster at index 2 will not be able to eat.

 

**Constraints:**

	
`1 <= hamsters.length <= 105`

	
`hamsters[i]` is either`'H'` or `'.'`.

**Hints:**
1. When is it impossible to feed all the hamsters?
2. When one or more hamsters do not have an empty space adjacent to it.
3. Assuming all previous hamsters are fed. If there is a hamster at index i and you are able to place a bucket at index i - 1 or i + 1, where should you put it?
4. It is always better to place a bucket at index i + 1 because it can feed the next hamster as well.

---

## Solution

```python

```
