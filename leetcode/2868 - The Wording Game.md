# 2868. The Wording Game

**Difficulty:** Hard
**Tags:** Array, Math, Two Pointers, String, Greedy, Game Theory
**Acceptance Rate:** 56.0%
**Access:** Premium
**URL:** https://leetcode.com/problems/the-wording-game/

---

_Problem description unavailable (Premium required)._

**Hints:**
1. If both Alice and Bob for each letter of the alphabet have at least one word beginning with that letter, then the winner is the player who has the lexicographically greatest word.
2. What happens if both have words that begin with the first `x` letters of the alphabet, but only one of them has a word beginning with the `x + 1th` letter?
3. Suppose Alice has a word beginning with the `x + 1th` letter. Note that if Alice has the lexicographically greatest word beginning with one of the first `x` letters, then she is the winner. But if Bob has such a word, then the game continues.
4. Now, we can conclude the winner is determined by the first letter which a player doesn’t have a word beginning with, and the other player has the lexicographically greatest word among all the words beginning with the letters before that letter.

---

## Solution

```python

```
