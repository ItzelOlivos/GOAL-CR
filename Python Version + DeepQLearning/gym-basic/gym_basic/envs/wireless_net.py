from abc import ABC
import gym
import numpy as np


class WirelessNet(gym.Env, ABC):
    def __init__(self):
        # Action: Probability with which nodes start a TX, bounded by 0-1
        self.action_space = gym.spaces.Box(low=0, high=.999, shape=(1,), dtype=np.float32)
        self.observation_space = None
        self.state = None
        self.belief = None
        self.init_nodes = None
        self.final_rwd = None
        self.b0 = None

    def customize(self, init_nodes, b0, final_rwd):
        self.state = init_nodes
        self.belief = b0
        self.b0 = b0
        self.init_nodes = init_nodes
        self.final_rwd = final_rwd
        self.observation_space = gym.spaces.Box(low=0, high=1, shape=(init_nodes + 1,), dtype=np.float32)

    def step(self, action):
        tx_attempts = np.random.binomial(1, action, self.state)
        done = False
        if sum(tx_attempts) == 1:
            # On successful communication
            self.state -= 1
            if self.state == 1:
                done = True

        # Belief updating mechanism
        i = 0
        for i in range(self.init_nodes):
            self.belief[i] = (1 - i * action * (1 - action) ** (i - 1)) * self.belief[i] + (
                        (i + 1) * action * (1 - action) ** i) * self.belief[i + 1]
        self.belief[self.init_nodes] = (1 - i * action * (1 - action) ** (self.init_nodes - 1)) * self.belief[
            self.init_nodes]
        self.belief = self.belief / np.sum(self.belief)

        rwd = -1 * (1 - self.belief[0] - self.belief[1]) + self.final_rwd * self.belief[1]

        info = {}
        return self.belief, rwd, done, info

    def reset(self):
        self.state = self.init_nodes
        self.belief = np.copy(self.b0)
        return self.belief
