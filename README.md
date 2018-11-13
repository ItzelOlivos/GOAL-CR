# GOAL-CR
We present GOAL-CR, a greedy algorithm that solves the single access contention resolution problem. The problem consists of devising a protocol that allows a set of n nodes to access a shared resource when there is no form of communication among them. It is assumed that: i) time is divided into discrete time slots; ii) if two or more nodes attempt to access simultaneously, they lock each other out and none can access the resource during the slot; iii) the nodes want to access the resource only once.

The uncertainty in the contention is addressed by modeling the problem as a partially observable Markov decision process (POMDP) and solve it using a greedy algorithm.

In this repository we show, using simulations, that the performance of GOAL-CR, in terms of the average number of time slots needed for all the active nodes to access the resource successfully, is close to that of a protocol with complete information about the exact number of nodes that have not yet accessed the resource.

In these experiments, time is divided into discrete slots, and during each slot, the nodes attempt to access the resource independently of each other using a given access probability. The simulations end when every node has accessed the resource.

We study three scenarios:
S1. The size of the network is known. The number of active nodes at time slot = 0 is known with certainty.
S2. Binomial distribution as initial belief. In applications like Wireless Sensor Networks, some nodes might not survive after the deployment; thus, we study the performance of GOAL-CR when the initial number of active nodes follows a binomial distribution.
S3. Mixture of gaussians as initial belief. We study the robustness of GOAL-CR against asymmetric initial distributions.
S4. Geometric delays. In real world applications, the nodes might start contending for the resource after a small random delay of i time slots.

For comparison purposes, we consider three additional protocols:

1. Perfect information. The nodes know the exact number of active nodes at each time slot, A_t, and attempt to access the resource with an optimal probability = 1/A_t.
2. Fixed optimal probability. A probability tau is computed at the beginning of the contention, and the nodes attempt to access the resource with that probability all along the contention.
3. Growth rule. Very low memory nodes might not be able to store the whole sequence of access probabilities (policy). We propose to approximate the policy with a rule: p_{t+1} = a * p_t.
