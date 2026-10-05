# 2648. Generate Fibonacci Sequence

**Difficulty:** Easy
**Tags:** N/A
**Acceptance Rate:** 83.7%
**Access:** Free
**URL:** https://leetcode.com/problems/generate-fibonacci-sequence/

---

Write a generator function that returns a generator object which yields the **fibonacci sequence**.

The **fibonacci sequence** is defined by the relation `Xn = Xn-1 + Xn-2`.

The first few numbers of the series are `0, 1, 1, 2, 3, 5, 8, 13`.

 

**Example 1:**

**Input:** callCount = 5
**Output:** [0,1,1,2,3]
**Explanation:**
const gen = fibGenerator();
gen.next().value; // 0
gen.next().value; // 1
gen.next().value; // 1
gen.next().value; // 2
gen.next().value; // 3

**Example 2:**

**Input:** callCount = 0
**Output:** []
**Explanation:** gen.next() is never called so nothing is outputted

 

**Constraints:**

	
`0 <= callCount <= 50`

**Hints:**
1. Javascript has the concept of generators. They are critical to this problem.
2. First yield 0 and 1.
3. Create an infinite "while(true)" loop.
4. In that loop, continuously yield the next value which is the sum of the previous two.

---

## Solution

```python

```
