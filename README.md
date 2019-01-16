# GOAL-CR

We present GOAL-CR, a greedy algorithm that solves a variant of the single access contention resolution problem. The problem consists of devising a protocol that allows a set of n nodes to access a shared resource when there is no form of communication among them. We assume that: i) time is divided into discrete time slots; ii) if two or more nodes attempt to access simultaneously, they lock each other out and none can access the resource during the slot; and iii) each node wants to access the resource only once.

The uncertainty in the contention is addressed by modeling the problem as a partially observable Markov decision process (POMDP).
We implemented a Reinforcement Learning method to solve the POMDP, and designed a greedy algorithm, GOAL-CR, to solve it in a more efficient running time.

In this repository we show, using simulations, that the performance of GOAL-CR, in terms of the average number of time slots needed for all the active nodes to access the resource successfully, is close to that of a protocol with complete information about the current number of nodes that have not yet accessed the resource.

We propose the following scenarios to study the robustness of the greedy algorithm:

S1. The size of the network is known and the nodes start to compete for the resource at the same time.

S2. The nodes start to compete asynchronously.

S3. The initial number active nodes is not known with certainty.

For comparison purposes, we also tested the alternatives described below:

1. Perfect-information protocol. The nodes know the exact number of active nodes at each time slot, A_t, and attempt to access the resource with an optimal probability = 1/A_t.
2. Fixed-optimal-probability protocol. A probability tau is computed at the beginning of the contention, and the nodes attempt to access the resource with that probability all along the contention.
3. Growth-rule protocol. Very low memory nodes might not be able to store the whole sequence of access probabilities (policy). We propose to approximate the policy with a parameterized function: p(t│a,b) = 1/n + (1-1/n)(1/(1+exp(-a(t-(b+3n)/2))))
